# VFB data pipeline specs

## Architecture

![image](https://user-images.githubusercontent.com/112839/52511024-26b44700-2bb3-11e9-8e75-9b6e220de24e.png)

## Components

### (VFB) KB

A knowledgeBase of images and the anatomical entities depicted in them.  Image data could be confocal, E.M., schematic, painted domains over confocal.  

* Anatomical and image individuals are typed using FBbt and FBbi respectively.  
* The genetic features expressed by anatomical entites are expressed using FB feature IDs.  
* Images depict anatomical enties.  Images may be registered to other images.

### (VFB) PDB

Integrated, web facing Neo4j DB

## Description of scripts

ONT2KB_update:   uk.ac.ebi.vfb.neo4j.KB_tools.node_importer.update_from_obograph (Requires JSON version for loading).

FB2KB_update:    uk.ac.ebi.vfb.neo4j.KB_tools.node_importer.update_from_flybase

### OLS loader

Installs the basic ontology into Prod from OWL (vfb, fbdv, fbcv, fbbi) 

Repo:[VirtualFlyBrain/Docker-OLS-loader](https://github.com/VirtualFlyBrain/Docker-OLS-loader) 
[Script](https://github.com/VirtualFlyBrain/Docker-OLS-loader/blob/master/loadOLS.sh) [DockerHub](https://hub.docker.com/r/virtualflybrain/docker-ols-loader/)

This process loads using custom [OLS configs](https://github.com/VirtualFlyBrain/OLS_configs) and creates a neo4j database (offline) under a mounted [volume](https://github.com/VirtualFlyBrain/Docker-OLS-loader/blob/master/Dockerfile#L14) [/data/](https://github.com/VirtualFlyBrain/Docker-OLS-loader/blob/master/loadOLS.sh#L32). The enviromental variable [VFB_OWL_VERSION](https://github.com/VirtualFlyBrain/Docker-OLS-loader/blob/master/Dockerfile#L3) sets the current [VFB OWL](https://github.com/VirtualFlyBrain/VFB_owl) [release](https://github.com/VirtualFlyBrain/VFB_owl/releases) to be [loaded](https://github.com/VirtualFlyBrain/Docker-OLS-loader/blob/master/loadOLS.sh#L6).  
Once finished the contents of /data/ can be loaded by a [neo4j production instance](https://hub.docker.com/r/virtualflybrain/docker-vfb-neo4j-productiondb/). under the mounted volume [/disk/](https://github.com/VirtualFlyBrain/Docker-VFB-Neo4j-ProductionDB/blob/master/Dockerfile#L9) (Previous /data/ -> /disk/data/neo4j/.ols/neo4j/).


### KB2Prod

Exports the non-OWL components of the KB to Prod: Image individuals; data_source; pub and related links to inds.

script: uk/ac/ebi/vfb/neo4j/neo2neo/KB2Prod.py  - run via [Pipeline shell script](https://github.com/VirtualFlyBrain/pipeline/blob/master/process.sh)

### Neo2OWL

Scala code built on the SCOWL library:  https://github.com/VirtualFlyBrain/VFB_neo_kb_2_owl 

This code is used to gate release of datasets to OWL (and from there to staging & production). In 'ALL' mode, any dataset with production=true is converted to OWL. It can also be used to write named datasets to OWL, independent of any dataset flags.

Jenkins: https://jenkins.virtualflybrain.org/job/Build_vfb.owl  Any dataset with production=true is converted to OWL.

### FB2Prod

* Import pub data from FlyBase: uk/ac/ebi/vfb/neo4j/flybase2neo/import\_pub_data.py - run via [Pipeline shell script](https://github.com/VirtualFlyBrain/pipeline/blob/master/process.sh) as part of [Jenkins pipline job](https://blanik-jenkins.virtualflybrain.org/view/Rancher/job/Load_VFB_Production_DB/)

* Import expression curation from FlyBase: uk/ac/ebi/vfb/neo4j/flybase2neo/expression_runner.py - Not currently in pipeline shell. https://blanik-jenkins.virtualflybrain.org/view/Rancher/job/Load_VFB_Production_DB-development/

### Prod2Prod

Denormalization scripts:

* Add constraints + generate labels from classification :  uk/ac/ebi/vfb/neo4j/neo2neo/add\_constraints\_and\_redundant\_labels.py run via [Pipeline shell script]

* Convert edges to use labels for relation names uk/ac/ebi/vfb/neo4j/neo2neo/make\_named\_edges.py  This needs to run last! run via [Pipeline shell script]

{ NOT CURRENTLY IMPLEMENTED - LEAVING FOR REFERENCE 

* Rule-based inference of classification and partonomy on expression patterns and exp pat fragments respectively

Can do this in Cypher:

~~~~~~~~~.cql

(i:Individual)-[:expresses]-(feat:Class)
(i)-[:Intanceof]-(:Class { label : expression pattern' } )
-> (i:Individual)-[:Intanceof]-(expression pattern of X)

....
(more work needed to fully spec)
~~~~~~~~~~~~
}

### Dev, Staging and Prod

Data release:

![image](https://user-images.githubusercontent.com/112839/52516050-45c5cf80-2bd9-11e9-9974-9624da75f0ba.png)

KB -> KBW = Jenkins: 

firstload -> staging (alpha) = Jenkins:

### Prod2SOLR
virtualflybrain/docker-vfb-solr takes a envirmental variable at startup called SOLRDOCS
This contains any additional records not added by the OLS loader. Currently just the DataSets from PDB are manually copied across. The records are creasted using the follopwing cypher:
```
MATCH (n:DataSet) where not has(n.public) with collect(distinct '{"id":"vfb:class:'+n.iri+'","iri":"'+n.iri+'","short_form":"'+n.short_form+'","shortform_autosuggest":["'+n.short_form+'"],"obo_id":"'+n.short_form+'","label":"'+n.label+'","label_autosuggest":"'+n.label+'","label_autosuggest_ws":"'+n.label+'","label_autosuggest_e":"'+n.label+'","autosuggest":["'+n.label+'"],"autosuggest_e":["'+n.label+'"],"description":["'+coalesce(n.description, n.label)+'"],"ontology_name":"vfb","ontology_title":"Virtual Fly Brain Knowledge Base","ontology_prefix":"VFB","ontology_iri":"http://purl.obolibrary.org/obo/fbbt/vfb/vfb.owl","type":"class","is_defining_ontology":false,"has_children":false,"is_root":true}') as doc Return REDUCE(output = [], r IN doc | output + r) AS flat
```

