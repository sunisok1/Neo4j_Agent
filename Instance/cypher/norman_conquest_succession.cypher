// Norman Conquest era: England throne SUCCEEDED_BY (1066) + link to Wessex & Norman chains
// Idempotent. MERGE on name_en.

// --- Harold Godwinson (1066) ---
MATCH (k:Kingdom {name_en: "Kingdom of England"})
MERGE (harold:Person {name_en: "Harold Godwinson"})
  SET harold.name = "哈罗德·戈德温森",
      harold.is_monarch = true,
      harold.identities = ["英格兰国王"],
      harold.reign_start = 1066,
      harold.reign_end = 1066,
      harold.death_year = 1066,
      harold.description = "1066年1月忏悔者爱德华死后由贤人会议拥立；9月斯坦福桥击败挪威哈罗德·哈德拉达，10月黑斯廷斯战败阵亡";

MERGE (harold)-[r:RULED {title: "英格兰国王", start_year: 1066, end_year: 1066, note: "1月加冕至10月黑斯廷斯阵亡"}]->(k);

// --- Enrich William the Conqueror (England reign) ---
MATCH (k:Kingdom {name_en: "Kingdom of England"})
MATCH (norman:Dynasty {name_en: "Norman Dynasty"})
MATCH (william:Person {name_en: "William the Conqueror"})
SET william.is_monarch = true,
    william.reign_start = coalesce(william.reign_start, 1066),
    william.reign_end = coalesce(william.reign_end, 1087),
    william.death_year = coalesce(william.death_year, 1087),
    william.identities = CASE
      WHEN "英格兰国王" IN coalesce(william.identities, []) THEN william.identities
      ELSE coalesce(william.identities, []) + ["英格兰国王"]
    END
MERGE (william)-[r:RULED {title: "英格兰国王", start_year: 1066, end_year: 1087}]->(k)
MERGE (william)-[:BELONGED_TO]->(norman)
MERGE (norman)-[:RULED_OVER {period: "1066-1154"}]->(k);

// --- Wessex → Norman dynasty handover ---
MATCH (wessex:Dynasty {name_en: "House of Wessex"})
MATCH (norman:Dynasty {name_en: "Norman Dynasty"})
MERGE (wessex)-[tc:THRONE_CONTINUED_BY]->(norman)
SET tc.year = 1066,
    tc.name = "诺曼征服",
    tc.description = "1066年黑斯廷斯后威廉一世加冕；威塞克斯本土线让位于诺曼王朝";

// --- England succession: Edward → Harold → William ---
MATCH (edward:Person {name_en: "Edward the Confessor"}), (harold:Person {name_en: "Harold Godwinson"})
MERGE (edward)-[r:SUCCEEDED_BY]->(harold)
SET r.succession_type = "贵族推选",
    r.year = 1066,
    r.inherited_title = ["英格兰国王"],
    r.description = "1066年1月忏悔者爱德华无嗣而卒；哈罗德·戈德温森（王后伊迪丝之兄）获贤人会议拥立";

MATCH (harold:Person {name_en: "Harold Godwinson"}), (william:Person {name_en: "William the Conqueror"})
MERGE (harold)-[r:SUCCEEDED_BY]->(william)
SET r.succession_type = "军事征服",
    r.year = 1066,
    r.inherited_title = ["英格兰国王"],
    r.dynasty_from = "House of Wessex",
    r.dynasty_to = "Norman Dynasty",
    r.description = "1066年10月黑斯廷斯之战哈罗德阵亡；12月威廉加冕为英格兰国王，诺曼征服完成";

// --- Norman England chain (1066–1154); enrich existing edges ---
OPTIONAL MATCH (e:Event {name_en: "Death of William the Conqueror"})
MATCH (a:Person {name_en: "William the Conqueror"}), (b:Person {name_en: "William Rufus"})
MERGE (a)-[r:SUCCEEDED_BY {inherited_title: "英格兰国王"}]->(b)
SET r.succession_type = "分割继承",
    r.year = coalesce(e.year, 1087),
    r.name = coalesce(e.name, "威廉一世去世"),
    r.description = coalesce(
      e.description,
      "1087年威廉一世卒，次子红毛威廉继英格兰王位（诺曼家族世系为威廉三世）"
    );

MATCH (e:Event {name_en: "Death of William Rufus"})
MATCH (a:Person {name_en: "William Rufus"}), (b:Person {name_en: "Henry I of England"})
MERGE (a)-[r:SUCCEEDED_BY {inherited_title: "英格兰国王"}]->(b)
SET r.succession_type = "兄弟继承",
    r.year = coalesce(e.year, 1100),
    r.name = coalesce(e.name, "红毛威廉之死"),
    r.description = coalesce(e.description, "1100年新森林狩猎事故，亨利一世随即即位");

MATCH (a:Person {name_en: "Henry I of England"}), (b:Person {name_en: "Stephen of England"})
MERGE (a)-[r:SUCCEEDED_BY {inherited_title: "英格兰国王"}]->(b)
SET r.succession_type = "旁支继位",
    r.year = 1135,
    r.name = "斯蒂芬即位",
    r.description = "亨利一世曾指定女儿玛蒂尔达继承；其侄斯蒂芬抢先加冕，引发安茹内战";

MATCH (a:Person {name_en: "Stephen of England"}), (b:Person {name_en: "Henry II of England"})
MERGE (a)-[r:SUCCEEDED_BY {inherited_title: "英格兰国王"}]->(b)
SET r.succession_type = "条约继承",
    r.year = 1154,
    r.name = "斯蒂芬—亨利二世继承安排",
    r.description = "1153年《温彻斯特条约》约定斯蒂芬身后由玛蒂尔达之子亨利二世继位；1154年斯蒂芬去世，安茹/金雀花统治开端";

// --- Event links ---
MATCH (edward:Person {name_en: "Edward the Confessor"})
MATCH (crisis:Event {name_en: "English Succession Crisis of 1066"})
MERGE (edward)-[:PARTICIPATED_IN {role: "无嗣驾崩"}]->(crisis);

MATCH (harold:Person {name_en: "Harold Godwinson"})
MATCH (crisis:Event {name_en: "English Succession Crisis of 1066"})
MERGE (harold)-[:PARTICIPATED_IN {role: "被推选的国王"}]->(crisis);

MATCH (william:Person {name_en: "William the Conqueror"})
MATCH (hastings:Event {name_en: "Battle of Hastings"})
MERGE (william)-[:PARTICIPATED_IN {role: "胜利者"}]->(hastings);

MATCH (william:Person {name_en: "William the Conqueror"})
MATCH (conquest:Event {name_en: "Norman Conquest of England"})
MERGE (william)-[:PARTICIPATED_IN {role: "征服者"}]->(conquest);

MATCH (crisis:Event {name_en: "English Succession Crisis of 1066"})
MATCH (hastings:Event {name_en: "Battle of Hastings"})
MERGE (crisis)-[:LED_TO]->(hastings);

// --- Timeline enrichment ---
MATCH (a:Person {name_en: "Harthacnut"}), (b:Person {name_en: "Edward the Confessor"})
MATCH (a)-[r:SUCCEEDED_BY]->(b)
SET r.description = coalesce(r.description, "1042年哈瑟克努特无嗣，忏悔者爱德华复位");
MATCH (a:Event {name_en: "English Succession Crisis of 1066"}), (b:Event {name_en: "Battle of Hastings"})
MERGE (a)-[:PRECEDES]->(b);
MATCH (a:Event {name_en: "Battle of Hastings"}), (b:Event {name_en: "Norman Conquest of England"})
MERGE (a)-[:PRECEDES]->(b);

// --- Example queries ---
// MATCH path = (a:Person {name_en: "Edward the Confessor"})-[:SUCCEEDED_BY*]->(b:Person {name_en: "Henry II of England"})
// RETURN [n IN nodes(path) | n.name] AS line,
//        [r IN relationships(path) | r.year + " " + r.succession_type] AS steps;
//
// MATCH path = (a:Person {name_en: "Alfred the Great"})-[:SUCCEEDED_BY*]->(b:Person {name_en: "Henry II of England"})
// RETURN length(path) AS hops, [n IN nodes(path) | n.name] AS full_line;
