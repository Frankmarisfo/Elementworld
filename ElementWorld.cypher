//create categories
LOAD CSV WITH HEADERS FROM 'file:///ElementWorld.csv' AS list
WITH trim(list.Type) AS type, trim(list.Categories) AS categories,list.url AS url ,list.Title AS title WHERE type='Category'
CREATE (n:Category{title:trim(title),parents:categories,url:url}) RETURN *;

//create category relations
MATCH (n:Category) WHERE NOT n.parents='***' 
UNWIND [p IN split(n.parents, ",")|trim(p)] AS parent
MATCH (m:Category{title:parent})
CREATE (n)-[:subClassOf]->(m) RETURN *;

//create individuals and individual-category relations
LOAD CSV WITH HEADERS FROM 'file:///ElementWorld.csv' AS list
WITH trim(list.Type) AS type,list.url AS url, trim(list.Categories) AS categories, list.Title AS title WHERE type='Individual'
CALL apoc.create.node([c IN split(categories, ",")|trim(c)], {title:title, categories: categories,url:url}) YIELD node
WITH categories, node AS n UNWIND [c IN split(categories, ",")|trim(c)] AS category
MATCH (m:Category{title:category})
CREATE (n)-[:ObjectOneOf]->(m) RETURN *;