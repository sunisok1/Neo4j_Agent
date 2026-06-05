// Wars of the Roses: key figures, battles, political events
// MERGE on name_en; links to existing Plantagenet monarchs & Concept. Idempotent.

// --- Key figures (non-monarch leaders & victims) ---
MERGE (yorkDuke:Person {name_en: "Richard, Duke of York"})
  SET yorkDuke.name = "理查，约克公爵",
      yorkDuke.identities = ["约克派领袖", "英格兰摄政"],
      yorkDuke.birth_year = 1411,
      yorkDuke.death_year = 1460,
      yorkDuke.description = "爱德华三世后裔；1455-1460年挑战亨利六世；1460年韦克菲尔德战死";

MERGE (margaret:Person {name_en: "Margaret of Anjou"})
  SET margaret.name = "安茹的玛格丽特",
      margaret.identities = ["英格兰王后", "兰开斯特派实际领袖"],
      margaret.birth_year = 1430,
      margaret.death_year = 1482,
      margaret.description = "亨利六世王后；1450年代起主导兰开斯特军事与政治";

MERGE (warwick:Person {name_en: "Richard Neville, Earl of Warwick"})
  SET warwick.name = "沃里克伯爵（造王者）",
      warwick.identities = ["约克派军事领袖", "造王者"],
      warwick.birth_year = 1428,
      warwick.death_year = 1471,
      warwick.description = "先扶爱德华四世，1470年倒向兰开斯特；1471年巴尼特战死";

MERGE (somerset:Person {name_en: "Edmund Beaufort, Duke of Somerset"})
  SET somerset.name = "埃德蒙·博福特（萨默塞特公爵）",
      somerset.identities = ["兰开斯特派军事领袖"],
      somerset.death_year = 1455,
      somerset.description = "1455年第一次圣奥尔本斯战死；兰开斯特对约克的主要对手之一";

MERGE (edmundRutland:Person {name_en: "Edmund, Earl of Rutland"})
  SET edmundRutland.name = "埃德蒙，拉特兰伯爵",
      edmundRutland.identities = ["约克公爵次子"],
      edmundRutland.death_year = 1460,
      edmundRutland.description = "1460年韦克菲尔德与父亲理查·约克一同被杀";

MERGE (princeWales:Person {name_en: "Edward of Westminster"})
  SET princeWales.name = "威尔士亲王爱德华",
      princeWales.identities = ["威尔士亲王", "兰开斯特继承人"],
      princeWales.birth_year = 1453,
      princeWales.death_year = 1471,
      princeWales.description = "亨利六世与玛格丽特之子；1471年特克斯伯里战败被杀";

MERGE (clarence:Person {name_en: "George Plantagenet, Duke of Clarence"})
  SET clarence.name = "乔治·金雀花（克拉伦斯公爵）",
      clarence.identities = ["约克派", "爱德华四世之弟"],
      clarence.birth_year = 1449,
      clarence.death_year = 1478,
      clarence.description = "1469年曾叛爱德华四世；1478年被处决";

MERGE (princeTower:Person {name_en: "Richard of Shrewsbury, Duke of York"})
  SET princeTower.name = "什鲁斯伯里公爵理查（约克王子）",
      princeTower.identities = ["约克派", "伦敦塔王子"],
      princeTower.birth_year = 1473,
      princeTower.death_year = 1483,
      princeTower.description = "爱德华四世幼子；1483年与兄爱德华五世一同被囚伦敦塔，下落不明";

MERGE (elizabethYork:Person {name_en: "Elizabeth of York"})
  SET elizabethYork.name = "约克的伊丽莎白",
      elizabethYork.identities = ["约克公主", "英格兰王后"],
      elizabethYork.birth_year = 1466,
      elizabethYork.death_year = 1503,
      elizabethYork.description = "爱德华四世长女；1486年与亨利七世联姻，红白玫瑰合一";

MERGE (stanley:Person {name_en: "Thomas Stanley, Earl of Derby"})
  SET stanley.name = "托马斯·斯坦利（德比伯爵）",
      stanley.identities = ["博斯沃思关键倒戈者"],
      stanley.description = "1485年博斯沃思临阵倒向亨利·都铎，决定战局";

// --- Battles ---
MERGE (ev1455StA:Event {name_en: "First Battle of St Albans"})
  SET ev1455StA.name = "第一次圣奥尔本斯战役",
      ev1455StA.year = 1455,
      ev1455StA.event_date = "1455-05-22",
      ev1455StA.event_type = "battle",
      ev1455StA.victor = "york",
      ev1455StA.description = "玫瑰战争首场大战；约克派胜，萨默塞特公爵被杀";

MERGE (ev1459Blore:Event {name_en: "Battle of Blore Heath"})
  SET ev1459Blore.name = "布洛尔希思战役",
      ev1459Blore.year = 1459,
      ev1459Blore.event_date = "1459-09-23",
      ev1459Blore.event_type = "battle",
      ev1459Blore.victor = "york",
      ev1459Blore.description = "1459年约克派小胜";

MERGE (ev1459Ludford:Event {name_en: "Battle of Ludford Bridge"})
  SET ev1459Ludford.name = "卢德福德桥对峙",
      ev1459Ludford.year = 1459,
      ev1459Ludford.event_date = "1459-10-12",
      ev1459Ludford.event_type = "battle",
      ev1459Ludford.victor = "lancaster",
      ev1459Ludford.description = "兰开斯特胜，约克公爵逃爱尔兰；考文垂「魔鬼议会」剥夺约克派";

MERGE (ev1460North:Event {name_en: "Battle of Northampton (1460)"})
  SET ev1460North.name = "北安普顿战役（1460）",
      ev1460North.year = 1460,
      ev1460North.event_date = "1460-07-10",
      ev1460North.event_type = "battle",
      ev1460North.victor = "york",
      ev1460North.description = "约克派俘亨利六世";

MERGE (ev1460Accord:Event {name_en: "Act of Accord"})
  SET ev1460Accord.name = "协调法案",
      ev1460Accord.year = 1460,
      ev1460Accord.event_date = "1460-10",
      ev1460Accord.event_type = "political",
      ev1460Accord.description = "亨利六世保留王位，但理查·约克及其子嗣为法定继承人";

MERGE (ev1460Wake:Event {name_en: "Battle of Wakefield"})
  SET ev1460Wake.name = "韦克菲尔德战役",
      ev1460Wake.year = 1460,
      ev1460Wake.event_date = "1460-12-30",
      ev1460Wake.event_type = "battle",
      ev1460Wake.victor = "lancaster",
      ev1460Wake.description = "兰开斯特大胜；约克公爵与次子埃德蒙·拉特兰战死";

MERGE (ev1461Mortimer:Event {name_en: "Battle of Mortimer's Cross"})
  SET ev1461Mortimer.name = "莫蒂默十字战役",
      ev1461Mortimer.year = 1461,
      ev1461Mortimer.event_date = "1461-02-02",
      ev1461Mortimer.event_type = "battle",
      ev1461Mortimer.victor = "york",
      ev1461Mortimer.description = "爱德华（约克）击败兰开斯特军队";

MERGE (ev1461StA2:Event {name_en: "Second Battle of St Albans"})
  SET ev1461StA2.name = "第二次圣奥尔本斯战役",
      ev1461StA2.year = 1461,
      ev1461StA2.event_date = "1461-02-17",
      ev1461StA2.event_type = "battle",
      ev1461StA2.victor = "lancaster",
      ev1461StA2.description = "兰开斯特胜，夺回亨利六世";

MERGE (ev1461Towton:Event {name_en: "Battle of Towton"})
  SET ev1461Towton.name = "陶顿战役",
      ev1461Towton.year = 1461,
      ev1461Towton.event_date = "1461-03-29",
      ev1461Towton.event_type = "battle",
      ev1461Towton.victor = "york",
      ev1461Towton.description = "玫瑰战争最惨烈一战；约克决定性大胜，爱德华四世走向加冕";

MERGE (ev1464Hedgeley:Event {name_en: "Battle of Hedgeley Moor"})
  SET ev1464Hedgeley.name = "赫奇利穆尔战役",
      ev1464Hedgeley.year = 1464,
      ev1464Hedgeley.event_date = "1464-04-25",
      ev1464Hedgeley.event_type = "battle",
      ev1464Hedgeley.victor = "york",
      ev1464Hedgeley.description = "约克派扫荡北部兰开斯特残部";

MERGE (ev1464Hexham:Event {name_en: "Battle of Hexham"})
  SET ev1464Hexham.name = "赫克瑟姆战役",
      ev1464Hexham.year = 1464,
      ev1464Hexham.event_date = "1464-05-15",
      ev1464Hexham.event_type = "battle",
      ev1464Hexham.victor = "york",
      ev1464Hexham.description = "兰开斯特北方势力遭重创";

MERGE (ev1469Edgecote:Event {name_en: "Battle of Edgecote Moor"})
  SET ev1469Edgecote.name = "埃奇科特穆尔战役",
      ev1469Edgecote.year = 1469,
      ev1469Edgecote.event_date = "1469-07-26",
      ev1469Edgecote.event_type = "battle",
      ev1469Edgecote.victor = "lancaster",
      ev1469Edgecote.description = "沃里克倒戈，爱德华四世一度被囚";

MERGE (ev1470Losecote:Event {name_en: "Battle of Losecote Field"})
  SET ev1470Losecote.name = "丢盔原野战役",
      ev1470Losecote.year = 1470,
      ev1470Losecote.event_date = "1470-03-12",
      ev1470Losecote.event_type = "battle",
      ev1470Losecote.victor = "york",
      ev1470Losecote.description = "爱德华四世重掌局势，沃里克与克拉伦斯逃法";

MERGE (ev1470Readeption:Event {name_en: "Readeption of Henry VI"})
  SET ev1470Readeption.name = "亨利六世复位",
      ev1470Readeption.year = 1470,
      ev1470Readeption.event_date = "1470-10",
      ev1470Readeption.event_type = "political",
      ev1470Readeption.description = "沃里克与玛格丽特结盟，亨利六世短暂第二次在位";

MERGE (ev1471Barnet:Event {name_en: "Battle of Barnet"})
  SET ev1471Barnet.name = "巴尼特战役",
      ev1471Barnet.year = 1471,
      ev1471Barnet.event_date = "1471-04-14",
      ev1471Barnet.event_type = "battle",
      ev1471Barnet.victor = "york",
      ev1471Barnet.description = "爱德华四世胜，沃里克伯爵战死";

MERGE (ev1471Tewkes:Event {name_en: "Battle of Tewkesbury"})
  SET ev1471Tewkes.name = "特克斯伯里战役",
      ev1471Tewkes.year = 1471,
      ev1471Tewkes.event_date = "1471-05-04",
      ev1471Tewkes.event_type = "battle",
      ev1471Tewkes.victor = "york",
      ev1471Tewkes.description = "威尔士亲王爱德华被杀，玛格丽特被俘；兰开斯特男性继承线断绝";

MERGE (ev1471HenryDeath:Event {name_en: "Death of Henry VI in the Tower"})
  SET ev1471HenryDeath.name = "亨利六世之死",
      ev1471HenryDeath.year = 1471,
      ev1471HenryDeath.event_date = "1471-05-21",
      ev1471HenryDeath.event_type = "political",
      ev1471HenryDeath.description = "亨利六世死于伦敦塔；兰开斯特名义王位终结";

MERGE (ev1483EdwardDeath:Event {name_en: "Death of Edward IV"})
  SET ev1483EdwardDeath.name = "爱德华四世驾崩",
      ev1483EdwardDeath.year = 1483,
      ev1483EdwardDeath.event_date = "1483-04-09",
      ev1483EdwardDeath.event_type = "political",
      ev1483EdwardDeath.description = "1483年4月爱德华四世去世，王位继承之争白热化";

MERGE (ev1483Tower:Event {name_en: "Princes in the Tower"})
  SET ev1483Tower.name = "伦敦塔王子",
      ev1483Tower.year = 1483,
      ev1483Tower.event_date = "1483-06",
      ev1483Tower.event_type = "political",
      ev1483Tower.description = "爱德华五世与约克公爵理查被囚伦敦塔；理查三世即位后两人下落不明";

MERGE (ev1483Buckingham:Event {name_en: "Buckingham's Rebellion"})
  SET ev1483Buckingham.name = "白金汉叛乱",
      ev1483Buckingham.year = 1483,
      ev1483Buckingham.event_date = "1483-10",
      ev1483Buckingham.event_type = "rebellion",
      ev1483Buckingham.description = "反理查三世；失败，白金汉公爵被处决";

MERGE (ev1487Stoke:Event {name_en: "Battle of Stoke Field"})
  SET ev1487Stoke.name = "斯托克菲尔德战役",
      ev1487Stoke.year = 1487,
      ev1487Stoke.event_date = "1487-06-16",
      ev1487Stoke.event_type = "battle",
      ev1487Stoke.victor = "tudor",
      ev1487Stoke.description = "亨利七世镇压兰伯特·西姆内尔叛乱；通常视为玫瑰战争最后一战";

// --- Faction badges (Concept) ---
MERGE (redRose:Concept {name_en: "Red Rose of Lancaster"})
  SET redRose.name = "兰开斯特红玫瑰",
      redRose.description = "兰开斯特派徽章；后由都铎玫瑰与约克白玫瑰合并";

MERGE (whiteRose:Concept {name_en: "White Rose of York"})
  SET whiteRose.name = "约克白玫瑰",
      whiteRose.description = "约克派徽章";

// --- Genealogy (key) ---
MATCH (yorkDuke:Person {name_en: "Richard, Duke of York"}), (edward4:Monarch {name_en: "Edward IV of England"})
MERGE (yorkDuke)-[:FATHER_OF]->(edward4);
MATCH (yorkDuke:Person {name_en: "Richard, Duke of York"}), (clarence:Person {name_en: "George Plantagenet, Duke of Clarence"})
MERGE (yorkDuke)-[:FATHER_OF]->(clarence);
MATCH (yorkDuke:Person {name_en: "Richard, Duke of York"}), (richard3:Monarch {name_en: "Richard III of England"})
MERGE (yorkDuke)-[:FATHER_OF]->(richard3);
MATCH (yorkDuke:Person {name_en: "Richard, Duke of York"}), (edmund:Person {name_en: "Edmund, Earl of Rutland"})
MERGE (yorkDuke)-[:FATHER_OF]->(edmund);
MATCH (edward4:Monarch {name_en: "Edward IV of England"}), (edward5:Monarch {name_en: "Edward V of England"})
MERGE (edward4)-[:FATHER_OF]->(edward5);
MATCH (edward4:Monarch {name_en: "Edward IV of England"}), (princeTower:Person {name_en: "Richard of Shrewsbury, Duke of York"})
MERGE (edward4)-[:FATHER_OF]->(princeTower);
MATCH (edward4:Monarch {name_en: "Edward IV of England"}), (elizabeth:Person {name_en: "Elizabeth of York"})
MERGE (edward4)-[:FATHER_OF]->(elizabeth);
MATCH (henry6:Monarch {name_en: "Henry VI of England"}), (princeWales:Person {name_en: "Edward of Westminster"})
MERGE (henry6)-[:FATHER_OF]->(princeWales);
MATCH (henry6:Monarch {name_en: "Henry VI of England"}), (margaret:Person {name_en: "Margaret of Anjou"})
MERGE (henry6)-[:SPOUSE_OF]->(margaret);

// --- Branch / faction links ---
MATCH (brYork:DynastyBranch {name_en: "Plantagenet York branch"})
MATCH (p:Person)
WHERE p.name_en IN [
  "Richard, Duke of York", "Richard Neville, Earl of Warwick",
  "George Plantagenet, Duke of Clarence", "Edmund, Earl of Rutland",
  "Richard of Shrewsbury, Duke of York", "Elizabeth of York"
]
MERGE (p)-[:BELONGED_TO {faction: "york"}]->(brYork);

MATCH (brLanc:DynastyBranch {name_en: "Plantagenet Lancaster branch"})
MATCH (p:Person)
WHERE p.name_en IN [
  "Margaret of Anjou", "Edmund Beaufort, Duke of Somerset", "Edward of Westminster"
]
MERGE (p)-[:BELONGED_TO {faction: "lancaster"}]->(brLanc);

// --- Participation: battles ---
MATCH (e:Event {name_en: "First Battle of St Albans"})
MATCH (y:Person {name_en: "Richard, Duke of York"}) MERGE (y)-[:PARTICIPATED_IN {role: "约克派统帅", faction: "york"}]->(e);
MATCH (e:Event {name_en: "First Battle of St Albans"})
MATCH (s:Person {name_en: "Edmund Beaufort, Duke of Somerset"}) MERGE (s)-[:PARTICIPATED_IN {role: "阵亡", faction: "lancaster"}]->(e);
MATCH (e:Event {name_en: "First Battle of St Albans"})
MATCH (h:Monarch {name_en: "Henry VI of England"}) MERGE (h)-[:PARTICIPATED_IN {role: "被俘一方君主", faction: "lancaster"}]->(e);

MATCH (e:Event {name_en: "Battle of Northampton (1460)"})
MATCH (y:Person {name_en: "Richard, Duke of York"}) MERGE (y)-[:PARTICIPATED_IN {role: "约克派统帅", faction: "york"}]->(e);
MATCH (e:Event {name_en: "Battle of Northampton (1460)"})
MATCH (w:Person {name_en: "Richard Neville, Earl of Warwick"}) MERGE (w)-[:PARTICIPATED_IN {role: "约克派将领", faction: "york"}]->(e);
MATCH (e:Event {name_en: "Battle of Northampton (1460)"})
MATCH (h:Monarch {name_en: "Henry VI of England"}) MERGE (h)-[:PARTICIPATED_IN {role: "被俘", faction: "lancaster"}]->(e);

MATCH (e:Event {name_en: "Act of Accord"})
MATCH (y:Person {name_en: "Richard, Duke of York"}) MERGE (y)-[:PARTICIPATED_IN {role: "继承人", faction: "york"}]->(e);
MATCH (e:Event {name_en: "Act of Accord"})
MATCH (h:Monarch {name_en: "Henry VI of England"}) MERGE (h)-[:PARTICIPATED_IN {role: "在位君主", faction: "lancaster"}]->(e);

MATCH (e:Event {name_en: "Battle of Wakefield"})
MATCH (y:Person {name_en: "Richard, Duke of York"}) MERGE (y)-[:PARTICIPATED_IN {role: "阵亡", faction: "york"}]->(e);
MATCH (e:Event {name_en: "Battle of Wakefield"})
MATCH (r:Person {name_en: "Edmund, Earl of Rutland"}) MERGE (r)-[:PARTICIPATED_IN {role: "阵亡", faction: "york"}]->(e);
MATCH (e:Event {name_en: "Battle of Wakefield"})
MATCH (m:Person {name_en: "Margaret of Anjou"}) MERGE (m)-[:PARTICIPATED_IN {role: "兰开斯特一方", faction: "lancaster"}]->(e);

MATCH (e:Event {name_en: "Battle of Mortimer's Cross"})
MATCH (ed:Monarch {name_en: "Edward IV of England"}) MERGE (ed)-[:PARTICIPATED_IN {role: "约克派统帅", faction: "york"}]->(e);

MATCH (e:Event {name_en: "Second Battle of St Albans"})
MATCH (m:Person {name_en: "Margaret of Anjou"}) MERGE (m)-[:PARTICIPATED_IN {role: "兰开斯特一方", faction: "lancaster"}]->(e);
MATCH (e:Event {name_en: "Second Battle of St Albans"})
MATCH (h:Monarch {name_en: "Henry VI of England"}) MERGE (h)-[:PARTICIPATED_IN {role: "被夺回", faction: "lancaster"}]->(e);

MATCH (e:Event {name_en: "Battle of Towton"})
MATCH (ed:Monarch {name_en: "Edward IV of England"}) MERGE (ed)-[:PARTICIPATED_IN {role: "约克派统帅", faction: "york"}]->(e);
MATCH (e:Event {name_en: "Battle of Towton"})
MATCH (w:Person {name_en: "Richard Neville, Earl of Warwick"}) MERGE (w)-[:PARTICIPATED_IN {role: "约克派将领", faction: "york"}]->(e);
MATCH (e:Event {name_en: "Battle of Towton"})
MATCH (m:Person {name_en: "Margaret of Anjou"}) MERGE (m)-[:PARTICIPATED_IN {role: "败退", faction: "lancaster"}]->(e);

MATCH (e:Event {name_en: "Battle of Edgecote Moor"})
MATCH (w:Person {name_en: "Richard Neville, Earl of Warwick"}) MERGE (w)-[:PARTICIPATED_IN {role: "倒戈统帅", faction: "lancaster"}]->(e);
MATCH (e:Event {name_en: "Battle of Edgecote Moor"})
MATCH (ed:Monarch {name_en: "Edward IV of England"}) MERGE (ed)-[:PARTICIPATED_IN {role: "被囚", faction: "york"}]->(e);

MATCH (e:Event {name_en: "Readeption of Henry VI"})
MATCH (w:Person {name_en: "Richard Neville, Earl of Warwick"}) MERGE (w)-[:PARTICIPATED_IN {role: "策划者", faction: "lancaster"}]->(e);
MATCH (e:Event {name_en: "Readeption of Henry VI"})
MATCH (h:Monarch {name_en: "Henry VI of England"}) MERGE (h)-[:PARTICIPATED_IN {role: "复位君主", faction: "lancaster"}]->(e);

MATCH (e:Event {name_en: "Battle of Barnet"})
MATCH (ed:Monarch {name_en: "Edward IV of England"}) MERGE (ed)-[:PARTICIPATED_IN {role: "约克派统帅", faction: "york"}]->(e);
MATCH (e:Event {name_en: "Battle of Barnet"})
MATCH (w:Person {name_en: "Richard Neville, Earl of Warwick"}) MERGE (w)-[:PARTICIPATED_IN {role: "阵亡", faction: "lancaster"}]->(e);

MATCH (e:Event {name_en: "Battle of Tewkesbury"})
MATCH (ed:Monarch {name_en: "Edward IV of England"}) MERGE (ed)-[:PARTICIPATED_IN {role: "约克派统帅", faction: "york"}]->(e);
MATCH (e:Event {name_en: "Battle of Tewkesbury"})
MATCH (p:Person {name_en: "Edward of Westminster"}) MERGE (p)-[:PARTICIPATED_IN {role: "阵亡", faction: "lancaster"}]->(e);
MATCH (e:Event {name_en: "Battle of Tewkesbury"})
MATCH (m:Person {name_en: "Margaret of Anjou"}) MERGE (m)-[:PARTICIPATED_IN {role: "被俘", faction: "lancaster"}]->(e);

MATCH (e:Event {name_en: "Death of Henry VI in the Tower"})
MATCH (h:Monarch {name_en: "Henry VI of England"}) MERGE (h)-[:PARTICIPATED_IN {role: "死者", faction: "lancaster"}]->(e);

MATCH (e:Event {name_en: "Death of Edward IV"})
MATCH (ed:Monarch {name_en: "Edward IV of England"}) MERGE (ed)-[:PARTICIPATED_IN {role: "驾崩君主", faction: "york"}]->(e);

MATCH (e:Event {name_en: "Princes in the Tower"})
MATCH (ev:Monarch {name_en: "Edward V of England"}) MERGE (ev)-[:PARTICIPATED_IN {role: "失踪王子", faction: "york"}]->(e);
MATCH (e:Event {name_en: "Princes in the Tower"})
MATCH (rt:Person {name_en: "Richard of Shrewsbury, Duke of York"}) MERGE (rt)-[:PARTICIPATED_IN {role: "失踪王子", faction: "york"}]->(e);
MATCH (e:Event {name_en: "Princes in the Tower"})
MATCH (r3:Monarch {name_en: "Richard III of England"}) MERGE (r3)-[:PARTICIPATED_IN {role: "取代者", faction: "york"}]->(e);

MATCH (e:Event {name_en: "Battle of Bosworth Field"})
MATCH (r3:Monarch {name_en: "Richard III of England"}) MERGE (r3)-[:PARTICIPATED_IN {role: "阵亡", faction: "york"}]->(e);
MATCH (e:Event {name_en: "Battle of Bosworth Field"})
MATCH (h7:Monarch {name_en: "Henry VII of England"}) MERGE (h7)-[:PARTICIPATED_IN {role: "胜利者", faction: "lancaster/tudor"}]->(e);
MATCH (e:Event {name_en: "Battle of Bosworth Field"})
MATCH (st:Person {name_en: "Thomas Stanley, Earl of Derby"}) MERGE (st)-[:PARTICIPATED_IN {role: "决定性倒戈", faction: "neutral"}]->(e);

MATCH (e:Event {name_en: "Battle of Stoke Field"})
MATCH (h7:Monarch {name_en: "Henry VII of England"}) MERGE (h7)-[:PARTICIPATED_IN {role: "胜利者", faction: "tudor"}]->(e);

// --- Link events to Wars of the Roses concept ---
MATCH (c:Concept {name_en: "Wars of the Roses"})
MATCH (e:Event)
WHERE e.name_en IN [
  "First Battle of St Albans", "Battle of Blore Heath", "Battle of Ludford Bridge",
  "Battle of Northampton (1460)", "Act of Accord", "Battle of Wakefield",
  "Battle of Mortimer's Cross", "Second Battle of St Albans", "Battle of Towton",
  "Battle of Hedgeley Moor", "Battle of Hexham", "Battle of Edgecote Moor",
  "Battle of Losecote Field", "Readeption of Henry VI", "Battle of Barnet",
  "Battle of Tewkesbury", "Death of Henry VI in the Tower", "Death of Edward IV",
  "Princes in the Tower", "Buckingham's Rebellion", "Battle of Bosworth Field",
  "Battle of Stoke Field"
]
MERGE (e)-[:INSTANCE_OF]->(c);

MATCH (e:Event {name_en: "First Battle of St Albans"}), (c:Concept {name_en: "Red Rose of Lancaster"}) MERGE (e)-[:SYMBOLIZED_BY]->(c);
MATCH (e:Event {name_en: "First Battle of St Albans"}), (c:Concept {name_en: "White Rose of York"}) MERGE (e)-[:SYMBOLIZED_BY]->(c);

// --- Refine generic "Wars of the Roses begins" -> first battle ---
MATCH (begins:Event {name_en: "Wars of the Roses begins"})
SET begins.name = "玫瑰战争开端（第一次圣奥尔本斯）",
    begins.description = "1455年5月22日第一次圣奥尔本斯；兰开斯特与约克武装冲突正式爆发",
    begins.event_date = "1455-05-22";
MATCH (begins:Event {name_en: "Wars of the Roses begins"}), (first:Event {name_en: "First Battle of St Albans"})
MERGE (begins)-[:SAME_AS]->(first);

// --- Event timeline (replace coarse begins->bosworth skip) ---
MATCH (a:Event {name_en: "Wars of the Roses begins"}), (b:Event {name_en: "Battle of Bosworth Field"})
OPTIONAL MATCH (a)-[old:PRECEDES]->(b)
DELETE old;

MATCH (a:Event {name_en: "Wars of the Roses begins"}), (b:Event {name_en: "First Battle of St Albans"}) MERGE (a)-[:PRECEDES]->(b);
MATCH (a:Event {name_en: "First Battle of St Albans"}), (b:Event {name_en: "Battle of Blore Heath"}) MERGE (a)-[:PRECEDES]->(b);
MATCH (a:Event {name_en: "Battle of Blore Heath"}), (b:Event {name_en: "Battle of Ludford Bridge"}) MERGE (a)-[:PRECEDES]->(b);
MATCH (a:Event {name_en: "Battle of Ludford Bridge"}), (b:Event {name_en: "Battle of Northampton (1460)"}) MERGE (a)-[:PRECEDES]->(b);
MATCH (a:Event {name_en: "Battle of Northampton (1460)"}), (b:Event {name_en: "Act of Accord"}) MERGE (a)-[:PRECEDES]->(b);
MATCH (a:Event {name_en: "Act of Accord"}), (b:Event {name_en: "Battle of Wakefield"}) MERGE (a)-[:PRECEDES]->(b);
MATCH (a:Event {name_en: "Battle of Wakefield"}), (b:Event {name_en: "Battle of Mortimer's Cross"}) MERGE (a)-[:PRECEDES]->(b);
MATCH (a:Event {name_en: "Battle of Mortimer's Cross"}), (b:Event {name_en: "Second Battle of St Albans"}) MERGE (a)-[:PRECEDES]->(b);
MATCH (a:Event {name_en: "Second Battle of St Albans"}), (b:Event {name_en: "Battle of Towton"}) MERGE (a)-[:PRECEDES]->(b);
MATCH (a:Event {name_en: "Battle of Towton"}), (b:Event {name_en: "Battle of Hedgeley Moor"}) MERGE (a)-[:PRECEDES]->(b);
MATCH (a:Event {name_en: "Battle of Hedgeley Moor"}), (b:Event {name_en: "Battle of Hexham"}) MERGE (a)-[:PRECEDES]->(b);
MATCH (a:Event {name_en: "Battle of Hexham"}), (b:Event {name_en: "Battle of Edgecote Moor"}) MERGE (a)-[:PRECEDES]->(b);
MATCH (a:Event {name_en: "Battle of Edgecote Moor"}), (b:Event {name_en: "Battle of Losecote Field"}) MERGE (a)-[:PRECEDES]->(b);
MATCH (a:Event {name_en: "Battle of Losecote Field"}), (b:Event {name_en: "Readeption of Henry VI"}) MERGE (a)-[:PRECEDES]->(b);
MATCH (a:Event {name_en: "Readeption of Henry VI"}), (b:Event {name_en: "Battle of Barnet"}) MERGE (a)-[:PRECEDES]->(b);
MATCH (a:Event {name_en: "Battle of Barnet"}), (b:Event {name_en: "Battle of Tewkesbury"}) MERGE (a)-[:PRECEDES]->(b);
MATCH (a:Event {name_en: "Battle of Tewkesbury"}), (b:Event {name_en: "Death of Henry VI in the Tower"}) MERGE (a)-[:PRECEDES]->(b);
MATCH (a:Event {name_en: "Death of Henry VI in the Tower"}), (b:Event {name_en: "Death of Edward IV"}) MERGE (a)-[:PRECEDES]->(b);
MATCH (a:Event {name_en: "Death of Edward IV"}), (b:Event {name_en: "Princes in the Tower"}) MERGE (a)-[:PRECEDES]->(b);
MATCH (a:Event {name_en: "Princes in the Tower"}), (b:Event {name_en: "Buckingham's Rebellion"}) MERGE (a)-[:PRECEDES]->(b);
MATCH (a:Event {name_en: "Buckingham's Rebellion"}), (b:Event {name_en: "Battle of Bosworth Field"}) MERGE (a)-[:PRECEDES]->(b);
MATCH (a:Event {name_en: "Battle of Bosworth Field"}), (b:Event {name_en: "Battle of Stoke Field"}) MERGE (a)-[:PRECEDES]->(b);

// --- Example queries ---
// MATCH (c:Concept {name_en: "Wars of the Roses"})<-[:INSTANCE_OF]-(e:Event)
// RETURN e.name, e.year, e.victor ORDER BY e.year;
//
// MATCH (p:Person)-[r:PARTICIPATED_IN]->(e:Event {name_en: "Battle of Towton"})
// RETURN p.name, r.role, r.faction;
//
// MATCH path=(a:Event {name_en: "Wars of the Roses begins"})-[:PRECEDES*]->(b:Event {name_en: "Battle of Stoke Field"})
// RETURN [n IN nodes(path) | n.name] AS timeline;
