#!/usr/bin/env python3
"""Pull graph data from remote Aura into the local Neo4j instance."""

from __future__ import annotations

import argparse
import subprocess
import sys
from pathlib import Path

INSTANCE_DIR = Path(__file__).resolve().parents[1]
sys.path.insert(0, str(INSTANCE_DIR / "scripts"))

from graph_sync import load_env, sync_graph, wait_for_neo4j  # noqa: E402


def ensure_docker_running() -> None:
    try:
        subprocess.run(
            ["docker", "info"],
            check=True,
            stdout=subprocess.DEVNULL,
            stderr=subprocess.DEVNULL,
        )
    except Exception as exc:  # noqa: BLE001
        raise RuntimeError(
            "Docker is not available. Please start Docker Desktop (or the Docker daemon) "
            "and re-run.\n"
            "Tip: you can also run with --no-start if local Neo4j is already running."
        ) from exc


def ensure_local_instance(running: bool) -> None:
    if not running:
        return

    ensure_docker_running()
    compose_file = INSTANCE_DIR / "docker-compose.yml"
    env_file = INSTANCE_DIR / ".env"
    print("Starting local Neo4j container...")
    subprocess.run(
        [
            "docker",
            "compose",
            "--env-file",
            str(env_file),
            "-f",
            str(compose_file),
            "up",
            "-d",
        ],
        check=True,
        cwd=INSTANCE_DIR,
    )


def main() -> int:
    parser = argparse.ArgumentParser(description="Pull remote Neo4j graph into local instance.")
    parser.add_argument(
        "--no-start",
        action="store_true",
        help="Do not auto-start docker compose; assume local Neo4j is already running.",
    )
    parser.add_argument(
        "--mode",
        choices=["replace", "upsert"],
        default="replace",
        help="replace: clear+recreate local graph; upsert: incremental MERGE via __sync_id.",
    )
    parser.add_argument(
        "--keep-local",
        action="store_true",
        help="Do not clear local graph before applying changes.",
    )
    args = parser.parse_args()

    env = load_env(INSTANCE_DIR / ".env")

    local_uri = env["LOCAL_NEO4J_URI"]
    local_auth = (env["LOCAL_NEO4J_USERNAME"], env["LOCAL_NEO4J_PASSWORD"])
    remote_uri = env["REMOTE_NEO4J_URI"]
    remote_auth = (env["REMOTE_NEO4J_USERNAME"], env["REMOTE_NEO4J_PASSWORD"])

    ensure_local_instance(not args.no_start)
    print(f"Waiting for local Neo4j at {local_uri} ...")
    wait_for_neo4j(local_uri, local_auth)

    print(f"Pulling graph from remote: {remote_uri}")
    result = sync_graph(
        remote_uri,
        remote_auth,
        env["REMOTE_NEO4J_DATABASE"],
        local_uri,
        local_auth,
        env["LOCAL_NEO4J_DATABASE"],
        mode=args.mode,
        replace_target=not args.keep_local,
        snapshot_dir=INSTANCE_DIR / "snapshots",
        snapshot_prefix="pull_from_remote",
    )

    print("Pull completed.")
    print(f"  Nodes imported: {result['nodes']}")
    print(f"  Relationships imported: {result['relationships']}")
    if result["snapshot"]:
        print(f"  Snapshot saved: {result['snapshot']}")
    print(f"  Local browser: http://localhost:{env.get('LOCAL_NEO4J_HTTP_PORT', '7474')}")
    return 0


if __name__ == "__main__":
    raise SystemExit(main())
