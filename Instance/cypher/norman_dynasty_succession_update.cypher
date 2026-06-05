// Norman Dynasty: enrich SUCCEEDED_BY (inheritance notes from death events)
// Does NOT delete Event nodes. Idempotent: safe to re-run.

// --- 威廉一世 → 威廉二世（1087；事件「威廉一世去世」）---
OPTIONAL MATCH (e:Event {name_en: "Death of William the Conqueror"})
MATCH (a:Person {name_en: "William the Conqueror"})
MATCH (b:Person {name_en: "William Rufus"})
MERGE (a)-[r:SUCCEEDED_BY {inherited_title: "英格兰国王"}]->(b)
SET r.succession_type = "父子继承",
    r.year = coalesce(e.year, 1087),
    r.name = coalesce(e.name, "威廉一世去世"),
    r.description = coalesce(
      e.description,
      "王国分裂：英格兰归威廉二世，诺曼底归罗伯特·柯索斯"
    ),
    r.note = "原事件节点 Death of William the Conqueror 信息已迁入此关系";

// --- 威廉二世 → 亨利一世（1100；事件「红毛威廉之死」）---
OPTIONAL MATCH (e:Event {name_en: "Death of William Rufus"})
MATCH (a:Person {name_en: "William Rufus"})
MATCH (b:Person {name_en: "Henry I of England"})
MERGE (a)-[r:SUCCEEDED_BY {inherited_title: "英格兰国王"}]->(b)
SET r.succession_type = "兄弟继承",
    r.year = coalesce(e.year, 1100),
    r.name = coalesce(e.name, "红毛威廉之死"),
    r.description = coalesce(
      e.description,
      "新森林狩猎事故，亨利一世随即即位"
    ),
    r.note = "原事件节点 Death of William Rufus 信息已迁入此关系";

// 亨利一世 → 斯蒂芬：双头衔合并边见 normandy_duchy_succession.cypher

// --- 斯蒂芬 → 亨利二世（1154；诺曼王朝王位终结前最后一位直接关联者）---
MATCH (a:Person {name_en: "Stephen of England"})
MATCH (b:Person {name_en: "Henry II of England"})
MERGE (a)-[r:SUCCEEDED_BY {inherited_title: "英格兰国王"}]->(b)
SET r.succession_type = "条约继承",
    r.year = coalesce(r.year, 1154),
    r.name = "斯蒂芬—亨利二世继承安排",
    r.description = "内战后期《温彻斯特条约》（1153）约定斯蒂芬身后由玛蒂尔达之子亨利二世继位；1154年斯蒂芬去世，亨利二世即位（安茹王朝开端）";
