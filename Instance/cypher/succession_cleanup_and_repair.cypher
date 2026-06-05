// One-shot repair: remove mis-applied Tudor/1485 props, restore succession metadata
// Safe to re-run. Run in Neo4j Browser (database: neo4j) or via local driver.

// --- Remove spurious edge (not maintained in project sources) ---
MATCH (a:Person {name_en: "Edward the Elder"})-[r:SUCCEEDED_BY]->(b:Person {name_en: "Aethelstan"})
WHERE r.description CONTAINS "都铎" OR r.year = 1485
DELETE r;

// --- Strip global corruption (keep only Richard III → Henry VII Tudor edge) ---
MATCH (a)-[r:SUCCEEDED_BY]->(b)
WHERE (r.description CONTAINS "都铎" OR r.succession_type = "战争夺位" OR r.year = 1485)
  AND NOT (a.name_en = "Richard III of England" AND b.name_en = "Henry VII of England")
REMOVE r.year, r.name, r.note
SET r.succession_type = null, r.description = null;

// --- Capetian kings (France); no inherited_title on these edges ---
MATCH (a:Person {name_en: "Hugh Capet"})
MATCH (b:Person {name_en: "Robert II of France"})
WITH head(collect(DISTINCT a)) AS a, head(collect(DISTINCT b)) AS b
MERGE (a)-[r:SUCCEEDED_BY]->(b)
SET r.succession_type = "父子继承",
    r.description = "于格·卡佩之子罗贝尔二世正常继位";
MATCH (a:Person {name_en: "Robert II of France"}), (b:Person {name_en: "Henry I of France"})
MERGE (a)-[r:SUCCEEDED_BY]->(b)
SET r.succession_type = "父子继承",
    r.description = "罗贝尔二世之子亨利一世正常继位";
MATCH (a:Person {name_en: "Henry I of France"}), (b:Person {name_en: "Philip I of France"})
MERGE (a)-[r:SUCCEEDED_BY]->(b)
SET r.succession_type = "父子继承",
    r.description = "亨利一世之子菲利普一世正常继位";
MATCH (a:Person {name_en: "Philip I of France"}), (b:Person {name_en: "Louis VI of France"})
MERGE (a)-[r:SUCCEEDED_BY]->(b)
SET r.succession_type = "父子继承",
    r.description = "菲利普一世之子路易六世正常继位";
MATCH (a:Person {name_en: "Louis VI of France"}), (b:Person {name_en: "Louis VII of France"})
MERGE (a)-[r:SUCCEEDED_BY]->(b)
SET r.succession_type = "父子继承",
    r.description = "路易六世之子路易七世正常继位";
MATCH (a:Person {name_en: "Louis VII of France"}), (b:Person {name_en: "Philip II of France"})
MERGE (a)-[r:SUCCEEDED_BY]->(b)
SET r.succession_type = "父子继承",
    r.description = "路易七世之子腓力二世（奥古斯都）正常继位";
MATCH (a:Person {name_en: "Philip II of France"}), (b:Person {name_en: "Louis VIII of France"})
MERGE (a)-[r:SUCCEEDED_BY]->(b)
SET r.succession_type = "父子继承",
    r.description = "腓力二世之子路易八世（狮子）正常继位";
MATCH (a:Person {name_en: "Louis VIII of France"}), (b:Person {name_en: "Louis IX of France"})
MERGE (a)-[r:SUCCEEDED_BY]->(b)
SET r.succession_type = "父子继承",
    r.description = "路易八世之子路易九世（圣路易）正常继位";
MATCH (a:Person {name_en: "Louis IX of France"}), (b:Person {name_en: "Philip III of France"})
MERGE (a)-[r:SUCCEEDED_BY]->(b)
SET r.succession_type = "父子继承",
    r.description = "路易九世之子腓力三世正常继位";
MATCH (a:Person {name_en: "Philip III of France"}), (b:Person {name_en: "Philip IV of France"})
MERGE (a)-[r:SUCCEEDED_BY]->(b)
SET r.succession_type = "父子继承",
    r.description = "腓力三世之子腓力四世正常继位";
MATCH (a:Person {name_en: "Philip IV of France"}), (b:Person {name_en: "Louis X of France"})
MERGE (a)-[r:SUCCEEDED_BY]->(b)
SET r.succession_type = "父子继承",
    r.description = "腓力四世之子路易十世正常继位";
MATCH (a:Person {name_en: "Louis X of France"}), (b:Person {name_en: "Philip V of France"})
MERGE (a)-[r:SUCCEEDED_BY]->(b)
SET r.succession_type = "兄弟继承",
    r.description = "路易十世无嗣去世，其弟腓力五世（长人）继位；涉及萨利克法与继承争议";
MATCH (a:Person {name_en: "Philip V of France"}), (b:Person {name_en: "Charles IV of France"})
MERGE (a)-[r:SUCCEEDED_BY]->(b)
SET r.succession_type = "兄弟继承",
    r.description = "腓力五世无嗣去世，其弟查理四世继位";
MATCH (a:Person {name_en: "Charles IV of France"}), (b:Person {name_en: "Philip VI of France"})
MERGE (a)-[r:SUCCEEDED_BY]->(b)
SET r.succession_type = "旁支继位",
    r.description = "查理四世无嗣，卡佩直系终结；瓦卢瓦的查理一系侄孙腓力六世（卡佩旁支）加冕";

// --- Norman England throne (match by inherited_title to avoid touching ducal edges) ---
OPTIONAL MATCH (e:Event {name_en: "Death of William the Conqueror"})
MATCH (a:Person {name_en: "William the Conqueror"}), (b:Person {name_en: "William Rufus"})
MERGE (a)-[r:SUCCEEDED_BY {inherited_title: "英格兰国王"}]->(b)
SET r.succession_type = coalesce(r.succession_type, "分割继承"),
    r.year = coalesce(e.year, r.year, 1087),
    r.name = coalesce(e.name, r.name, "威廉一世去世"),
    r.description = coalesce(
      e.description,
      r.description,
      "1087年英格兰世系威廉一世（征服者）卒，次子红毛威廉继英格兰王位为威廉二世（诺曼家族世系为威廉三世）"
    );
OPTIONAL MATCH (e:Event {name_en: "Death of William Rufus"})
MATCH (a:Person {name_en: "William Rufus"}), (b:Person {name_en: "Henry I of England"})
MERGE (a)-[r:SUCCEEDED_BY {inherited_title: "英格兰国王"}]->(b)
SET r.succession_type = "兄弟继承",
    r.year = coalesce(e.year, 1100),
    r.name = coalesce(e.name, "红毛威廉之死"),
    r.description = coalesce(e.description, "新森林狩猎事故，亨利一世随即即位");

MATCH (a:Person {name_en: "Stephen of England"}), (b:Person {name_en: "Henry II of England"})
MERGE (a)-[r:SUCCEEDED_BY {inherited_title: "英格兰国王"}]->(b)
SET r.succession_type = "条约继承",
    r.year = 1154,
    r.name = "斯蒂芬—亨利二世继承安排",
    r.description = "内战后期《温彻斯特条约》（1153）约定斯蒂芬身后由玛蒂尔达之子亨利二世继位；1154年斯蒂芬去世，亨利二世即位（安茹王朝开端）";

// 双头衔合并见 succession_merge_dual_inherited_titles.cypher

// --- Plantagenet English monarch chain ---
MATCH (a:Monarch {name_en: "Henry III of England"}), (b:Monarch {name_en: "Edward I of England"})
MERGE (a)-[r:SUCCEEDED_BY {inherited_title: "英格兰国王"}]->(b)
SET r.succession_type = "父子继承",
    r.description = "亨利三世长子爱德华一世";
MATCH (a:Monarch {name_en: "Edward I of England"}), (b:Monarch {name_en: "Edward II of England"})
MERGE (a)-[r:SUCCEEDED_BY {inherited_title: "英格兰国王"}]->(b)
SET r.succession_type = "父子继承",
    r.description = "爱德华一世之子爱德华二世";
MATCH (a:Monarch {name_en: "Edward II of England"}), (b:Monarch {name_en: "Edward III of England"})
MERGE (a)-[r:SUCCEEDED_BY {inherited_title: "英格兰国王"}]->(b)
SET r.succession_type = "父子继承",
    r.description = "1327年爱德华二世被废，其子爱德华三世即位";
MATCH (a:Monarch {name_en: "Edward III of England"}), (b:Monarch {name_en: "Richard II of England"})
MERGE (a)-[r:SUCCEEDED_BY {inherited_title: "英格兰国王"}]->(b)
SET r.succession_type = "父子继承",
    r.description = "爱德华三世孙辈理查二世（黑太子爱德华之子）";
MATCH (a:Monarch {name_en: "Richard II of England"}), (b:Monarch {name_en: "Henry IV of England"})
MERGE (a)-[r:SUCCEEDED_BY {inherited_title: "英格兰国王"}]->(b)
SET r.succession_type = "篡位/旁支",
    r.year = 1399,
    r.description = "理查二世被废，冈特的约翰之子亨利四世建立兰开斯特支系统治";
MATCH (a:Monarch {name_en: "Henry IV of England"}), (b:Monarch {name_en: "Henry V of England"})
MERGE (a)-[r:SUCCEEDED_BY {inherited_title: "英格兰国王"}]->(b)
SET r.succession_type = "父子继承",
    r.description = "亨利四世之子亨利五世";
MATCH (a:Monarch {name_en: "Henry V of England"}), (b:Monarch {name_en: "Henry VI of England"})
MERGE (a)-[r:SUCCEEDED_BY {inherited_title: "英格兰国王"}]->(b)
SET r.succession_type = "父子继承",
    r.description = "亨利五世之子亨利六世，幼主即位";
MATCH (a:Monarch {name_en: "Henry VI of England"}), (b:Monarch {name_en: "Edward IV of England"})
MERGE (a)-[r:SUCCEEDED_BY {inherited_title: "英格兰国王"}]->(b)
SET r.succession_type = "约克党夺位",
    r.year = 1461,
    r.description = "玫瑰战争中约克党爱德华四世取代亨利六世（非父死子继）";
MATCH (a:Monarch {name_en: "Edward IV of England"}), (b:Monarch {name_en: "Edward V of England"})
MERGE (a)-[r:SUCCEEDED_BY {inherited_title: "英格兰国王"}]->(b)
SET r.succession_type = "父子继承",
    r.description = "爱德华四世之子爱德华五世，在位仅数月";
MATCH (a:Monarch {name_en: "Edward V of England"}), (b:Monarch {name_en: "Richard III of England"})
MERGE (a)-[r:SUCCEEDED_BY {inherited_title: "英格兰国王"}]->(b)
SET r.succession_type = "叔侄/篡位",
    r.description = "理查三世取代爱德华五世，伦敦塔王子事件";

// --- Tudor transition (only legitimate 1485 / 战争夺位 on monarch succession) ---
MATCH (a:Monarch {name_en: "Richard III of England"}), (b:Monarch {name_en: "Henry VII of England"})
OPTIONAL MATCH (a)-[old:SUCCEEDED_BY]->(b)
WHERE old.inherited_title IS NULL
DELETE old;
MATCH (a:Monarch {name_en: "Richard III of England"}), (b:Monarch {name_en: "Henry VII of England"})
MERGE (a)-[r:SUCCEEDED_BY {inherited_title: "英格兰国王"}]->(b)
SET r.succession_type = "战争夺位",
    r.year = 1485,
    r.description = "博斯沃思战败，都铎王朝开端";

// --- Drop legacy duplicate edges (same pair, multiple untitled rels) ---
MATCH (a)-[r:SUCCEEDED_BY]->(b)
WHERE r.inherited_title IS NULL
  AND size([(a)-[x:SUCCEEDED_BY]->(b) | x]) > 1
DELETE r;

// --- Validation (uncomment in Browser) ---
// MATCH (a)-[r:SUCCEEDED_BY]->(b)
// WHERE r.description CONTAINS "都铎"
//   AND NOT (a.name_en = "Richard III of England" AND b.name_en = "Henry VII of England")
// RETURN count(r) AS bad_tudor_edges;
//
// MATCH (a)-[r:SUCCEEDED_BY]->(b)
// WHERE r.succession_type = "战争夺位"
//   AND NOT (a.name_en = "Richard III of England" AND b.name_en = "Henry VII of England")
// RETURN count(r) AS bad_war_succession;
//
// MATCH (a)-[r:SUCCEEDED_BY]->(b)
// WITH a, b, coalesce(r.inherited_title, "") AS it, count(*) AS n
// WHERE n > 1
// RETURN a.name_en, b.name_en, it, n;
