# Build based on Tomcat
# FROM tomcat:9.0.7
FROM tomcat:9.0.11-jre8-alpine
MAINTAINER Peter Lawrence "peter.lawrence@inova8.com"

# install utilities and update OS
RUN apk update
#RUN apk add apt-get
#RUN apt-get update -y
#RUN apt-get install wget -y
#RUN apt-get install less -y
#RUN apt-get install tree -y
#RUN apt-get install nano -y
RUN apk add wget
RUN apk add less
RUN apk add tree
RUN apk add nano

# Setup variables
# ENV RDF4J_VERSION="2.3.2"
# ENV RDF4J_DATA="/opt/eclipse-rdf4j-${RDF4J_VERSION}/data"
ENV RDF4J_DATA="/root/.RDF4J"
# ENV JVM_PARAMS="-Xmx4g"
# ENV ODATA4SPARQL ="C:/Users/Peter/git/com.inova8.odata2sparql.v4/odata2sparql.v4/target/"
# ENV FRAMEWORK ="C:/Apps/SAPWebIDE/serverworkspace/pe/peterlawrence1/OrionContent/com.inova8.lens.framework.v4/target/"
# ENV SERVER ="C:/Users/Peter/AppData/Roaming/rdf4j/data/server"

#https://github.com/Merck/Halyard/releases/download/nightly_build_20180905/halyard-sdk-2.0-SNAPSHOT.zip
#https://github.com/Merck/Halyard/releases/download/nightly_build_20180905/halyard-webapps-2.0-SNAPSHOT.zip
ARG HBASE_VERSION=1.1.2
ARG HALYARD_VERSION=1.5
ENV HALYARD_PREFIX=/opt/halyard-$HALYARD_VERSION
ENV PATH $HALYARD_PREFIX:$PATH

# Install the lastest RDF4J server and workbench
# RUN curl -sS -o /tmp/rdf4j.zip -L http://download.eclipse.org/rdf4j/eclipse-rdf4j-${RDF4J_VERSION}-sdk.zip && \
#    cd /opt && \
#    unzip /tmp/rdf4j.zip && \
#    rm /tmp/rdf4j.zip
# RUN mv /opt/eclipse-rdf4j-${RDF4J_VERSION}/war/*.war /usr/local/tomcat/webapps
# RUN echo "CATALINA_OPTS=\"\$CATALINA_OPTS \$JVM_PARAMS -Dorg.eclipse.rdf4j.appdata.basedir=\$RDF4J_DATA\"" >> /usr/local/tomcat/bin/setenv.sh

# Install RDF4J with Halyard webapps
WORKDIR /tmp
RUN wget -t 10 --max-redirect 1 --retry-connrefused https://github.com/Merck/Halyard/releases/download/r$HALYARD_VERSION/halyard-sdk-$HALYARD_VERSION.zip
# RUN mkdir /opt/halyard
RUN mkdir -p /opt/halyard-sdk-$HALYARD_VERSION
RUN unzip -d /opt/halyard-sdk-$HALYARD_VERSION halyard-sdk-$HALYARD_VERSION.zip

RUN wget https://github.com/Merck/Halyard/releases/download/r$HALYARD_VERSION/halyard-webapps-$HALYARD_VERSION.zip
RUN mkdir -p /opt/halyard-webapps-$HALYARD_VERSION
RUN unzip -d /opt/halyard-webapps-$HALYARD_VERSION  halyard-webapps-$HALYARD_VERSION.zip
# RUN mv /opt/halyard-webapps-$HALYARD_VERSION/*.war /opt/tomcat/webapps
RUN mv /opt/halyard-webapps-$HALYARD_VERSION/*.war /usr/local/tomcat/webapps

# Configure Tomcat users
# ADD  tomcat-users.xml /usr/local/tomcat/conf/tomcat-users.xml
# ADD  context.xml  /usr/local/tomcat/webapps/manager/META-INF/context.xml
# ADD  tomcat-users.xml /opt/tomcat/conf/tomcat-users.xml # define users for managing tomcat via tomcat admin console
# ADD  context.xml  /opt/tomcat/webapps/manager/META-INF/context.xml # Allows for external admin access of tomcat

# define users for managing tomcat via tomcat admin console
ADD  tomcat-users.xml /usr/local/tomcat/conf/tomcat-users.xml
# Allows for external admin access of tomcat
ADD  context.xml  /usr/local/tomcat/webapps/manager/META-INF/context.xml

# Install odata2sparql and its configuration file (models.ttl)
#ADD  odata2sparql.v4.war  /usr/local/tomcat/webapps/odata2sparql.war
#ADD  models.ttl /var/opt/inova8/odata2sparql/V4/ # TODO contains stuff that can be parameterised further
#ADD  odata2sparql.v4.war  /opt/tomcat/webapps/odata2sparql.war
#ADD  models.ttl /var/opt/inova8/odata2sparql/V4/ #ADD should create this dir - TODO - check this. # TODO contains stuff that can be parameterised further


ADD  odata2sparql.v4.war  /usr/local/tomcat/webapps/odata2sparql.war
#ADD should create this dir - TODO - check this. # TODO contains stuff that can be parameterised further
ADD  models.ttl /var/opt/inova8/odata2sparql/V4/

# Install lens framwork and its preprared repositories
# NOTE that since the odata4sparql is now on a different server than the app is running,  it should be redirected in the <apartment>/manifest.json.
# For example "sap.app": {      "dataSources": {"dataService": "uri": "http://localhost:8080/odata2sparql/northwind/" -> "http://localhost:<Port of Docker container>/odata2sparql/northwind/"
# ADD  com.inova8.lens.framework.v4.war  /usr/local/tomcat/webapps/lens2odata.war
# ADD  com.inova8.lens.framework.v4.war  /opt/tomcat/webapps/lens2odata.war # TODO contains stuff that can be parameterised further

# TODO contains stuff that can be parameterised further
ADD  com.inova8.lens.framework.v4.war  /usr/local/tomcat/webapps/lens2odata.war

# TODO - update server dir with desired configuration # TODO contains stuff that can be parameterised further
# A system repository is not created - even if I comment these two lines out:
RUN mkdir -p $RDF4J_DATA
ADD  server $RDF4J_DATA/server


#ADD sample.war /usr/local/tomcat/webapps/sample.war

# TODO - zip and download /root/.RDF4J/server (ensure this is copied over before startup to ensure it isn't written by RDF4J)
# CREATE FOLDER OF CONFIG - ADD TO A REPO, WGET AND UNZIP ON DOCKERFILE INTO /root/.RDF4J

# Copy model files for consistency and rebuilding if required.
#ADD  inova8.northwind /var/opt/inova8/odata2sparql/northwind/
#ADD  NHS /var/opt/inova8/odata2sparql/NHS/

# # TODO CHECK IF WE NEED HBASE CLIENTS
#  Install HBase
#  ENV PATH $PATH:/opt/hbase/bin
ENV JAVA_HOME=/usr
# ENV TOMCAT_HOME=/opt/tomcat
ENV TOMCAT_HOME=/usr/local/tomcat
ENV HBASE_HOME=/opt/hbase
ENV HADOOP_CLASSPATH=$HADOOP_CLASSPATH:/opt/hbase/lib/hbase-server-$HBASE_VERSION.jar
ENV CLASSPATH=$CLASSPATH:$HADOOP_CLASSPATH

RUN wget -t 10 --max-redirect 1 --retry-connrefused http://archive.apache.org/dist/hbase/$HBASE_VERSION/hbase-$HBASE_VERSION-bin.tar.gz
RUN mkdir -p "/opt/hbase-$HBASE_VERSION"
RUN tar zxf "hbase-$HBASE_VERSION-bin.tar.gz" -C "/opt/hbase-$HBASE_VERSION" --strip 1
RUN test -d "/opt/hbase-$HBASE_VERSION"
RUN ln -sv "/opt/hbase-$HBASE_VERSION" /opt/hbase
RUN rm -fv "hbase-$HBASE_VERSION-bin.tar.gz"

RUN ln -sv /opt/hbase-$HBASE_VERSION/lib/jaxb-api-2.2.2.jar /opt/hbase-$HBASE_VERSION/lib/jaxb-api.jar
RUN ln -sv /opt/hbase-$HBASE_VERSION/lib/jaxb-impl-2.2.3-1.jar /opt/hbase-$HBASE_VERSION/lib/jaxb1-impl.jar
RUN ln -sv /opt/hbase-$HBASE_VERSION/lib/activation-1.1.jar /opt/hbase-$HBASE_VERSION/lib/activation.jar
RUN wget http://bits.netbeans.org/maven2/org/netbeans/external/jsr173_1.0_api/RELEASE731/jsr173_1.0_api-RELEASE731.jar -O /opt/hbase-$HBASE_VERSION/lib/jsr173_1.0_api.jar

COPY setenv.sh $TOMCAT_HOME/bin/setenv.sh
RUN echo "CATALINA_OPTS=\"\$CATALINA_OPTS \$JVM_PARAMS -Dorg.eclipse.rdf4j.appdata.basedir=\$RDF4J_DATA\"" >> /usr/local/tomcat/bin/setenv.sh
COPY hbase-site.xml /opt/hbase/conf/hbase-site.xml

# Publish RDF4J data volumes
VOLUME ${RDF4J_DATA}
EXPOSE 8080
