// Plantagenet dynasty (金雀花王朝): DynastyBranch -[:BELONGED_TO]-> Dynasty; Monarch -[:BELONGED_TO]-> DynastyBranch
// 四支系以 SUCCEEDED_BY 串联：安茹 -> 主系 -> 兰开斯特 -> 约克
// Idempotent: MERGE on name_en. Paste into Neo4j Browser (run all at once).

// --- Dynasty ---
MERGE (plant:Dynasty {name_en: "House of Plantagenet"})
  SET plant.name = "金雀花王朝",
      plant.start_year = 1154,
      plant.end_year = 1485,
      plant.description = "1154年亨利二世即位至1485年理查三世阵亡；统治英格兰约331年，含安茹、主系、兰开斯特、约克四支；玫瑰战争后由都铎取代";

// --- Four branches (DynastyBranch nodes) ---
MERGE (brAngevin:DynastyBranch {name_en: "Plantagenet Angevin branch"})
  SET brAngevin.name = "安茹支系",
      brAngevin.branch_id = "angevin",
      brAngevin.sequence = 1,
      brAngevin.start_year = 1154,
      brAngevin.end_year = 1216,
      brAngevin.period = "1154-1216",
      brAngevin.description = "常称安茹金雀花或安茹帝国；亨利二世起保有法国大量领地，1214-1216年失地后该支系名义终结";

MERGE (brMain:DynastyBranch {name_en: "Plantagenet Main line"})
  SET brMain.name = "金雀花主系",
      brMain.branch_id = "main",
      brMain.sequence = 2,
      brMain.start_year = 1216,
      brMain.end_year = 1399,
      brMain.period = "1216-1399",
      brMain.description = "失去安茹后以英格兰为核心；自亨利三世至理查二世共八位国王";

MERGE (brLancaster:DynastyBranch {name_en: "Plantagenet Lancaster branch"})
  SET brLancaster.name = "兰开斯特支系",
      brLancaster.branch_id = "lancaster",
      brLancaster.sequence = 3,
      brLancaster.start_year = 1399,
      brLancaster.end_year = 1471,
      brLancaster.period = "1399-1471",
      brLancaster.description = "爱德华三世之子冈特的约翰后裔；1399年亨利四世篡位起至亨利六世；玫瑰战争中与约克党争位";

MERGE (brYork:DynastyBranch {name_en: "Plantagenet York branch"})
  SET brYork.name = "约克支系",
      brYork.branch_id = "york",
      brYork.sequence = 4,
      brYork.start_year = 1461,
      brYork.end_year = 1485,
      brYork.period = "1461-1485",
      brYork.description = "爱德华三世之子兰利的爱德蒙后裔；1461年爱德华四世起至1485年理查三世；末代金雀花国王";

MERGE (england:Kingdom {name_en: "Kingdom of England"})
  SET england.name = "英格兰王国",
      england.capital = "伦敦（王室驻跸）",
      england.period_start = 927,
      england.description = "英格兰君主统治的核心王国；含威塞克斯、丹麦与金雀花时期；1154-1485年由金雀花及其兰开斯特、约克支系统治";

// --- Monarchs: Angevin branch ---
MERGE (henry2:Person:Monarch {name_en: "Henry II of England"})
  SET henry2.name = "亨利二世",
      henry2.identities = ["英格兰国王", "安茹伯爵", "诺曼底公爵", "阿基坦公爵"],
      henry2.dynasty_branch = "angevin",
      henry2.reign_start = 1154,
      henry2.reign_end = 1189,
      henry2.death_year = 1189,
      henry2.description = "玛蒂尔达之子；1154年即位，建立金雀花对英格兰的统治；安茹帝国版图从比利牛斯至苏格兰边境";

MERGE (richard1:Person:Monarch {name_en: "Richard I of England"})
  SET richard1.name = "理查一世（狮心王）",
      richard1.identities = ["英格兰国王"],
      richard1.epithet = "狮心王",
      richard1.dynasty_branch = "angevin",
      richard1.reign_start = 1189,
      richard1.reign_end = 1199,
      richard1.death_year = 1199,
      richard1.description = "第三次十字军领袖；长期不在英格兰，王权由摄政治理";

MERGE (john:Person:Monarch {name_en: "John, King of England"})
  SET john.name = "约翰王",
      john.identities = ["英格兰国王"],
      john.dynasty_branch = "angevin",
      john.reign_start = 1199,
      john.reign_end = 1216,
      john.death_year = 1216,
      john.description = "失诺曼底等地；1215年被迫签署《大宪章》；1216年内战期间去世";

// --- Monarchs: Main line ---
MERGE (henry3:Person:Monarch {name_en: "Henry III of England"})
  SET henry3.name = "亨利三世",
      henry3.identities = ["英格兰国王"],
      henry3.dynasty_branch = "main",
      henry3.reign_start = 1216,
      henry3.reign_end = 1272,
      henry3.death_year = 1272,
      henry3.description = "9岁即位；1258年《牛津条例》与贵族改革；1264-1265年西蒙·德·蒙福尔摄政";

MERGE (edward1:Person:Monarch {name_en: "Edward I of England"})
  SET edward1.name = "爱德华一世（长腿爱德华）",
      edward1.identities = ["英格兰国王"],
      edward1.epithet = "长腿爱德华",
      edward1.dynasty_branch = "main",
      edward1.reign_start = 1272,
      edward1.reign_end = 1307,
      edward1.death_year = 1307,
      edward1.description = "征服威尔士；对苏格兰用兵，获「苏格兰之锤」之称；1295年召集模范议会";

MERGE (edward2:Person:Monarch {name_en: "Edward II of England"})
  SET edward2.name = "爱德华二世",
      edward2.identities = ["英格兰国王"],
      edward2.dynasty_branch = "main",
      edward2.reign_start = 1307,
      edward2.reign_end = 1327,
      edward2.death_year = 1327,
      edward2.description = "1314年班诺克本战败；1327年被王后伊莎贝拉与莫蒂默废黜";

MERGE (edward3:Person:Monarch {name_en: "Edward III of England"})
  SET edward3.name = "爱德华三世",
      edward3.identities = ["英格兰国王"],
      edward3.dynasty_branch = "main",
      edward3.reign_start = 1327,
      edward3.reign_end = 1377,
      edward3.death_year = 1377,
      edward3.description = "1337年宣称法兰西王位，开启百年战争；黑死病时期；兰开斯特与约克两支系均出自其子";

MERGE (richard2:Person:Monarch {name_en: "Richard II of England"})
  SET richard2.name = "理查二世",
      richard2.identities = ["英格兰国王"],
      richard2.dynasty_branch = "main",
      richard2.reign_start = 1377,
      richard2.reign_end = 1399,
      richard2.death_year = 1400,
      richard2.description = "1381年农民起义；1399年被博林布鲁克的亨利废黜，主系终结";

// --- Monarchs: Lancaster cadet ---
MERGE (henry4:Person:Monarch {name_en: "Henry IV of England"})
  SET henry4.name = "亨利四世（博林布鲁克）",
      henry4.identities = ["英格兰国王", "兰开斯特支系开国君主"],
      henry4.epithet = "博林布鲁克",
      henry4.dynasty_branch = "lancaster",
      henry4.reign_start = 1399,
      henry4.reign_end = 1413,
      henry4.death_year = 1413,
      henry4.description = "冈特的约翰之子；1399年篡位，兰开斯特支系开端";

MERGE (henry5:Person:Monarch {name_en: "Henry V of England"})
  SET henry5.name = "亨利五世",
      henry5.identities = ["英格兰国王"],
      henry5.dynasty_branch = "lancaster",
      henry5.reign_start = 1413,
      henry5.reign_end = 1422,
      henry5.death_year = 1422,
      henry5.description = "1415年阿金库尔大胜；《特鲁瓦条约》承认其对法兰西王位继承权";

MERGE (henry6:Person:Monarch {name_en: "Henry VI of England"})
  SET henry6.name = "亨利六世",
      henry6.identities = ["英格兰国王"],
      henry6.dynasty_branch = "lancaster",
      henry6.reign_start = 1422,
      henry6.reign_end = 1471,
      henry6.reign_periods = "1422-1461;1470-1471",
      henry6.death_year = 1471,
      henry6.description = "幼主即位；1453年法国失地；玫瑰战争中两次在位，1471年伦敦塔遇害";

// --- Monarchs: York cadet ---
MERGE (edward4:Person:Monarch {name_en: "Edward IV of England"})
  SET edward4.name = "爱德华四世",
      edward4.identities = ["英格兰国王"],
      edward4.dynasty_branch = "york",
      edward4.reign_start = 1461,
      edward4.reign_end = 1483,
      edward4.reign_periods = "1461-1470;1471-1483",
      edward4.death_year = 1483,
      edward4.description = "约克党人；1461年即位，1470-1471年亨利六世短暂复位期间流亡，后复辟";

MERGE (edward5:Person:Monarch {name_en: "Edward V of England"})
  SET edward5.name = "爱德华五世",
      edward5.identities = ["英格兰国王"],
      edward5.dynasty_branch = "york",
      edward5.reign_start = 1483,
      edward5.reign_end = 1483,
      edward5.death_year = 1483,
      edward5.description = "1483年4月即位，6月被叔父理查三世取代；「伦敦塔王子」下落不明";

MERGE (richard3:Person:Monarch {name_en: "Richard III of England"})
  SET richard3.name = "理查三世",
      richard3.identities = ["英格兰国王"],
      richard3.dynasty_branch = "york",
      richard3.reign_start = 1483,
      richard3.reign_end = 1485,
      richard3.death_year = 1485,
      richard3.description = "金雀花末代国王；1485年博斯沃思原野阵亡，都铎的亨利七世继位";

// --- Key events ---
MERGE (ev1154:Event {name_en: "Accession of Henry II"})
  SET ev1154.name = "亨利二世即位",
      ev1154.year = 1154,
      ev1154.description = "金雀花王朝对英格兰统治的起点；结束安茹内战与斯蒂芬时期";

MERGE (ev1215:Event {name_en: "Magna Carta"})
  SET ev1215.name = "《大宪章》",
      ev1215.year = 1215,
      ev1215.description = "约翰王在兰尼米德被迫签署，限制王权、保障贵族权利";

MERGE (ev1265:Event {name_en: "Battle of Evesham"})
  SET ev1265.name = "埃夫舍姆之战",
      ev1265.year = 1265,
      ev1265.description = "爱德华王子击败并杀死西蒙·德·蒙福尔，亨利三世王权复振";

MERGE (ev1283:Event {name_en: "Conquest of Wales by Edward I"})
  SET ev1283.name = "爱德华一世征服威尔士",
      ev1283.year = 1283,
      ev1283.description = "卢埃林·阿普·格鲁菲思之死，威尔士并入英格兰王权";

MERGE (ev1337:Event {name_en: "Outbreak of the Hundred Years War"})
  SET ev1337.name = "百年战争爆发",
      ev1337.year = 1337,
      ev1337.description = "爱德华三世宣称法兰西王位，英法长期战争开始";

MERGE (ev1381:Event {name_en: "Peasants Revolt"})
  SET ev1381.name = "1381年农民起义",
      ev1381.year = 1381,
      ev1381.description = "瓦特·泰勒等领导的英格兰下层暴动，理查二世时期";

MERGE (ev1399:Event {name_en: "Deposition of Richard II"})
  SET ev1399.name = "理查二世被废黜",
      ev1399.year = 1399,
      ev1399.description = "亨利·博林布鲁克返英夺位，金雀花主系终结、兰开斯特支系掌权";

MERGE (ev1415:Event {name_en: "Battle of Agincourt"})
  SET ev1415.name = "阿金库尔战役",
      ev1415.year = 1415,
      ev1415.description = "亨利五世以少胜多击败法军，百年战争高潮";

MERGE (ev1455:Event {name_en: "Wars of the Roses begins"})
  SET ev1455.name = "玫瑰战争开端",
      ev1455.year = 1455,
      ev1455.description = "兰开斯特（红玫瑰）与约克（白玫瑰）两派武装争夺王位";

MERGE (ev1485:Event {name_en: "Battle of Bosworth Field"})
  SET ev1485.name = "博斯沃思原野战役",
      ev1485.year = 1485,
      ev1485.description = "理查三世阵亡，亨利·都铎即位；金雀花王朝终结";

MERGE (warsRoses:Concept {name_en: "Wars of the Roses"})
  SET warsRoses.name = "玫瑰战争",
      warsRoses.period = "1455-1487",
      warsRoses.description = "金雀花兰开斯特与约克两支系内战；1485年后由都铎巩固和平";

// --- Dynasty <-> branches <-> monarchs (MATCH by name_en) ---
MATCH (plant:Dynasty {name_en: "House of Plantagenet"})
MATCH (brAngevin:DynastyBranch {name_en: "Plantagenet Angevin branch"})
MATCH (brMain:DynastyBranch {name_en: "Plantagenet Main line"})
MATCH (brLancaster:DynastyBranch {name_en: "Plantagenet Lancaster branch"})
MATCH (brYork:DynastyBranch {name_en: "Plantagenet York branch"})
MATCH (england:Kingdom {name_en: "Kingdom of England"})
MERGE (brAngevin)-[:BELONGED_TO {sequence: 1}]->(plant)
MERGE (brMain)-[:BELONGED_TO {sequence: 2}]->(plant)
MERGE (brLancaster)-[:BELONGED_TO {sequence: 3}]->(plant)
MERGE (brYork)-[:BELONGED_TO {sequence: 4}]->(plant)
MERGE (plant)-[:RULED_OVER {period: "1154-1485"}]->(england)
MERGE (brAngevin)-[sb12:SUCCEEDED_BY]->(brMain)
  SET sb12.year = 1216,
      sb12.succession_type = "支系统替",
      sb12.description = "约翰王之后亨利三世即位，安茹支系终结、金雀花主系延续"
MERGE (brMain)-[sb23:SUCCEEDED_BY]->(brLancaster)
  SET sb23.year = 1399,
      sb23.succession_type = "旁支篡位",
      sb23.description = "理查二世被废，冈特的约翰一系（兰开斯特）取代主系"
MERGE (brLancaster)-[sb34:SUCCEEDED_BY]->(brYork)
  SET sb34.year = 1461,
      sb34.succession_type = "旁支夺位",
      sb34.description = "玫瑰战争中约克党爱德华四世取代兰开斯特的亨利六世"
MERGE (brAngevin)-[:RULED_OVER {period: "1154-1216"}]->(england)
MERGE (brMain)-[:RULED_OVER {period: "1216-1399"}]->(england)
MERGE (brLancaster)-[:RULED_OVER {period: "1399-1471"}]->(england)
MERGE (brYork)-[:RULED_OVER {period: "1461-1485"}]->(england);

MATCH (plant:Dynasty {name_en: "House of Plantagenet"})
MATCH (henry2:Monarch {name_en: "Henry II of England"})
MERGE (plant)-[plantFounder:HAS_FOUNDER]->(henry2)
  SET plantFounder.name = "开创者",
      plantFounder.year = 1154,
      plantFounder.description = "1154年即位，开创金雀花对英格兰的统治";

MATCH (br:DynastyBranch {name_en: "Plantagenet Angevin branch"}), (m:Monarch {name_en: "Henry II of England"})
MERGE (br)-[f:HAS_FOUNDER]->(m)
  SET f.year = 1154, f.description = "安茹支系首位英格兰国王";
MATCH (br:DynastyBranch {name_en: "Plantagenet Main line"}), (m:Monarch {name_en: "Henry III of England"})
MERGE (br)-[f:HAS_FOUNDER]->(m)
  SET f.year = 1216, f.description = "主系首位国王（前属安茹支系末代过渡）";
MATCH (br:DynastyBranch {name_en: "Plantagenet Lancaster branch"}), (m:Monarch {name_en: "Henry IV of England"})
MERGE (br)-[f:HAS_FOUNDER]->(m)
  SET f.year = 1399, f.description = "兰开斯特支系开国君主";
MATCH (br:DynastyBranch {name_en: "Plantagenet York branch"}), (m:Monarch {name_en: "Edward IV of England"})
MERGE (br)-[f:HAS_FOUNDER]->(m)
  SET f.year = 1461, f.description = "约克支系开国君主";

MATCH (br:DynastyBranch {branch_id: "angevin"})
UNWIND ["Henry II of England", "Richard I of England", "John, King of England"] AS monarch_en
MATCH (m:Monarch {name_en: monarch_en})
MERGE (m)-[:BELONGED_TO]->(br);
MATCH (br:DynastyBranch {branch_id: "main"})
UNWIND ["Henry III of England", "Edward I of England", "Edward II of England", "Edward III of England", "Richard II of England"] AS monarch_en
MATCH (m:Monarch {name_en: monarch_en})
MERGE (m)-[:BELONGED_TO]->(br);
MATCH (br:DynastyBranch {branch_id: "lancaster"})
UNWIND ["Henry IV of England", "Henry V of England", "Henry VI of England"] AS monarch_en
MATCH (m:Monarch {name_en: monarch_en})
MERGE (m)-[:BELONGED_TO]->(br);
MATCH (br:DynastyBranch {branch_id: "york"})
UNWIND ["Edward IV of England", "Edward V of England", "Richard III of England"] AS monarch_en
MATCH (m:Monarch {name_en: monarch_en})
MERGE (m)-[:BELONGED_TO]->(br);

MATCH (england:Kingdom {name_en: "Kingdom of England"})
UNWIND [
  {name_en: "Henry II of England", start_year: 1154, end_year: 1189, note: null},
  {name_en: "Richard I of England", start_year: 1189, end_year: 1199, note: null},
  {name_en: "John, King of England", start_year: 1199, end_year: 1216, note: null},
  {name_en: "Henry III of England", start_year: 1216, end_year: 1272, note: null},
  {name_en: "Edward I of England", start_year: 1272, end_year: 1307, note: null},
  {name_en: "Edward II of England", start_year: 1307, end_year: 1327, note: null},
  {name_en: "Edward III of England", start_year: 1327, end_year: 1377, note: null},
  {name_en: "Richard II of England", start_year: 1377, end_year: 1399, note: null},
  {name_en: "Henry IV of England", start_year: 1399, end_year: 1413, note: null},
  {name_en: "Henry V of England", start_year: 1413, end_year: 1422, note: null},
  {name_en: "Henry VI of England", start_year: 1422, end_year: 1471, note: "1461-1470、1471间歇被约克取代"},
  {name_en: "Edward IV of England", start_year: 1461, end_year: 1483, note: "1470-1471亨利六世复位期间流亡"},
  {name_en: "Edward V of England", start_year: 1483, end_year: 1483, note: null},
  {name_en: "Richard III of England", start_year: 1483, end_year: 1485, note: null}
] AS row
MATCH (m:Monarch {name_en: row.name_en})
MERGE (m)-[r:RULED {title: "英格兰国王", start_year: row.start_year, end_year: row.end_year}]->(england)
  SET r.note = row.note;

// --- Succession (father → son where applicable) ---
MATCH (a:Monarch {name_en: "Henry II of England"}), (b:Monarch {name_en: "Richard I of England"}) MERGE (a)-[:FATHER_OF]->(b);
MATCH (a:Monarch {name_en: "Henry II of England"}), (b:Monarch {name_en: "John, King of England"}) MERGE (a)-[:FATHER_OF]->(b);
MATCH (a:Monarch {name_en: "John, King of England"}), (b:Monarch {name_en: "Henry III of England"}) MERGE (a)-[:FATHER_OF]->(b);
MATCH (a:Monarch {name_en: "Henry III of England"}), (b:Monarch {name_en: "Edward I of England"}) MERGE (a)-[:FATHER_OF]->(b);
MATCH (a:Monarch {name_en: "Edward I of England"}), (b:Monarch {name_en: "Edward II of England"}) MERGE (a)-[:FATHER_OF]->(b);
MATCH (a:Monarch {name_en: "Edward II of England"}), (b:Monarch {name_en: "Edward III of England"}) MERGE (a)-[:FATHER_OF]->(b);
// 理查二世为黑太子之子、爱德华三世之孙（非父子，不设 FATHER_OF）
MATCH (a:Monarch {name_en: "Henry IV of England"}), (b:Monarch {name_en: "Henry V of England"}) MERGE (a)-[:FATHER_OF]->(b);
MATCH (a:Monarch {name_en: "Henry V of England"}), (b:Monarch {name_en: "Henry VI of England"}) MERGE (a)-[:FATHER_OF]->(b);
MATCH (a:Monarch {name_en: "Edward IV of England"}), (b:Monarch {name_en: "Edward V of England"}) MERGE (a)-[:FATHER_OF]->(b);
MATCH (a:Monarch {name_en: "Edward IV of England"}), (b:Monarch {name_en: "Richard III of England"}) MERGE (a)-[:FATHER_OF]->(b);

// 亨利二世→理查一世、理查一世→约翰、约翰→亨利三世：双头衔继承见 normandy_duchy_succession.cypher
MATCH (a:Monarch {name_en: "Henry III of England"}), (b:Monarch {name_en: "Edward I of England"})
MERGE (a)-[sb:SUCCEEDED_BY {inherited_title: "英格兰国王"}]->(b)
  SET sb.succession_type = "父子继承",
      sb.description = "亨利三世长子爱德华一世";
MATCH (a:Monarch {name_en: "Edward I of England"}), (b:Monarch {name_en: "Edward II of England"})
MERGE (a)-[sb:SUCCEEDED_BY {inherited_title: "英格兰国王"}]->(b)
  SET sb.succession_type = "父子继承",
      sb.description = "爱德华一世之子爱德华二世";
MATCH (a:Monarch {name_en: "Edward II of England"}), (b:Monarch {name_en: "Edward III of England"})
MERGE (a)-[sb:SUCCEEDED_BY {inherited_title: "英格兰国王"}]->(b)
  SET sb.succession_type = "父子继承",
      sb.description = "1327年爱德华二世被废，其子爱德华三世即位";
MATCH (a:Monarch {name_en: "Edward III of England"}), (b:Monarch {name_en: "Richard II of England"})
MERGE (a)-[sb:SUCCEEDED_BY {inherited_title: "英格兰国王"}]->(b)
  SET sb.succession_type = "父子继承",
      sb.description = "爱德华三世孙辈理查二世（黑太子爱德华之子）";
MATCH (a:Monarch {name_en: "Richard II of England"}), (b:Monarch {name_en: "Henry IV of England"})
MERGE (a)-[sb:SUCCEEDED_BY {inherited_title: "英格兰国王"}]->(b)
  SET sb.succession_type = "篡位/旁支",
      sb.year = 1399,
      sb.description = "理查二世被废，冈特的约翰之子亨利四世建立兰开斯特支系统治";
MATCH (a:Monarch {name_en: "Henry IV of England"}), (b:Monarch {name_en: "Henry V of England"})
MERGE (a)-[sb:SUCCEEDED_BY {inherited_title: "英格兰国王"}]->(b)
  SET sb.succession_type = "父子继承",
      sb.description = "亨利四世之子亨利五世";
MATCH (a:Monarch {name_en: "Henry V of England"}), (b:Monarch {name_en: "Henry VI of England"})
MERGE (a)-[sb:SUCCEEDED_BY {inherited_title: "英格兰国王"}]->(b)
  SET sb.succession_type = "父子继承",
      sb.description = "亨利五世之子亨利六世，幼主即位";
MATCH (a:Monarch {name_en: "Henry VI of England"}), (b:Monarch {name_en: "Edward IV of England"})
MERGE (a)-[sb:SUCCEEDED_BY {inherited_title: "英格兰国王"}]->(b)
  SET sb.succession_type = "约克党夺位",
      sb.year = 1461,
      sb.description = "玫瑰战争中约克党爱德华四世取代亨利六世（非父死子继）";
MATCH (a:Monarch {name_en: "Edward IV of England"}), (b:Monarch {name_en: "Edward V of England"})
MERGE (a)-[sb:SUCCEEDED_BY {inherited_title: "英格兰国王"}]->(b)
  SET sb.succession_type = "父子继承",
      sb.description = "爱德华四世之子爱德华五世，在位仅数月";
MATCH (a:Monarch {name_en: "Edward V of England"}), (b:Monarch {name_en: "Richard III of England"})
MERGE (a)-[sb:SUCCEEDED_BY {inherited_title: "英格兰国王"}]->(b)
  SET sb.succession_type = "叔侄/篡位",
      sb.description = "理查三世取代爱德华五世，伦敦塔王子事件";

MERGE (henry7:Person:Monarch {name_en: "Henry VII of England"})
  ON CREATE SET henry7.name = "亨利七世",
      henry7.identities = ["英格兰国王", "都铎王朝开国君主"],
      henry7.reign_start = 1485,
      henry7.reign_end = 1509,
      henry7.description = "博斯沃思后即位，终结金雀花世系对王位的占据";
MATCH (a:Monarch {name_en: "Richard III of England"}), (b:Monarch {name_en: "Henry VII of England"})
MERGE (a)-[sb:SUCCEEDED_BY {inherited_title: "英格兰国王"}]->(b)
  SET sb.succession_type = "战争夺位",
      sb.year = 1485,
      sb.description = "博斯沃思战败，都铎王朝开端";

// --- Milestone participation ---
MATCH (m:Monarch {name_en: "Henry II of England"}), (e:Event {name_en: "Accession of Henry II"}) MERGE (m)-[:PARTICIPATED_IN {role: "主角"}]->(e);
MATCH (e:Event {name_en: "Accession of Henry II"}), (d:Dynasty {name_en: "House of Plantagenet"}) MERGE (e)-[:ESTABLISHED]->(d);
MATCH (m:Monarch {name_en: "John, King of England"}), (e:Event {name_en: "Magna Carta"}) MERGE (m)-[:PARTICIPATED_IN {role: "被迫签署"}]->(e);
MATCH (m:Monarch {name_en: "Henry III of England"}), (e:Event {name_en: "Battle of Evesham"}) MERGE (m)-[:PARTICIPATED_IN {role: "一方君主"}]->(e);
MATCH (m:Monarch {name_en: "Edward I of England"}), (e:Event {name_en: "Battle of Evesham"}) MERGE (m)-[:PARTICIPATED_IN {role: "胜利王子"}]->(e);
MATCH (m:Monarch {name_en: "Edward I of England"}), (e:Event {name_en: "Conquest of Wales by Edward I"}) MERGE (m)-[:PARTICIPATED_IN {role: "征服者"}]->(e);
MATCH (m:Monarch {name_en: "Edward III of England"}), (e:Event {name_en: "Outbreak of the Hundred Years War"}) MERGE (m)-[:PARTICIPATED_IN {role: "宣战者"}]->(e);
MATCH (m:Monarch {name_en: "Richard II of England"}), (e:Event {name_en: "Peasants Revolt"}) MERGE (m)-[:PARTICIPATED_IN {role: "当事君主"}]->(e);
MATCH (m:Monarch {name_en: "Richard II of England"}), (e:Event {name_en: "Deposition of Richard II"}) MERGE (m)-[:PARTICIPATED_IN {role: "被废者"}]->(e);
MATCH (m:Monarch {name_en: "Henry IV of England"}), (e:Event {name_en: "Deposition of Richard II"}) MERGE (m)-[:PARTICIPATED_IN {role: "夺位者"}]->(e);
MATCH (m:Monarch {name_en: "Henry V of England"}), (e:Event {name_en: "Battle of Agincourt"}) MERGE (m)-[:PARTICIPATED_IN {role: "统帅"}]->(e);
MATCH (m:Monarch {name_en: "Henry VI of England"}), (e:Event {name_en: "Wars of the Roses begins"}) MERGE (m)-[:PARTICIPATED_IN {role: "兰开斯特一方"}]->(e);
MATCH (m:Monarch {name_en: "Edward IV of England"}), (e:Event {name_en: "Wars of the Roses begins"}) MERGE (m)-[:PARTICIPATED_IN {role: "约克一方"}]->(e);
MATCH (m:Monarch {name_en: "Richard III of England"}), (e:Event {name_en: "Battle of Bosworth Field"}) MERGE (m)-[:PARTICIPATED_IN {role: "战败者"}]->(e);
MATCH (e:Event {name_en: "Battle of Bosworth Field"}), (d:Dynasty {name_en: "House of Plantagenet"}) MERGE (e)-[:ENDED]->(d);
MATCH (e:Event {name_en: "Wars of the Roses begins"}), (c:Concept {name_en: "Wars of the Roses"}) MERGE (e)-[:INSTANCE_OF]->(c);

// --- Event sequencing ---
MATCH (a:Event {name_en: "Accession of Henry II"}), (b:Event {name_en: "Magna Carta"}) MERGE (a)-[:PRECEDES]->(b);
MATCH (a:Event {name_en: "Magna Carta"}), (b:Event {name_en: "Battle of Evesham"}) MERGE (a)-[:PRECEDES]->(b);
MATCH (a:Event {name_en: "Battle of Evesham"}), (b:Event {name_en: "Conquest of Wales by Edward I"}) MERGE (a)-[:PRECEDES]->(b);
MATCH (a:Event {name_en: "Conquest of Wales by Edward I"}), (b:Event {name_en: "Outbreak of the Hundred Years War"}) MERGE (a)-[:PRECEDES]->(b);
MATCH (a:Event {name_en: "Outbreak of the Hundred Years War"}), (b:Event {name_en: "Peasants Revolt"}) MERGE (a)-[:PRECEDES]->(b);
MATCH (a:Event {name_en: "Peasants Revolt"}), (b:Event {name_en: "Deposition of Richard II"}) MERGE (a)-[:PRECEDES]->(b);
MATCH (a:Event {name_en: "Deposition of Richard II"}), (b:Event {name_en: "Battle of Agincourt"}) MERGE (a)-[:PRECEDES]->(b);
MATCH (a:Event {name_en: "Battle of Agincourt"}), (b:Event {name_en: "Wars of the Roses begins"}) MERGE (a)-[:PRECEDES]->(b);
MATCH (a:Event {name_en: "Wars of the Roses begins"}), (b:Event {name_en: "Battle of Bosworth Field"}) MERGE (a)-[:PRECEDES]->(b);

// --- Link to Norman succession (optional; skip if nodes missing) ---
OPTIONAL MATCH (stephen:Person {name_en: "Stephen of England"})
OPTIONAL MATCH (henry2:Person {name_en: "Henry II of England"})
OPTIONAL MATCH (stephen)-[r:SUCCEEDED_BY]->(henry2)
FOREACH (_ IN CASE WHEN r IS NULL THEN [] ELSE [1] END |
  SET r.description = coalesce(r.description, "1154年亨利二世即位，诺曼王朝终结、金雀花王朝开端")
);

// --- Upgrade: Henry II Monarch label if pre-existed as Person only ---
MATCH (m:Person {name_en: "Henry II of England"})
WHERE NOT m:Monarch
SET m:Monarch,
    m.death_year = coalesce(m.death_year, m.reign_end);

// --- Upgrade: ensure RULED_OVER to England ---
MATCH (plant:Dynasty {name_en: "House of Plantagenet"})
MATCH (england:Kingdom {name_en: "Kingdom of England"})
MERGE (plant)-[:RULED_OVER {period: "1154-1485"}]->(england);

// --- Upgrade: remove legacy flat branch properties on Dynasty ---
MATCH (d:Dynasty {name_en: "House of Plantagenet"})
REMOVE d.branch_ids,
       d.branch_angevin_name, d.branch_angevin_name_en, d.branch_angevin_start_year,
       d.branch_angevin_end_year, d.branch_angevin_period, d.branch_angevin_description,
       d.branch_main_name, d.branch_main_name_en, d.branch_main_start_year,
       d.branch_main_end_year, d.branch_main_period, d.branch_main_description,
       d.branch_lancaster_name, d.branch_lancaster_name_en, d.branch_lancaster_start_year,
       d.branch_lancaster_end_year, d.branch_lancaster_period, d.branch_lancaster_description,
       d.branch_york_name, d.branch_york_name_en, d.branch_york_start_year,
       d.branch_york_end_year, d.branch_york_period, d.branch_york_description;

// --- Upgrade: monarchs linked directly to Dynasty -> re-link to DynastyBranch ---
MATCH (m:Monarch)-[old:BELONGED_TO]->(d:Dynasty {name_en: "House of Plantagenet"})
MATCH (br:DynastyBranch {branch_id: coalesce(old.branch, m.dynasty_branch)})
MERGE (m)-[:BELONGED_TO]->(br)
DELETE old;

// --- Upgrade: HAS_BRANCH -> branch BELONGED_TO dynasty ---
MATCH (d:Dynasty {name_en: "House of Plantagenet"})-[old:HAS_BRANCH]->(b:DynastyBranch)
MERGE (b)-[r:BELONGED_TO]->(d)
SET r.sequence = coalesce(r.sequence, old.sequence)
DELETE old;

// --- Upgrade: remove CADET_BRANCH_OF; restore branch SUCCEEDED_BY chain ---
MATCH ()-[c:CADET_BRANCH_OF]->()
DELETE c;
MATCH (brAngevin:DynastyBranch {branch_id: "angevin"})
MATCH (brMain:DynastyBranch {branch_id: "main"})
MATCH (brLancaster:DynastyBranch {branch_id: "lancaster"})
MATCH (brYork:DynastyBranch {branch_id: "york"})
MERGE (brAngevin)-[sb12:SUCCEEDED_BY]->(brMain)
SET sb12.year = 1216,
    sb12.succession_type = "支系统替",
    sb12.description = "约翰王之后亨利三世即位，安茹支系终结、金雀花主系延续"
MERGE (brMain)-[sb23:SUCCEEDED_BY]->(brLancaster)
SET sb23.year = 1399,
    sb23.succession_type = "旁支篡位",
    sb23.description = "理查二世被废，冈特的约翰一系（兰开斯特）取代主系"
MERGE (brLancaster)-[sb34:SUCCEEDED_BY]->(brYork)
SET sb34.year = 1461,
    sb34.succession_type = "旁支夺位",
    sb34.description = "玫瑰战争中约克党爱德华四世取代兰开斯特的亨利六世";
MATCH (brMain:DynastyBranch {branch_id: "main"})
REMOVE brMain.is_trunk;

// --- Example queries (Browser) ---
// MATCH (b:DynastyBranch)-[:BELONGED_TO]->(d:Dynasty {name_en: "House of Plantagenet"})
// RETURN d.name, b.name, b.sequence ORDER BY b.sequence;
//
// MATCH path=(b1:DynastyBranch {branch_id: "angevin"})-[:SUCCEEDED_BY*]->(b4:DynastyBranch {branch_id: "york"})
// RETURN path;
//
// MATCH (d:Dynasty {name_en: "House of Plantagenet"})<-[:BELONGED_TO]-(b:DynastyBranch)<-[:BELONGED_TO]-(m:Monarch)
// RETURN d.name, b.name, m.name, m.reign_start
// ORDER BY b.sequence, m.reign_start;
