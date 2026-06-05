// Merge parallel England + Normandy SUCCEEDED_BY into one edge; inherited_title is a list
// Each block is ONE statement (no semicolon between DELETE and MERGE). Idempotent.

// --- Henry I → Stephen ---
MATCH (a:Person {name_en: "Henry I of England"}), (b:Person {name_en: "Stephen of England"})
OPTIONAL MATCH (a)-[old:SUCCEEDED_BY]->(b)
DELETE old
WITH a, b
MERGE (a)-[r:SUCCEEDED_BY]->(b)
SET r.inherited_title = ["英格兰国王", "诺曼底公爵"],
    r.inheritance_descriptions = [
      "亨利一世曾指定女儿玛蒂尔达继承；其侄斯蒂芬（威廉一世之外孙女系）抢先加冕，引发安茹内战",
      "亨利一世无男嗣，外甥斯蒂芬继位；引发与玛蒂尔达之内战"
    ],
    r.succession_types = ["旁支继位", "侄辈继位"],
    r.year = 1135,
    r.name = "斯蒂芬即位",
    r.description = "1135年斯蒂芬同时取得英格兰王位与诺曼底公爵领";

// --- Henry II → Richard I ---
MATCH (a:Person {name_en: "Henry II of England"}), (b:Person {name_en: "Richard I of England"})
OPTIONAL MATCH (a)-[old:SUCCEEDED_BY]->(b)
DELETE old
WITH a, b
MERGE (a)-[r:SUCCEEDED_BY]->(b)
SET r.inherited_title = ["英格兰国王", "诺曼底公爵"],
    r.inheritance_descriptions = [
      "亨利二世卒，理查一世继英格兰王位",
      "亨利二世卒，理查一世继诺曼底公爵"
    ],
    r.succession_type = "父子继承",
    r.year = 1189,
    r.description = "1189年理查一世同时继承英格兰王位与诺曼底公爵";

// --- Richard I → John ---
MATCH (a:Person {name_en: "Richard I of England"}), (b:Person {name_en: "John, King of England"})
OPTIONAL MATCH (a)-[old:SUCCEEDED_BY]->(b)
DELETE old
WITH a, b
MERGE (a)-[r:SUCCEEDED_BY]->(b)
SET r.inherited_title = ["英格兰国王", "诺曼底公爵"],
    r.inheritance_descriptions = [
      "理查一世无嗣，幼弟约翰继英格兰王位",
      "理查一世无嗣，幼弟约翰继诺曼底公爵"
    ],
    r.succession_type = "兄弟继承",
    r.year = 1199,
    r.description = "1199年约翰同时继承英格兰王位与诺曼底公爵";

// --- John → Henry III ---
MATCH (a:Person {name_en: "John, King of England"}), (b:Person {name_en: "Henry III of England"})
OPTIONAL MATCH (a)-[old:SUCCEEDED_BY]->(b)
DELETE old
WITH a, b
MERGE (a)-[r:SUCCEEDED_BY]->(b)
SET r.inherited_title = ["英格兰国王", "诺曼底公爵（名义）"],
    r.inheritance_descriptions = [
      "1216年约翰卒，其子亨利三世继英格兰王位",
      "1204年大陆诺曼底已失；1216年约翰卒后亨利三世仍自称公爵直至1259年放弃声索"
    ],
    r.succession_type = "父子继承",
    r.year = 1216,
    r.description = "1216年亨利三世继英格兰王位，并保有诺曼底公爵名义声索";
