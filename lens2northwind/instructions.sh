
# CREATE DOCKER HOST
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
# END OF CREATE DOCKER HOST

#gsutil cp gs://nexify-test-bucket/com.inova8.docker.zip .

------------------------------------------------------------------------------------------
# CREATE AND RUN NEXIFY-CORE IMAGE USING DOCKER
# cd to directory containing the Dockerfile
docker stop nexify
docker rm nexify
#docker images | grep nexify
#docker images | grep nexify | awk -v x=3 '{print $x}'
docker image rm `docker images | grep nexify | awk -v x=3 '{print $x}'`
sudo docker build -t nexify/nexify-core:v1 .
docker run --name nexify -d -p 8080:8080 nexify/nexify-core:v1
docker logs -f nexify
# END OF CREATE AND RUN NEXIFY-CORE IMAGE USING DOCKER

# ssh to docker image
docker exec -it nexify bash

------------------------------------------------------------------------------------------
# commands to get latest WAR - need to be built from source
curl -L https://github.com/peterjohnlawrence/com.inova8.docker/raw/master/lens2northwind/com.inova8.lens.framework.v4.war -o com.inova8.lens.framework.v4.war
curl -L https://github.com/peterjohnlawrence/com.inova8.docker/raw/master/lens2northwind/odata2sparql.v4.war  -o odata2sparql.v4.war
------------------------------------------------------------------------------------------

# Completed task
Copy Northwind
Copy NHS (rename to NHSModel)
Update models.ttl to refer to NHSModel and localhost

docker containers to build
---------------------------
nexify/stable
nexify/latestbuild


Update Hadoop Master node with LATEST BUILD of Halyard SDK
----------------------------------------------------------
sudo su
export HALYARD_VERSION=2.0-SNAPSHOT
mkdir -p /opt/halyard-sdk-$HALYARD_VERSION
cd /opt/halyard-sdk-$HALYARD_VERSION
wget -t 10 --max-redirect 1 --retry-connrefused https://github.com/Merck/Halyard/releases/download/nightly_build_20180905/halyard-sdk-$HALYARD_VERSION.zip
unzip halyard-sdk-$HALYARD_VERSION.zip
rm -f halyard-sdk-$HALYARD_VERSION.zip
cd /opt
rm -f /opt/halyard
ln -s /opt/halyard-sdk-$HALYARD_VERSION /opt/halyard
ls -la

Update Hadoop Master node with STABLE BUILD of Halyard SDK
----------------------------------------------------------
sudo su
export HALYARD_VERSION=2.0
mkdir -p /opt/halyard-sdk-$HALYARD_VERSION
cd /opt/halyard-sdk-$HALYARD_VERSION
wget -t 10 --max-redirect 1 --retry-connrefused https://github.com/Merck/Halyard/releases/download/r$HALYARD_VERSION/halyard-sdk-$HALYARD_VERSION.zip
unzip halyard-sdk-$HALYARD_VERSION.zip
rm -f halyard-sdk-$HALYARD_VERSION.zip
cd /opt
rm -f /opt/halyard
ln -s /opt/halyard-sdk-$HALYARD_VERSION /opt/halyard
ls -la
