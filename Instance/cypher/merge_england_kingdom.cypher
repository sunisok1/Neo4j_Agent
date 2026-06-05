// Merge duplicate Kingdom {name_en: "England"} into {name_en: "Kingdom of England"}
// Idempotent: safe when dup node already removed.

MATCH (dup:Kingdom {name_en: "England"})
MATCH (keeper:Kingdom {name_en: "Kingdom of England"})
SET keeper.name = coalesce(keeper.name, "英格兰王国"),
    keeper.capital = coalesce(keeper.capital, dup.capital),
    keeper.language = coalesce(keeper.language, dup.language),
    keeper.religion = coalesce(keeper.religion, dup.religion),
    keeper.government_seat = coalesce(keeper.government_seat, dup.government_seat),
    keeper.period_start = coalesce(keeper.period_start, dup.period_start),
    keeper.period_end = coalesce(keeper.period_end, dup.period_end),
    keeper.description = coalesce(keeper.description, dup.description);

// --- Redirect incoming: INCLUDED ---
MATCH (dup:Kingdom {name_en: "England"})
MATCH (keeper:Kingdom {name_en: "Kingdom of England"})
MATCH (a)-[r:INCLUDED]->(dup)
MERGE (a)-[r2:INCLUDED]->(keeper)
SET r2 += properties(r)
DELETE r;

// --- Redirect incoming: CONCERNS ---
MATCH (dup:Kingdom {name_en: "England"})
MATCH (keeper:Kingdom {name_en: "Kingdom of England"})
MATCH (a)-[r:CONCERNS]->(dup)
MERGE (a)-[r2:CONCERNS]->(keeper)
SET r2 += properties(r)
DELETE r;

// --- Redirect incoming: CLAIMED_THRONE_OF ---
MATCH (dup:Kingdom {name_en: "England"})
MATCH (keeper:Kingdom {name_en: "Kingdom of England"})
MATCH (a)-[r:CLAIMED_THRONE_OF]->(dup)
MERGE (a)-[r2:CLAIMED_THRONE_OF]->(keeper)
SET r2 += properties(r)
DELETE r;

// --- Redirect incoming: UNIFIED ---
MATCH (dup:Kingdom {name_en: "England"})
MATCH (keeper:Kingdom {name_en: "Kingdom of England"})
MATCH (a)-[r:UNIFIED]->(dup)
MERGE (a)-[r2:UNIFIED]->(keeper)
SET r2 += properties(r)
DELETE r;

// --- Redirect incoming: RULED (merge props if duplicate edge exists) ---
MATCH (dup:Kingdom {name_en: "England"})
MATCH (keeper:Kingdom {name_en: "Kingdom of England"})
MATCH (a)-[r:RULED]->(dup)
OPTIONAL MATCH (a)-[ex:RULED]->(keeper)
WHERE coalesce(ex.start_year, -1) = coalesce(r.start_year, -1)
  AND coalesce(ex.title, "") = coalesce(r.title, "")
WITH a, r, keeper, ex
WHERE ex IS NOT NULL
SET ex += properties(r)
DELETE r;

MATCH (dup:Kingdom {name_en: "England"})
MATCH (keeper:Kingdom {name_en: "Kingdom of England"})
MATCH (a)-[r:RULED]->(dup)
MERGE (a)-[r2:RULED]->(keeper)
SET r2 += properties(r)
DELETE r;

// --- Remove duplicate node ---
MATCH (dup:Kingdom {name_en: "England"})
DETACH DELETE dup;

// --- Validation ---
// MATCH (k:Kingdom) WHERE k.name_en CONTAINS "England" RETURN k.name_en, k.name;
// MATCH ()-[r:RULED]->(k:Kingdom) WHERE k.name_en <> "Kingdom of England" AND k.name CONTAINS "英格兰" RETURN count(r);
