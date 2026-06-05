#!/usr/bin/env python3
"""Push local Neo4j graph data back to remote Aura."""

from __future__ import annotations

import argparse
import subprocess
import sys
from pathlib import Path

INSTANCE_DIR = Path(__file__).resolve().parents[1]
sys.path.insert(0, str(INSTANCE_DIR / "scripts"))

from graph_sync import load_env, sync_graph, wait_for_neo4j  # noqa: E402


def ensure_local_running(local_uri: str, local_auth: tuple[str, str]) -> None:
    print(f"Checking local Neo4j at {local_uri} ...")
    try:
        wait_for_neo4j(local_uri, local_auth)
    except Exception:
        # If the user relies on Docker, provide a hint.
        try:
            subprocess.run(["docker", "info"], check=True, stdout=subprocess.DEVNULL, stderr=subprocess.DEVNULL)
            print("Tip: local Neo4j may not be started. Run: docker compose --env-file .env up -d")
        except Exception:
            print("Tip: Docker does not seem to be running, and local Neo4j is unreachable.")
        raise


def main() -> int:
    parser = argparse.ArgumentParser(description="Push local Neo4j graph to remote Aura.")
    parser.add_argument(
        "--yes",
        action="store_true",
        help="Required when --mode=replace. Confirm that remote graph data will be replaced.",
    )
    parser.add_argument(
        "--mode",
        choices=["replace", "upsert"],
        default="replace",
        help="replace: clear+recreate remote graph; upsert: incremental MERGE via __sync_id.",
    )
    parser.add_argument(
        "--keep-remote",
        action="store_true",
        help="Do not clear remote graph before applying changes.",
    )
    args = parser.parse_args()

    if args.mode == "replace" and not args.yes and not args.keep_remote:
        print("Refusing to push without confirmation.")
        print("Remote data will be replaced unless you pass --keep-remote.")
        print("Re-run with: python scripts/push_to_remote.py --yes")
        return 1

    env = load_env(INSTANCE_DIR / ".env")

    local_uri = env["LOCAL_NEO4J_URI"]
    local_auth = (env["LOCAL_NEO4J_USERNAME"], env["LOCAL_NEO4J_PASSWORD"])
    remote_uri = env["REMOTE_NEO4J_URI"]
    remote_auth = (env["REMOTE_NEO4J_USERNAME"], env["REMOTE_NEO4J_PASSWORD"])

    ensure_local_running(local_uri, local_auth)

    print(f"Pushing graph to remote: {remote_uri}")
    result = sync_graph(
        local_uri,
        local_auth,
        env["LOCAL_NEO4J_DATABASE"],
        remote_uri,
        remote_auth,
        env["REMOTE_NEO4J_DATABASE"],
        mode=args.mode,
        replace_target=not args.keep_remote,
        snapshot_dir=INSTANCE_DIR / "snapshots",
        snapshot_prefix="push_to_remote",
    )

    print("Push completed.")
    print(f"  Nodes exported: {result['nodes']}")
    print(f"  Relationships exported: {result['relationships']}")
    if result["snapshot"]:
        print(f"  Snapshot saved: {result['snapshot']}")
    return 0


if __name__ == "__main__":
    raise SystemExit(main())
