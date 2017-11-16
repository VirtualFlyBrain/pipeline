# pipeline
A repository for amalgamating pipeline issue tickets and general VFB pipeline doc

## VFB live server info:

Neo4J databases:

VFBneoKB = KnowledgeBase of annotations kept by VFB.
VFBneoProd = Web facing Neo4J database

Endpoints: 

 Endpoint | DB | Neo4j version | Bolt | r/w status | Behind VPN | Status in pipeline (test/dev/production) |
 
 kbw.virtualflybrain.org | VFBneoKB; Neo4j 3.n; read/write; behind VPN.  Master DB ?
kb.virtualflybrain.org   - VFBNeoKB; Neo4j 3.m; read only, publicly available
pdb.virtualflybrain.org  - VFBNeoProd;  read only ?  publicly available


OWL servers:
AberOWL: 
http://owl.virtualflybrain.org/api/runQuery.groovy?

SOLR servers:

front end:

virtualflybrain.org - live VFB 1.5
sandboxN.vfb.ed.ac.uk  = ???
v2.virtualflybrain.org - live VFB 1.5

