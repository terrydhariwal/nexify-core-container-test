export PROJECT_ID=quorum-360-187413
export COMPUTE_ZONE=europe-west1-c

gcloud config set project ${PROJECT_ID};
gcloud config set compute/zone ${COMPUTE_ZONE};

export cluster_names=`gcloud container clusters list --zone=${COMPUTE_ZONE} --format=json | jq -r ".[].name"`
echo $cluster_names

if [[ $cluster_names = *"$K8_CLUSTER_NAME"* ]]; then
   echo "Cluster $K8_CLUSTER_NAME already exists!"
else
  gcloud beta container --project "quorum-360-187413" clusters create "${K8_CLUSTER_NAME}" --zone "${COMPUTE_ZONE}" --username "admin" --cluster-version "1.9.7-gke.6" --machine-type "n1-standard-1" --image-type "COS" --disk-type "pd-standard" --disk-size "100" --scopes "https://www.googleapis.com/auth/compute","https://www.googleapis.com/auth/devstorage.read_only","https://www.googleapis.com/auth/logging.write","https://www.googleapis.com/auth/monitoring","https://www.googleapis.com/auth/servicecontrol","https://www.googleapis.com/auth/service.management.readonly","https://www.googleapis.com/auth/trace.append" --num-nodes "1" --enable-cloud-logging --enable-cloud-monitoring --network "projects/quorum-360-187413/global/networks/hortonworks-network" --addons HorizontalPodAutoscaling,HttpLoadBalancing,KubernetesDashboard --no-enable-autoupgrade --enable-autorepair
fi

gcloud container clusters get-credentials ${K8_CLUSTER_NAME} --zone "${COMPUTE_ZONE}"
export deployment_app=quorum360
deployment_name=${deployment_app}

export current_deployments=`kubectl get deployments -o=json`
echo $current_deployments | jq -r ".items[].metadata.name"
current_deployments=`echo $current_deployments | jq -r ".items[].metadata.name"`
echo $current_deployments

if [[ $current_deployments = *"$deployment_name"* ]]; then
   echo "Deployment ${deployment_name} already exists!"
else
  kubectl run ${deployment_name} --image gcr.io/${PROJECT_ID}/quorum360:halyard-v1.5-4gb-ram --port 8080
fi

# check if its running as expected
kubectl get po -a

export current_services=`kubectl get service -o=json`
echo $current_services | jq -r ".items[].metadata.name"
current_services=`echo $current_services | jq -r ".items[].metadata.name"`
echo $current_services

if [[ $current_services = *"$deployment_name"* ]]; then
   echo "Service ${deployment_name} already exists!"
else
  kubectl expose deployment ${deployment_name} --type LoadBalancer  --port 8080 --target-port 8080
fi

# get IP address of service load balancer for FW rule
#kubectl describe service quorum360
get_service_ip=1
while [ "${get_service_ip}" -ne 0 ]
do
  SERVICE_LOAD_BALANCER=`kubectl get service ${deployment_name} -o=json` #set as variable
  #echo ${SERVICE_LOAD_BALANCER} | jq
  #NEED TO HANDLE ARRAY IF IPs here
  SERVICE_LOAD_BALANCER=`echo ${SERVICE_LOAD_BALANCER} | jq -r ".status.loadBalancer.ingress[0].ip"`
  echo ${SERVICE_LOAD_BALANCER}
  if [ $SERVICE_LOAD_BALANCER != "null" ] && [ -n $SERVICE_LOAD_BALANCER ]; then
    get_service_ip=0;
    echo "found_ip";
  else
   echo "ip is null";
  fi
  sleep 3
done
echo ${SERVICE_LOAD_BALANCER}

FIREWALL_RULE_NAME=hortonworks-network-ambari-access
FIREWALL_CONFIG=`gcloud compute firewall-rules describe ${FIREWALL_RULE_NAME} --format=json`
echo ${FIREWALL_CONFIG} | jq
NEW_FW_RULE=$(echo ${FIREWALL_CONFIG} | jq --arg SERVICE_LOAD_BALANCER "$SERVICE_LOAD_BALANCER" '.sourceRanges += [$SERVICE_LOAD_BALANCER]' )
echo ${NEW_FW_RULE}
NEW_SOURCE_RANGE=`echo ${NEW_FW_RULE} | jq -r ".sourceRanges"`
echo ${NEW_SOURCE_RANGE}

NEW_SOURCE_RANGE=`echo $NEW_SOURCE_RANGE | sed -re 's/\/32/"/g'`
NEW_SOURCE_RANGE=`echo $NEW_SOURCE_RANGE | sed -re 's/([0-9])"/\1\/32"/g'`
NEW_SOURCE_RANGE=`echo $NEW_SOURCE_RANGE | sed -re 's/ //g'`
NEW_SOURCE_RANGE=`echo $NEW_SOURCE_RANGE | sed -e 's/"//g'`
NEW_SOURCE_RANGE=`echo $NEW_SOURCE_RANGE | sed -e 's/\[//g'`
NEW_SOURCE_RANGE=`echo $NEW_SOURCE_RANGE | sed -e 's/\]//g'`
NEW_SOURCE_RANGE=`echo $NEW_SOURCE_RANGE | sed -e 's/\]//g'`
gcloud compute firewall-rules update hortonworks-network-ambari-access --source-ranges="${NEW_SOURCE_RANGE}"

# Now you can access rdf4j-workbench
# however the container can't access HBase (since the LB is for ingress traffic only)
# get container IP address for Hbase access

# Get POD IP
POD_IP=`kubectl describe pod quorum360 | grep IP` #set as variable
echo ${POD_IP}
POD_IP=`echo $POD_IP | sed -re 's/ //g'`
POD_IP=`echo $POD_IP | sed -re 's/IP://g'`
echo ${POD_IP}

FIREWALL_RULE_NAME=hortonworks-network-ambari-access
FIREWALL_CONFIG=`gcloud compute firewall-rules describe ${FIREWALL_RULE_NAME} --format=json`
echo ${FIREWALL_CONFIG} | jq
NEW_FW_RULE=$(echo ${FIREWALL_CONFIG} | jq --arg POD_IP "$POD_IP" '.sourceRanges += [$POD_IP]' )
echo ${NEW_FW_RULE}
NEW_SOURCE_RANGE=`echo ${NEW_FW_RULE} | jq -r ".sourceRanges"`
echo ${NEW_SOURCE_RANGE}

NEW_SOURCE_RANGE=`echo $NEW_SOURCE_RANGE | sed -re 's/\/32/"/g'`
NEW_SOURCE_RANGE=`echo $NEW_SOURCE_RANGE | sed -re 's/([0-9])"/\1\/32"/g'`
NEW_SOURCE_RANGE=`echo $NEW_SOURCE_RANGE | sed -re 's/ //g'`
NEW_SOURCE_RANGE=`echo $NEW_SOURCE_RANGE | sed -e 's/"//g'`
NEW_SOURCE_RANGE=`echo $NEW_SOURCE_RANGE | sed -e 's/\[//g'`
NEW_SOURCE_RANGE=`echo $NEW_SOURCE_RANGE | sed -e 's/\]//g'`
NEW_SOURCE_RANGE=`echo $NEW_SOURCE_RANGE | sed -e 's/\]//g'`
gcloud compute firewall-rules update hortonworks-network-ambari-access --source-ranges="${NEW_SOURCE_RANGE}"

# Now you can access rdf4j-workbench and HBase
