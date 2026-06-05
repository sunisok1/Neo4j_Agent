---
name: neo4j-access
description: Connects to Neo4j with the Python driver, preferring the local Desktop/database instance by default. Use when running Cypher, inspecting the graph, syncing data, or any Neo4j/Aura task unless the user explicitly asks for remote/Aura/cloud.
---

# Neo4j access (local first)

## Default target

Unless the user **explicitly** asks for remote, Aura, cloud, or a specific remote instance ID (e.g. `8ad13313`):

1. Connect to the **local** Neo4j on `bolt://localhost:7687`.
2. Do **not** use Docker as a prerequisite; use the Python `neo4j` driver only.
3. Load credentials from `Instance/.env` when present; otherwise use the defaults below.

## Local connection (primary)

| Setting   | Value |
|-----------|--------|
| URI       | `bolt://localhost:7687` (fallback: `neo4j://localhost:7687`) |
| Username  | `neo4j` |
| Password  | `password` |
| Database  | `neo4j` |

Neo4j Desktop instance ID (for human reference only; Bolt does not need it): `d51fe9d6-06f3-4201-a3e6-54737181ab84`.

From `Instance/.env`: `LOCAL_NEO4J_URI`, `LOCAL_NEO4J_USERNAME`, `LOCAL_NEO4J_PASSWORD`, `LOCAL_NEO4J_DATABASE`.

## Remote connection (only when requested)

Use when the user mentions Aura, remote, cloud, or a remote instance/file such as `Neo4j-*-Created-*.txt`.

- Env: `Instance/.env` → `REMOTE_NEO4J_*`
- Or parse a credentials file:

```text
NEO4J_URI=...
NEO4J_USERNAME=neo4j
NEO4J_PASSWORD=...
NEO4J_DATABASE=neo4j
```

## Python driver pattern

Use the project venv at `Instance/.venv` (package `neo4j` already installed).

```python
from pathlib import Path
from neo4j import GraphDatabase

def load_env(path: Path) -> dict[str, str]:
    env: dict[str, str] = {}
    if not path.exists():
        return env
    for line in path.read_text().splitlines():
        line = line.strip()
        if line and not line.startswith("#") and "=" in line:
            k, v = line.split("=", 1)
            env[k.strip()] = v.strip()
    return env

def connect_local():
    env = load_env(Path("Instance/.env"))
    uri = env.get("LOCAL_NEO4J_URI", "bolt://localhost:7687")
    auth = (
        env.get("LOCAL_NEO4J_USERNAME", "neo4j"),
        env.get("LOCAL_NEO4J_PASSWORD", "password"),
    )
    database = env.get("LOCAL_NEO4J_DATABASE", "neo4j")
    driver = GraphDatabase.driver(uri, auth=auth)
    driver.verify_connectivity()
    return driver, database

def connect_remote():
    env = load_env(Path("Instance/.env"))
    uri = env["REMOTE_NEO4J_URI"]
    auth = (env["REMOTE_NEO4J_USERNAME"], env["REMOTE_NEO4J_PASSWORD"])
    database = env.get("REMOTE_NEO4J_DATABASE", "neo4j")
    driver = GraphDatabase.driver(uri, auth=auth)
    driver.verify_connectivity()
    return driver, database

def run_cypher(driver, database: str, query: str, **params):
    with driver.session(database=database) as session:
        return [record.data() for record in session.run(query, **params)]
```

Run from repo root:

```bash
cd Instance && .venv/bin/python -c "..."
```

## Connectivity check

After connecting, run:

```cypher
RETURN 1 AS ok;
```

Optional version info:

```cypher
CALL dbms.components() YIELD name, versions, edition
RETURN name, versions[0] AS version, edition;
```

## Workflow

1. Decide target: **local** (default) vs **remote** (explicit user request).
2. `verify_connectivity()` before heavy queries or writes.
3. For graph changes the user will paste into Browser, still follow project rule **Cypher-first** (`.cursor/rules/neo4j-cypher-first.mdc`).
4. Always `driver.close()` when done.

## Failure handling

- Local connection refused → tell the user to start the Neo4j Desktop database `d51fe9d6-06f3-4201-a3e6-54737181ab84` (or check Bolt port `7687`).
- Do not fall back to remote silently; only switch when the user asked for remote or local is unreachable and they approve using Aura.
