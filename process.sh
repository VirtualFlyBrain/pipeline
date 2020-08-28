#!/bin/sh



cd ${WORKSPACE}/VFB_neo4j
git config --global user.email "support@VirtualFlyBrain.org"
git pull origin pipline2
cd ..

cd "${WORKSPACE}/VFB_neo4j" && \
pip install -r requirements.txt

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

echo -e "travis_fold:start:add_refs_for_anat"
echo '** Expanding refs on anatomy terms **'
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

echo ''
echo -e "travis_fold:start:expand_xrefs"
echo '** expand_xrefs **'
if [ "${RUN_expand_xrefs}" != false ]
then
  export BUILD_OUTPUT=${WORKSPACE}/expand_xrefs.out
  ${WORKSPACE}/runsilent.sh "python3 ${WORKSPACE}/VFB_neo4j/src/uk/ac/ebi/vfb/neo4j/neo2neo/expand_xrefs.py ${PDBSERVER} ${PDBuser} ${PDBpassword}"
  cp $BUILD_OUTPUT /logs/
  egrep 'Exception|Error|error|exception|warning' $BUILD_OUTPUT
else
  echo SKIPPED
fi
echo -e "travis_fold:end:expand_xrefs"

echo ''
echo -e "travis_fold:start:owl2neolabels"
echo '** Owl2neolabels **'
if [ "${RUN_Owl2neolabels}" != false ]
then
  export BUILD_OUTPUT=${WORKSPACE}/Owl2neolabels.out
  ${WORKSPACE}/runsilent.sh "python3 ${WORKSPACE}/VFB_neo4j/src/uk/ac/ebi/vfb/neo4j/owl2neo/add_labels_from_owl_queries.py ${PDBSERVER} ${PDBuser} ${PDBpassword} ${OWLSERVER}"
  cp $BUILD_OUTPUT /logs/
  egrep 'Exception|Error|error|exception|warning' $BUILD_OUTPUT
else
  echo SKIPPED
fi
echo -e "travis_fold:end:owl2neolabels"

