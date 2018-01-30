#!/bin/sh

echo 'START' >> ${WORKSPACE}/tick.out
# tail -f ${WORKSPACE}/tick.out >&1 &>&1

cd ${WORKSPACE}/VFB_neo4j
git pull | :
cd -

echo -e "travis_fold:start:add_refs_for_anat"
echo '** Side loading from vfb owl: add refs **'
if [ "${RUN_add_refs_for_anat}" != false ]
then
  sed -i -e "s/chunk_length=2000/chunk_length=${CHUNK_SIZE}/g" ${WORKSPACE}/VFB_neo4j/src/uk/ac/ebi/vfb/neo4j/flybase2neo/add_refs_for_anat.py
  export BUILD_OUTPUT=${WORKSPACE}/add_refs_for_anat.out
  ${WORKSPACE}/runsilent.sh "python3 ${WORKSPACE}/VFB_neo4j/src/uk/ac/ebi/vfb/neo4j/flybase2neo/add_refs_for_anat.py ${PDBSERVER} ${PDBuser} ${PDBpassword}"
  cp $BUILD_OUTPUT /logs/
  egrep 'Exception|Error|error|exception|warning' $BUILD_OUTPUT
else
  echo SKIPPED
fi
echo -e "travis_fold:end:add_refs_for_anat"

echo ''
echo -e "travis_fold:start:KB2Prod"
echo '** KB2Prod **'
if [ "${RUN_KB2Prod}" != false ]
then
  export BUILD_OUTPUT=${WORKSPACE}/KB2Prod.out
  ${WORKSPACE}/runsilent.sh "python3 ${WORKSPACE}/VFB_neo4j/src/uk/ac/ebi/vfb/neo4j/neo2neo/KB2Prod.py ${KBSERVER} ${KBuser} ${KBpassword} ${PDBSERVER} ${PDBuser} ${PDBpassword}"
  cp $BUILD_OUTPUT /logs/
  egrep 'Exception|Error|error|exception|warning' $BUILD_OUTPUT
else
  echo SKIPPED
fi
echo -e "travis_fold:end:KB2Prod"

echo ''
echo -e "travis_fold:start:import_pub_data"
echo '** Loading from FB : import pub data **'
if [ "${RUN_import_pub_data}" != false ]
then
  export BUILD_OUTPUT=${WORKSPACE}/import_pub_data.out
  ${WORKSPACE}/runsilent.sh "python3 ${WORKSPACE}/VFB_neo4j/src/uk/ac/ebi/vfb/neo4j/flybase2neo/import_pub_data.py ${PDBSERVER} ${PDBuser} ${PDBpassword}"
  cp $BUILD_OUTPUT /logs/
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
  sed -i -e "s/chunk_length = 10000/chunk_length=${CHUNK_SIZE}/g" ${WORKSPACE}/VFB_neo4j/src/uk/ac/ebi/vfb/neo4j/neo2neo/make_named_edges.py
  if [ "${RUN_add_refs_for_anat}" != true ]
  then
    sed -i -e "s/test_mode = False/test_mode = True/g" ${WORKSPACE}/VFB_neo4j/src/uk/ac/ebi/vfb/neo4j/neo2neo/make_named_edges.py
  fi
  export BUILD_OUTPUT=${WORKSPACE}/make_named_edges.out
  ${WORKSPACE}/runsilent.sh "python3 ${WORKSPACE}/VFB_neo4j/src/uk/ac/ebi/vfb/neo4j/neo2neo/make_named_edges.py ${PDBSERVER} ${PDBuser} ${PDBpassword}"
  cp $BUILD_OUTPUT /logs/
  egrep 'Exception|Error|error|exception|warning' $BUILD_OUTPUT
else
  echo SKIPPED
fi
echo -e "travis_fold:end:make_named_edges"

echo -e "travis_fold:start:add_constraints_and_redundant_labels"
echo '** Adding constraints and redundant labels **'
if [ "${RUN_add_constraints_and_redundant_labels}" != false ]
then
# NA  sed -i -e "s/chunk_length = 10000/chunk_length=${CHUNK_SIZE}/g" ${WORKSPACE}/VFB_neo4j/src/uk/ac/ebi/vfb/neo4j/neo2neo/add_constraints_and_redundant_labels.py
  export BUILD_OUTPUT=${WORKSPACE}/add_constraints_and_redundant_labels.out
  ${WORKSPACE}/runsilent.sh "python3 ${WORKSPACE}/VFB_neo4j/src/uk/ac/ebi/vfb/neo4j/neo2neo/add_constraints_and_redundant_labels.py ${PDBSERVER} ${PDBuser} ${PDBpassword}"
  cp $BUILD_OUTPUT /logs/
  egrep 'Exception|Error|error|exception|warning' $BUILD_OUTPUT
else
  echo SKIPPED
fi
echo -e "travis_fold:end:add_constraints_and_redundant_labels"

