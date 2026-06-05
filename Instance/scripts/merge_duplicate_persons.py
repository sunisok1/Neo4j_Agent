#!/usr/bin/env python3
"""Merge duplicate Person nodes sharing the same name_en (keep best-connected node)."""
from __future__ import annotations

from pathlib import Path

from neo4j import GraphDatabase

CAPETIAN_NAMES = [
    "Hugh Capet",
    "Robert II of France",
    "Henry I of France",
    "Philip I of France",
    "Louis VI of France",
    "Louis VII of France",
    "Philip II of France",
    "Louis VIII of France",
    "Louis IX of France",
    "Philip III of France",
    "Philip IV of France",
    "Louis X of France",
    "Philip V of France",
    "Charles IV of France",
    "Philip VI of France",
]

OUTGOING_TYPES = (
    "SUCCEEDED_BY",
    "FATHER_OF",
    "BELONGED_TO",
    "RULED",
    "PARTICIPATED_IN",
    "SWORE_FEALTY_TO",
    "VASSAL_OF",
)
INCOMING_TYPES = ("SWORE_FEALTY_TO", "HAS_FOUNDER", "FATHER_OF", "SUCCEEDED_BY")


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


def pick_keeper(session, name_en: str) -> str | None:
    rows = session.run(
        """
        MATCH (p:Person {name_en: $name})
        RETURN elementId(p) AS id,
               size([(p)--() | 1]) AS deg,
               EXISTS { (p)-[:BELONGED_TO]->() } AS hasDyn,
               EXISTS { (p)-[:RULED]->() } AS hasRuled
        ORDER BY hasDyn DESC, hasRuled DESC, deg DESC
        LIMIT 1
        """,
        name=name_en,
    ).data()
    return rows[0]["id"] if rows else None


def copy_outgoing(session, keeper_id: str, dup_id: str, rel_type: str) -> int:
    result = session.run(
        f"""
        MATCH (dup) WHERE elementId(dup) = $dupId
        MATCH (keeper) WHERE elementId(keeper) = $keeperId
        MATCH (dup)-[r:{rel_type}]->(t)
        MERGE (keeper)-[r2:{rel_type}]->(t)
        SET r2 += properties(r)
        DELETE r
        RETURN count(*) AS c
        """,
        dupId=dup_id,
        keeperId=keeper_id,
    ).single()
    return result["c"] if result else 0


def copy_incoming(session, keeper_id: str, dup_id: str, rel_type: str) -> int:
    result = session.run(
        f"""
        MATCH (dup) WHERE elementId(dup) = $dupId
        MATCH (keeper) WHERE elementId(keeper) = $keeperId
        MATCH (s)-[r:{rel_type}]->(dup)
        MERGE (s)-[r2:{rel_type}]->(keeper)
        SET r2 += properties(r)
        DELETE r
        RETURN count(*) AS c
        """,
        dupId=dup_id,
        keeperId=keeper_id,
    ).single()
    return result["c"] if result else 0


def merge_name(session, name_en: str) -> bool:
    nodes = session.run(
        "MATCH (p:Person {name_en: $name}) RETURN elementId(p) AS id",
        name=name_en,
    ).data()
    if len(nodes) <= 1:
        return False

    keeper_id = pick_keeper(session, name_en)
    if not keeper_id:
        return False

    dup_ids = [n["id"] for n in nodes if n["id"] != keeper_id]
    for dup_id in dup_ids:
        for rel in OUTGOING_TYPES:
            copy_outgoing(session, keeper_id, dup_id, rel)
        for rel in INCOMING_TYPES:
            copy_incoming(session, keeper_id, dup_id, rel)
        session.run(
            "MATCH (dup) WHERE elementId(dup) = $dupId DETACH DELETE dup",
            dupId=dup_id,
        ).consume()

    session.run(
        """
        MATCH (keeper) WHERE elementId(keeper) = $keeperId
        SET keeper:Monarch
        """,
        keeperId=keeper_id,
    ).consume()
    return True


def main() -> None:
    env = load_env(Path(__file__).resolve().parents[1] / ".env")
    driver = GraphDatabase.driver(
        env.get("LOCAL_NEO4J_URI", "bolt://localhost:7687"),
        auth=(env.get("LOCAL_NEO4J_USERNAME", "neo4j"), env.get("LOCAL_NEO4J_PASSWORD", "password")),
    )
    db = env.get("LOCAL_NEO4J_DATABASE", "neo4j")

    with driver.session(database=db) as session:
        merged = 0
        for name in CAPETIAN_NAMES:
            if merge_name(session, name):
                merged += 1
                print(f"merged duplicates for {name}")

        dups = session.run(
            """
            MATCH (p:Person)
            WHERE p.name_en IN $names
            WITH p.name_en AS ne, count(*) AS c
            WHERE c > 1
            RETURN ne, c
            """,
            names=CAPETIAN_NAMES,
        ).data()
        print("remaining duplicates:", dups)

        try:
            session.run(
                "CREATE CONSTRAINT person_name_en IF NOT EXISTS "
                "FOR (p:Person) REQUIRE p.name_en IS UNIQUE"
            ).consume()
            print("constraint person_name_en: ok")
        except Exception as exc:
            print("constraint:", exc)

    driver.close()


if __name__ == "__main__":
    main()
