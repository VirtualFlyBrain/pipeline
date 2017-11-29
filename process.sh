#!/bin/sh


echo ''
echo '** Side loading from vfb.owl: add_annonymous types **'

sleep 10

jython ${WORKSPACE}/VFB_owl/src/code/owl2neo/add_anonymous_types.py ${PDBSERVER} ${PDBuser} ${PDBpassword} ${WORKSPACE}/VFB_owl/src/owl/vfb.owl

sleep 10

echo ''
echo '** Side loading from vfb owl: add refs **'

jython ${WORKSPACE}/VFB_owl/src/code/owl2neo/add_refs_for_anat.py ${PDBSERVER} ${PDBuser} ${PDBpassword} ${WORKSPACE}/VFB_owl/src/owl/vfb.owl

sleep 10

export PYTHONPATH=${WORKSPACE}/VFB_neo4j/src/

echo ''
echo '** Loading from FB : import pub data **'

python3 ${WORKSPACE}/VFB_neo4j/src/uk/ac/ebi/vfb/neo4j/flybase2neo/import_pub_data.py ${PDBSERVER} ${PDBuser} ${PDBpassword}

sleep 10


echo ''
echo '** Denormalization: Make named edges **'

python3 ${WORKSPACE}/VFB_neo4j/src/uk/ac/ebi/vfb/neo4j/neo2neo/make_named_edges.py ${PDBSERVER} ${PDBuser} ${PDBpassword}

sleep 10

echo ''
echo '** KB2Prod **'

python3 ${WORKSPACE}/VFB_neo4j/src/uk/ac/ebi/vfb/neo4j/neo2neo/KB2Prod ${KBSERVER} ${KBuser} ${KBpassword} ${PDBSERVER} ${PDBuser} ${PDBpassword}

sleep 10
