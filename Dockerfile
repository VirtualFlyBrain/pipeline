FROM paternal/pythons

ENV WORKSPACE=/opt/VFB

ENV JYTHON_VER=2.7.1

ENV JYTHON_HOME=/usr/lib/jython$JYTHON_VER

RUN apt-get -qq update || apt-get -qq update && \ 
apt-get -qq -y install git curl wget default-jdk pigz maven gnupg2 libpq-dev python-dev

RUN apt-get -qq -y remove jython

RUN mkdir -p $WORKSPACE && cd $WORKSPACE && wget –quiet http://central.maven.org/maven2/org/python/jython-installer/$JYTHON_VER/jython-installer-$JYTHON_VER.jar && \
java -jar $WORKSPACE/jython-installer-$JYTHON_VER.jar -s -d $JYTHON_HOME && ln -f $JYTHON_HOME/bin/jython /usr/bin/jython 

RUN pip install site-packages

RUN $JYTHON_HOME/bin/pip install psycopg2

RUN $JYTHON_HOME/bin/pip install requests

ENV VFB_OWL_VERSION=Current

ENV KBSERVER=http://kb.virtualflybrain.org

ENV PDBSERVER=http://pdb.virtualflybrain.org

ENV PDBuser=user

ENV PDBpassword=password

ENV KBuser=user

ENV KBpassword=password

COPY process.sh /opt/VFB/process.sh

RUN chmod +x /opt/VFB/*.sh

COPY gen-key-script /opt/VFB/gen-key-script

RUN gpg --batch --gen-key --passphrase '' --verify-options no-show-photos --list-options no-show-photos --pinentry-mode loopback /opt/VFB/gen-key-script

CMD ["/opt/VFB/process.sh"]
