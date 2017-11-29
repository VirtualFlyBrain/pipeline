#!/bin/sh

echo -e "travis_fold:start:set_chunk"
egrep -lir --include=*.{py} "(chunk_length=1000)" ${WORKSPACE} | xargs sed -i -e "s/chunk_length=1000/chunk_length=${CHUNK_SIZE}/g" 
echo -e "travis_fold:end:set_chunk"

echo -e "travis_fold:start:add_anonymous_types"
echo ''
echo '** Side loading from vfb.owl: add_annonymous types **'

sleep 10

jython ${WORKSPACE}/VFB_owl/src/code/owl2neo/add_anonymous_types.py ${PDBSERVER} ${PDBuser} ${PDBpassword} ${WORKSPACE}/VFB_owl/src/owl/vfb.owl

echo -e "travis_fold:end:add_anonymous_types"

echo -e "travis_fold:start:add_refs_for_anat"
sleep 10

echo ''
echo '** Side loading from vfb owl: add refs **'

jython ${WORKSPACE}/VFB_owl/src/code/owl2neo/add_refs_for_anat.py ${PDBSERVER} ${PDBuser} ${PDBpassword} ${WORKSPACE}/VFB_owl/src/owl/vfb.owl
echo -e "travis_fold:end:add_refs_for_anat"

echo -e "travis_fold:start:import_pub_data"
sleep 10

echo ''
echo '** Loading from FB : import pub data **'

python3 ${WORKSPACE}/VFB_neo4j/src/uk/ac/ebi/vfb/neo4j/flybase2neo/import_pub_data.py ${PDBSERVER} ${PDBuser} ${PDBpassword}

echo -e "travis_fold:end:import_pub_data"

echo -e "travis_fold:start:make_named_edges"
sleep 10


echo ''
echo '** Denormalization: Make named edges **'

python3 ${WORKSPACE}/VFB_neo4j/src/uk/ac/ebi/vfb/neo4j/neo2neo/make_named_edges.py ${PDBSERVER} ${PDBuser} ${PDBpassword}

echo -e "travis_fold:end:make_named_edges"

echo -e "travis_fold:start:KB2Prod"
sleep 10

echo ''
echo '** KB2Prod **'

python3 ${WORKSPACE}/VFB_neo4j/src/uk/ac/ebi/vfb/neo4j/neo2neo/KB2Prod.py ${KBSERVER} ${KBuser} ${KBpassword} ${PDBSERVER} ${PDBuser} ${PDBpassword}


echo -e "travis_fold:end:KB2Prod"
sleep 10

