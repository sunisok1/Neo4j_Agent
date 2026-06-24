#!/usr/bin/env python3
"""Import Cypher files into Neo4j with automatic backup and rollback.

Safety workflow:
  1. Backup current graph to snapshots/ (JSON, via graph_sync)
  2. Clear the database
  3. Import schema → nodes → relationships from .cypher files
  4. Verify imported counts
  5. On ANY failure: auto-restore from the backup
"""

from __future__ import annotations

import argparse
import json
import re
import sys
import traceback
from datetime import datetime, timezone
from pathlib import Path

INSTANCE_DIR = Path(__file__).resolve().parents[1]
sys.path.insert(0, str(INSTANCE_DIR / "scripts"))

from graph_sync import (  # noqa: E402
    clear_graph,
    export_graph_replace,
    import_graph_replace,
    load_env,
    save_snapshot,
    wait_for_neo4j,
)
from neo4j import GraphDatabase  # noqa: E402

DEFAULT_IMPORT_DIR = INSTANCE_DIR / "export"
SNAPSHOTS_DIR = INSTANCE_DIR / "snapshots"

COMMENT_RE = re.compile(r"^\s*//")


def backup_current_graph(driver, database: str) -> tuple[dict, Path]:
    """Export current graph to a timestamped JSON snapshot. Returns (data, path)."""
    with driver.session(database=database) as session:
        data = export_graph_replace(session)

    node_count = len(data.get("nodes", []))
    rel_count = len(data.get("relationships", []))
    path = save_snapshot(data, SNAPSHOTS_DIR, "pre_import_backup")
    print(f"  Backup saved: {path.name}  ({node_count} nodes, {rel_count} relationships)")
    return data, path


def restore_from_backup(driver, database: str, backup_data: dict) -> None:
    """Clear the database and restore from backup data."""
    with driver.session(database=database) as session:
        clear_graph(session)
        node_count, rel_count = import_graph_replace(session, backup_data)
    print(f"  Restored: {node_count} nodes, {rel_count} relationships")


def parse_cypher_file(path: Path) -> list[str]:
    """Read a .cypher file and split into statements, respecting quoted strings."""
    text = path.read_text(encoding="utf-8")
    statements: list[str] = []
    current: list[str] = []
    in_quote = False
    escape_next = False

    for ch in text:
        if escape_next:
            current.append(ch)
            escape_next = False
            continue
        if ch == "\\" and in_quote:
            current.append(ch)
            escape_next = True
            continue
        if ch == "'":
            in_quote = not in_quote
            current.append(ch)
            continue
        if ch == ";" and not in_quote:
            raw = "".join(current).strip()
            lines = [l for l in raw.splitlines() if not COMMENT_RE.match(l)]
            cleaned = "\n".join(lines).strip()
            if cleaned:
                statements.append(cleaned)
            current = []
            continue
        current.append(ch)

    raw = "".join(current).strip()
    if raw:
        lines = [l for l in raw.splitlines() if not COMMENT_RE.match(l)]
        cleaned = "\n".join(lines).strip()
        if cleaned:
            statements.append(cleaned)

    return statements


def run_statements(session, statements: list[str], label: str) -> int:
    """Execute a list of Cypher statements. Returns count of executed statements."""
    executed = 0
    errors = 0
    for i, stmt in enumerate(statements):
        try:
            session.run(stmt).consume()
            executed += 1
        except Exception as exc:
            errors += 1
            short = stmt[:120].replace("\n", " ")
            print(f"  WARNING [{label} #{i+1}]: {exc}  |  {short}...")
            if errors > 10:
                raise RuntimeError(f"Too many errors in {label} ({errors}), aborting") from exc
    return executed


def get_counts(session) -> tuple[int, int]:
    node_count = session.run("MATCH (n) RETURN count(n) AS c").single()["c"]
    rel_count = session.run("MATCH ()-[r]->() RETURN count(r) AS c").single()["c"]
    return node_count, rel_count


def main() -> int:
    parser = argparse.ArgumentParser(description="Import Cypher files into Neo4j (with backup & rollback).")
    parser.add_argument(
        "-i", "--input-dir",
        type=Path,
        default=DEFAULT_IMPORT_DIR,
        help=f"Directory containing .cypher files (default: {DEFAULT_IMPORT_DIR.relative_to(INSTANCE_DIR)})",
    )
    parser.add_argument(
        "--no-backup",
        action="store_true",
        help="Skip backup (dangerous, not recommended).",
    )
    parser.add_argument(
        "--no-clear",
        action="store_true",
        help="Do not clear existing data before import (additive import).",
    )
    parser.add_argument(
        "--yes",
        action="store_true",
        help="Skip interactive confirmation.",
    )
    args = parser.parse_args()

    import_dir: Path = args.input_dir
    if not import_dir.is_dir():
        print(f"Error: import directory not found: {import_dir}")
        return 1

    schema_file = import_dir / "schema.cypher"
    nodes_file = import_dir / "nodes.cypher"
    rels_file = import_dir / "relationships.cypher"
    single_file = import_dir / "graph.cypher"

    if single_file.exists():
        files_to_import = [("graph", single_file)]
    elif nodes_file.exists():
        files_to_import = []
        if schema_file.exists():
            files_to_import.append(("schema", schema_file))
        files_to_import.append(("nodes", nodes_file))
        if rels_file.exists():
            files_to_import.append(("relationships", rels_file))
    else:
        print(f"Error: no importable files found in {import_dir}")
        print("  Expected: nodes.cypher + relationships.cypher, or graph.cypher")
        return 1

    total_stmts = 0
    for label, fpath in files_to_import:
        count = len(parse_cypher_file(fpath))
        total_stmts += count
        print(f"  Found {fpath.name}: {count} statements")

    env = load_env(INSTANCE_DIR / ".env")
    uri = env.get("LOCAL_NEO4J_URI", "bolt://localhost:7687")
    auth = (env.get("LOCAL_NEO4J_USERNAME", "neo4j"), env.get("LOCAL_NEO4J_PASSWORD", "password"))
    database = env.get("LOCAL_NEO4J_DATABASE", "neo4j")

    print(f"\nConnecting to {uri} ...")
    wait_for_neo4j(uri, auth)
    driver = GraphDatabase.driver(uri, auth=auth)

    try:
        with driver.session(database=database) as session:
            before_nodes, before_rels = get_counts(session)
        print(f"Current database: {before_nodes} nodes, {before_rels} relationships")

        if not args.yes:
            action = "additively import into" if args.no_clear else "CLEAR and replace"
            print(f"\nAbout to {action} database '{database}' with {total_stmts} statements.")
            if not args.no_backup:
                print("A backup will be saved first; auto-rollback on failure.")
            answer = input("Continue? [y/N] ").strip().lower()
            if answer not in ("y", "yes"):
                print("Aborted.")
                return 0

        # Step 1: backup
        backup_data = None
        if not args.no_backup and before_nodes > 0:
            print("\nStep 1: Backing up current graph ...")
            backup_data, backup_path = backup_current_graph(driver, database)
        else:
            print("\nStep 1: Backup skipped (database empty or --no-backup).")

        # Step 2: clear
        if not args.no_clear:
            print("Step 2: Clearing database ...")
            with driver.session(database=database) as session:
                clear_graph(session)
            print("  Database cleared.")
        else:
            print("Step 2: Clear skipped (--no-clear).")

        # Step 3: import
        print("Step 3: Importing ...")
        total_executed = 0
        try:
            with driver.session(database=database) as session:
                for label, fpath in files_to_import:
                    stmts = parse_cypher_file(fpath)
                    print(f"  Importing {fpath.name} ({len(stmts)} statements) ...")
                    executed = run_statements(session, stmts, label)
                    total_executed += executed
                    print(f"    Done: {executed} executed")
        except Exception:
            print(f"\n{'='*60}")
            print("IMPORT FAILED!")
            traceback.print_exc()
            if backup_data:
                print(f"\nAuto-restoring from backup ...")
                restore_from_backup(driver, database, backup_data)
                print("Database restored to pre-import state.")
            else:
                print("WARNING: No backup available, database may be in partial state.")
            print(f"{'='*60}")
            return 1

        # Step 4: verify
        print("Step 4: Verifying ...")
        with driver.session(database=database) as session:
            after_nodes, after_rels = get_counts(session)
        print(f"  Result: {after_nodes} nodes, {after_rels} relationships")
        print(f"  Executed: {total_executed} / {total_stmts} statements")

        if after_nodes == 0 and total_stmts > 0:
            print("\nWARNING: Import produced 0 nodes — something may be wrong.")
            if backup_data:
                answer = input("Rollback to backup? [y/N] ").strip().lower()
                if answer in ("y", "yes"):
                    restore_from_backup(driver, database, backup_data)
                    print("Database restored.")
                    return 1

        print("\nImport completed successfully.")
        return 0

    finally:
        driver.close()


if __name__ == "__main__":
    raise SystemExit(main())
