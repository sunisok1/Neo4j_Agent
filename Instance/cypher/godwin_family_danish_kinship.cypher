// Godwin family: maternal Danish kinship (Gytha → Ulf → Estrid → Jelling dynasty)
// Harold Godwinson's link to Cnut / Sweyn II Estridsson. Idempotent MERGE on name_en.

// --- Godwin & Gytha ---
MERGE (godwin:Person {name_en: "Godwin of Wessex"})
SET godwin.name = "戈德温（威塞克斯伯爵）",
    godwin.identities = ["威塞克斯伯爵", "赫里福德伯爵"],
    godwin.reign_start = null,
    godwin.description = "克努特时期重臣，后成为威塞克斯伯爵；与丹麦贵族戈蒂联姻，使戈德温森家族与耶灵王室形成母系姻亲";

MERGE (gytha:Person {name_en: "Gytha Thorkelsdottir"})
SET gytha.name = "戈蒂·托克尔之女",
    gytha.identities = ["丹麦贵族"],
    gytha.birth_year = 997,
    gytha.death_year = 1069,
    gytha.description = "丹麦首领托尔吉尔之女；兄乌尔夫娶克努特之妹埃斯特里德，故其子女与丹麦王室为母系姻亲";

MERGE (ulf:Person {name_en: "Ulf Thorgilsson"})
SET ulf.name = "乌尔夫·托吉尔森",
    ulf.identities = ["丹麦伯爵"],
    ulf.death_year = 1027,
    ulf.description = "戈蒂之兄；娶斯韦恩一世之女埃斯特里德（克努特之妹），子斯韦恩二世为丹麦王";

MERGE (estrid:Person {name_en: "Estrid Svendsdatter"})
SET estrid.name = "埃斯特里德·斯韦恩斯达特",
    estrid.identities = ["丹麦公主", "耶灵王朝成员"],
    estrid.description = "八字胡斯韦恩之女、克努特之妹；嫁乌尔夫，为斯韦恩二世（埃斯特里德森）之母";

MERGE (edith:Person {name_en: "Edith of Wessex"})
SET edith.name = "伊迪丝（威塞克斯王后）",
    edith.identities = ["英格兰王后"],
    edith.reign_start = 1045,
    edith.reign_end = 1066,
    edith.death_year = 1075,
    edith.description = "戈德温之女；1045年嫁忏悔者爱德华，哈罗德由此成为国王内兄（妻兄）";

// --- Enrich Harold ---
MATCH (harold:Person {name_en: "Harold Godwinson"})
SET harold.description = "戈德温与戈蒂之子；母系：姨母埃斯特里德为克努特之妹，堂表亲斯韦恩二世为丹麦王；父系联姻：妹伊迪丝为忏悔者爱德华王后，1066年1月获贤人会议拥立"
WITH harold,
  CASE WHEN "丹麦王室姻亲" IN coalesce(harold.identities, [])
    THEN coalesce(harold.identities, [])
    ELSE coalesce(harold.identities, []) + ["丹麦王室姻亲"]
  END AS ids
SET harold.identities = ids;

// --- Marriage & parentage ---
MATCH (godwin:Person {name_en: "Godwin of Wessex"}), (gytha:Person {name_en: "Gytha Thorkelsdottir"})
MERGE (godwin)-[m:MARRIED_TO {year: 1022, order: "联姻"}]->(gytha)
SET m.description = "约1022–1023年联姻；戈蒂为乌尔夫之妹，乌尔夫娶克努特之妹，巩固盎格鲁—斯堪的纳维亚贵族联盟";

MATCH (godwin:Person {name_en: "Godwin of Wessex"}), (harold:Person {name_en: "Harold Godwinson"})
MERGE (godwin)-[:FATHER_OF]->(harold);

MATCH (gytha:Person {name_en: "Gytha Thorkelsdottir"}), (harold:Person {name_en: "Harold Godwinson"})
MERGE (gytha)-[:MOTHER_OF]->(harold);

MATCH (godwin:Person {name_en: "Godwin of Wessex"}), (edith:Person {name_en: "Edith of Wessex"})
MERGE (godwin)-[:FATHER_OF]->(edith);

MATCH (gytha:Person {name_en: "Gytha Thorkelsdottir"}), (edith:Person {name_en: "Edith of Wessex"})
MERGE (gytha)-[:MOTHER_OF]->(edith);

MATCH (godwin:Person {name_en: "Godwin of Wessex"}), (harold:Person {name_en: "Harold Godwinson"}), (edith:Person {name_en: "Edith of Wessex"})
MERGE (harold)-[s:RELATED_TO {kinship: "兄妹"}]->(edith)
SET s.via = "同为戈德温与戈蒂之子";

// --- Gytha ↔ Ulf (siblings) ---
MATCH (gytha:Person {name_en: "Gytha Thorkelsdottir"}), (ulf:Person {name_en: "Ulf Thorgilsson"})
MERGE (gytha)-[s:RELATED_TO {kinship: "兄妹"}]->(ulf)
SET s.description = "同为托尔吉尔·斯普拉凯灵之子，戈蒂嫁英格兰戈德温，乌尔夫娶丹麦公主埃斯特里德";

// --- Ulf ↔ Estrid marriage → Jelling ---
MATCH (ulf:Person {name_en: "Ulf Thorgilsson"}), (estrid:Person {name_en: "Estrid Svendsdatter"})
MERGE (ulf)-[m:MARRIED_TO {year: 1022}]->(estrid)
SET m.description = "乌尔夫娶克努特之妹埃斯特里德，其子斯韦恩二世为丹麦国王（埃斯特里德森王朝）";

MATCH (estrid:Person {name_en: "Estrid Svendsdatter"})
MATCH (d:Dynasty {name_en: "Jelling Dynasty / House of Knýtlinga"})
MERGE (estrid)-[:BELONGED_TO]->(d);

MATCH (sweynFb:Person {name_en: "Sweyn Forkbeard"}), (estrid:Person {name_en: "Estrid Svendsdatter"})
MERGE (sweynFb)-[:FATHER_OF]->(estrid);

MATCH (sweynFb:Person {name_en: "Sweyn Forkbeard"}), (cnut:Person {name_en: "Cnut the Great"})
MERGE (sweynFb)-[:FATHER_OF]->(cnut);

MATCH (estrid:Person {name_en: "Estrid Svendsdatter"}), (cnut:Person {name_en: "Cnut the Great"})
MERGE (estrid)-[s:RELATED_TO {kinship: "兄妹"}]->(cnut)
SET s.description = "斯韦恩一世之女，克努特大帝之妹";

MATCH (ulf:Person {name_en: "Ulf Thorgilsson"}), (sweyn2:Person {name_en: "Sweyn II Estridsson"})
MERGE (ulf)-[:FATHER_OF]->(sweyn2);

// --- Edward ↔ Edith (king's brother-in-law) ---
MATCH (edward:Person {name_en: "Edward the Confessor"}), (edith:Person {name_en: "Edith of Wessex"})
MERGE (edward)-[m:MARRIED_TO {year: 1045, month: 1, day: 23}]->(edith)
SET m.description = "1045年1月23日加冕王后；哈罗德·戈德温森为其兄";

MATCH (harold:Person {name_en: "Harold Godwinson"}), (edward:Person {name_en: "Edward the Confessor"})
MERGE (harold)-[r:RELATED_TO {kinship: "妻兄", via: "妹伊迪丝"}]->(edward)
SET r.description = "爱德华王后伊迪丝之兄，无血缘姻亲";

// --- Harold ↔ Danish royalty (maternal line) ---
MATCH (harold:Person {name_en: "Harold Godwinson"}), (gytha:Person {name_en: "Gytha Thorkelsdottir"})
MATCH (gytha)-[:RELATED_TO {kinship: "兄妹"}]->(ulf:Person {name_en: "Ulf Thorgilsson"})
MATCH (ulf)-[:MARRIED_TO]->(estrid:Person {name_en: "Estrid Svendsdatter"})
MATCH (estrid)-[:RELATED_TO {kinship: "兄妹"}]->(cnut:Person {name_en: "Cnut the Great"})
MERGE (harold)-[r:RELATED_TO {kinship: "丹麦王室姻亲", line: "母系"}]->(cnut)
SET r.path = "哈罗德 → 母戈蒂 → 兄乌尔夫 → 妻埃斯特里德 → 兄克努特",
    r.description = "母戈蒂为乌尔夫之妹，乌尔夫娶克努特之妹埃斯特里德，哈罗德经母系与耶灵丹麦王族为姻亲";

MATCH (harold:Person {name_en: "Harold Godwinson"}), (gytha:Person {name_en: "Gytha Thorkelsdottir"})
MATCH (gytha)-[:RELATED_TO {kinship: "兄妹"}]->(ulf:Person {name_en: "Ulf Thorgilsson"})
MATCH (ulf)-[:FATHER_OF]->(sweyn2:Person {name_en: "Sweyn II Estridsson"})
MERGE (harold)-[r:RELATED_TO {kinship: "堂表亲（母系）", line: "母系"}]->(sweyn2)
SET r.path = "哈罗德 → 母戈蒂 → 兄乌尔夫 → 子斯韦恩二世",
    r.description = "斯韦恩二世为乌尔夫与埃斯特里德之子，哈罗德按母系与其为堂表亲";

MATCH (harold:Person {name_en: "Harold Godwinson"}), (estrid:Person {name_en: "Estrid Svendsdatter"})
MATCH (gytha:Person {name_en: "Gytha Thorkelsdottir"})-[:RELATED_TO {kinship: "兄妹"}]->(ulf:Person {name_en: "Ulf Thorgilsson"})
MATCH (ulf)-[:MARRIED_TO]->(estrid)
MERGE (harold)-[r:RELATED_TO {kinship: "姨母（姻亲）", line: "母系"}]->(estrid)
SET r.description = "舅父乌尔夫之妻，克努特之妹，丹麦公主";

// --- Update succession edge description ---
MATCH (edward:Person {name_en: "Edward the Confessor"})-[r:SUCCEEDED_BY]->(harold:Person {name_en: "Harold Godwinson"})
SET r.description = "1066年1月忏悔者爱德华无嗣而卒；哈罗德·戈德温森（王后伊迪丝之兄）获贤人会议拥立；其家族另经母戈蒂与丹麦乌尔夫—埃斯特里德联姻，与耶灵王室有母系姻亲";

// --- Example queries ---
// MATCH path = (h:Person {name_en: "Harold Godwinson"})-[r:RELATED_TO*1..6]->(c:Person {name_en: "Cnut the Great"})
// WHERE r.line = "母系" OR "母系" IN coalesce(r.line, "")
// RETURN path;
//
// MATCH (h:Person {name_en: "Harold Godwinson"})-[r:RELATED_TO]->(x:Person)
// WHERE r.line = "母系" OR r.kinship CONTAINS "丹麦"
// RETURN h.name, r.kinship, r.path, x.name AS related;
