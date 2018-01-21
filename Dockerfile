FROM rcourt/docker-pythons

VOLUME /logs

ENV WORKSPACE=/opt/VFB

ENV JYTHON_VER=2.7.1

ENV JYTHON_HOME=/usr/lib/jython$JYTHON_VER

ENV VFB_OWL_VERSION=Current

ENV OWLTOOLS_VERSION=owlapi-3.5.1

ENV CHUNK_SIZE=1000

ENV PING_SLEEP=120s

ENV BUILD_OUTPUT=${WORKSPACE}/build.out

ENV RUN_add_anonymous_types=true
ENV RUN_add_refs_for_anat=true
ENV RUN_import_pub_data=true
ENV RUN_make_named_edges=true
ENV RUN_KB2Prod=true
ENV RUN_add_constraints_and_redundant_labels=true

RUN pip install site-packages

RUN pip3 install requests

RUN pip3 install psycopg2

RUN apt-get -qq update || apt-get -qq update && \ 
apt-get -qq -y install git curl wget default-jdk pigz maven gnupg2 libpq-dev python-dev tree gawk

RUN apt-get -qq -y remove jython

RUN mkdir -p $WORKSPACE && cd $WORKSPACE && wget -q http://central.maven.org/maven2/org/python/jython-installer/$JYTHON_VER/jython-installer-$JYTHON_VER.jar && \
java -jar $WORKSPACE/jython-installer-$JYTHON_VER.jar -s -d $JYTHON_HOME && ln -f $JYTHON_HOME/bin/jython /usr/bin/jython 

RUN $JYTHON_HOME/bin/pip install requests

ENV KBSERVER=http://kb.virtualflybrain.org

ENV PDBSERVER=http://pdb.virtualflybrain.org

ENV PDBuser=user

ENV PDBpassword=password

ENV KBuser=user

ENV KBpassword=password

COPY process.sh /opt/VFB/process.sh

COPY runsilent.sh /opt/VFB/runsilent.sh

RUN chmod +x /opt/VFB/*.sh

COPY gen-key-script /opt/VFB/gen-key-script

RUN gpg --batch --gen-key --passphrase '' --verify-options no-show-photos --list-options no-show-photos --pinentry-mode loopback /opt/VFB/gen-key-script


RUN echo -e "travis_fold:start:processLoad" && \
cd "${WORKSPACE}" && \
echo '** Git checkout VFB_neo4j **' && \
git clone --quiet https://github.com/VirtualFlyBrain/VFB_neo4j.git 

RUN echo '** Git checkout hdietze/Brain **' && \
cd ${WORKSPACE} && git clone --quiet https://github.com/hdietze/Brain.git && \
cd ${WORKSPACE}/Brain && \
mvn -q -Dgpg.passphrase=default99 -DskipTests=true -Dmaven.javadoc.skip=true -Dsource.skip=true install 


RUN cd ${WORKSPACE} && \
echo '** Git checkout VFB_owl **' && \
git clone --quiet https://github.com/VirtualFlyBrain/VFB_owl.git && \



RUN cd ${WORKSPACE} && \
echo '** Git checkout owltools **' && \
git clone --quiet https://github.com/owlcollab/owltools.git && \
cd ${WORKSPACE}/owltools && \
git checkout ${OWLTOOLS_VERSION} && \
cd ${WORKSPACE}/owltools/OWLTools-Parent/ && \
mvn -q clean install -DskipTests -Dmaven.javadoc.skip=true -Dsource.skip=true

RUN mkdir -p ${WORKSPACE}/owlapi/ && \
cd ${WORKSPACE}/owlapi/ && \
wget -q http://central.maven.org/maven2/net/sourceforge/owlapi/owlapi-distribution/3.5.1/owlapi-distribution-3.5.1.jar && \
wget -q http://central.maven.org/maven2/net/sourceforge/owlapi/owlapi-apibinding/3.5.1/owlapi-apibinding-3.5.1.jar && \
wget -q http://central.maven.org/maven2/net/sourceforge/owlapi/owlapi-api/3.5.1/owlapi-api-3.5.1.jar && \
wget -q http://central.maven.org/maven2/net/sourceforge/owlapi/owlapi-tools/3.5.1/owlapi-tools-3.5.1.jar && \
wget -q http://central.maven.org/maven2/net/sourceforge/owlapi/owlapi-impl/3.5.1/owlapi-impl-3.5.1.jar && \
wget -q http://central.maven.org/maven2/net/sourceforge/owlapi/owlapi-parsers/3.5.1/owlapi-parsers-3.5.1.jar && \
wget -q http://central.maven.org/maven2/net/sourceforge/owlapi/owlapi-oboformat/3.5.1/owlapi-oboformat-3.5.1.jar && \
wget -q http://central.maven.org/maven2/net/sourceforge/owlapi/oboformat-included-owlapi/3.4.9/oboformat-included-owlapi-3.4.9.jar && \
wget -q http://central.maven.org/maven2/com/google/guava/guava/23.0/guava-23.0.jar && \
wget -q http://central.maven.org/maven2/net/sf/trove4j/trove4j/3.0.3/trove4j-3.0.3.jar && \
wget -q http://central.maven.org/maven2/org/semanticweb/elk/elk-standalone/0.3.2/elk-standalone-0.3.2.jar && \
wget -q http://central.maven.org/maven2/org/semanticweb/elk/elk-owlapi/0.3.2/elk-owlapi-0.3.2.jar 


RUN cd ${WORKSPACE} && \
echo -e "travis_fold:end:processLoad"

RUN echo -e "travis_fold:start:sourcetree" && tree ${WORKSPACE} && echo -e "travis_fold:end:sourcetree"

ENV JYTHONPATH=${WORKSPACE}/VFB_neo4j/src/:${WORKSPACE}/VFB_owl/src/code/mod/:${WORKSPACE}/VFB_owl/src/code/owl2neo/:${WORKSPACE}/VFB_owl/src/code/db_maintenance/:${WORKSPACE}/VFB_owl/src/code/entity_checks/:${WORKSPACE}/VFB_owl/src/code/export/:${WORKSPACE}/VFB_owl/src/code/owl_gen/:${WORKSPACE}/VFB_owl/src/code/unit_tests/
ENV CLASSPATH=${WORKSPACE}/owltools/OWLTools-Core/target/OWLTools-Core-0.2.2-SNAPSHOT.jar:${WORKSPACE}/Brain/target/Brain-1.5.2-SNAPSHOT.jar:${WORKSPACE}/owltools/OWLTools-Runner/target/OWLTools-Runner-0.2.2-SNAPSHOT.jar:${WORKSPACE}/owlapi/*
ENV PYTHONPATH=${WORKSPACE}/VFB_neo4j/src/

CMD ["/opt/VFB/process.sh"]
