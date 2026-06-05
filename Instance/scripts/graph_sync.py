#!/usr/bin/env python3
"""Shared helpers for exporting and importing a Neo4j graph.

Two sync modes are supported:
- replace: export by elementId(), clear target, recreate everything (simple + reliable)
- upsert: assign and use stable __sync_id on nodes/relationships, MERGE into target
"""

from __future__ import annotations

import json
import re
import time
from datetime import datetime, timezone
from pathlib import Path
from typing import Any

from neo4j import GraphDatabase
from neo4j.exceptions import ServiceUnavailable

IDENTIFIER_PATTERN = re.compile(r"^[A-Za-z_][A-Za-z0-9_]*$")
SYNC_ID_PROP = "__sync_id"


def validate_identifier(name: str, kind: str) -> str:
    if not IDENTIFIER_PATTERN.match(name):
        raise ValueError(f"Invalid {kind}: {name!r}")
    return name


def load_env(env_path: Path) -> dict[str, str]:
    values: dict[str, str] = {}
    for line in env_path.read_text(encoding="utf-8").splitlines():
        line = line.strip()
        if not line or line.startswith("#") or "=" not in line:
            continue
        key, value = line.split("=", 1)
        values[key.strip()] = value.strip()
    return values


def wait_for_neo4j(uri: str, auth: tuple[str, str], timeout: int = 90) -> None:
    deadline = time.time() + timeout
    last_error: Exception | None = None

    while time.time() < deadline:
        try:
            driver = GraphDatabase.driver(uri, auth=auth)
            try:
                driver.verify_connectivity()
                return
            finally:
                driver.close()
        except ServiceUnavailable as exc:
            last_error = exc
            time.sleep(2)

    raise TimeoutError(f"Neo4j not reachable at {uri}: {last_error}")


def ensure_sync_ids(session) -> dict[str, int]:
    """Ensure all nodes and relationships have stable __sync_id."""
    node_res = session.run(
        f"""
        MATCH (n)
        WHERE n.{SYNC_ID_PROP} IS NULL
        SET n.{SYNC_ID_PROP} = randomUUID()
        RETURN count(n) AS cnt
        """
    ).single()
    rel_res = session.run(
        f"""
        MATCH ()-[r]->()
        WHERE r.{SYNC_ID_PROP} IS NULL
        SET r.{SYNC_ID_PROP} = randomUUID()
        RETURN count(r) AS cnt
        """
    ).single()
    return {"nodes": int(node_res["cnt"]), "relationships": int(rel_res["cnt"])}


def export_graph_replace(session) -> dict[str, Any]:
    nodes = session.run(
        """
        MATCH (n)
        RETURN elementId(n) AS id, labels(n) AS labels, properties(n) AS props
        ORDER BY elementId(n)
        """
    ).data()
    relationships = session.run(
        """
        MATCH (a)-[r]->(b)
        RETURN elementId(a) AS start,
               elementId(b) AS end,
               type(r) AS type,
               properties(r) AS props
        ORDER BY elementId(a), type(r), elementId(b)
        """
    ).data()
    return {"mode": "replace", "exported_at": datetime.now(timezone.utc).isoformat(), "nodes": nodes, "relationships": relationships}


def export_graph_upsert(session) -> dict[str, Any]:
    ensured = ensure_sync_ids(session)
    nodes = session.run(
        f"""
        MATCH (n)
        RETURN n.{SYNC_ID_PROP} AS sid, labels(n) AS labels, properties(n) AS props
        ORDER BY n.{SYNC_ID_PROP}
        """
    ).data()
    relationships = session.run(
        f"""
        MATCH (a)-[r]->(b)
        RETURN a.{SYNC_ID_PROP} AS start_sid,
               b.{SYNC_ID_PROP} AS end_sid,
               r.{SYNC_ID_PROP} AS sid,
               type(r) AS type,
               properties(r) AS props
        ORDER BY a.{SYNC_ID_PROP}, type(r), b.{SYNC_ID_PROP}
        """
    ).data()
    return {
        "mode": "upsert",
        "exported_at": datetime.now(timezone.utc).isoformat(),
        "ensured_sync_ids": ensured,
        "nodes": nodes,
        "relationships": relationships,
    }


def clear_graph(session) -> None:
    session.run("MATCH (n) DETACH DELETE n")


def import_graph_replace(session, data: dict[str, Any]) -> tuple[int, int]:
    id_map: dict[str, str] = {}
    node_count = 0
    rel_count = 0

    for node in data.get("nodes", []):
        labels = node.get("labels") or []
        for label in labels:
            validate_identifier(label, "label")

        label_clause = ""
        if labels:
            label_clause = ":" + ":".join(f"`{label}`" for label in labels)

        result = session.run(
            f"CREATE (n{label_clause}) SET n = $props RETURN elementId(n) AS id",
            props=node.get("props") or {},
        ).single()
        id_map[node["id"]] = result["id"]
        node_count += 1

    for rel in data.get("relationships", []):
        start_id = id_map.get(rel["start"])
        end_id = id_map.get(rel["end"])
        if not start_id or not end_id:
            continue

        rel_type = validate_identifier(rel["type"], "relationship type")
        session.run(
            f"""
            MATCH (a) WHERE elementId(a) = $start
            MATCH (b) WHERE elementId(b) = $end
            CREATE (a)-[r:`{rel_type}`]->(b)
            SET r = $props
            """,
            start=start_id,
            end=end_id,
            props=rel.get("props") or {},
        )
        rel_count += 1

    return node_count, rel_count


def import_graph_upsert(session, data: dict[str, Any]) -> tuple[int, int]:
    node_count = 0
    rel_count = 0

    nodes = data.get("nodes", []) or []
    rels = data.get("relationships", []) or []

    for node in nodes:
        sid = node.get("sid")
        if not sid:
            continue
        labels = node.get("labels") or []
        for label in labels:
            validate_identifier(label, "label")
        label_clause = ""
        if labels:
            label_clause = ":" + ":".join(f"`{label}`" for label in labels)

        props = dict(node.get("props") or {})
        props[SYNC_ID_PROP] = sid
        session.run(
            f"MERGE (n{label_clause} {{{SYNC_ID_PROP}: $sid}}) SET n += $props",
            sid=sid,
            props=props,
        )
        node_count += 1

    for rel in rels:
        sid = rel.get("sid")
        start_sid = rel.get("start_sid")
        end_sid = rel.get("end_sid")
        if not sid or not start_sid or not end_sid:
            continue
        rel_type = validate_identifier(rel["type"], "relationship type")
        props = dict(rel.get("props") or {})
        props[SYNC_ID_PROP] = sid

        session.run(
            f"""
            MATCH (a {{{SYNC_ID_PROP}: $start}})
            MATCH (b {{{SYNC_ID_PROP}: $end}})
            MERGE (a)-[r:`{rel_type}` {{{SYNC_ID_PROP}: $sid}}]->(b)
            SET r += $props
            """,
            start=start_sid,
            end=end_sid,
            sid=sid,
            props=props,
        )
        rel_count += 1

    return node_count, rel_count


def save_snapshot(data: dict[str, Any], snapshots_dir: Path, prefix: str) -> Path:
    snapshots_dir.mkdir(parents=True, exist_ok=True)
    timestamp = datetime.now(timezone.utc).strftime("%Y%m%dT%H%M%SZ")
    path = snapshots_dir / f"{prefix}_{timestamp}.json"
    path.write_text(json.dumps(data, ensure_ascii=False, indent=2), encoding="utf-8")
    return path


def sync_graph(
    source_uri: str,
    source_auth: tuple[str, str],
    source_database: str,
    target_uri: str,
    target_auth: tuple[str, str],
    target_database: str,
    *,
    mode: str = "replace",
    replace_target: bool = True,
    snapshot_dir: Path | None = None,
    snapshot_prefix: str = "graph",
) -> dict[str, int | str | None]:
    source_driver = GraphDatabase.driver(source_uri, auth=source_auth)
    target_driver = GraphDatabase.driver(target_uri, auth=target_auth)

    try:
        with source_driver.session(database=source_database) as source_session:
            if mode == "replace":
                graph = export_graph_replace(source_session)
            elif mode == "upsert":
                graph = export_graph_upsert(source_session)
            else:
                raise ValueError(f"Unknown mode: {mode!r} (expected 'replace' or 'upsert')")

        snapshot_path: Path | None = None
        if snapshot_dir is not None:
            snapshot_path = save_snapshot(graph, snapshot_dir, snapshot_prefix)

        with target_driver.session(database=target_database) as target_session:
            if replace_target:
                clear_graph(target_session)
            if mode == "replace":
                node_count, rel_count = import_graph_replace(target_session, graph)
            else:
                node_count, rel_count = import_graph_upsert(target_session, graph)

        return {
            "nodes": node_count,
            "relationships": rel_count,
            "snapshot": str(snapshot_path) if snapshot_path else None,
        }
    finally:
        source_driver.close()
        target_driver.close()
