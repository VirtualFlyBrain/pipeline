# pipeline
A repository for amalgamating pipeline issue tickets and general VFB pipeline doc

## VFB live server info:

### Neo4J databases:

VFBneoKB = KnowledgeBase of annotations kept by VFB.
VFBneoProd = Web facing Neo4J database

Endpoints: 

 Endpoint | DB | Neo4j version | Bolt | r/w status | Behind VPN | Status in pipeline (test/dev/staging/production) |
 --- | ----| --- | --- | --- | ----| ---- 
 kbw.virtualflybrain.org | VFBneoKB | Neo4j 3,n | y | r/w | Y | production |
kb.virtualflybrain.org   | VFBNeoKB | Neo4j 3.n | ? | read only | N | ? | 
pdb.virtualflybrain.org  | VFBNeoProd |  Neo4j 2.n | n | read only | N | production?|
...


## OWL servers:

### AberOWL: 
 Endpoint |  Status in pipeline (test/dev/staging/production) |
 --- | ----
http://owl.virtualflybrain.org/api/runQuery.groovy? | production

SOLR servers:

front end:

virtualflybrain.org - live VFB 1.5
sandboxN.vfb.ed.ac.uk  = ???
v2.virtualflybrain.org - live VFB 1.5

