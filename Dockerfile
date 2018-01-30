FROM python3

VOLUME /logs

ENV WORKSPACE=/opt/VFB

ENV VFB_OWL_VERSION=Current

ENV OWLTOOLS_VERSION=owlapi-3.5.1

ENV CHUNK_SIZE=1000

ENV PING_SLEEP=120s

ENV BUILD_OUTPUT=${WORKSPACE}/build.out

ENV RUN_add_refs_for_anat=true
ENV RUN_import_pub_data=true
ENV RUN_make_named_edges=true
ENV RUN_KB2Prod=true
ENV RUN_add_constraints_and_redundant_labels=true

RUN pip3 install site-packages

RUN pip3 install requests

RUN pip3 install psycopg2

RUN apt-get -qq update || apt-get -qq update && \ 
apt-get -qq -y install git curl wget default-jdk pigz maven gnupg2 libpq-dev python-dev tree gawk

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

RUN cd ${WORKSPACE} && \
echo -e "travis_fold:end:processLoad"

RUN echo -e "travis_fold:start:sourcetree" && tree ${WORKSPACE} && echo -e "travis_fold:end:sourcetree"

ENV CLASSPATH=${WORKSPACE}/owltools/OWLTools-Core/target/OWLTools-Core-0.2.2-SNAPSHOT.jar:${WORKSPACE}/Brain/target/Brain-1.5.2-SNAPSHOT.jar:${WORKSPACE}/owltools/OWLTools-Runner/target/OWLTools-Runner-0.2.2-SNAPSHOT.jar:${WORKSPACE}/owlapi/*
ENV PYTHONPATH=${WORKSPACE}/VFB_neo4j/src/

CMD ["/opt/VFB/process.sh"]
