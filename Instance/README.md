# Instance (Local Neo4j + Aura Sync)

This folder runs a **local Neo4j** (Docker) for fast read/write during learning, and provides scripts to:

- **Pull** data from Neo4j Aura (remote) into local
- **Push** local data back to Aura (remote)

## 1) Setup

1. Copy env example:

```bash
cp .env.example .env
```

2. Fill in `.env`:
   - `REMOTE_NEO4J_URI`, `REMOTE_NEO4J_USERNAME`, `REMOTE_NEO4J_PASSWORD`, `REMOTE_NEO4J_DATABASE`
   - Optionally adjust local ports and password

## 2) Start local Neo4j

```bash
docker compose --env-file .env up -d
```

Local browser (default): `http://localhost:7474`

## 3) Pull from remote to local

Default is **replace** (clear local DB and recreate):

```bash
./pull.sh
```

Incremental **upsert** mode (stable `__sync_id`, MERGE into local):

```bash
./pull.sh --mode upsert --keep-local
```

## 4) Push from local to remote

Default is **replace** (clear remote DB and recreate). This requires explicit confirmation:

```bash
./push.sh --yes
```

Incremental **upsert** mode (stable `__sync_id`, MERGE into remote), without clearing remote:

```bash
./push.sh --mode upsert --keep-remote
```

## Notes / Trade-offs

- **replace** mode is simplest and safest if you treat Aura as "final snapshot".
- **upsert** mode is best if you want to keep a stable identity across local/remote.
  It will assign a `__sync_id` to nodes/relationships that don't have one yet.
- Deletions are **not** propagated in upsert mode (it's merge-only). If you need deletions,
  use replace mode for the final sync.

