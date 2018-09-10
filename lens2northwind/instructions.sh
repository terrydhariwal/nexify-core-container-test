export my_project=quorum-360-187413
export my_zone=europe-west1-c
export my_instance_name=pilot-docker-host-for-halyard2

gcloud config set project ${my_project}

gcloud config list

gcloud compute instances create "${my_instance_name}" \
--project "${my_project}" \
--zone "${my_zone}" --machine-type "n1-standard-4" \
--network "hortonworks-network" \
--min-cpu-platform "Automatic" --image "debian-9-stretch-v20180307" \
--image-project "debian-cloud" \
--boot-disk-size "20" --boot-disk-type "pd-ssd" \
--boot-disk-device-name "${my_instance_name}" \
--scopes "https://www.googleapis.com/auth/source.read_only","https://www.googleapis.com/auth/servicecontrol","https://www.googleapis.com/auth/service.management.readonly","https://www.googleapis.com/auth/logging.write","https://www.googleapis.com/auth/monitoring.write","https://www.googleapis.com/auth/trace.append","https://www.googleapis.com/auth/devstorage.read_only"

sudo apt-get update -y

sudo apt-get install apt-transport-https ca-certificates curl software-properties-common nano -y

curl -fsSL https://download.docker.com/linux/ubuntu/gpg | sudo apt-key add -

sudo apt-key fingerprint 0EBFCD88

sudo add-apt-repository \
   "deb [arch=amd64] https://download.docker.com/linux/ubuntu \
   $(lsb_release -cs) \
   stable"

sudo add-apt-repository \
"deb [arch=amd64] https://download.docker.com/linux/ubuntu xenial stable" -y

sudo apt-get update -y
apt-cache search docker-ce
sudo apt-get install docker-ce -y

sudo groupadd docker #Create the docker group.
sudo usermod -aG docker $USER #Add your user to the docker group.
groups $USER
sudo systemctl enable docker #sudo systemctl disable docker

gsutil cp gs://nexify-test-bucket/com.inova8.docker.zip .

docker stop nexify
docker rm nexify
#docker images | grep nexify
#docker images | grep nexify | awk -v x=3 '{print $x}'
docker image rm `docker images | grep nexify | awk -v x=3 '{print $x}'`
sudo docker build -t nexify/nexify-core:v1 .
docker run --name nexify -d -p 8080:8080 nexify/nexify-core:v1
docker logs -f nexify

rm Dockerfile
nano Dockerfile

sudo docker build -t nexify/nexify-core:v1 .
docker run --name nexify -d -p 8080:8080 nexify/nexify-core:v1
docker logs nexify

docker exec -it nexify bash

-----
TEMP_PATH=$(echo `/opt/hbase/bin/hbase classpath`)
export CLASSPATH="$CLASSPATH:$CATALINA_HOME/lib/servlet-api.jar:$TEMP_PATH"
echo $CLASSPATH


curl -L https://github.com/peterjohnlawrence/com.inova8.docker/raw/master/lens2northwind/com.inova8.lens.framework.v4.war -o com.inova8.lens.framework.v4.war
curl -L https://github.com/peterjohnlawrence/com.inova8.docker/raw/master/lens2northwind/odata2sparql.v4.war  -o odata2sparql.v4.war

---

ENV without setenv.sh
---------------------
echo $CATALINA_BASE

echo $CATALINA_HOME
/usr/local/tomcat
echo $CATALINA_TMPDIR

echo $JRE_HOME

echo $JAVA_HOME
/usr
echo $CLASSPATH
::/opt/hbase/lib/hbase-server-1.1.2.jar
echo $TOMCAT_HOME
/usr/local/tomcat

ENV with setenv.sh
---------------------
echo $CATALINA_BASE

echo $CATALINA_HOME
/usr/local/tomcat
echo $CATALINA_TMPDIR

echo $JRE_HOME

echo $JAVA_HOME
/usr
echo $CLASSPATH
::/opt/hbase/lib/hbase-server-1.1.2.jar
echo $TOMCAT_HOME
/usr/local/tomcat


----

Copy Northwind
Copy NHS (rename to NHSModel)
Update models.ttl to refer to NHSModel and localhost

docker conatiners to build
---------------------------
nexify/stable
nexify/latestbuild
