// House of Wessex (威塞克斯王朝): rulers Æthelred I → Edward the Confessor
// Danish interlude: Cnut → Harold Harefoot → Harthacnut (Jelling Dynasty)
// Person + is_monarch; MERGE on name_en. Idempotent.

// --- Dynasties ---
MERGE (wessexDyn:Dynasty {name_en: "House of Wessex"})
  SET wessexDyn.name = "威塞克斯王朝",
      wessexDyn.start_year = 865,
      wessexDyn.end_year = 1066,
      wessexDyn.description = "865年埃塞尔雷德一世起至1066年忏悔者爱德华；1016–1042年间英格兰王位由耶灵/克努特系丹麦人占据";

MERGE (jelling:Dynasty {name_en: "Jelling Dynasty / House of Knýtlinga"})
  SET jelling.name = "耶灵王朝",
      jelling.description = "丹麦王室；1016–1042年统治英格兰";

MERGE (england:Kingdom {name_en: "Kingdom of England"})
  SET england.name = "英格兰王国",
      england.capital = coalesce(england.capital, "伦敦"),
      england.period_start = coalesce(england.period_start, 927),
      england.language = coalesce(england.language, "古英语、古诺尔斯语");

MERGE (wessex:Kingdom {name_en: "Wessex"})
  SET wessex.name = "威塞克斯",
      wessex.description = "盎格鲁-撒克逊七国之一；埃塞尔斯坦起多合一为英格兰";

MERGE (wessex)-[:PRECURSOR_OF]->(england);

MERGE (wessexDyn)-[:RULED_OVER {period: "865-1016;1042-1066"}]->(england);
MERGE (jelling)-[:RULED_OVER {period: "1016-1042"}]->(england);

// --- Wessex rulers (from Æthelred I) ---
MERGE (aethelred1:Person {name_en: "Aethelred I of Wessex"})
  SET aethelred1.name = "埃塞尔雷德一世",
      aethelred1.is_monarch = true,
      aethelred1.identities = ["威塞克斯国王"],
      aethelred1.reign_start = 865,
      aethelred1.reign_end = 871,
      aethelred1.death_year = 871,
      aethelred1.description = "埃塞尔伍尔夫之子；阿尔弗雷德之兄；抗丹麦战争时期";

MERGE (alfred:Person {name_en: "Alfred the Great"})
  SET alfred.name = "阿尔弗雷德大帝",
      alfred.is_monarch = true,
      alfred.identities = ["威塞克斯国王", "盎格鲁-撒克逊人之王"],
      alfred.reign_start = 871,
      alfred.reign_end = 899,
      alfred.death_year = 899,
      alfred.description = "唯一称「大帝」的英格兰君主；约886年起称盎格鲁-撒克逊人之王";

MERGE (edwardElder:Person {name_en: "Edward the Elder"})
  SET edwardElder.name = "爱德华长者",
      edwardElder.is_monarch = true,
      edwardElder.identities = ["威塞克斯国王", "盎格鲁-撒克逊人之王"],
      edwardElder.reign_start = 899,
      edwardElder.reign_end = 924,
      edwardElder.death_year = 924,
      edwardElder.description = "阿尔弗雷德之子；逐步统一英格兰诸王国";

MERGE (aelfweard:Person {name_en: "Aelfweard of Wessex"})
  SET aelfweard.name = "埃尔夫威德",
      aelfweard.is_monarch = true,
      aelfweard.identities = ["威塞克斯国王"],
      aelfweard.reign_start = 924,
      aelfweard.reign_end = 924,
      aelfweard.death_year = 924,
      aelfweard.description = "924年7月即位，约16天后去世；长者爱德华之子";

MERGE (aethelstan:Person {name_en: "Aethelstan"})
  SET aethelstan.name = "埃塞尔斯坦",
      aethelstan.is_monarch = true,
      aethelstan.identities = ["英格兰国王"],
      aethelstan.reign_start = 924,
      aethelstan.reign_end = 939,
      aethelstan.death_year = 939,
      aethelstan.description = "首位广泛称「英格兰人之王」的君主";

MERGE (edmund1:Person {name_en: "Edmund I of England"})
  SET edmund1.name = "埃德蒙一世",
      edmund1.is_monarch = true,
      edmund1.identities = ["英格兰国王"],
      edmund1.reign_start = 939,
      edmund1.reign_end = 946,
      edmund1.death_year = 946,
      edmund1.description = "埃塞尔斯坦之弟";

MERGE (eadred:Person {name_en: "Eadred of England"})
  SET eadred.name = "埃德雷德",
      eadred.is_monarch = true,
      eadred.identities = ["英格兰国王"],
      eadred.reign_start = 946,
      eadred.reign_end = 955,
      eadred.death_year = 955,
      eadred.description = "埃德蒙一世之弟";

MERGE (eadwig:Person {name_en: "Eadwig of England"})
  SET eadwig.name = "埃德威格",
      eadwig.is_monarch = true,
      eadwig.identities = ["英格兰国王"],
      eadwig.reign_start = 955,
      eadwig.reign_end = 959,
      eadwig.death_year = 959,
      eadwig.description = "埃德蒙一世之子";

MERGE (edgar:Person {name_en: "Edgar of England"})
  SET edgar.name = "埃德加（和平者）",
      edgar.is_monarch = true,
      edgar.identities = ["英格兰国王"],
      edgar.epithet = "和平者",
      edgar.reign_start = 959,
      edgar.reign_end = 975,
      edgar.death_year = 975,
      edgar.description = "埃德蒙一世之子；埃德威格之弟";

MERGE (edwardMartyr:Person {name_en: "Edward the Martyr"})
  SET edwardMartyr.name = "殉教者爱德华",
      edwardMartyr.is_monarch = true,
      edwardMartyr.identities = ["英格兰国王"],
      edwardMartyr.reign_start = 975,
      edwardMartyr.reign_end = 978,
      edwardMartyr.death_year = 978,
      edwardMartyr.description = "埃德加之子；978年被杀";

MERGE (aethelred2:Person {name_en: "Aethelred the Unready"})
  SET aethelred2.name = "埃塞尔雷德二世（无准备者）",
      aethelred2.is_monarch = true,
      aethelred2.identities = ["英格兰国王"],
      aethelred2.epithet = "无准备者",
      aethelred2.reign_start = 978,
      aethelred2.reign_end = 1016,
      aethelred2.reign_periods = "978-1013;1014-1016",
      aethelred2.death_year = 1016,
      aethelred2.description = "埃德加之子；978-1016年在位（1013-1014被克努特短暂取代）";

MERGE (edmundIronside:Person {name_en: "Edmund Ironside"})
  SET edmundIronside.name = "铁甲埃德蒙",
      edmundIronside.is_monarch = true,
      edmundIronside.identities = ["英格兰国王"],
      edmundIronside.epithet = "铁甲",
      edmundIronside.reign_start = 1016,
      edmundIronside.reign_end = 1016,
      edmundIronside.death_year = 1016,
      edmundIronside.description = "埃塞尔雷德二世之子；1016年与克努特瓜分英格兰后同年去世";

// --- Jelling / Danish rulers of England (reuse Cnut) ---
MERGE (cnut:Person {name_en: "Cnut the Great"})
  SET cnut.name = "克努特大帝",
      cnut.is_monarch = true,
      cnut.identities = ["英格兰国王", "丹麦国王", "挪威国王"],
      cnut.reign_start = 1016,
      cnut.reign_end = 1035,
      cnut.death_year = 1035,
      cnut.description = "1016年征服英格兰；北海帝国建立者";

MERGE (haroldHarefoot:Person {name_en: "Harold Harefoot"})
  SET haroldHarefoot.name = "哈拉尔·兔足",
      haroldHarefoot.is_monarch = true,
      haroldHarefoot.identities = ["英格兰国王"],
      haroldHarefoot.reign_start = 1035,
      haroldHarefoot.reign_end = 1040,
      haroldHarefoot.death_year = 1040,
      haroldHarefoot.description = "克努特之子（北安普顿的埃尔弗里嘉所生）；1035-1040年统治英格兰";

MERGE (harthacnut:Person {name_en: "Harthacnut"})
  SET harthacnut.name = "哈瑟克努特",
      harthacnut.is_monarch = true,
      harthacnut.identities = ["英格兰国王", "丹麦国王"],
      harthacnut.reign_start = 1040,
      harthacnut.reign_end = 1042,
      harthacnut.death_year = 1042,
      harthacnut.description = "克努特与诺曼的埃玛之子；1040-1042年统治英格兰";

MERGE (edwardConfessor:Person {name_en: "Edward the Confessor"})
  SET edwardConfessor.name = "忏悔者爱德华",
      edwardConfessor.is_monarch = true,
      edwardConfessor.identities = ["英格兰国王"],
      edwardConfessor.reign_start = 1042,
      edwardConfessor.reign_end = 1066,
      edwardConfessor.death_year = 1066,
      edwardConfessor.description = "埃塞尔雷德二世与埃玛之子；1042年威塞克斯血脉复辟；1066年无嗣驾崩";

// --- Dynasty membership ---
MATCH (d:Dynasty {name_en: "House of Wessex"})
MATCH (p:Person)
WHERE p.name_en IN [
  "Aethelred I of Wessex", "Alfred the Great", "Edward the Elder", "Aelfweard of Wessex",
  "Aethelstan", "Edmund I of England", "Eadred of England", "Eadwig of England",
  "Edgar of England", "Edward the Martyr", "Aethelred the Unready", "Edmund Ironside",
  "Edward the Confessor"
]
MERGE (p)-[:BELONGED_TO]->(d);

MATCH (d:Dynasty {name_en: "Jelling Dynasty / House of Knýtlinga"})
MATCH (p:Person)
WHERE p.name_en IN ["Cnut the Great", "Harold Harefoot", "Harthacnut"]
MERGE (p)-[:BELONGED_TO]->(d);

// --- Genealogy (parent → child) ---
MATCH (a:Person {name_en: "Alfred the Great"}), (b:Person {name_en: "Edward the Elder"})
MERGE (a)-[:FATHER_OF]->(b);
MATCH (a:Person {name_en: "Edward the Elder"}), (b:Person {name_en: "Aelfweard of Wessex"})
MERGE (a)-[:FATHER_OF]->(b);
MATCH (a:Person {name_en: "Edward the Elder"}), (b:Person {name_en: "Aethelstan"})
MERGE (a)-[:FATHER_OF]->(b);
MATCH (a:Person {name_en: "Edward the Elder"}), (b:Person {name_en: "Edmund I of England"})
MERGE (a)-[:FATHER_OF]->(b);
MATCH (a:Person {name_en: "Edmund I of England"}), (b:Person {name_en: "Eadred of England"})
MERGE (a)-[:FATHER_OF]->(b);
MATCH (a:Person {name_en: "Edmund I of England"}), (b:Person {name_en: "Eadwig of England"})
MERGE (a)-[:FATHER_OF]->(b);
MATCH (a:Person {name_en: "Edmund I of England"}), (b:Person {name_en: "Edgar of England"})
MERGE (a)-[:FATHER_OF]->(b);
MATCH (a:Person {name_en: "Edgar of England"}), (b:Person {name_en: "Edward the Martyr"})
MERGE (a)-[:FATHER_OF]->(b);
MATCH (a:Person {name_en: "Edgar of England"}), (b:Person {name_en: "Aethelred the Unready"})
MERGE (a)-[:FATHER_OF]->(b);
MATCH (a:Person {name_en: "Aethelred the Unready"}), (b:Person {name_en: "Edmund Ironside"})
MERGE (a)-[:FATHER_OF]->(b);
MATCH (a:Person {name_en: "Aethelred the Unready"}), (b:Person {name_en: "Edward the Confessor"})
MERGE (a)-[:FATHER_OF]->(b);
MATCH (a:Person {name_en: "Cnut the Great"}), (b:Person {name_en: "Harold Harefoot"})
MERGE (a)-[:FATHER_OF]->(b);
MATCH (a:Person {name_en: "Cnut the Great"}), (b:Person {name_en: "Harthacnut"})
MERGE (a)-[:FATHER_OF]->(b);

OPTIONAL MATCH (emma:Person {name_en: "Emma of Normandy"})
OPTIONAL MATCH (atr:Person {name_en: "Aethelred the Unready"})
OPTIONAL MATCH (cn:Person {name_en: "Cnut the Great"})
WITH emma, atr, cn
FOREACH (_ IN CASE WHEN emma IS NULL OR atr IS NULL THEN [] ELSE [1] END |
  MERGE (atr)-[:SPOUSE_OF]->(emma)
)
FOREACH (_ IN CASE WHEN emma IS NULL OR cn IS NULL THEN [] ELSE [1] END |
  MERGE (cn)-[:SPOUSE_OF]->(emma)
);

// --- RULED (England) ---
MATCH (k:Kingdom {name_en: "Kingdom of England"})
MATCH (p:Person {name_en: "Aethelred I of Wessex"})
MERGE (p)-[r:RULED {title: "威塞克斯国王", start_year: 865, end_year: 871}]->(k);
MATCH (k:Kingdom {name_en: "Kingdom of England"})
MATCH (p:Person {name_en: "Alfred the Great"})
MERGE (p)-[r:RULED {title: "威塞克斯国王", start_year: 871, end_year: 899}]->(k);
MATCH (k:Kingdom {name_en: "Kingdom of England"})
UNWIND [
  {name_en: "Edward the Elder", start_year: 899, end_year: 924},
  {name_en: "Aelfweard of Wessex", start_year: 924, end_year: 924},
  {name_en: "Aethelstan", start_year: 924, end_year: 939},
  {name_en: "Edmund I of England", start_year: 939, end_year: 946},
  {name_en: "Eadred of England", start_year: 946, end_year: 955},
  {name_en: "Eadwig of England", start_year: 955, end_year: 959},
  {name_en: "Edgar of England", start_year: 959, end_year: 975},
  {name_en: "Edward the Martyr", start_year: 975, end_year: 978},
  {name_en: "Aethelred the Unready", start_year: 978, end_year: 1016, note: "1013-1014短暂被克努特取代"},
  {name_en: "Edmund Ironside", start_year: 1016, end_year: 1016},
  {name_en: "Cnut the Great", start_year: 1016, end_year: 1035},
  {name_en: "Harold Harefoot", start_year: 1035, end_year: 1040},
  {name_en: "Harthacnut", start_year: 1040, end_year: 1042},
  {name_en: "Edward the Confessor", start_year: 1042, end_year: 1066}
] AS row
MATCH (m:Person {name_en: row.name_en})
MERGE (m)-[r:RULED {title: "英格兰国王", start_year: row.start_year, end_year: row.end_year}]->(k)
SET r.note = row.note;

// --- Succession chain (includes Jelling interlude) ---
MATCH (a:Person {name_en: "Aethelred I of Wessex"}), (b:Person {name_en: "Alfred the Great"})
MERGE (a)-[r:SUCCEEDED_BY]->(b)
SET r.succession_type = "兄弟继承",
    r.year = 871,
    r.inherited_title = ["威塞克斯国王"],
    r.description = "871年埃塞尔雷德一世战死后，其弟阿尔弗雷德继位";

MATCH (a:Person {name_en: "Alfred the Great"}), (b:Person {name_en: "Edward the Elder"})
MERGE (a)-[r:SUCCEEDED_BY]->(b)
SET r.succession_type = "父子继承",
    r.year = 899,
    r.inherited_title = ["威塞克斯国王", "盎格鲁-撒克逊人之王"],
    r.description = "899年阿尔弗雷德卒，长子爱德华长者继位";

MATCH (a:Person {name_en: "Edward the Elder"}), (b:Person {name_en: "Aelfweard of Wessex"})
MERGE (a)-[r:SUCCEEDED_BY]->(b)
SET r.succession_type = "父子继承",
    r.year = 924,
    r.inherited_title = ["威塞克斯国王"],
    r.description = "924年7月爱德华长者卒，长子埃尔夫威德继位";

MATCH (a:Person {name_en: "Aelfweard of Wessex"}), (b:Person {name_en: "Aethelstan"})
MERGE (a)-[r:SUCCEEDED_BY]->(b)
SET r.succession_type = "兄弟继承",
    r.year = 924,
    r.inherited_title = ["英格兰国王"],
    r.description = "924年8月埃尔夫威德卒，其弟埃塞尔斯坦继位";

MATCH (a:Person {name_en: "Aethelstan"}), (b:Person {name_en: "Edmund I of England"})
MERGE (a)-[r:SUCCEEDED_BY]->(b)
SET r.succession_type = "兄弟继承",
    r.year = 939,
    r.inherited_title = ["英格兰国王"],
    r.description = "939年埃塞尔斯坦无嗣，其弟埃德蒙一世继位";

MATCH (a:Person {name_en: "Edmund I of England"}), (b:Person {name_en: "Eadred of England"})
MERGE (a)-[r:SUCCEEDED_BY]->(b)
SET r.succession_type = "兄弟继承",
    r.year = 946,
    r.inherited_title = ["英格兰国王"],
    r.description = "946年埃德蒙一世遇害，其弟埃德雷德继位";

MATCH (a:Person {name_en: "Eadred of England"}), (b:Person {name_en: "Eadwig of England"})
MERGE (a)-[r:SUCCEEDED_BY]->(b)
SET r.succession_type = "侄辈/旁系",
    r.year = 955,
    r.inherited_title = ["英格兰国王"],
    r.description = "955年埃德雷德无嗣，埃德蒙一世之子埃德威格继位";

MATCH (a:Person {name_en: "Eadwig of England"}), (b:Person {name_en: "Edgar of England"})
MERGE (a)-[r:SUCCEEDED_BY]->(b)
SET r.succession_type = "兄弟继承",
    r.year = 959,
    r.inherited_title = ["英格兰国王"],
    r.description = "959年埃德威格卒，其弟埃德加（和平者）继位";

MATCH (a:Person {name_en: "Edgar of England"}), (b:Person {name_en: "Edward the Martyr"})
MERGE (a)-[r:SUCCEEDED_BY]->(b)
SET r.succession_type = "父子继承",
    r.year = 975,
    r.inherited_title = ["英格兰国王"],
    r.description = "975年埃德加卒，长子殉教者爱德华继位";

MATCH (a:Person {name_en: "Edward the Martyr"}), (b:Person {name_en: "Aethelred the Unready"})
MERGE (a)-[r:SUCCEEDED_BY]->(b)
SET r.succession_type = "兄弟继承",
    r.year = 978,
    r.inherited_title = ["英格兰国王"],
    r.description = "978年殉教者爱德华被杀，其弟埃塞尔雷德二世（无准备者）继位";

MATCH (a:Person {name_en: "Aethelred the Unready"}), (b:Person {name_en: "Edmund Ironside"})
MERGE (a)-[r:SUCCEEDED_BY]->(b)
SET r.succession_type = "父子继承",
    r.year = 1016,
    r.inherited_title = ["英格兰国王"],
    r.description = "1016年埃塞尔雷德二世卒，其子铁甲埃德蒙继位";

// --- Wessex → Jelling (Danish conquest) ---
MATCH (a:Person {name_en: "Edmund Ironside"}), (b:Person {name_en: "Cnut the Great"})
MERGE (a)-[r:SUCCEEDED_BY]->(b)
SET r.succession_type = "丹麦征服",
    r.year = 1016,
    r.inherited_title = ["英格兰国王"],
    r.dynasty_from = "House of Wessex",
    r.dynasty_to = "Jelling Dynasty / House of Knýtlinga",
    r.description = "1016年埃德蒙与克努特议和并瓜分英格兰；埃德蒙同年卒，克努特成为全英格兰国王";

MATCH (w:Dynasty {name_en: "House of Wessex"}), (j:Dynasty {name_en: "Jelling Dynasty / House of Knýtlinga"})
MERGE (w)-[tc:THRONE_CONTINUED_BY]->(j)
SET tc.year = 1016,
    tc.name = "丹麦征服",
    tc.description = "1016年克努特取代威塞克斯本土线，耶灵王朝统治英格兰";

MATCH (a:Person {name_en: "Cnut the Great"}), (b:Person {name_en: "Harold Harefoot"})
MERGE (a)-[r:SUCCEEDED_BY]->(b)
SET r.succession_type = "父子继承",
    r.year = 1035,
    r.inherited_title = ["英格兰国王"],
    r.description = "1035年克努特卒，其子哈拉尔·兔足继英格兰王位";

MATCH (a:Person {name_en: "Harold Harefoot"}), (b:Person {name_en: "Harthacnut"})
MERGE (a)-[r:SUCCEEDED_BY]->(b)
SET r.succession_type = "兄弟继承",
    r.year = 1040,
    r.inherited_title = ["英格兰国王"],
    r.description = "1040年哈拉尔·兔足卒，其异母弟哈瑟克努特继英格兰王位";

// --- Jelling → Wessex (restoration) ---
MATCH (a:Person {name_en: "Harthacnut"}), (b:Person {name_en: "Edward the Confessor"})
MERGE (a)-[r:SUCCEEDED_BY]->(b)
SET r.succession_type = "威塞克斯复辟",
    r.year = 1042,
    r.inherited_title = ["英格兰国王"],
    r.dynasty_from = "Jelling Dynasty / House of Knýtlinga",
    r.dynasty_to = "House of Wessex",
    r.description = "1042年哈瑟克努特无嗣而卒，埃塞尔雷德二世之子忏悔者爱德华复位";

MATCH (j:Dynasty {name_en: "Jelling Dynasty / House of Knýtlinga"}), (w:Dynasty {name_en: "House of Wessex"})
MERGE (j)-[tc:THRONE_CONTINUED_BY]->(w)
SET tc.year = 1042,
    tc.name = "威塞克斯复辟",
    tc.description = "1042年忏悔者爱德华即位，威塞克斯血脉重返英格兰王位";

// --- Dynasty founders ---
MATCH (d:Dynasty {name_en: "House of Wessex"}), (f:Person {name_en: "Aethelred I of Wessex"})
MERGE (d)-[hf:HAS_FOUNDER]->(f)
SET hf.year = 865, hf.description = "865年起本支系连续统治威塞克斯/英格兰（至1016；1042年复辟）";

MATCH (d:Dynasty {name_en: "Jelling Dynasty / House of Knýtlinga"}), (f:Person {name_en: "Cnut the Great"})
MERGE (d)-[hf:HAS_FOUNDER {scope: "英格兰"}]->(f)
SET hf.year = 1016, hf.description = "1016-1042年统治英格兰的克努特系（耶灵王朝支系）";

// --- Example queries ---
// MATCH path=(a:Person {name_en: "Aethelred I of Wessex"})-[:SUCCEEDED_BY*]->(b:Person {name_en: "Edward the Confessor"})
// RETURN [n IN nodes(path) | n.name] AS line,
//        [r IN relationships(path) | r.succession_type + coalesce(" → " + r.dynasty_to, "")] AS steps;
//
// MATCH (p:Person)-[:BELONGED_TO]->(d:Dynasty {name_en: "Jelling Dynasty / House of Knýtlinga"})
// RETURN p.name, p.reign_start, p.reign_end ORDER BY p.reign_start;
