#!/usr/bin/env python3
"""Remove invalid Neo4j nodes: unlabeled sync stubs and optional orphan nodes."""

from __future__ import annotations

import argparse
import sys
from pathlib import Path

from neo4j import GraphDatabase

INSTANCE_DIR = Path(__file__).resolve().parents[1]

INVALID_NO_LABEL = """
MATCH (n)
WHERE size(labels(n)) = 0
OPTIONAL MATCH (n)-[r]-()
RETURN count(DISTINCT n) AS nodes, count(r) AS rels
"""

INVALID_ORPHANS = """
MATCH (n)
WHERE size(labels(n)) > 0
  AND NOT (n)--()
RETURN labels(n)[0] AS label, count(*) AS count
ORDER BY count DESC, label
"""

DELETE_NO_LABEL = """
MATCH (n)
WHERE size(labels(n)) = 0
DETACH DELETE n
RETURN count(n) AS deleted
"""

DELETE_ORPHANS = """
MATCH (n)
WHERE size(labels(n)) > 0
  AND NOT (n)--()
DETACH DELETE n
RETURN count(n) AS deleted
"""


def load_env(path: Path) -> dict[str, str]:
    env: dict[str, str] = {}
    if not path.exists():
        return env
    for line in path.read_text().splitlines():
        line = line.strip()
        if line and not line.startswith("#") and "=" in line:
            key, value = line.split("=", 1)
            env[key.strip()] = value.strip()
    return env


def connect(target: str) -> tuple[GraphDatabase, str]:
    env = load_env(INSTANCE_DIR / ".env")
    if target == "remote":
        uri = env["REMOTE_NEO4J_URI"]
        auth = (env["REMOTE_NEO4J_USERNAME"], env["REMOTE_NEO4J_PASSWORD"])
        database = env.get("REMOTE_NEO4J_DATABASE", "neo4j")
    else:
        uri = env.get("LOCAL_NEO4J_URI", "bolt://localhost:7687")
        auth = (
            env.get("LOCAL_NEO4J_USERNAME", "neo4j"),
            env.get("LOCAL_NEO4J_PASSWORD", "password"),
        )
        database = env.get("LOCAL_NEO4J_DATABASE", "neo4j")

    driver = GraphDatabase.driver(uri, auth=auth)
    driver.verify_connectivity()
    return driver, database


def count_nodes(session) -> int:
    row = session.run("MATCH (n) RETURN count(n) AS c").single()
    return row["c"] if row else 0


def preview(session, include_orphans: bool) -> None:
    total = count_nodes(session)
    print(f"Total nodes: {total}")

    row = session.run(INVALID_NO_LABEL).single()
    if row:
        print(
            f"Unlabeled invalid nodes: {row['nodes']} "
            f"(with {row['rels']} attached relationships)"
        )

    if include_orphans:
        orphans = session.run(INVALID_ORPHANS).data()
        orphan_total = sum(r["count"] for r in orphans)
        print(f"Labeled orphan nodes: {orphan_total}")
        for row in orphans:
            print(f"  {row['label'] or '(none)'}: {row['count']}")
    else:
        orphan_total = session.run(
            """
            MATCH (n)
            WHERE size(labels(n)) > 0 AND NOT (n)--()
            RETURN count(n) AS c
            """
        ).single()["c"]
        if orphan_total:
            print(
                f"Labeled orphan nodes (skipped, use --include-orphans): {orphan_total}"
            )


def cleanup(session, include_orphans: bool) -> tuple[int, int]:
    deleted_no_label = session.run(DELETE_NO_LABEL).single()["deleted"]
    deleted_orphans = 0
    if include_orphans:
        deleted_orphans = session.run(DELETE_ORPHANS).single()["deleted"]
    return deleted_no_label, deleted_orphans


def main() -> int:
    parser = argparse.ArgumentParser(
        description="Remove invalid Neo4j nodes (unlabeled sync stubs; optional orphans)."
    )
    parser.add_argument(
        "--target",
        choices=["local", "remote"],
        default="local",
        help="Neo4j instance to clean (default: local).",
    )
    parser.add_argument(
        "--include-orphans",
        action="store_true",
        help="Also delete labeled nodes with zero relationships.",
    )
    parser.add_argument(
        "--yes",
        action="store_true",
        help="Apply deletions. Without this flag, only preview counts.",
    )
    args = parser.parse_args()

    driver, database = connect(args.target)
    try:
        with driver.session(database=database) as session:
            print(f"Target: {args.target} ({database})")
            preview(session, args.include_orphans)

            if not args.yes:
                print("Dry run only. Re-run with --yes to delete.")
                return 0

            before = count_nodes(session)
            deleted_no_label, deleted_orphans = cleanup(session, args.include_orphans)
            after = count_nodes(session)

            print(
                f"Deleted unlabeled nodes: {deleted_no_label}; "
                f"deleted orphan nodes: {deleted_orphans}"
            )
            print(f"Nodes before: {before}; after: {after}")
    finally:
        driver.close()

    return 0


if __name__ == "__main__":
    sys.exit(main())
