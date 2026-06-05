// Capetian dynasty (卡佩王朝): rulers, succession, milestones
// Kings: Person:Monarch; identities = list of titles/roles (replaces title + role)
// Idempotent: MERGE on name_en. Paste into Neo4j Browser (run all at once).

// --- Dynasty & polity ---
MERGE (capet:Dynasty {name_en: "House of Capet"})
  SET capet.name = "卡佩王朝",
      capet.start_year = 987,
      capet.end_year = 1328,
      capet.description = "987年于格·卡佩起统治法兰西王国的卡佩直系王朝；1328年查理四世无嗣后直系终结，王位由瓦卢瓦旁支继承";

MERGE (valois:Dynasty {name_en: "House of Valois"})
  SET valois.name = "瓦卢瓦王朝",
      valois.start_year = 1328,
      valois.end_year = 1589,
      valois.description = "卡佩家族旁支；1328年腓力六世即位后成为统治法兰西的王朝，1589年亨利三世死后由波旁取代";

MERGE (valois)-[:CADET_BRANCH_OF]->(capet);
MERGE (capet)-[throneHandover:THRONE_CONTINUED_BY]->(valois)
  SET throneHandover.year = 1328,
      throneHandover.name = "瓦卢瓦继位",
      throneHandover.description = "查理四世无嗣，腓力六世（瓦卢瓦支系）加冕；卡佩直系终结、瓦卢瓦王朝开端，百年战争导火索之一";

MERGE (france:Kingdom {name_en: "Kingdom of France"})
  SET france.name = "法兰西王国",
      france.capital = "巴黎（王室驻跸）",
      france.period_start = 987,
      france.description = "中世纪卡佩诸王名义上的封建王国；王权长期限于法兰西岛王领，后逐步扩张";

MERGE (ile:Region {name_en: "Île-de-France"})
  SET ile.name = "法兰西岛",
      ile.type = "王领核心区",
      ile.description = "卡佩王权直接控制的腹地，巴黎所在";

MERGE (ile)-[:CORE_OF]->(france);

// --- Capetian kings (Person:Monarch) ---
MERGE (hugh:Person {name_en: "Hugh Capet"})
  SET hugh.name = "于格·卡佩",
      hugh.identities = ["法兰西国王"],
      hugh.reign_start = 987,
      hugh.reign_end = 996,
      hugh.death_year = 996,
      hugh.description = "987年加冕，终结加洛林直系对王位的占据；开创卡佩世系";

MERGE (robert2:Person {name_en: "Robert II of France"})
  SET robert2.name = "罗贝尔二世（虔诚者）",
      robert2.identities = ["法兰西国王"],
      robert2.epithet = "虔诚者",
      robert2.reign_start = 996,
      robert2.reign_end = 1031,
      robert2.death_year = 1031,
      robert2.description = "卡佩第二代；与教会关系紧密，王权仍弱";

MERGE (henry1:Person {name_en: "Henry I of France"})
  SET henry1.name = "亨利一世",
      henry1.identities = ["法兰西国王"],
      henry1.reign_start = 1031,
      henry1.reign_end = 1060,
      henry1.death_year = 1060,
      henry1.description = "诺曼底公爵威廉的宗主之一；1057年瓦拉维尔之战试图遏制诺曼底";

MERGE (philip1:Person {name_en: "Philip I of France"})
  SET philip1.name = "菲利普一世",
      philip1.identities = ["法兰西国王"],
      philip1.reign_start = 1060,
      philip1.reign_end = 1108,
      philip1.death_year = 1108,
      philip1.description = "1060年幼龄即位；1066年诺曼征服时仍由摄政，王权孱弱";

MERGE (louis6:Person {name_en: "Louis VI of France"})
  SET louis6.name = "路易六世（胖子）",
      louis6.identities = ["法兰西国王"],
      louis6.epithet = "胖子",
      louis6.reign_start = 1108,
      louis6.reign_end = 1137,
      louis6.death_year = 1137,
      louis6.description = "整顿王领、打击地方豪强，卡佩王权实质性巩固的起点";

MERGE (louis7:Person {name_en: "Louis VII of France"})
  SET louis7.name = "路易七世（幼王）",
      louis7.identities = ["法兰西国王"],
      louis7.epithet = "幼王",
      louis7.reign_start = 1137,
      louis7.reign_end = 1180,
      louis7.death_year = 1180,
      louis7.description = "参加第二次十字军；1152年与阿基坦的埃莉诺离婚，安茹—英格兰势力坐大";

MERGE (philip2:Person {name_en: "Philip II of France"})
  SET philip2.name = "腓力二世（奥古斯都）",
      philip2.identities = ["法兰西国王"],
      philip2.epithet = "奥古斯都",
      philip2.reign_start = 1180,
      philip2.reign_end = 1223,
      philip2.death_year = 1223,
      philip2.description = "击败安茹帝国；1204年收复诺曼底等地；1214年布汶之战确立法国优势";

MERGE (louis8:Person {name_en: "Louis VIII of France"})
  SET louis8.name = "路易八世（狮子）",
      louis8.identities = ["法兰西国王"],
      louis8.epithet = "狮子",
      louis8.reign_start = 1223,
      louis8.reign_end = 1226,
      louis8.death_year = 1226,
      louis8.description = "短暂在位；阿尔比十字军后期作为王太子已参与南方战事";

MERGE (louis9:Person {name_en: "Louis IX of France"})
  SET louis9.name = "路易九世（圣路易）",
      louis9.identities = ["法兰西国王"],
      louis9.epithet = "圣路易",
      louis9.reign_start = 1226,
      louis9.reign_end = 1270,
      louis9.death_year = 1270,
      louis9.description = "中世纪法兰西模范君主；第七次十字军；1297年封圣";

MERGE (philip3:Person {name_en: "Philip III of France"})
  SET philip3.name = "腓力三世（硬汉子）",
      philip3.identities = ["法兰西国王"],
      philip3.epithet = "硬汉子",
      philip3.reign_start = 1270,
      philip3.reign_end = 1285,
      philip3.death_year = 1285,
      philip3.description = "延续向南扩张；1285年征阿拉贡时阵亡";

MERGE (philip4:Person {name_en: "Philip IV of France"})
  SET philip4.name = "腓力四世（美男子）",
      philip4.identities = ["法兰西国王"],
      philip4.epithet = "美男子",
      philip4.reign_start = 1285,
      philip4.reign_end = 1314,
      philip4.death_year = 1314,
      philip4.description = "强化王权对抗教廷；1302年召开三级会议；1312年取缔圣殿骑士团";

MERGE (louis10:Person {name_en: "Louis X of France"})
  SET louis10.name = "路易十世（争吵者）",
      louis10.identities = ["法兰西国王"],
      louis10.epithet = "争吵者",
      louis10.reign_start = 1314,
      louis10.reign_end = 1316,
      louis10.death_year = 1316,
      louis10.description = "卡佩末代直系之一；在位短暂";

MERGE (philipV:Person {name_en: "Philip V of France"})
  SET philipV.name = "腓力五世（长人）",
      philipV.identities = ["法兰西国王"],
      philipV.epithet = "长人",
      philipV.reign_start = 1316,
      philipV.reign_end = 1322,
      philipV.death_year = 1322,
      philipV.description = "1316年即位；涉及萨利克法与女性/母系继承争议";

MERGE (charles4:Person {name_en: "Charles IV of France"})
  SET charles4.name = "查理四世（美男子）",
      charles4.identities = ["法兰西国王"],
      charles4.epithet = "美男子",
      charles4.reign_start = 1322,
      charles4.reign_end = 1328,
      charles4.death_year = 1328,
      charles4.description = "卡佩直系末王；1328年无嗣去世，王冠转入瓦卢瓦家族";

MERGE (philip6:Person {name_en: "Philip VI of France"})
  SET philip6.name = "腓力六世",
      philip6.identities = ["法兰西国王", "瓦卢瓦王朝开国君主"],
      philip6.epithet = "瓦卢瓦的",
      philip6.reign_start = 1328,
      philip6.reign_end = 1350,
      philip6.death_year = 1350,
      philip6.description = "瓦卢瓦的查理之孙、腓力四世侄孙；1328年加冕，卡佩直系终结后首位法王，百年战争前夕";

MATCH (p:Person)
WHERE p.name_en IN [
  "Hugh Capet", "Robert II of France", "Henry I of France", "Philip I of France",
  "Louis VI of France", "Louis VII of France", "Philip II of France", "Louis VIII of France",
  "Louis IX of France", "Philip III of France", "Philip IV of France", "Louis X of France",
  "Philip V of France", "Charles IV of France", "Philip VI of France"
]
SET p:Monarch;

// --- Key events ---
MERGE (ev987:Event {name_en: "Coronation of Hugh Capet"})
  SET ev987.name = "于格·卡佩加冕",
      ev987.year = 987,
      ev987.description = "卡佩王朝起点；加洛林名义上的王位传承在此转折";

MERGE (ev1057:Event {name_en: "Battle of Varaville"})
  SET ev1057.name = "瓦拉维尔之战",
      ev1057.year = 1057,
      ev1057.description = "亨利一世与少年菲利普一方对诺曼底威廉的挫败性胜利，但未根除诺曼势力";

MERGE (ev1066ctx:Event {name_en: "Capetian regency during Norman Conquest"})
  SET ev1066ctx.name = "诺曼征服时期的卡佩摄政",
      ev1066ctx.year = 1066,
      ev1066ctx.description = "菲利普一世年幼，无力干预威廉跨海征服英格兰";

MERGE (ev1108:Event {name_en: "Louis VI consolidation of royal domain"})
  SET ev1108.name = "路易六世整顿王领",
      ev1108.year = 1108,
      ev1108.description = "卡佩从「法兰西岛领主」走向更强王权的阶段标志";

MERGE (ev1152:Event {name_en: "Louis VII divorce from Eleanor"})
  SET ev1152.name = "路易七世与埃莉诺离婚",
      ev1152.year = 1152,
      ev1152.description = "阿基坦归埃莉诺，后嫁亨利二世，安茹—英格兰霸权形成";

MERGE (ev1204:Event {name_en: "Philip II annexation of Normandy"})
  SET ev1204.name = "腓力二世收复诺曼底",
      ev1204.year = 1204,
      ev1204.description = "约翰王失守，法王将诺曼底等安茹遗产大批并入王室";

MERGE (ev1214:Event {name_en: "Battle of Bouvines"})
  SET ev1214.name = "布汶之战",
      ev1214.year = 1214,
      ev1214.description = "腓力二世击败神圣罗马帝国与英格兰联盟，法兰西王权威信高峰";

MERGE (ev1248:Event {name_en: "Seventh Crusade"})
  SET ev1248.name = "第七次十字军",
      ev1248.year = 1248,
      ev1248.description = "路易九世亲征埃及，1249年曼苏拉战败被俘";

MERGE (ev1302:Event {name_en: "Estates-General of 1302"})
  SET ev1302.name = "1302年三级会议",
      ev1302.year = 1302,
      ev1302.description = "腓力四世为对抗教廷征税与动员而召开，王权与等级政治制度化";

MERGE (ev1312:Event {name_en: "Suppression of the Knights Templar"})
  SET ev1312.name = "取缔圣殿骑士团",
      ev1312.year = 1312,
      ev1312.description = "腓力四世在教会压力下消灭圣殿骑士团并没收财产";

MERGE (estates:Institution {name_en: "Estates-General"})
  SET estates.name = "三级会议",
      estates.description = "教士、贵族、市民代表会议；1302年起成为法王动员与征税的重要工具";

// --- Dynasty & rule ---
MERGE (capet)-[capetFounder:HAS_FOUNDER]->(hugh)
  SET capetFounder.name = "开创者",
      capetFounder.year = 987,
      capetFounder.description = "987年加冕，开创卡佩王朝";
MERGE (valois)-[valoisFounder:HAS_FOUNDER]->(philip6)
  SET valoisFounder.name = "开创者",
      valoisFounder.year = 1328,
      valoisFounder.description = "1328年加冕，瓦卢瓦王朝首位法兰西国王";

MERGE (capet)-[:RULED_OVER {period: "987-1328 直系在位"}]->(france);
MERGE (valois)-[:RULED_OVER {period: "1328 起继承王位"}]->(france);

MERGE (hugh)-[:BELONGED_TO]->(capet);
MERGE (robert2)-[:BELONGED_TO]->(capet);
MERGE (henry1)-[:BELONGED_TO]->(capet);
MERGE (philip1)-[:BELONGED_TO]->(capet);
MERGE (louis6)-[:BELONGED_TO]->(capet);
MERGE (louis7)-[:BELONGED_TO]->(capet);
MERGE (philip2)-[:BELONGED_TO]->(capet);
MERGE (louis8)-[:BELONGED_TO]->(capet);
MERGE (louis9)-[:BELONGED_TO]->(capet);
MERGE (philip3)-[:BELONGED_TO]->(capet);
MERGE (philip4)-[:BELONGED_TO]->(capet);
MERGE (louis10)-[:BELONGED_TO]->(capet);
MERGE (philipV)-[:BELONGED_TO]->(capet);
MERGE (charles4)-[:BELONGED_TO]->(capet);
MERGE (philip6)-[:BELONGED_TO]->(valois);

MERGE (hugh)-[:RULED {title: "法兰西国王", start_year: 987, end_year: 996}]->(france);
MERGE (robert2)-[:RULED {title: "法兰西国王", start_year: 996, end_year: 1031}]->(france);
MERGE (henry1)-[:RULED {title: "法兰西国王", start_year: 1031, end_year: 1060}]->(france);
MERGE (philip1)-[:RULED {title: "法兰西国王", start_year: 1060, end_year: 1108}]->(france);
MERGE (louis6)-[:RULED {title: "法兰西国王", start_year: 1108, end_year: 1137}]->(france);
MERGE (louis7)-[:RULED {title: "法兰西国王", start_year: 1137, end_year: 1180}]->(france);
MERGE (philip2)-[:RULED {title: "法兰西国王", start_year: 1180, end_year: 1223}]->(france);
MERGE (louis8)-[:RULED {title: "法兰西国王", start_year: 1223, end_year: 1226}]->(france);
MERGE (louis9)-[:RULED {title: "法兰西国王", start_year: 1226, end_year: 1270}]->(france);
MERGE (philip3)-[:RULED {title: "法兰西国王", start_year: 1270, end_year: 1285}]->(france);
MERGE (philip4)-[:RULED {title: "法兰西国王", start_year: 1285, end_year: 1314}]->(france);
MERGE (louis10)-[:RULED {title: "法兰西国王", start_year: 1314, end_year: 1316}]->(france);
MERGE (philipV)-[:RULED {title: "法兰西国王", start_year: 1316, end_year: 1322}]->(france);
MERGE (charles4)-[:RULED {title: "法兰西国王", start_year: 1322, end_year: 1328}]->(france);
MERGE (philip6)-[:RULED {title: "法兰西国王", start_year: 1328, end_year: 1350}]->(france);

// --- Succession chain (father → son where applicable) ---
MERGE (hugh)-[:FATHER_OF]->(robert2);
MERGE (robert2)-[:FATHER_OF]->(henry1);
MERGE (henry1)-[:FATHER_OF]->(philip1);
MERGE (philip1)-[:FATHER_OF]->(louis6);
MERGE (louis6)-[:FATHER_OF]->(louis7);
MERGE (louis7)-[:FATHER_OF]->(philip2);
MERGE (philip2)-[:FATHER_OF]->(louis8);
MERGE (louis8)-[:FATHER_OF]->(louis9);
MERGE (louis9)-[:FATHER_OF]->(philip3);
MERGE (philip3)-[:FATHER_OF]->(philip4);
MERGE (philip4)-[:FATHER_OF]->(louis10);
MERGE (philip4)-[:FATHER_OF]->(philipV);
MERGE (philip4)-[:FATHER_OF]->(charles4);

MERGE (hugh)-[sb1:SUCCEEDED_BY]->(robert2)
  SET sb1.succession_type = "父子继承",
      sb1.description = "于格·卡佩之子罗贝尔二世正常继位";
MERGE (robert2)-[sb2:SUCCEEDED_BY]->(henry1)
  SET sb2.succession_type = "父子继承",
      sb2.description = "罗贝尔二世之子亨利一世正常继位";
MERGE (henry1)-[sb3:SUCCEEDED_BY]->(philip1)
  SET sb3.succession_type = "父子继承",
      sb3.description = "亨利一世之子菲利普一世正常继位";
MERGE (philip1)-[sb4:SUCCEEDED_BY]->(louis6)
  SET sb4.succession_type = "父子继承",
      sb4.description = "菲利普一世之子路易六世正常继位";
MERGE (louis6)-[sb5:SUCCEEDED_BY]->(louis7)
  SET sb5.succession_type = "父子继承",
      sb5.description = "路易六世之子路易七世正常继位";
MERGE (louis7)-[sb6:SUCCEEDED_BY]->(philip2)
  SET sb6.succession_type = "父子继承",
      sb6.description = "路易七世之子腓力二世（奥古斯都）正常继位";
MERGE (philip2)-[sb7:SUCCEEDED_BY]->(louis8)
  SET sb7.succession_type = "父子继承",
      sb7.description = "腓力二世之子路易八世（狮子）正常继位";
MERGE (louis8)-[sb8:SUCCEEDED_BY]->(louis9)
  SET sb8.succession_type = "父子继承",
      sb8.description = "路易八世之子路易九世（圣路易）正常继位";
MERGE (louis9)-[sb9:SUCCEEDED_BY]->(philip3)
  SET sb9.succession_type = "父子继承",
      sb9.description = "路易九世之子腓力三世正常继位";
MERGE (philip3)-[sb10:SUCCEEDED_BY]->(philip4)
  SET sb10.succession_type = "父子继承",
      sb10.description = "腓力三世之子腓力四世正常继位";
MERGE (philip4)-[sb11:SUCCEEDED_BY]->(louis10)
  SET sb11.succession_type = "父子继承",
      sb11.description = "腓力四世之子路易十世正常继位";
MERGE (louis10)-[sb12:SUCCEEDED_BY]->(philipV)
  SET sb12.succession_type = "兄弟继承",
      sb12.description = "路易十世无嗣去世，其弟腓力五世（长人）继位；涉及萨利克法与继承争议";
MERGE (philipV)-[sb13:SUCCEEDED_BY]->(charles4)
  SET sb13.succession_type = "兄弟继承",
      sb13.description = "腓力五世无嗣去世，其弟查理四世继位";
MERGE (charles4)-[sb14:SUCCEEDED_BY]->(philip6)
  SET sb14.succession_type = "旁支继位",
      sb14.description = "查理四世无嗣，卡佩直系终结；瓦卢瓦的查理一系侄孙腓力六世（卡佩旁支）加冕";

// --- Milestone participation ---
MERGE (hugh)-[:PARTICIPATED_IN {role: "主角"}]->(ev987);
MERGE (ev987)-[:ESTABLISHED]->(capet);

MERGE (henry1)-[:PARTICIPATED_IN {role: "一方统帅"}]->(ev1057);
MERGE (philip1)-[:PARTICIPATED_IN {role: "名义君主（年幼）"}]->(ev1057);

MERGE (philip1)-[:PARTICIPATED_IN {role: "无法有效干预"}]->(ev1066ctx);

MERGE (louis6)-[:PARTICIPATED_IN {role: "推动者"}]->(ev1108);

MERGE (louis7)-[:PARTICIPATED_IN {role: "当事人"}]->(ev1152);

MERGE (philip2)-[:PARTICIPATED_IN {role: "征服者"}]->(ev1204);
MERGE (philip2)-[:PARTICIPATED_IN {role: "胜利者"}]->(ev1214);

MERGE (louis9)-[:PARTICIPATED_IN {role: "亲自率军"}]->(ev1248);

MERGE (philip4)-[:PARTICIPATED_IN {role: "召集者"}]->(ev1302);
MERGE (philip4)-[:PARTICIPATED_IN {role: "主导取缔"}]->(ev1312);
MERGE (ev1302)-[:CONVENED]->(estates);

// --- Event sequencing ---
MERGE (ev987)-[:PRECEDES]->(ev1057);
MERGE (ev1057)-[:PRECEDES]->(ev1066ctx);
MERGE (ev1066ctx)-[:PRECEDES]->(ev1108);
MERGE (ev1108)-[:PRECEDES]->(ev1152);
MERGE (ev1152)-[:PRECEDES]->(ev1204);
MERGE (ev1204)-[:PRECEDES]->(ev1214);
MERGE (ev1214)-[:PRECEDES]->(ev1248);
MERGE (ev1248)-[:PRECEDES]->(ev1302);
MERGE (ev1302)-[:PRECEDES]->(ev1312);
// --- Upgrade: remove Valois succession Event → THRONE_CONTINUED_BY properties ---
MATCH (capet:Dynasty {name_en: "House of Capet"})
MATCH (valois:Dynasty {name_en: "House of Valois"})
MERGE (capet)-[tc:THRONE_CONTINUED_BY]->(valois)
SET tc.year = 1328,
    tc.name = "瓦卢瓦继位",
    tc.description = "查理四世无嗣，腓力六世（瓦卢瓦支系）加冕；卡佩直系终结、瓦卢瓦王朝开端，百年战争导火索之一"
WITH tc
OPTIONAL MATCH (ev:Event {name_en: "Valois succession to the French throne"})
DETACH DELETE ev;

// --- Upgrade: Philip VI → Valois dynasty (run if graph had philip6-[:BELONGED_TO]->capet) ---
MATCH (philip6:Person {name_en: "Philip VI of France"})
MATCH (capet:Dynasty {name_en: "House of Capet"})
MATCH (valois:Dynasty {name_en: "House of Valois"})
OPTIONAL MATCH (philip6)-[oldBelong:BELONGED_TO]->(capet)
DELETE oldBelong
MERGE (philip6)-[:BELONGED_TO]->(valois);

// --- Upgrade existing Person-only Capetian nodes (optional; skip on fresh import) ---
MATCH (m:Person)
WHERE m.name_en IN [
  "Hugh Capet", "Robert II of France", "Henry I of France", "Philip I of France",
  "Louis VI of France", "Louis VII of France", "Philip II of France", "Louis VIII of France",
  "Louis IX of France", "Philip III of France", "Philip IV of France", "Louis X of France",
  "Philip V of France", "Charles IV of France", "Philip VI of France"
]
  AND NOT m:Monarch
SET m:Monarch,
    m.death_year = coalesce(m.death_year, m.reign_end);

// --- Upgrade: merge title/role → identities; remove legacy fields ---
MATCH (p)
WHERE (p:Person OR p:Monarch)
  AND (p.role IS NOT NULL OR p.title IS NOT NULL)
WITH p, coalesce(p.identities, []) AS base,
  [x IN [p.title, p.role] WHERE x IS NOT NULL] AS legacy
WITH p, base + [x IN legacy WHERE NOT x IN base] AS merged
SET p.identities = merged
REMOVE p.role, p.title;

// --- Upgrade: dynasty HAS_FOUNDER (开创者); LIMIT 1 avoids duplicate Person match ---
MATCH (d:Dynasty {name_en: "House of Capet"})
MATCH (f:Person {name_en: "Hugh Capet"})
WITH d, f
ORDER BY size([(f)--() | 1]) DESC
LIMIT 1
MERGE (d)-[r:HAS_FOUNDER]->(f)
SET r.name = "开创者", r.year = 987, r.description = "987年加冕，开创卡佩王朝";

MATCH (d:Dynasty {name_en: "House of Valois"})
MATCH (f:Person {name_en: "Philip VI of France"})
WITH d, f
ORDER BY size([(f)--() | 1]) DESC
LIMIT 1
MERGE (d)-[r:HAS_FOUNDER]->(f)
SET r.name = "开创者", r.year = 1328, r.description = "1328年加冕，瓦卢瓦王朝首位法兰西国王";

// --- Link to Norman Conquest graph (run after add_norman_conquest; skip if nodes missing) ---
MATCH (william:Person {name_en: "William of Normandy"})
MATCH (france:Kingdom {name_en: "Kingdom of France"})
MATCH (philip1:Monarch {name_en: "Philip I of France"})
MATCH (conquest:Event {name_en: "Norman Conquest of England"})
MATCH (ev1066ctx:Event {name_en: "Capetian regency during Norman Conquest"})
MERGE (william)-[:VASSAL_OF {feudal_lord: "法兰西国王"}]->(france)
MERGE (william)-[:SWORE_FEALTY_TO]->(philip1)
MERGE (conquest)-[:CONCURRENT_IN_FRANCE]->(ev1066ctx);

// --- Constraint: one Person per name_en (run after duplicate merge if import failed) ---
CREATE CONSTRAINT person_name_en_unique IF NOT EXISTS
FOR (p:Person) REQUIRE p.name_en IS UNIQUE;
