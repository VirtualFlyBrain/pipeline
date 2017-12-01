#!/bin/sh

echo 'START' >> ${WORKSPACE}/tick.out
tail -f ${WORKSPACE}/tick.out >&1 &>&1

echo -e "travis_fold:start:add_anonymous_types"
echo '** Side loading from vfb.owl: add_annonymous types **'
if [ "${RUN_add_anonymous_types}" != false ]
then
  sed -i -e "s/chunk_length = 1000/chunk_length=${CHUNK_SIZE}/g" ${WORKSPACE}/VFB_owl/src/code/owl2neo/add_anonymous_types.py
  export BUILD_OUTPUT=${WORKSPACE}/add_anonymous_types.out
  ${WORKSPACE}/runsilent.sh "jython ${WORKSPACE}/VFB_owl/src/code/owl2neo/add_anonymous_types.py ${PDBSERVER} ${PDBuser} ${PDBpassword} ${WORKSPACE}/VFB_owl/src/owl/vfb.owl"
  egrep 'Exception|Error|error|exception|warning' $BUILD_OUTPUT
  echo -e "travis_fold:end:add_anonymous_types"
else
  echo SKIPPED
fi

echo ''
echo -e "travis_fold:start:add_refs_for_anat"
echo '** Side loading from vfb owl: add refs **'
if [ "${RUN_add_refs_for_anat}" != false ]
then
  sed -i -e "s/chunk_length = 500/chunk_length=${CHUNK_SIZE}/g" ${WORKSPACE}/VFB_owl/src/code/owl2neo/add_refs_for_anat.py
  export BUILD_OUTPUT=${WORKSPACE}/add_refs_for_anat.out
  ${WORKSPACE}/runsilent.sh "jython ${WORKSPACE}/VFB_owl/src/code/owl2neo/add_refs_for_anat.py ${PDBSERVER} ${PDBuser} ${PDBpassword} ${WORKSPACE}/VFB_owl/src/owl/vfb.owl"
  egrep 'Exception|Error|error|exception|warning' $BUILD_OUTPUT
else
  echo SKIPPED
fi
echo -e "travis_fold:end:add_refs_for_anat"

echo ''
echo -e "travis_fold:start:import_pub_data"
echo '** Loading from FB : import pub data **'
if [ "${RUN_import_pub_data}" != false ]
then
  export BUILD_OUTPUT=${WORKSPACE}/import_pub_data.out
  ${WORKSPACE}/runsilent.sh "python3 ${WORKSPACE}/VFB_neo4j/src/uk/ac/ebi/vfb/neo4j/flybase2neo/import_pub_data.py ${PDBSERVER} ${PDBuser} ${PDBpassword}"
  egrep 'Exception|Error|error|exception|warning' $BUILD_OUTPUT
else
  echo SKIPPED
fi
echo -e "travis_fold:end:import_pub_data"

echo ''
echo -e "travis_fold:start:make_named_edges"
echo '** Denormalization: Make named edges **'
if [ "${RUN_make_named_edges}" != false ]
then
  export BUILD_OUTPUT=${WORKSPACE}/make_named_edges.out
  ${WORKSPACE}/runsilent.sh "python3 ${WORKSPACE}/VFB_neo4j/src/uk/ac/ebi/vfb/neo4j/neo2neo/make_named_edges.py ${PDBSERVER} ${PDBuser} ${PDBpassword}"
  egrep 'Exception|Error|error|exception|warning' $BUILD_OUTPUT
else
  echo SKIPPED
fi
echo -e "travis_fold:end:make_named_edges"

echo ''
echo -e "travis_fold:start:KB2Prod"
echo '** KB2Prod **'
if [ "${RUN_KB2Prod}" != false ]
then
  export BUILD_OUTPUT=${WORKSPACE}/KB2Prod.out
  ${WORKSPACE}/runsilent.sh "python3 ${WORKSPACE}/VFB_neo4j/src/uk/ac/ebi/vfb/neo4j/neo2neo/KB2Prod.py ${KBSERVER} ${KBuser} ${KBpassword} ${PDBSERVER} ${PDBuser} ${PDBpassword}"
  egrep 'Exception|Error|error|exception|warning' $BUILD_OUTPUT
else
  echo SKIPPED
fi
echo -e "travis_fold:end:KB2Prod"

