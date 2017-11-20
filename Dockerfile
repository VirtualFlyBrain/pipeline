FROM python:3

RUN apt-get -y update && \ 
apt-get -y install git curl wget default-jdk pigz

ENV PYTHONPATH=/opt/VFB_neo4j/src/

RUN pip3 install requests

ENV VFB_OWL_VERSION=Current

ENV KBSERVER=http://kb.virtualflybrain.org

ENV PDBSERVER=http://pdb.virtualflybrain.org

ENV PDBuser=user

ENV PDBpassword=password

ENV KBuser=user

ENV KBpassword=password

ENV WORKSPACE=/opt/VFB

RUN mkdir -p /opt/VFB/jython

RUN cd /opt/VFB/jython && wget -rv -nH --cut-dirs=2 -np -R index.html* http://data.virtualflybrain.org/archive/jython/jython.jar 

COPY process.sh /opt/VFB/process.sh

RUN chmod +x /opt/VFB/*.sh

CMD ["/opt/VFB/process.sh"]
