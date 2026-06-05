// Duchy of Normandy: title succession 911–1469
// MERGE new rulers only; MATCH existing Person nodes (Norman/Plantagenet/Capetian)
// Title succession on SUCCEEDED_BY; inherited_title is a list (multi-title) or single-title list after import
// 1087 split succession = different successors, still multiple edges; same successor dual title = one edge
// Idempotent. Paste into Neo4j Browser (run all at once).

// --- Polity ---
MERGE (normandy:Fief {name_en: "Duchy of Normandy"})
  SET normandy.name = "诺曼底公国",
      normandy.fief_type = "公国",
      normandy.created_year = 911,
      normandy.description = "911年罗洛获封鲁昂一带；942年起统治者多称公爵；1066年后与英格兰王位联动；1204年法王收复大陆诺曼底；1259年英王亨利三世放弃声索；1469年永久并入法兰西王室领地",
      normandy.post_1204_status = "1204年起法国王室直接控制大陆诺曼底；英王仅保留海峡群岛相关名义公爵头衔至1259年《巴黎条约》",
      normandy.title_abolished_year = 1469,
      normandy.title_abolished_note = "1469年路易十一迫使其弟将诺曼底换为吉耶纳；11月9日诺曼财政厅砸碎公爵戒指，公国不再授予封臣，并入王室领地";

MERGE (france:Kingdom {name_en: "Kingdom of France"})
  SET france.name = coalesce(france.name, "法兰西王国");

MERGE (normandy)-[:VASSAL_OF {since: 911, note: "名义上为法兰西国王封臣"}]->(france);

// --- Early Norman rulers (new nodes) ---
MERGE (rollo:Person {name_en: "Rollo of Normandy"})
  SET rollo.name = "罗洛",
      rollo.identities = ["诺曼人首领", "鲁昂统治者"],
      rollo.reign_start = 911,
      rollo.reign_end = 927,
      rollo.death_year = 933,
      rollo.description = "约911年法王查理三世授封塞纳河口北岸；当代文献多称诺曼人之首（princeps Nortmannorum），无固定伯爵/公爵头衔；卒于928–933年间";

MERGE (williamLs:Person {name_en: "William Longsword"})
  SET williamLs.name = "威廉一世·长剑",
      williamLs.identities = ["鲁昂伯爵"],
      williamLs.epithet = "长剑",
      williamLs.reign_start = 927,
      williamLs.reign_end = 942,
      williamLs.death_year = 942,
      williamLs.regnal_number_normandy = 1,
      williamLs.regnal_style_normandy = "威廉一世",
      williamLs.regnal_disambiguation = "诺曼底世系首位威廉（长剑）；非英格兰国王，无英格兰序号",
      williamLs.description = "罗洛之子；927年前后继父领导诺曼人；942年在佩罗讷被佛兰德的阿尔努夫一世诱杀";

MERGE (richard1n:Person {name_en: "Richard I, Duke of Normandy"})
  SET richard1n.name = "理查一世（无畏者）",
      richard1n.identities = ["诺曼底公爵", "鲁昂伯爵"],
      richard1n.epithet = "无畏者",
      richard1n.reign_start = 942,
      richard1n.reign_end = 996,
      richard1n.death_year = 996,
      richard1n.description = "长剑之子；Planctus称其为鲁昂伯爵；942–996年巩固诺曼政权并扩张";

MERGE (richard2n:Person {name_en: "Richard II, Duke of Normandy"})
  SET richard2n.name = "理查二世（善良者）",
      richard2n.identities = ["诺曼底公爵"],
      richard2n.epithet = "善良者",
      richard2n.reign_start = 996,
      richard2n.reign_end = 1027,
      richard2n.death_year = 1026,
      richard2n.description = "首位在文献中正式使用「诺曼底公爵」称号的统治者（约1006年起普遍采用）；996–1027年在位";

MERGE (richard3n:Person {name_en: "Richard III, Duke of Normandy"})
  SET richard3n.name = "理查三世",
      richard3n.identities = ["诺曼底公爵"],
      richard3n.reign_start = 1026,
      richard3n.reign_end = 1027,
      richard3n.death_year = 1027,
      richard3n.description = "理查二世长子；在位仅约一年，1027年卒，由弟罗伯特继位";

MERGE (robert1n:Person {name_en: "Robert I, Duke of Normandy"})
  SET robert1n.name = "罗伯特一世（宽宏者）",
      robert1n.identities = ["诺曼底公爵"],
      robert1n.epithet = "宽宏者",
      robert1n.reign_start = 1027,
      robert1n.reign_end = 1035,
      robert1n.death_year = 1035,
      robert1n.description = "理查二世幼子；1027–1035年公爵；私生子威廉其后继承诺曼底";

MERGE (geoffreyAnjou:Person {name_en: "Geoffrey V, Count of Anjou"})
  SET geoffreyAnjou.name = "若弗鲁瓦五世（美男子）",
      geoffreyAnjou.identities = ["安茹伯爵", "诺曼底公爵"],
      geoffreyAnjou.epithet = "美男子 / Plantagenet",
      geoffreyAnjou.reign_start = 1144,
      geoffreyAnjou.reign_end = 1150,
      geoffreyAnjou.death_year = 1151,
      geoffreyAnjou.description = "安茹伯；1144年1月进入鲁昂，夏宣称诺曼底公爵；1149–1150年与玛蒂尔达将公国让予其子亨利，1150年法王路易七世正式承认";

// --- Enrich existing persons (no duplicate MERGE) ---
MATCH (williamC:Person {name_en: "William the Conqueror"})
SET williamC.identities = CASE
      WHEN "诺曼底公爵" IN coalesce(williamC.identities, []) THEN williamC.identities
      ELSE coalesce(williamC.identities, []) + ["诺曼底公爵"]
    END,
    williamC.duke_of_normandy_start = 1035,
    williamC.duke_of_normandy_end = 1087,
    williamC.regnal_number_england = 1,
    williamC.regnal_number_normandy = 2,
    williamC.regnal_style_england = "威廉一世",
    williamC.regnal_style_normandy = "威廉二世",
    williamC.regnal_disambiguation = "英格兰国王世系为威廉一世；诺曼底公爵世系为威廉二世（长剑威廉为诺曼一世）",
    williamC.description = coalesce(williamC.description, "1035–1087年诺曼底公爵（诺曼二世）；1066年征服英格兰（英一世）");

MATCH (williamR:Person {name_en: "William Rufus"})
SET williamR.regnal_number_england = 2,
    williamR.regnal_number_normandy = 3,
    williamR.regnal_style_england = "威廉二世",
    williamR.regnal_style_normandy = "威廉三世",
    williamR.regnal_disambiguation = "英格兰国王世系为威廉二世；诺曼家族世系为威廉三世（未继承诺曼底公爵，该头衔由兄罗伯特·柯索斯继承）",
    williamR.description = coalesce(williamR.description, "1087–1100年英格兰国王（英二世）；诺曼落号世系中的威廉三世");

MATCH (robertC:Person {name_en: "Robert Curthose"})
SET robertC.identities = CASE
      WHEN "诺曼底公爵" IN coalesce(robertC.identities, []) THEN robertC.identities
      ELSE coalesce(robertC.identities, []) + ["诺曼底公爵"]
    END,
    robertC.duke_of_normandy_start = 1087,
    robertC.duke_of_normandy_end = 1106;

MATCH (henry1:Person {name_en: "Henry I of England"})
SET henry1.identities = CASE
      WHEN "诺曼底公爵" IN coalesce(henry1.identities, []) THEN henry1.identities
      ELSE coalesce(henry1.identities, []) + ["诺曼底公爵"]
    END,
    henry1.duke_of_normandy_start = 1106,
    henry1.duke_of_normandy_end = 1135;

MATCH (stephen:Person {name_en: "Stephen of England"})
SET stephen.identities = CASE
      WHEN "诺曼底公爵" IN coalesce(stephen.identities, []) THEN stephen.identities
      ELSE coalesce(stephen.identities, []) + ["诺曼底公爵"]
    END,
    stephen.duke_of_normandy_start = 1135,
    stephen.duke_of_normandy_end = 1144,
    stephen.description = coalesce(stephen.description, "1135–1144年名义控制诺曼底；1144年被若弗鲁瓦五世攻占");

MATCH (henry2:Person {name_en: "Henry II of England"})
SET henry2.identities = CASE
      WHEN "诺曼底公爵" IN coalesce(henry2.identities, []) THEN henry2.identities
      ELSE coalesce(henry2.identities, []) + ["诺曼底公爵"]
    END,
    henry2.duke_of_normandy_start = 1150,
    henry2.duke_of_normandy_end = 1189;

MATCH (richard1e:Person {name_en: "Richard I of England"})
SET richard1e.identities = CASE
      WHEN "诺曼底公爵" IN coalesce(richard1e.identities, []) THEN richard1e.identities
      ELSE coalesce(richard1e.identities, []) + ["诺曼底公爵"]
    END,
    richard1e.duke_of_normandy_start = 1189,
    richard1e.duke_of_normandy_end = 1199;

MATCH (john:Person {name_en: "John, King of England"})
SET john.identities = CASE
      WHEN "诺曼底公爵" IN coalesce(john.identities, []) THEN john.identities
      ELSE coalesce(john.identities, []) + ["诺曼底公爵"]
    END,
    john.duke_of_normandy_start = 1199,
    john.duke_of_normandy_end = 1204,
    john.description = coalesce(john.description, "1199–1204年诺曼底公爵；1204年大陆领土被腓力二世征服");

MATCH (henry3:Person {name_en: "Henry III of England"})
SET henry3.identities = CASE
      WHEN "诺曼底公爵（名义）" IN coalesce(henry3.identities, []) THEN henry3.identities
      ELSE coalesce(henry3.identities, []) + ["诺曼底公爵（名义）"]
    END,
    henry3.duke_of_normandy_nominal_end = 1259,
    henry3.description = coalesce(henry3.description, "1204年后仅对海峡群岛等地保留名义公爵头衔；1259年《巴黎条约》放弃对大陆诺曼底声索");

// --- RULED: ducal title over Normandy ---
MATCH (n:Fief {name_en: "Duchy of Normandy"})
MATCH (p:Person {name_en: "Rollo of Normandy"})
MERGE (p)-[:RULED {title: "诺曼人之首（无固定公爵号）", start_year: 911, end_year: 927}]->(n);
MATCH (n:Fief {name_en: "Duchy of Normandy"}), (p:Person {name_en: "William Longsword"})
MERGE (p)-[:RULED {title: "鲁昂伯爵", start_year: 927, end_year: 942}]->(n);
MATCH (n:Fief {name_en: "Duchy of Normandy"}), (p:Person {name_en: "Richard I, Duke of Normandy"})
MERGE (p)-[:RULED {title: "诺曼底公爵", start_year: 942, end_year: 996}]->(n);
MATCH (n:Fief {name_en: "Duchy of Normandy"}), (p:Person {name_en: "Richard II, Duke of Normandy"})
MERGE (p)-[:RULED {title: "诺曼底公爵", start_year: 996, end_year: 1027, note: "约1006年起正式称公爵"}]->(n);
MATCH (n:Fief {name_en: "Duchy of Normandy"}), (p:Person {name_en: "Richard III, Duke of Normandy"})
MERGE (p)-[:RULED {title: "诺曼底公爵", start_year: 1026, end_year: 1027}]->(n);
MATCH (n:Fief {name_en: "Duchy of Normandy"}), (p:Person {name_en: "Robert I, Duke of Normandy"})
MERGE (p)-[:RULED {title: "诺曼底公爵", start_year: 1027, end_year: 1035}]->(n);
MATCH (n:Fief {name_en: "Duchy of Normandy"}), (p:Person {name_en: "William the Conqueror"})
MERGE (p)-[:RULED {title: "诺曼底公爵", start_year: 1035, end_year: 1087}]->(n);
MATCH (n:Fief {name_en: "Duchy of Normandy"}), (p:Person {name_en: "Robert Curthose"})
MERGE (p)-[:RULED {title: "诺曼底公爵", start_year: 1087, end_year: 1106}]->(n);
MATCH (n:Fief {name_en: "Duchy of Normandy"}), (p:Person {name_en: "Henry I of England"})
MERGE (p)-[:RULED {title: "诺曼底公爵", start_year: 1106, end_year: 1135, note: "1106年征服诺曼底后重新统一"}]->(n);
MATCH (n:Fief {name_en: "Duchy of Normandy"}), (p:Person {name_en: "Stephen of England"})
MERGE (p)-[:RULED {title: "诺曼底公爵", start_year: 1135, end_year: 1144}]->(n);
MATCH (n:Fief {name_en: "Duchy of Normandy"}), (p:Person {name_en: "Geoffrey V, Count of Anjou"})
MERGE (p)-[:RULED {title: "诺曼底公爵", start_year: 1144, end_year: 1150, note: "安茹伯爵征服诺曼底"}]->(n);
MATCH (n:Fief {name_en: "Duchy of Normandy"}), (p:Person {name_en: "Henry II of England"})
MERGE (p)-[:RULED {title: "诺曼底公爵", start_year: 1150, end_year: 1189, note: "1150年受封，金雀花王朝起点"}]->(n);
MATCH (n:Fief {name_en: "Duchy of Normandy"}), (p:Person {name_en: "Richard I of England"})
MERGE (p)-[:RULED {title: "诺曼底公爵", start_year: 1189, end_year: 1199}]->(n);
MATCH (n:Fief {name_en: "Duchy of Normandy"}), (p:Person {name_en: "John, King of England"})
MERGE (p)-[:RULED {title: "诺曼底公爵", start_year: 1199, end_year: 1204, note: "1204年失大陆诺曼底"}]->(n);
MATCH (n:Fief {name_en: "Duchy of Normandy"}), (p:Person {name_en: "Henry III of England"})
MERGE (p)-[:RULED {title: "诺曼底公爵（名义）", start_year: 1216, end_year: 1259, note: "1259年《巴黎条约》放弃声索；此后英王仅对海峡群岛保留相关名义"}]->(n);

// --- Genealogy (Norman ducal line only) ---
MATCH (a:Person {name_en: "Rollo of Normandy"}), (b:Person {name_en: "William Longsword"}) MERGE (a)-[:FATHER_OF]->(b);
MATCH (a:Person {name_en: "William Longsword"}), (b:Person {name_en: "Richard I, Duke of Normandy"}) MERGE (a)-[:FATHER_OF]->(b);
MATCH (a:Person {name_en: "Richard I, Duke of Normandy"}), (b:Person {name_en: "Richard II, Duke of Normandy"}) MERGE (a)-[:FATHER_OF]->(b);
MATCH (a:Person {name_en: "Richard II, Duke of Normandy"}), (b:Person {name_en: "Richard III, Duke of Normandy"}) MERGE (a)-[:FATHER_OF]->(b);
MATCH (a:Person {name_en: "Richard II, Duke of Normandy"}), (b:Person {name_en: "Robert I, Duke of Normandy"}) MERGE (a)-[:FATHER_OF]->(b);
MATCH (a:Person {name_en: "Robert I, Duke of Normandy"}), (b:Person {name_en: "William the Conqueror"}) MERGE (a)-[:FATHER_OF]->(b);
MATCH (a:Person {name_en: "William the Conqueror"}), (b:Person {name_en: "Robert Curthose"}) MERGE (a)-[:FATHER_OF]->(b);
MATCH (a:Person {name_en: "William the Conqueror"}), (b:Person {name_en: "William Rufus"}) MERGE (a)-[:FATHER_OF]->(b);
MATCH (a:Person {name_en: "William the Conqueror"}), (b:Person {name_en: "Henry I of England"}) MERGE (a)-[:FATHER_OF]->(b);
MATCH (a:Person {name_en: "Geoffrey V, Count of Anjou"}), (b:Person {name_en: "Henry II of England"}) MERGE (a)-[:FATHER_OF]->(b);

// --- Title succession (SUCCEEDED_BY; inherited_title on rel distinguishes parallel edges) ---
MATCH (a:Person {name_en: "Rollo of Normandy"}), (b:Person {name_en: "William Longsword"})
MERGE (a)-[r:SUCCEEDED_BY {inherited_title: "鲁昂伯爵"}]->(b)
  SET r.succession_type = "父子继承",
      r.year = 927,
      r.description = "罗洛卒后长子长剑威廉继为诺曼人之首";
MATCH (a:Person {name_en: "William Longsword"}), (b:Person {name_en: "Richard I, Duke of Normandy"})
MERGE (a)-[r:SUCCEEDED_BY {inherited_title: "诺曼底公爵"}]->(b)
  SET r.succession_type = "父子继承",
      r.year = 942,
      r.description = "长剑威廉遇害，其子理查一世继位，诺曼政权巩固";
MATCH (a:Person {name_en: "Richard I, Duke of Normandy"}), (b:Person {name_en: "Richard II, Duke of Normandy"})
MERGE (a)-[r:SUCCEEDED_BY {inherited_title: "诺曼底公爵"}]->(b)
  SET r.succession_type = "父子继承",
      r.year = 996,
      r.description = "理查二世为首位广泛采用「公爵」称号的诺曼统治者";
MATCH (a:Person {name_en: "Richard II, Duke of Normandy"}), (b:Person {name_en: "Richard III, Duke of Normandy"})
MERGE (a)-[r:SUCCEEDED_BY {inherited_title: "诺曼底公爵"}]->(b)
  SET r.succession_type = "父子继承",
      r.year = 1026,
      r.description = "理查二世长子理查三世继位";
MATCH (a:Person {name_en: "Richard III, Duke of Normandy"}), (b:Person {name_en: "Robert I, Duke of Normandy"})
MERGE (a)-[r:SUCCEEDED_BY {inherited_title: "诺曼底公爵"}]->(b)
  SET r.succession_type = "兄弟继承",
      r.year = 1027,
      r.description = "理查三世无嗣，弟罗伯特一世继位";
MATCH (a:Person {name_en: "Robert I, Duke of Normandy"}), (b:Person {name_en: "William the Conqueror"})
MERGE (a)-[r:SUCCEEDED_BY {inherited_title: "诺曼底公爵"}]->(b)
  SET r.succession_type = "私生子继承",
      r.year = 1035,
      r.description = "罗伯特一世卒，私生子威廉继诺曼底公爵位";

// 1087 分割继承：两条 SUCCEEDED_BY，各自标明 inherited_title
MATCH (a:Person {name_en: "William the Conqueror"}), (b:Person {name_en: "Robert Curthose"})
MERGE (a)-[r:SUCCEEDED_BY {inherited_title: "诺曼底公爵"}]->(b)
  SET r.succession_type = "分割继承",
      r.year = 1087,
      r.description = "1087年诺曼底世系威廉二世（征服者）卒，长子罗伯特·柯索斯继诺曼底公爵";
MATCH (a:Person {name_en: "William the Conqueror"}), (b:Person {name_en: "William Rufus"})
MERGE (a)-[r:SUCCEEDED_BY {inherited_title: "英格兰国王"}]->(b)
  SET r.succession_type = "分割继承",
      r.year = 1087,
      r.description = "1087年英格兰世系威廉一世（征服者）卒，次子红毛威廉继英格兰王位为威廉二世（诺曼家族世系为威廉三世）";

MATCH (a:Person {name_en: "Robert Curthose"}), (b:Person {name_en: "Henry I of England"})
MERGE (a)-[r:SUCCEEDED_BY {inherited_title: "诺曼底公爵"}]->(b)
  SET r.succession_type = "兄弟征服",
      r.year = 1106,
      r.description = "1106年亨利一世征服诺曼底，公国与英格兰王权再度统一";
MATCH (a:Person {name_en: "Henry I of England"}), (b:Person {name_en: "Stephen of England"})
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
MATCH (a:Person {name_en: "Stephen of England"}), (b:Person {name_en: "Geoffrey V, Count of Anjou"})
MERGE (a)-[r:SUCCEEDED_BY {inherited_title: "诺曼底公爵"}]->(b)
  SET r.succession_type = "军事征服",
      r.year = 1144,
      r.description = "1144年若弗鲁瓦五世攻占诺曼底；安茹系取代斯蒂芬对公国的控制";
MATCH (a:Person {name_en: "Geoffrey V, Count of Anjou"}), (b:Person {name_en: "Henry II of England"})
MERGE (a)-[r:SUCCEEDED_BY {inherited_title: "诺曼底公爵"}]->(b)
  SET r.succession_type = "让渡/父子",
      r.year = 1150,
      r.description = "1149–1150年若弗鲁瓦与玛蒂尔达将诺曼底让予亨利；1150年路易七世承认，金雀花统治开端";
MATCH (a:Person {name_en: "Henry II of England"}), (b:Person {name_en: "Richard I of England"})
MERGE (a)-[r:SUCCEEDED_BY]->(b)
  SET r.inherited_title = ["英格兰国王", "诺曼底公爵"],
      r.inheritance_descriptions = [
        "亨利二世卒，理查一世继英格兰王位",
        "亨利二世卒，理查一世继诺曼底公爵"
      ],
      r.succession_type = "父子继承",
      r.year = 1189,
      r.description = "1189年理查一世同时继承英格兰王位与诺曼底公爵";
MATCH (a:Person {name_en: "Richard I of England"}), (b:Person {name_en: "John, King of England"})
MERGE (a)-[r:SUCCEEDED_BY]->(b)
  SET r.inherited_title = ["英格兰国王", "诺曼底公爵"],
      r.inheritance_descriptions = [
        "理查一世无嗣，幼弟约翰继英格兰王位",
        "理查一世无嗣，幼弟约翰继诺曼底公爵"
      ],
      r.succession_type = "兄弟继承",
      r.year = 1199,
      r.description = "1199年约翰同时继承英格兰王位与诺曼底公爵";
MATCH (a:Person {name_en: "John, King of England"}), (b:Person {name_en: "Henry III of England"})
MERGE (a)-[r:SUCCEEDED_BY]->(b)
  SET r.inherited_title = ["英格兰国王", "诺曼底公爵（名义）"],
      r.inheritance_descriptions = [
        "1216年约翰卒，其子亨利三世继英格兰王位",
        "1204年大陆诺曼底已失；1216年约翰卒后亨利三世仍自称公爵直至1259年放弃声索"
      ],
      r.succession_type = "父子继承",
      r.year = 1216,
      r.description = "1216年亨利三世继英格兰王位，并保有诺曼底公爵名义声索";
MATCH (a:Person {name_en: "John, King of England"}), (b:Person {name_en: "Philip II of France"})
MERGE (a)-[r:LOST_DUCHY_TO]->(b)
  SET r.year = 1204,
      r.inherited_title = "诺曼底公爵",
      r.description = "1204年腓力二世奥古斯都征服诺曼底大陆；安茹帝国丧失该公国实权",
      r.succession_type = "法王征服";

// --- Link major event (reuse existing; no new Event nodes) ---
OPTIONAL MATCH (john:Person {name_en: "John, King of England"})
OPTIONAL MATCH (philip:Person {name_en: "Philip II of France"})
OPTIONAL MATCH (ev:Event {name_en: "Philip II annexation of Normandy"})
OPTIONAL MATCH (n:Fief {name_en: "Duchy of Normandy"})
WITH john, philip, ev, n
WHERE john IS NOT NULL AND ev IS NOT NULL
MERGE (john)-[:PARTICIPATED_IN {role: "失守一方"}]->(ev);
OPTIONAL MATCH (philip:Person {name_en: "Philip II of France"})
OPTIONAL MATCH (ev:Event {name_en: "Philip II annexation of Normandy"})
WITH philip, ev WHERE philip IS NOT NULL AND ev IS NOT NULL
MERGE (philip)-[:PARTICIPATED_IN {role: "征服者"}]->(ev);
OPTIONAL MATCH (ev:Event {name_en: "Philip II annexation of Normandy"})
OPTIONAL MATCH (n:Fief {name_en: "Duchy of Normandy"})
WITH ev, n WHERE ev IS NOT NULL AND n IS NOT NULL
MERGE (ev)-[:ENDED_ANGEVIN_RULE_IN]->(n);

// --- Norman Dynasty link (optional) ---
OPTIONAL MATCH (dyn:Dynasty {name_en: "Norman Dynasty"})
OPTIONAL MATCH (rollo:Person {name_en: "Rollo of Normandy"})
FOREACH (_ IN CASE WHEN dyn IS NULL OR rollo IS NULL THEN [] ELSE [1] END |
  MERGE (rollo)-[:BELONGED_TO]->(dyn)
);
OPTIONAL MATCH (dyn:Dynasty {name_en: "Norman Dynasty"})
OPTIONAL MATCH (williamC:Person {name_en: "William the Conqueror"})
FOREACH (_ IN CASE WHEN dyn IS NULL OR williamC IS NULL THEN [] ELSE [1] END |
  MERGE (williamC)-[:BELONGED_TO]->(dyn)
);

// --- Upgrade: migrate DUCAL_SUCCESSION -> SUCCEEDED_BY with inherited_title ---
MATCH (a:Person)-[old:DUCAL_SUCCESSION]->(b:Person)
WITH a, b, old, coalesce(old.inherited_title, old.title, "诺曼底公爵") AS it
MERGE (a)-[r:SUCCEEDED_BY {inherited_title: it}]->(b)
SET r.succession_type = old.succession_type,
    r.year = old.year,
    r.description = old.description
DELETE old;

// --- Upgrade: legacy r.title -> inherited_title on SUCCEEDED_BY ---
MATCH ()-[r:SUCCEEDED_BY]->()
WHERE r.title IS NOT NULL AND r.inherited_title IS NULL
SET r.inherited_title = r.title
REMOVE r.title;

// --- Upgrade: enrich England-only SUCCEEDED_BY from norman_dynasty_succession_update ---
MATCH (a:Person {name_en: "William the Conqueror"}), (b:Person {name_en: "William Rufus"})
MERGE (a)-[r:SUCCEEDED_BY {inherited_title: "英格兰国王"}]->(b)
SET r.succession_type = coalesce(r.succession_type, "分割继承"),
    r.year = coalesce(r.year, 1087);
MATCH (a:Person {name_en: "William Rufus"}), (b:Person {name_en: "Henry I of England"})
MERGE (a)-[r:SUCCEEDED_BY {inherited_title: "英格兰国王"}]->(b);
MATCH (a:Person {name_en: "Henry I of England"}), (b:Person {name_en: "Stephen of England"})
MERGE (a)-[r:SUCCEEDED_BY {inherited_title: "英格兰国王"}]->(b);
MATCH (a:Person {name_en: "Stephen of England"}), (b:Person {name_en: "Henry II of England"})
MERGE (a)-[r:SUCCEEDED_BY {inherited_title: "英格兰国王"}]->(b);

// --- Upgrade: regnal numbering (England vs Normandy lines) ---
MATCH (p:Person {name_en: "William Longsword"})
SET p.regnal_number_normandy = 1,
    p.regnal_style_normandy = "威廉一世",
    p.regnal_disambiguation = coalesce(p.regnal_disambiguation, "诺曼底世系首位威廉（长剑）；非英格兰国王，无英格兰序号");
MATCH (p:Person {name_en: "William the Conqueror"})
SET p.regnal_number_england = 1,
    p.regnal_number_normandy = 2,
    p.regnal_style_england = "威廉一世",
    p.regnal_style_normandy = "威廉二世",
    p.regnal_disambiguation = "英格兰国王世系为威廉一世；诺曼底公爵世系为威廉二世（长剑威廉为诺曼一世）";
MATCH (p:Person {name_en: "William Rufus"})
SET p.regnal_number_england = 2,
    p.regnal_number_normandy = 3,
    p.regnal_style_england = "威廉二世",
    p.regnal_style_normandy = "威廉三世",
    p.regnal_disambiguation = "英格兰国王世系为威廉二世；诺曼家族世系为威廉三世（未继承诺曼底公爵）";

// --- Example queries ---
// MATCH (p:Person)
// WHERE p.name_en IN ["William the Conqueror", "William Rufus", "William Longsword"]
// RETURN p.name, p.regnal_style_england, p.regnal_style_normandy, p.regnal_disambiguation;
//
// MATCH (w:Person {name_en: "William the Conqueror"})-[r:SUCCEEDED_BY]->(h)
// WHERE r.succession_type = "分割继承"
// RETURN h.name, r.inherited_title, r.description;
//
// MATCH (rollo:Person {name_en: "Rollo of Normandy"})
// MATCH (end:Person {name_en: "Henry III of England"})
// MATCH p = (rollo)-[:SUCCEEDED_BY*]->(end)
// WHERE ALL(rel IN relationships(p) WHERE
//   ANY(t IN rel.inherited_title WHERE t CONTAINS "诺曼底" OR t = "鲁昂伯爵"))
// RETURN [n IN nodes(p) | n.name] AS ducal_line, [rel IN relationships(p) | rel.inherited_title] AS titles;
