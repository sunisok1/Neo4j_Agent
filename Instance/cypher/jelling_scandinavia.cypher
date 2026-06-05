// Jelling Dynasty (耶灵/克努特王朝) in Scandinavia: Denmark, Norway, Southern Sweden
// Complements house_of_wessex.cypher (England interlude). Idempotent MERGE on name_en.

// --- Dynasty & region ---
MERGE (jelling:Dynasty {name_en: "Jelling Dynasty / House of Knýtlinga"})
SET jelling.name = "耶灵王朝",
    jelling.start_year = 936,
    jelling.end_year = 1047,
    jelling.description = "以日德兰耶灵为权力中心的丹麦王室（克努特系）；936年起统一丹麦，986–1014年斯韦恩一世扩张，1016–1035年克努特建立北海帝国；1047年后支系以埃斯特里德森家族延续丹麦王位";

MERGE (scandinavia:Region {name_en: "Scandinavia"})
SET scandinavia.name = "斯堪的纳维亚",
    scandinavia.description = "北欧核心地区，含丹麦、挪威及瑞典南部（梅拉伦湖/斯科讷一带）";

MERGE (denmark:Kingdom {name_en: "Denmark"})
SET denmark.name = "丹麦",
    denmark.capital = coalesce(denmark.capital, "罗斯基勒"),
    denmark.description = "耶灵王朝本土核心；维京时代后期至克努特北海帝国的权力基座";

MERGE (norway:Kingdom {name_en: "Norway"})
SET norway.name = "挪威",
    norway.capital = coalesce(norway.capital, "特隆赫姆"),
    norway.description = "1028–1035年由克努特直接统治；此前与奥拉夫二世长期争夺";

MERGE (sweSouth:Kingdom {name_en: "Southern Sweden"})
SET sweSouth.name = "瑞典南部",
    sweSouth.capital = coalesce(sweSouth.capital, "锡格蒂纳"),
    sweSouth.description = "1026年赫尔河之战后克努特势力所及（斯科讷/梅拉伦湖周边），非全瑞典";

MERGE (scandinavia)-[:CONTAINS]->(denmark)
MERGE (scandinavia)-[:CONTAINS]->(norway)
MERGE (scandinavia)-[:CONTAINS]->(sweSouth);

MERGE (jelling)-[:RULED_OVER {period: "936-1042"}]->(denmark)
MERGE (jelling)-[:RULED_OVER {period: "986-1014;1028-1035"}]->(norway)
MERGE (jelling)-[:RULED_OVER {period: "1026-1035"}]->(sweSouth);

// --- Founders & early kings ---
MERGE (gorm:Person {name_en: "Gorm the Old"})
SET gorm.name = "老戈姆",
    gorm.is_monarch = true,
    gorm.identities = ["丹麦国王"],
    gorm.reign_start = 936,
    gorm.reign_end = 958,
    gorm.death_year = 958,
    gorm.description = "耶灵王朝第一位有明确史料的丹麦君主；葬于耶灵北冢";

MERGE (bluetooth:Person {name_en: "Harald Bluetooth"})
SET bluetooth.name = "哈拉尔·蓝牙",
    bluetooth.is_monarch = true,
    bluetooth.identities = ["丹麦国王"],
    bluetooth.reign_start = 958,
    bluetooth.reign_end = 986,
    bluetooth.death_year = 986,
    bluetooth.description = "统一丹麦并推动基督教化；耶灵石与大型环状要塞（特雷勒堡）为其政绩";

MERGE (sweyn:Person {name_en: "Sweyn Forkbeard"})
SET sweyn.name = "八字胡斯韦恩",
    sweyn.is_monarch = true,
    sweyn.identities = ["丹麦国王", "挪威国王（宣称）", "英格兰国王（1013-1014）"],
    sweyn.reign_start = 986,
    sweyn.reign_end = 1014,
    sweyn.death_year = 1014,
    sweyn.description = "986年起统治丹麦；多次入侵英格兰，1013–1014年短暂称英格兰王；1014年卒于根斯索普";

MERGE (harald2:Person {name_en: "Harald II of Denmark"})
SET harald2.name = "丹麦哈拉尔二世",
    harald2.is_monarch = true,
    harald2.identities = ["丹麦国王"],
    harald2.reign_start = 1014,
    harald2.reign_end = 1018,
    harald2.death_year = 1018,
    harald2.description = "斯韦恩之子、克努特之兄；1014–1018年与克努特争夺丹麦";

MERGE (olaf2:Person {name_en: "Olaf II of Norway"})
SET olaf2.name = "奥拉夫二世（圣奥拉夫）",
    olaf2.is_monarch = true,
    olaf2.identities = ["挪威国王"],
    olaf2.reign_start = 1015,
    olaf2.reign_end = 1028,
    olaf2.death_year = 1030,
    olaf2.description = "1015–1028年统治挪威；1028年被克努特驱逐，1030年斯蒂克莱斯塔德战死";

MERGE (magnus:Person {name_en: "Magnus the Good"})
SET magnus.name = "马格努斯一世（好人）",
    magnus.is_monarch = true,
    magnus.identities = ["挪威国王", "丹麦国王"],
    magnus.reign_start = 1035,
    magnus.reign_end = 1047,
    magnus.death_year = 1047,
    magnus.description = "奥拉夫二世之子；1035年起据挪威，1042年哈瑟克努特死后兼丹麦王位至1047年";

MERGE (sweyn2:Person {name_en: "Sweyn II Estridsson"})
SET sweyn2.name = "斯韦恩二世（埃斯特里德森）",
    sweyn2.is_monarch = true,
    sweyn2.identities = ["丹麦国王"],
    sweyn2.reign_start = 1047,
    sweyn2.reign_end = 1074,
    sweyn2.death_year = 1074,
    sweyn2.description = "克努特之甥（埃斯特里德之子）；1047年自马格努斯手中夺得丹麦，克努特系在丹麦复位";

// --- Enrich existing Knýtlinga rulers ---
MATCH (cnut:Person {name_en: "Cnut the Great"})
SET cnut.reign_start_dk = 1018,
    cnut.reign_end_dk = 1035,
    cnut.description = "1018年确立丹麦统治；1016年征服英格兰；1028年征服挪威；1026年赫尔河之战后控制瑞典南部；北海帝国建立者";

MATCH (harthacnut:Person {name_en: "Harthacnut"})
SET harthacnut.description = "克努特与诺曼的埃玛之子；1035–1042年丹麦国王，1040–1042年兼英格兰国王";

// --- Dynasty membership ---
MATCH (d:Dynasty {name_en: "Jelling Dynasty / House of Knýtlinga"})
MATCH (p:Person)
WHERE p.name_en IN [
  "Gorm the Old", "Harald Bluetooth", "Sweyn Forkbeard", "Harald II of Denmark",
  "Cnut the Great", "Harthacnut", "Sweyn II Estridsson"
]
MERGE (p)-[:BELONGED_TO]->(d);

// --- Genealogy ---
MATCH (a:Person {name_en: "Gorm the Old"}), (b:Person {name_en: "Harald Bluetooth"})
MERGE (a)-[:FATHER_OF]->(b);

MATCH (a:Person {name_en: "Harald Bluetooth"}), (b:Person {name_en: "Sweyn Forkbeard"})
MERGE (a)-[:FATHER_OF]->(b);

MATCH (a:Person {name_en: "Sweyn Forkbeard"}), (b:Person {name_en: "Cnut the Great"})
MERGE (a)-[:FATHER_OF]->(b);

MATCH (a:Person {name_en: "Sweyn Forkbeard"}), (b:Person {name_en: "Harald II of Denmark"})
MERGE (a)-[:FATHER_OF]->(b);

MATCH (a:Person {name_en: "Cnut the Great"}), (b:Person {name_en: "Harthacnut"})
MERGE (a)-[:FATHER_OF]->(b);

MATCH (a:Person {name_en: "Olaf II of Norway"}), (b:Person {name_en: "Magnus the Good"})
MERGE (a)-[:FATHER_OF]->(b);

// --- RULED (Scandinavia) ---
MATCH (dk:Kingdom {name_en: "Denmark"})
MATCH (p:Person {name_en: "Gorm the Old"})
MERGE (p)-[:RULED {title: "丹麦国王", start_year: 936, end_year: 958}]->(dk);

MATCH (dk:Kingdom {name_en: "Denmark"})
MATCH (p:Person {name_en: "Harald Bluetooth"})
MERGE (p)-[:RULED {title: "丹麦国王", start_year: 958, end_year: 986}]->(dk);

MATCH (dk:Kingdom {name_en: "Denmark"})
MATCH (p:Person {name_en: "Sweyn Forkbeard"})
MERGE (p)-[:RULED {title: "丹麦国王", start_year: 986, end_year: 1014}]->(dk);

MATCH (dk:Kingdom {name_en: "Denmark"})
MATCH (p:Person {name_en: "Harald II of Denmark"})
MERGE (p)-[:RULED {title: "丹麦国王", start_year: 1014, end_year: 1018}]->(dk);

MATCH (dk:Kingdom {name_en: "Denmark"})
MATCH (p:Person {name_en: "Cnut the Great"})
MERGE (p)-[:RULED {title: "丹麦国王", start_year: 1018, end_year: 1035}]->(dk);

MATCH (dk:Kingdom {name_en: "Denmark"})
MATCH (p:Person {name_en: "Harthacnut"})
MERGE (p)-[:RULED {title: "丹麦国王", start_year: 1035, end_year: 1042}]->(dk);

MATCH (dk:Kingdom {name_en: "Denmark"})
MATCH (p:Person {name_en: "Magnus the Good"})
MERGE (p)-[:RULED {title: "丹麦国王", start_year: 1042, end_year: 1047}]->(dk);

MATCH (dk:Kingdom {name_en: "Denmark"})
MATCH (p:Person {name_en: "Sweyn II Estridsson"})
MERGE (p)-[:RULED {title: "丹麦国王", start_year: 1047, end_year: 1074}]->(dk);

MATCH (no:Kingdom {name_en: "Norway"})
MATCH (p:Person {name_en: "Olaf II of Norway"})
MERGE (p)-[:RULED {title: "挪威国王", start_year: 1015, end_year: 1028, note: "1028年被克努特驱逐"}]->(no);

MATCH (no:Kingdom {name_en: "Norway"})
MATCH (p:Person {name_en: "Cnut the Great"})
MERGE (p)-[:RULED {title: "挪威国王", start_year: 1028, end_year: 1035}]->(no);

MATCH (no:Kingdom {name_en: "Norway"})
MATCH (p:Person {name_en: "Magnus the Good"})
MERGE (p)-[:RULED {title: "挪威国王", start_year: 1035, end_year: 1047}]->(no);

MATCH (eng:Kingdom {name_en: "Kingdom of England"})
MATCH (p:Person {name_en: "Sweyn Forkbeard"})
MERGE (p)-[:RULED {title: "英格兰国王", start_year: 1013, end_year: 1014, note: "短暂征服，1014年2月卒"}]->(eng);

// --- Denmark SUCCEEDED_BY chain ---
MATCH (a:Person {name_en: "Gorm the Old"}), (b:Person {name_en: "Harald Bluetooth"})
MERGE (a)-[r:SUCCEEDED_BY {inherited_title: ["丹麦国王"]}]->(b)
SET r.succession_type = "父子继承",
    r.year = 958,
    r.description = "958年老戈姆卒，其子蓝牙哈拉尔继位";

MATCH (a:Person {name_en: "Harald Bluetooth"}), (b:Person {name_en: "Sweyn Forkbeard"})
MERGE (a)-[r:SUCCEEDED_BY {inherited_title: ["丹麦国王"]}]->(b)
SET r.succession_type = "父子继承",
    r.year = 986,
    r.description = "986年蓝牙哈拉尔卒或被推翻，斯韦恩继位";

MATCH (a:Person {name_en: "Sweyn Forkbeard"}), (b:Person {name_en: "Harald II of Denmark"})
MERGE (a)-[r:SUCCEEDED_BY {inherited_title: ["丹麦国王"]}]->(b)
SET r.succession_type = "父子继承",
    r.year = 1014,
    r.description = "1014年斯韦恩在英格兰卒；其兄哈拉尔二世暂据丹麦";

MATCH (a:Person {name_en: "Harald II of Denmark"}), (b:Person {name_en: "Cnut the Great"})
MERGE (a)-[r:SUCCEEDED_BY {inherited_title: ["丹麦国王"]}]->(b)
SET r.succession_type = "兄弟征服",
    r.year = 1018,
    r.description = "1018年克努特击败兄哈拉尔二世，统一丹麦";

MATCH (a:Person {name_en: "Cnut the Great"}), (b:Person {name_en: "Harthacnut"})
MERGE (a)-[r:SUCCEEDED_BY {inherited_title: ["丹麦国王"]}]->(b)
SET r.succession_type = "父子继承",
    r.year = 1035,
    r.description = "1035年克努特卒，其嫡子哈瑟克努特继丹麦王位";

MATCH (a:Person {name_en: "Harthacnut"}), (b:Person {name_en: "Magnus the Good"})
MERGE (a)-[r:SUCCEEDED_BY {inherited_title: ["丹麦国王"]}]->(b)
SET r.succession_type = "选举/继承",
    r.year = 1042,
    r.dynasty_from = "Jelling Dynasty / House of Knýtlinga",
    r.dynasty_to = "House of St. Olaf",
    r.description = "1042年哈瑟克努特无嗣而卒；挪威/丹麦贵族拥立奥拉夫之子马格努斯";

MATCH (a:Person {name_en: "Magnus the Good"}), (b:Person {name_en: "Sweyn II Estridsson"})
MERGE (a)-[r:SUCCEEDED_BY {inherited_title: ["丹麦国王"]}]->(b)
SET r.succession_type = "军事争夺",
    r.year = 1047,
    r.dynasty_from = "House of St. Olaf",
    r.dynasty_to = "Jelling Dynasty / House of Knýtlinga",
    r.description = "1047年马格努斯战死；克努特外甥斯韦恩二世夺回丹麦，耶灵支系延续";

// --- Norway SUCCEEDED_BY (Jelling era) ---
MATCH (a:Person {name_en: "Olaf II of Norway"}), (b:Person {name_en: "Cnut the Great"})
MERGE (a)-[r:SUCCEEDED_BY {inherited_title: ["挪威国王"]}]->(b)
SET r.succession_type = "军事征服",
    r.year = 1028,
    r.description = "1028年奥拉夫被克努特驱逐；1030年斯蒂克莱斯塔德战死";

MATCH (a:Person {name_en: "Cnut the Great"}), (b:Person {name_en: "Magnus the Good"})
MERGE (a)-[r:SUCCEEDED_BY {inherited_title: ["挪威国王"]}]->(b)
SET r.succession_type = "奥拉夫系继承",
    r.year = 1035,
    r.description = "1035年克努特卒；挪威由奥拉夫之子马格努斯统治";

// --- Dynasty founder (Scandinavia) ---
MATCH (d:Dynasty {name_en: "Jelling Dynasty / House of Knýtlinga"})
MATCH (g:Person {name_en: "Gorm the Old"})
MERGE (d)-[hf:HAS_FOUNDER {scope: "丹麦/斯堪的纳维亚"}]->(g)
SET hf.year = 936,
    hf.description = "老戈姆为耶灵王朝在丹麦的奠基者";

// --- North Sea Empire (keep existing edge direction) ---
MATCH (empire:Empire {name_en: "North Sea Empire"})
MATCH (cnut:Person {name_en: "Cnut the Great"})
MERGE (empire)-[:FOUNDED_BY]->(cnut)
MERGE (empire)-[d:DISSOLVED_AFTER {year: 1035}]->(cnut)
SET d.description = "1035年克努特卒，北海帝国分裂";

// --- Events ---
MERGE (e:Event {name_en: "Christianization of Denmark"})
SET e.name = "丹麦基督教化",
    e.year = 965,
    e.description = "蓝牙哈拉尔受洗并推动丹麦基督教化；耶灵石见证";

MERGE (e2:Event {name_en: "Sweyn Forkbeard's conquest of England 1013"})
SET e2.name = "斯韦恩征服英格兰（1013）",
    e2.year = 1013,
    e2.description = "1013年斯韦恩再侵英格兰，埃塞尔雷德二世出逃，斯韦恩短暂称王";

MATCH (s:Person {name_en: "Sweyn Forkbeard"}), (e2:Event {name_en: "Sweyn Forkbeard's conquest of England 1013"})
MERGE (s)-[:PARTICIPATED_IN {role: "征服者"}]->(e2);

MATCH (b:Person {name_en: "Harald Bluetooth"}), (e:Event {name_en: "Christianization of Denmark"})
MERGE (b)-[:PARTICIPATED_IN {role: "推动者"}]->(e);

MATCH (o:Person {name_en: "Olaf II of Norway"}), (st:Event {name_en: "Battle of Stiklestad"})
MERGE (o)-[:PARTICIPATED_IN {role: "阵亡者"}]->(st);

MATCH (h:Event {name_en: "Battle of Helgeå"}), (st:Event {name_en: "Battle of Stiklestad"})
MERGE (h)-[:PRECEDES]->(st);

// --- Example queries ---
// MATCH path = (a:Person {name_en: "Gorm the Old"})-[:SUCCEEDED_BY* {inherited_title: "丹麦国王"}]->(b)
// WHERE b.name_en IN ["Harthacnut", "Magnus the Good", "Sweyn II Estridsson"]
// RETURN [n IN nodes(path) | n.name] AS danish_line;
//
// MATCH (p:Person)-[r:RULED]->(k:Kingdom)
// WHERE k.name_en IN ["Denmark", "Norway", "Southern Sweden"]
//   AND p.name_en IN ["Gorm the Old","Harald Bluetooth","Sweyn Forkbeard","Cnut the Great","Harthacnut","Olaf II of Norway","Magnus the Good"]
// RETURN p.name AS ruler, r.title, r.start_year, r.end_year, k.name AS realm
// ORDER BY r.start_year;
