export PROJECT_ID=quorum-360-187413
export COMPUTE_ZONE=europe-west1-b

gcloud config set project ${PROJECT_ID};
gcloud config set compute/zone ${COMPUTE_ZONE};

export K8_CLUSTER_NAME=test-cluster-2
gcloud container clusters get-credentials ${K8_CLUSTER_NAME} --zone "${COMPUTE_ZONE}"

POD_IP=`kubectl describe pod ${deployment_name} | grep IP` #set as variable
echo ${POD_IP}
POD_IP=`echo $POD_IP | sed -re 's/ //g'`
POD_IP=`echo $POD_IP | sed -re 's/IP://g'`
echo ${POD_IP}

FIREWALL_RULE_NAME=hortonworks-network-ambari-access
FIREWALL_CONFIG=`gcloud compute firewall-rules describe ${FIREWALL_RULE_NAME} --format=json`
echo ${FIREWALL_CONFIG} | jq
NEW_FW_RULE=$(echo ${FIREWALL_CONFIG} | jq --arg POD_IP "$POD_IP/32" '.sourceRanges -= [$POD_IP]' )
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

#SERVICE_LOAD_BALANCER=`kubectl get service ${deployment_name} -o=json` #set as variable
SERVICE_LOAD_BALANCER=`kubectl get service -o=json` #set as variable
echo ${SERVICE_LOAD_BALANCER} | jq
SERVICE_LOAD_BALANCER=`echo ${SERVICE_LOAD_BALANCER} | jq -r ".status.loadBalancer.ingress[0].ip"`
echo ${SERVICE_LOAD_BALANCER}

FIREWALL_RULE_NAME=hortonworks-network-ambari-access
FIREWALL_CONFIG=`gcloud compute firewall-rules describe ${FIREWALL_RULE_NAME} --format=json`
echo ${FIREWALL_CONFIG} | jq
NEW_FW_RULE=$(echo ${FIREWALL_CONFIG} | jq --arg SERVICE_LOAD_BALANCER "$SERVICE_LOAD_BALANCER/32" '.sourceRanges -= [$SERVICE_LOAD_BALANCER]' )
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

# To avoid incurring charges
#   1. Delete the application's Service by running kubectl delete:
kubectl delete service ${deployment_name}

#   2. Delete your cluster by running gcloud container clusters delete:
gcloud container clusters delete ${K8_CLUSTER_NAME} --zone=${COMPUTE_ZONE} --async --quiet
