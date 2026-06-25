#!/usr/bin/env python3
"""Export the local Neo4j graph as deterministic Cypher statements.

Output is optimised for Git:
- existing entries keep their position from the previous export
- new entries are appended at the end (sorted among themselves)
- deleted entries simply disappear
- modified properties update in-place on the same line
"""

from __future__ import annotations

import argparse
import json
import re
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

SYNC_ID_RE = re.compile(r"`__sync_id`:\s*'([^']+)'")


# ---------------------------------------------------------------------------
# Cypher serialisation helpers
# ---------------------------------------------------------------------------

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
    """Stable sort for NEW nodes: by label, then name, then __sync_id."""
    labels = sorted(node.get("labels") or [])
    props = node.get("props") or {}
    name = props.get("name") or props.get("title") or ""
    return (labels, str(name), props.get(SYNC_ID, ""))


# ---------------------------------------------------------------------------
# Ordering: preserve existing file order, append new entries at the end
# ---------------------------------------------------------------------------

def read_existing_order(path: Path, *, use_last_match: bool = False) -> list[str]:
    """Extract the ordered list of __sync_id values from a previous export file.

    For node files each line has one __sync_id (the node's own).
    For relationship files each line has three: two node IDs in MATCH clauses
    and the relationship's own ID in the CREATE clause. Set *use_last_match*
    to pick the last occurrence per line (the relationship's own ID).
    """
    if not path.exists():
        return []
    order: list[str] = []
    for line in path.read_text(encoding="utf-8").splitlines():
        matches = SYNC_ID_RE.findall(line)
        if matches:
            order.append(matches[-1] if use_last_match else matches[0])
    return order


def stable_sort(items: dict[str, str], previous_order: list[str], new_sort_key=None) -> list[str]:
    """Return lines sorted by previous file order, with new items appended.

    Args:
        items: mapping of sync_id → Cypher line
        previous_order: ordered sync_ids from the last export
        new_sort_key: optional key func(sync_id) for sorting new items
    """
    seen = set()
    result: list[str] = []

    for sid in previous_order:
        if sid in items:
            result.append(items[sid])
            seen.add(sid)

    new_sids = [sid for sid in items if sid not in seen]
    if new_sort_key:
        new_sids.sort(key=new_sort_key)
    else:
        new_sids.sort()
    for sid in new_sids:
        result.append(items[sid])

    return result


# ---------------------------------------------------------------------------
# Export functions
# ---------------------------------------------------------------------------

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


def export_nodes(session) -> tuple[dict[str, str], dict[str, str], dict[str, dict]]:
    """Export all nodes as CREATE statements.

    Returns:
        sid_to_line: __sync_id → Cypher CREATE line
        eid_to_sid:  elementId → __sync_id  (for relationship export)
        sid_to_node: __sync_id → {labels, props}  (for new-node sorting)
    """
    raw = session.run(
        "MATCH (n) "
        "RETURN elementId(n) AS id, labels(n) AS labels, properties(n) AS props"
    ).data()

    sid_to_line: dict[str, str] = {}
    eid_to_sid: dict[str, str] = {}
    sid_to_node: dict[str, dict] = {}

    for node in raw:
        labels = sorted(node.get("labels") or [])
        props = node.get("props") or {}
        sid = props.get(SYNC_ID)
        if not sid:
            continue
        eid_to_sid[node["id"]] = sid
        sid_to_node[sid] = {"labels": labels, "props": props}
        lc = label_clause(labels)
        pb = props_block(props)
        sid_to_line[sid] = f"CREATE (n{lc}{pb});"

    return sid_to_line, eid_to_sid, sid_to_node


def export_relationships(session, eid_to_sid: dict[str, str]) -> dict[str, str]:
    """Export all relationships. Returns rel_key → Cypher line mapping.

    The key is (type, start_sid, end_sid, rel_sync_id) serialised, ensuring
    uniqueness even for parallel edges.
    """
    raw = session.run(
        "MATCH (a)-[r]->(b) "
        "RETURN elementId(a) AS start, elementId(b) AS end, "
        "type(r) AS type, properties(r) AS props"
    ).data()

    sid_to_line: dict[str, str] = {}
    for rel in raw:
        start_sid = eid_to_sid.get(rel["start"])
        end_sid = eid_to_sid.get(rel["end"])
        if not start_sid or not end_sid:
            continue
        props = rel.get("props") or {}
        rel_sid = props.get(SYNC_ID)
        if not rel_sid:
            continue
        pb = props_block(props)
        line = (
            f"MATCH (a {{`{SYNC_ID}`: {cypher_literal(start_sid)}}})"
            f" MATCH (b {{`{SYNC_ID}`: {cypher_literal(end_sid)}}})"
            f" CREATE (a)-[:`{rel['type']}`{pb}]->(b);"
        )
        sid_to_line[rel_sid] = line

    return sid_to_line


# ---------------------------------------------------------------------------
# File I/O
# ---------------------------------------------------------------------------

def write_file(path: Path, header: str, lines: list[str]) -> None:
    with open(path, "w", encoding="utf-8") as f:
        f.write(f"// {header}\n")
        f.write(f"// exported at {datetime.now(timezone.utc).strftime('%Y-%m-%d %H:%M:%S UTC')}\n\n")
        for line in lines:
            f.write(line + "\n")
    print(f"  {path.name}: {len(lines)} statements")


# ---------------------------------------------------------------------------
# Main
# ---------------------------------------------------------------------------

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
    parser.add_argument(
        "--reorder",
        action="store_true",
        help="Ignore previous file order and sort everything from scratch.",
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
            node_sid_lines, eid_to_sid, sid_to_node = export_nodes(session)

            print("Exporting relationships ...")
            rel_sid_lines = export_relationships(session, eid_to_sid)
    finally:
        driver.close()

    out_dir: Path = args.output_dir
    out_dir.mkdir(parents=True, exist_ok=True)

    # Determine ordering
    if args.reorder:
        prev_node_order: list[str] = []
        prev_rel_order: list[str] = []
    else:
        nodes_file = out_dir / "nodes.cypher"
        rels_file = out_dir / "relationships.cypher"
        graph_file = out_dir / "graph.cypher"
        if args.single_file:
            prev_node_order = read_existing_order(graph_file)
            prev_rel_order = read_existing_order(graph_file, use_last_match=True)
        else:
            prev_node_order = read_existing_order(nodes_file)
            prev_rel_order = read_existing_order(rels_file, use_last_match=True)

    def new_node_sort(sid: str) -> tuple:
        info = sid_to_node.get(sid)
        if info:
            return node_sort_key(info)
        return ([], "", sid)

    node_lines = stable_sort(node_sid_lines, prev_node_order, new_sort_key=new_node_sort)
    rel_lines = stable_sort(rel_sid_lines, prev_rel_order)

    new_nodes = len(node_sid_lines) - len(set(node_sid_lines) & set(prev_node_order))
    new_rels = len(rel_sid_lines) - len(set(rel_sid_lines) & set(prev_rel_order))

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
    if new_nodes or new_rels:
        print(f"  New entries appended: {new_nodes} nodes, {new_rels} relationships.")
    return 0


if __name__ == "__main__":
    raise SystemExit(main())
