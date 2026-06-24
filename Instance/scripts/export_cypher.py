#!/usr/bin/env python3
"""Export the local Neo4j graph as deterministic Cypher statements.

Output is optimised for Git:
- one statement per line
- nodes / relationships sorted for stable diffs
- each node/relationship carries a stable __sync_id (UUID) for matching
"""

from __future__ import annotations

import argparse
import json
import sys
from datetime import datetime, timezone
from pathlib import Path
from typing import Any

INSTANCE_DIR = Path(__file__).resolve().parents[1]
sys.path.insert(0, str(INSTANCE_DIR / "scripts"))

from graph_sync import ensure_sync_ids, load_env, wait_for_neo4j  # noqa: E402
from neo4j import GraphDatabase  # noqa: E402

DEFAULT_EXPORT_DIR = INSTANCE_DIR / "export"
SYNC_ID = "__sync_id"


def cypher_literal(value: Any) -> str:
    """Convert a Python value to a Cypher literal string."""
    if value is None:
        return "null"
    if isinstance(value, bool):
        return "true" if value else "false"
    if isinstance(value, int):
        return str(value)
    if isinstance(value, float):
        return repr(value)
    if isinstance(value, str):
        escaped = value.replace("\\", "\\\\").replace("'", "\\'").replace("\n", "\\n").replace("\r", "\\r")
        return f"'{escaped}'"
    if isinstance(value, list):
        items = ", ".join(cypher_literal(v) for v in value)
        return f"[{items}]"
    if isinstance(value, dict):
        return cypher_literal(json.dumps(value, ensure_ascii=False))
    return cypher_literal(str(value))


def props_block(props: dict[str, Any]) -> str:
    """Build a Cypher property map like {name: 'Alice', age: 30}."""
    filtered = {k: v for k, v in sorted(props.items()) if v is not None}
    if not filtered:
        return ""
    pairs = ", ".join(f"`{k}`: {cypher_literal(v)}" for k, v in filtered.items())
    return f" {{{pairs}}}"


def label_clause(labels: list[str]) -> str:
    if not labels:
        return ""
    return ":" + ":".join(f"`{l}`" for l in sorted(labels))


def node_sort_key(node: dict) -> tuple:
    """Stable sort: by first label, then by name/title, then by __sync_id."""
    labels = sorted(node.get("labels") or [])
    props = node.get("props") or {}
    name = props.get("name") or props.get("title") or ""
    return (labels, str(name), props.get(SYNC_ID, ""))


def export_schema(session) -> list[str]:
    lines: list[str] = []
    constraints = session.run("SHOW CONSTRAINTS YIELD name, type, entityType, labelsOrTypes, properties").data()
    for c in sorted(constraints, key=lambda x: x["name"]):
        entity = c["labelsOrTypes"][0] if c["labelsOrTypes"] else "Unknown"
        props = c["properties"] or []
        prop_str = ", ".join(f"n.`{p}`" for p in props)
        if c["type"] == "UNIQUENESS":
            lines.append(f"CREATE CONSTRAINT `{c['name']}` IF NOT EXISTS FOR (n:`{entity}`) REQUIRE ({prop_str}) IS UNIQUE;")
        elif c["type"] == "NODE_KEY":
            lines.append(f"CREATE CONSTRAINT `{c['name']}` IF NOT EXISTS FOR (n:`{entity}`) REQUIRE ({prop_str}) IS NODE KEY;")
        elif c["type"] == "NODE_PROPERTY_EXISTENCE":
            lines.append(f"CREATE CONSTRAINT `{c['name']}` IF NOT EXISTS FOR (n:`{entity}`) REQUIRE ({prop_str}) IS NOT NULL;")

    indexes = session.run(
        "SHOW INDEXES YIELD name, type, entityType, labelsOrTypes, properties, owningConstraint "
        "WHERE owningConstraint IS NULL"
    ).data()
    for idx in sorted(indexes, key=lambda x: x["name"]):
        entity = idx["labelsOrTypes"][0] if idx["labelsOrTypes"] else "Unknown"
        props = idx["properties"] or []
        prop_str = ", ".join(f"n.`{p}`" for p in props)
        if idx["type"] == "RANGE":
            lines.append(f"CREATE INDEX `{idx['name']}` IF NOT EXISTS FOR (n:`{entity}`) ON ({prop_str});")
        elif idx["type"] == "TEXT":
            lines.append(f"CREATE TEXT INDEX `{idx['name']}` IF NOT EXISTS FOR (n:`{entity}`) ON ({prop_str});")
        elif idx["type"] == "FULLTEXT":
            lines.append(f"CREATE FULLTEXT INDEX `{idx['name']}` IF NOT EXISTS FOR (n:`{entity}`) ON EACH [{prop_str}];")

    return lines


def export_nodes(session) -> tuple[list[str], dict[str, str]]:
    """Export all nodes as CREATE statements.

    Returns (lines, elementId → __sync_id map).
    """
    raw = session.run(
        "MATCH (n) "
        "RETURN elementId(n) AS id, labels(n) AS labels, properties(n) AS props"
    ).data()

    raw.sort(key=node_sort_key)
    lines: list[str] = []
    id_to_sid: dict[str, str] = {}

    for node in raw:
        labels = sorted(node.get("labels") or [])
        props = node.get("props") or {}
        sid = props.get(SYNC_ID)
        if sid:
            id_to_sid[node["id"]] = sid
        lc = label_clause(labels)
        pb = props_block(props)
        lines.append(f"CREATE (n{lc}{pb});")

    return lines, id_to_sid


def export_relationships(session, id_to_sid: dict[str, str]) -> list[str]:
    raw = session.run(
        "MATCH (a)-[r]->(b) "
        "RETURN elementId(a) AS start, elementId(b) AS end, "
        "type(r) AS type, properties(r) AS props"
    ).data()

    rels = []
    for rel in raw:
        start_sid = id_to_sid.get(rel["start"])
        end_sid = id_to_sid.get(rel["end"])
        if not start_sid or not end_sid:
            continue
        rels.append({
            "type": rel["type"],
            "props": rel.get("props") or {},
            "start_sid": start_sid,
            "end_sid": end_sid,
        })

    rels.sort(key=lambda r: (r["type"], r["start_sid"], r["end_sid"]))
    lines: list[str] = []
    for rel in rels:
        pb = props_block(rel["props"])
        lines.append(
            f"MATCH (a {{`{SYNC_ID}`: {cypher_literal(rel['start_sid'])}}})"
            f" MATCH (b {{`{SYNC_ID}`: {cypher_literal(rel['end_sid'])}}})"
            f" CREATE (a)-[:`{rel['type']}`{pb}]->(b);"
        )

    return lines


def write_file(path: Path, header: str, lines: list[str]) -> None:
    with open(path, "w", encoding="utf-8") as f:
        f.write(f"// {header}\n")
        f.write(f"// exported at {datetime.now(timezone.utc).strftime('%Y-%m-%d %H:%M:%S UTC')}\n\n")
        for line in lines:
            f.write(line + "\n")
    print(f"  {path.name}: {len(lines)} statements")


def main() -> int:
    parser = argparse.ArgumentParser(description="Export local Neo4j graph as Cypher for Git.")
    parser.add_argument(
        "-o", "--output-dir",
        type=Path,
        default=DEFAULT_EXPORT_DIR,
        help=f"Output directory (default: {DEFAULT_EXPORT_DIR.relative_to(INSTANCE_DIR)})",
    )
    parser.add_argument(
        "--single-file",
        action="store_true",
        help="Write everything to a single graph.cypher instead of separate files.",
    )
    args = parser.parse_args()

    env = load_env(INSTANCE_DIR / ".env")
    uri = env.get("LOCAL_NEO4J_URI", "bolt://localhost:7687")
    auth = (env.get("LOCAL_NEO4J_USERNAME", "neo4j"), env.get("LOCAL_NEO4J_PASSWORD", "password"))
    database = env.get("LOCAL_NEO4J_DATABASE", "neo4j")

    print(f"Connecting to {uri} ...")
    wait_for_neo4j(uri, auth)
    driver = GraphDatabase.driver(uri, auth=auth)

    try:
        with driver.session(database=database) as session:
            print("Ensuring __sync_id on all nodes and relationships ...")
            assigned = ensure_sync_ids(session)
            if assigned["nodes"] or assigned["relationships"]:
                print(f"  Assigned new IDs: {assigned['nodes']} nodes, {assigned['relationships']} relationships")

            print("Exporting schema ...")
            schema_lines = export_schema(session)

            print("Exporting nodes ...")
            node_lines, id_to_sid = export_nodes(session)

            print("Exporting relationships ...")
            rel_lines = export_relationships(session, id_to_sid)
    finally:
        driver.close()

    out_dir: Path = args.output_dir
    out_dir.mkdir(parents=True, exist_ok=True)

    if args.single_file:
        all_lines: list[str] = []
        if schema_lines:
            all_lines.append("// --- Schema ---")
            all_lines.extend(schema_lines)
            all_lines.append("")
        all_lines.append("// --- Nodes ---")
        all_lines.extend(node_lines)
        all_lines.append("")
        all_lines.append("// --- Relationships ---")
        all_lines.extend(rel_lines)
        write_file(out_dir / "graph.cypher", "Full graph export", all_lines)
    else:
        if schema_lines:
            write_file(out_dir / "schema.cypher", "Schema (constraints & indexes)", schema_lines)
        write_file(out_dir / "nodes.cypher", "Nodes", node_lines)
        write_file(out_dir / "relationships.cypher", "Relationships", rel_lines)

    total = len(schema_lines) + len(node_lines) + len(rel_lines)
    print(f"\nDone. {total} statements total ({len(node_lines)} nodes, {len(rel_lines)} relationships).")
    return 0


if __name__ == "__main__":
    raise SystemExit(main())
