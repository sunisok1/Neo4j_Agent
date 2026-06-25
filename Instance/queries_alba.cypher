// ============================================
// 查询 1：阿尔平王朝君主全表（按在位时间排序）
// ============================================
MATCH (p:Person)-[:BELONGED_TO]->(d:Dynasty {name: '阿尔平王朝'})
OPTIONAL MATCH (p)-[:SUCCEEDED_BY]->(next:Person)
RETURN 
  p.name AS 君主,
  p.name_en AS 英文名,
  p.reign_start AS 在位始,
  p.reign_end AS 在位终,
  p.epithet AS 绰号,
  p.description AS 简介,
  next.name AS 继任者
ORDER BY p.reign_start

// ============================================
// 查询 2：阿尔巴王国关键事件时间线
// ============================================
MATCH (e:Event)
WHERE e.name IN [
  '阿尔巴王国建立', '安德之战', '布鲁南伯尔之战', 
  '卡伦姆之战', '阿尔平王朝终结'
]
OPTIONAL MATCH (p:Person)-[:PARTICIPATED_IN]->(e)
WITH e, collect(p.name) AS 参与者
RETURN 
  e.year AS 年份,
  e.name AS 事件,
  e.name_en AS 英文名,
  e.description AS 描述,
  参与者
ORDER BY e.year

// ============================================
// 查询 3：阿尔平王朝父子关系图
// ============================================
MATCH (father:Person)-[:FATHER_OF]->(son:Person)
WHERE father.name IN [
  '肯尼思一世·麦克阿尔平', '康斯坦丁一世', '艾德', 
  '唐纳德二世', '马尔科姆一世', '英多尔夫', 
  '库尔伦', '杜布', '肯尼思二世'
]
RETURN 
  father.name AS 父,
  father.reign_start + '-' + father.reign_end AS 父在位,
  son.name AS 子,
  son.reign_start + '-' + son.reign_end AS 子在位
ORDER BY father.reign_start

// ============================================
// 查询 4：布鲁南伯尔之战——与现有英格兰数据的连接
// ============================================
MATCH (e:Event {name: '布鲁南伯尔之战'})
MATCH (p:Person)-[:PARTICIPATED_IN]->(e)
MATCH (p)-[:BELONGED_TO]->(d:Dynasty)
RETURN 
  e.year AS 年份,
  e.name AS 事件,
  e.description AS 描述,
  collect({
    name: p.name,
    name_en: p.name_en,
    dynasty: d.name,
    reign: p.reign_start + '-' + p.reign_end
  }) AS 参战君主

// ============================================
// 查询 5：阿尔平王朝 → 邓凯尔德过渡
// ============================================
MATCH (p:Person)-[:BELONGED_TO]->(d:Dynasty)
WHERE d.name IN ['阿尔平王朝', '邓凯尔德家族']
OPTIONAL MATCH (p)-[:SUCCEEDED_BY]->(next)
RETURN 
  d.name AS 王朝,
  p.reign_start AS 在位始,
  p.name AS 君主,
  next.name AS 继任者
ORDER BY p.reign_start

// ============================================
// 查询 6：综合概览（所有新节点）
// ============================================
MATCH (n)
WHERE n.name_en IN [
  'Kenneth I MacAlpin', 'Donald I', 'Constantine I', 'Áed', 'Giric',
  'Donald II', 'Constantine II', 'Malcolm I', 'Indulf', 'Dub',
  'Cuilén', 'Kenneth II', 'Constantine III', 'Kenneth III', 'Malcolm II', 'Duncan I',
  'House of Alpin', 'House of Dunkeld', 'Kingdom of Alba',
  'Foundation of the Kingdom of Alba', 'Battle of Inverdovat', 'Battle of Brunanburh',
  'Battle of Carham', 'End of the House of Alpin'
]
RETURN labels(n)[0] AS 类型, n.name AS 名称
ORDER BY 类型, n.name

// ============================================
// 查询 7：阿尔平王朝继承链（可视化关系）
// ============================================
MATCH path = (start:Person)-[:SUCCEEDED_BY*]->(end:Person)
WHERE start.name = '肯尼思一世·麦克阿尔平'
  AND end.name = '邓肯一世'
WITH path, nodes(path) AS monarchs
UNWIND monarchs AS m
RETURN m.name AS 君主, m.reign_start AS 在位始, m.reign_end AS 在位终
ORDER BY m.reign_start

// ============================================
// 查询 8：统计新插入的数据量
// ============================================
MATCH (n)
WHERE n.name_en IN [
  'Kenneth I MacAlpin', 'Donald I', 'Constantine I', 'Áed', 'Giric',
  'Donald II', 'Constantine II', 'Malcolm I', 'Indulf', 'Dub',
  'Cuilén', 'Kenneth II', 'Constantine III', 'Kenneth III', 'Malcolm II', 'Duncan I',
  'House of Alpin', 'House of Dunkeld', 'Kingdom of Alba',
  'Foundation of the Kingdom of Alba', 'Battle of Inverdovat', 'Battle of Brunanburh',
  'Battle of Carham', 'End of the House of Alpin'
]
WITH labels(n)[0] AS label, count(n) AS count
RETURN label AS 节点类型, count AS 数量
ORDER BY count DESC

// ============================================
// 查询 9：所有参与阿尔巴事件的君主
// ============================================
MATCH (p:Person)-[:PARTICIPATED_IN]->(e:Event)
WHERE e.name IN [
  '阿尔巴王国建立', '安德之战', '布鲁南伯尔之战', 
  '卡伦姆之战', '阿尔平王朝终结'
]
RETURN p.name AS 君主, collect(e.name) AS 参与事件
ORDER BY p.reign_start

// ============================================
// 查询 10：阿尔巴王国统治链（Ruled 关系）
// ============================================
MATCH (p:Person)-[:RULED]->(k:Kingdom {name_en: 'Kingdom of Alba'})
MATCH (p)-[:BELONGED_TO]->(d:Dynasty)
RETURN 
  p.name AS 君主,
  p.reign_start AS 在位始,
  p.reign_end AS 在位终,
  d.name AS 王朝
ORDER BY p.reign_start
