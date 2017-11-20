cd "${WORKSPACE}"
echo '** Git checkout VFB_neo4j **'
git clone git@github.com:VirtualFlyBrain/VFB_neo4j.git
echo '** Git checkout VFB_owl **'
git clone git@github.com:VirtualFlyBrain/VFB_owl.git
cd VFB_owl
git checkout tags/${VFB_OWL_VERSION}
find . -name '*.gz' -exec pigz -dvf '{}' \;
