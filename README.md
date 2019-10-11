Amalgamated pipeline code 
| Add Refs for Anat | Import Pub Data   | Make Named Edges  | KB to Prod        | Add Contraints and Redundant Labels |
|-------------------|-------------------|-------------------|-------------------|-------------------------------------|
| [![Build1][1]][6] | [![Build2][2]][6] | [![Build3][3]][6] | [![Build4][4]][6] | [![Build4][5]][6]                   |

[1]: https://travis-matrix-badges.herokuapp.com/repos/VirtualFlyBrain/pipeline/branches/master/1
[2]: https://travis-matrix-badges.herokuapp.com/repos/VirtualFlyBrain/pipeline/branches/master/2
[3]: https://travis-matrix-badges.herokuapp.com/repos/VirtualFlyBrain/pipeline/branches/master/3
[4]: https://travis-matrix-badges.herokuapp.com/repos/VirtualFlyBrain/pipeline/branches/master/4
[5]: https://travis-matrix-badges.herokuapp.com/repos/VirtualFlyBrain/pipeline/branches/master/5
[6]: https://travis-ci.org/VirtualFlyBrain/pipeline

# pipeline
A repository for amalgamating pipeline issue tickets and general VFB pipeline doc

## Pipeline documentation:

Summary:

![image](https://cloud.githubusercontent.com/assets/112839/23518012/fbf38b24-ff69-11e6-945a-378b1949ab81.png)

[Full documentation](https://github.com/VirtualFlyBrain/pipeline/blob/master/doc/pipeline.md)

## VFB live server info:
[Rancher Cluster Documentation and backup configs](https://github.com/VirtualFlyBrain/RancherServices/blob/master/README.md)

### Neo4J databases:

* **VFBneoKB** : KnowledgeBase of annotations kept by VFB.
* **VFBneoProd** :  Web facing Neo4J database

#### Endpoints: 

 Endpoint | DB | Neo4j version | Bolt | r/w status | Behind VPN | Status in pipeline (test/dev/staging/prod) | backup link |
 --- | ----| --- | --- | --- | ----| ---- | ---
 kbw.virtualflybrain.org:7474 | VFBneoKB | Neo4j 3,n | y | r/w | Y | prod | [backup/deploy](https://blanik.inf.ed.ac.uk:8079/view/NEO4j/job/Backup%20KB%20on%20rancher/)
kb.virtualflybrain.org   | VFBNeoKB | Neo4j 3.n | Y | read only | N | ? | [update](https://blanik.inf.ed.ac.uk:8079/view/Rancher/job/Sync_Servers/) |
pdb.virtualflybrain.org  | VFBNeoProd |  Neo4j 2.n | NS | read only | N | prod?| |
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

[VFB 1.5 Site Deployment Documentation](https://github.com/VirtualFlyBrain/VFB/blob/master/deploy/README.md)

v2.virtualflybrain.org - live VFB 2.0

## GitHub branches for server code

TODO: Doc branch -> front end relationship (this should probably be on geppetto-vfb repo)

