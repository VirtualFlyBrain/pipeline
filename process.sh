#!/bin/sh



cd ${WORKSPACE}/VFB_neo4j
git config --global user.email "support@VirtualFlyBrain.org"
git pull origin nonCSV
cd ..

cd "${WORKSPACE}/VFB_neo4j" && \
pip install -r requirements.txt


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

