FROM paternal/pythons

RUN apt-get -qq -y update && \ 
apt-get -qq -y install git curl wget default-jdk pigz maven gnupg2

RUN pip3 install psycopg2

RUN pip3 install requests

RUN pip2 install site

RUN pip3 install site

ENV VFB_OWL_VERSION=Current

ENV KBSERVER=http://kb.virtualflybrain.org

ENV PDBSERVER=http://pdb.virtualflybrain.org

ENV PDBuser=user

ENV PDBpassword=password

ENV KBuser=user

ENV KBpassword=password

ENV WORKSPACE=/opt/VFB

#RUN mkdir -p /opt/VFB/jython

#RUN cd /opt/VFB/jython && wget -r -nv -nH --cut-dirs=2 -np -R index.html* http://data.virtualflybrain.org/archive/jython/jython.jar 

COPY process.sh /opt/VFB/process.sh

RUN chmod +x /opt/VFB/*.sh

CMD ["/opt/VFB/process.sh"]
