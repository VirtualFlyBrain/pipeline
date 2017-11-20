FROM python:3

RUN apt-get -y update && \ 
apt-get -y install git curl wget default-jdk

RUN cd /opt/ && \
git clone https://github.com/VirtualFlyBrain/VFB_neo4j.git

ENV PYTHONPATH=/opt/VFB_neo4j/src/

RUN pip3 install requests

ENV KBSERVER=http://kbw.virtualflybrain.org:7474

ENV PDBSERVER=http://pdl.virtualflybrain.org:7474

ENV PDBuser=user

ENV PDBpassword=password

ENV KBuser=user

ENV KBpassword=password

ENV WORKSPACE=/opt/VFB

RUN mkdir -p /opt/VFB/jython

RUN cd /opt/VFB/jython && wget -rv -nH --cut-dirs=2 -np -R index.html* http://data.virtualflybrain.org/archive/jython/jython.jar 

CMD ['/bin/bash']
