FROM paternal/pythons

RUN apt-get update || apt-get update && \ 
apt-get -qq -y install git curl wget default-jdk pigz maven gnupg2 ca-certificates

RUN pip3 install psycopg2

RUN pip3 install requests

RUN pip2 -vvv install site

RUN pip3 install site

ENV VFB_OWL_VERSION=Current

ENV KBSERVER=http://kb.virtualflybrain.org

ENV PDBSERVER=http://pdb.virtualflybrain.org

ENV PDBuser=user

ENV PDBpassword=password

ENV KBuser=user

ENV KBpassword=password

ENV WORKSPACE=/opt/VFB

COPY Brain-1.5.2-SNAPSHOT.jar /opt/VFB/Brain-1.5.2-SNAPSHOT.jar
COPY Brain-1.5.2-SNAPSHOT.pom /opt/VFB/Brain-1.5.2-SNAPSHOT.pom

COPY process.sh /opt/VFB/process.sh

RUN chmod +x /opt/VFB/*.sh

CMD ["/opt/VFB/process.sh"]
