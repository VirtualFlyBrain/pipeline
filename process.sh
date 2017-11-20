cd "${WORKSPACE}"
echo '** Git checkout VFB_neo4j **'
git clone git@github.com:VirtualFlyBrain/VFB_neo4j.git
echo '** Git checkout VFB_owl **'
git clone git@github.com:VirtualFlyBrain/VFB_owl.git
cd VFB_owl
echo "Checkout OWL release ${VFB_OWL_VERSION}"
git checkout tags/${VFB_OWL_VERSION}
echo "Expanding compressed OWL files"
find . -name '*.gz' -exec pigz -dvf '{}' \;

echo ''
echo '** Side loading from vfb.owl: add_annonymous types **'

export PYTHONPATH=${WORKSPACE}/VFB_owl/src/code/mod/:${WORKSPACE}/VFB_owl/src/code/owl2neo/:${WORKSPACE}/VFB_owl/src/code/db_maintenance/:${WORKSPACE}/VFB_owl/src/code/entity_checks/:${WORKSPACE}/VFB_owl/src/code/export/:${WORKSPACE}/VFB_owl/src/code/owl_gen/:${WORKSPACE}/VFB_owl/src/code/unit_tests/

sleep 10

java -cp ${WORKSPACE}/VFB_owl/lib/*:/partition/bocian/VFBTools/jython/jython-2.7.0/jython.jar org.python.util.jython -Dpython.path=$PYTHONPATH ${WORKSPACE}/VFB_owl/src/code/owl2neo/add_anonymous_types.py http://localhost:7474 neo4j neo4j ${WORKSPACE}/VFB_owl/src/owl/vfb.owl


sleep 10


echo ''
echo '** Side loading from vfb owl: add refs **'

java -cp ${WORKSPACE}/VFB_owl/lib/*:/partition/bocian/VFBTools/jython/jython-2.7.0/jython.jar org.python.util.jython -Dpython.path=$PYTHONPATH ${WORKSPACE}/VFB_owl/src/code/owl2neo/add_refs_for_anat.py http://localhost:7474 neo4j neo4j ${WORKSPACE}/VFB_owl/src/owl/vfb.owl

sleep 10

export PYTHONPATH=${WORKSPACE}/VFB_neo4j/src/

echo ''
echo '** Loading from FB : import pub data **'

python3 ${WORKSPACE}/VFB_neo4j/src/uk/ac/ebi/vfb/neo4j/flybase2neo/import_pub_data.py http://localhost:7474 neo4j neo4j

sleep 10


echo ''
echo '** Denormalization: Make named edges **'

python3 ${WORKSPACE}/VFB_neo4j/src/uk/ac/ebi/vfb/neo4j/neo2neo/make_named_edges.py http://localhost:7474 neo4j neo4j

sleep 10
