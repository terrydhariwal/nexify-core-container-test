# Build based on Tomcat
FROM tomcat:9-jre8
MAINTAINER Peter Lawrence "peter.lawrence@inova8.com"

# install utilities and update OS
RUN apt-get update -y
RUN apt-get install -y \
    less \
    tree \
    nano

# Setup variables
ENV RDF4J_DATA="/root/.RDF4J"

ARG HBASE_VERSION=1.1.2
ARG HALYARD_VERSION=1.5
#ARG HALYARD_VERSION=2.0-SNAPSHOT
#ARG HALYARD_VERSION=2.0

ENV HALYARD_PREFIX=/opt/halyard-$HALYARD_VERSION
ENV PATH $HALYARD_PREFIX:$PATH

WORKDIR /tmp

# Install RDF4J with Halyard webapps
#RUN wget -t 10 --max-redirect 1 --retry-connrefused https://github.com/Merck/Halyard/releases/download/nightly_build_20180905/halyard-sdk-$HALYARD_VERSION.zip
RUN wget -t 10 --max-redirect 1 --retry-connrefused https://github.com/Merck/Halyard/releases/download/r$HALYARD_VERSION/halyard-sdk-$HALYARD_VERSION.zip

RUN mkdir -p /opt/halyard-sdk-$HALYARD_VERSION
RUN unzip -d /opt/halyard-sdk-$HALYARD_VERSION halyard-sdk-$HALYARD_VERSION.zip

#RUN wget https://github.com/Merck/Halyard/releases/download/nightly_build_20180905/halyard-webapps-$HALYARD_VERSION.zip
RUN wget https://github.com/Merck/Halyard/releases/download/r$HALYARD_VERSION/halyard-webapps-$HALYARD_VERSION.zip

RUN mkdir -p /opt/halyard-webapps-$HALYARD_VERSION
RUN unzip -d /opt/halyard-webapps-$HALYARD_VERSION  halyard-webapps-$HALYARD_VERSION.zip
RUN mv /opt/halyard-webapps-$HALYARD_VERSION/*.war /usr/local/tomcat/webapps

# Configure Tomcat users and context
ADD  tomcat/tomcat-users.xml /usr/local/tomcat/conf/tomcat-users.xml
ADD  tomcat/context.xml  /usr/local/tomcat/webapps/manager/META-INF/context.xml

# Install odata2sparql and its configuration file (models.ttl)
ADD  tomcat/war/odata2sparql.v4.war  /usr/local/tomcat/webapps/odata2sparql.war
ADD  tomcat/war/com.inova8.lens.framework.v4.war  /usr/local/tomcat/webapps/lens2odata.war
ADD  halyard/models.ttl /var/opt/inova8/odata2sparql/V4/

RUN mkdir -p $RDF4J_DATA
ADD halyard/server $RDF4J_DATA/server

#  Install HBase
ENV JAVA_HOME=/usr
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

COPY tomcat/setenv.sh $TOMCAT_HOME/bin/setenv.sh
RUN echo "CATALINA_OPTS=\"\$CATALINA_OPTS \$JVM_PARAMS -Dorg.eclipse.rdf4j.appdata.basedir=\$RDF4J_DATA\"" >> /usr/local/tomcat/bin/setenv.sh
COPY hbase/hbase-site.xml /opt/hbase/conf/hbase-site.xml

# Expose 8080
EXPOSE 8080
