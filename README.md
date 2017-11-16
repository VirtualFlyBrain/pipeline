# pipeline
A repository for amalgamating pipeline issue tickets and general VFB pipeline doc

## VFB live server info:

### Neo4J databases:

* **VFBneoKB** : KnowledgeBase of annotations kept by VFB.
* **VFBneoProd** :  Web facing Neo4J database

#### Endpoints: 

 Endpoint | DB | Neo4j version | Bolt | r/w status | Behind VPN | Status in pipeline (test/dev/staging/prod) | backup link |
 --- | ----| --- | --- | --- | ----| ---- 
 kbw.virtualflybrain.org:7474 | VFBneoKB | Neo4j 3,n | y | r/w | Y | prod | [backup](https://blanik.inf.ed.ac.uk:8079/view/NEO4j/job/Backup%20KB%20on%20rancher/)
kb.virtualflybrain.org   | VFBNeoKB | Neo4j 3.n | ? | read only | N | ? | 
pdb.virtualflybrain.org  | VFBNeoProd |  Neo4j 2.n | n | read only | N | prod?|
...

TODO: 
 - Document relaionship kb to kbw
 - If we have test instances for production, which front end server are they currently used by.  Would be very handy to keep this up-to-date.

### OWL servers:

#### AberOWL: 
 Endpoint |  Status in pipeline (test/dev/staging/production) |
 --- | ----
http://owl.virtualflybrain.org/api/runQuery.groovy? | production

### SOLR servers:

### front end:

virtualflybrain.org - live VFB 1.5

sandboxN.vfb.ed.ac.uk  = VFB 1.5 test ?

v2.virtualflybrain.org - live VFB 1.5

## GitHub branches for server code

TODO: Doc branch -> front end relationship (this should probably be on geppetto-vfb repo)

