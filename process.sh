#!/bin/sh
cd "${WORKSPACE}"
gpg full-gen-key --passwd default99 --batch
echo '** Git checkout VFB_neo4j **'
git clone --quiet https://github.com/VirtualFlyBrain/VFB_neo4j.git
echo '** Git checkout hdietze/Brain **'
git clone --quiet https://github.com/hdietze/Brain.git
cd Brain
mvn -Dgpg.passphrase=default99 -DskipTests=true -Dmaven.javadoc.skip=true -Dsource.skip=true install
cd ${WORKSPACE}
echo '** Git checkout VFB_owl **'
git clone --quiet https://github.com/VirtualFlyBrain/VFB_owl.git
cd VFB_owl
echo "Checkout OWL release ${VFB_OWL_VERSION}"
git checkout tags/${VFB_OWL_VERSION}
mvn install
ls ${WORKSPACE}/VFB_owl/lib/*
echo "Expanding compressed OWL files"
find . -name '*.gz' -exec pigz -dvf '{}' \;

echo ''
echo '** Side loading from vfb.owl: add_annonymous types **'

export JYTHONPATH=${WORKSPACE}/VFB_neo4j/src/:${WORKSPACE}/VFB_owl/src/code/mod/:${WORKSPACE}/VFB_owl/src/code/owl2neo/:${WORKSPACE}/VFB_owl/src/code/db_maintenance/:${WORKSPACE}/VFB_owl/src/code/entity_checks/:${WORKSPACE}/VFB_owl/src/code/export/:${WORKSPACE}/VFB_owl/src/code/owl_gen/:${WORKSPACE}/VFB_owl/src/code/unit_tests/
export CLASSPATH=${WORKSPACE}/VFB_owl/lib/*

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
