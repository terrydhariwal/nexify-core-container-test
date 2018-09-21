gcloud container clusters get-credentials ${CLUSTER_NAME} --zone "${COMPUTE_ZONE}"
export DEPLOYMENT_APP=quorum360
export DEPLOYMENT_NAME=${DEPLOYMENT_APP}

export CURRENT_DEPLOYMENTS=`kubectl get deployments -o=json`
#echo $CURRENT_DEPLOYMENTS | jq -r ".items[].metadata.name"
CURRENT_DEPLOYMENTS=`echo $current_deployments | jq -r ".items[].metadata.name"`
#echo "CURRENT_DEPLOYMENTS = $CURRENT_DEPLOYMENTS"

if [[ $CURRENT_DEPLOYMENTS = *"$DEPLOYMENT_NAME"* ]]; then
   echo "Deployment ${DEPLOYMENT_NAME} already exists!"
else
  # Pass in image to use with a default
  kubectl run ${DEPLOYMENT_NAME} --image gcr.io/${PROJECT_ID}/quorum360:${IMAGE_NAME} --port 8080
fi

# check if its running as expected
kubectl get po -a

export CURRENT_SERVICES=`kubectl get service -o=json`
#echo $CURRENT_SERVICES | jq -r ".items[].metadata.name"
CURRENT_SERVICES=`echo $CURRENT_SERVICES | jq -r ".items[].metadata.name"`
#echo "CURRENT_SERVICES = $CURRENT_SERVICES"

if [[ $CURRENT_SERVICES = *"$DEPLOYMENT_NAME"* ]]; then
   echo "Service ${DEPLOYMENT_NAME} already exists!"
else
  kubectl expose deployment ${DEPLOYMENT_NAME} --type LoadBalancer  --port 8080 --target-port 8080
fi

# get IP address of service load balancer for FW rule
#kubectl describe service quorum360
GET_SERVICE_IP=1
while [ "${GET_SERVICE_IP}" -ne 0 ]
do
  SERVICE_LOAD_BALANCER=`kubectl get service ${DEPLOYMENT_NAME} -o=json` #set as variable
  #echo ${SERVICE_LOAD_BALANCER} | jq
  #NEED TO HANDLE ARRAY IF IPs here
  SERVICE_LOAD_BALANCER=`echo ${SERVICE_LOAD_BALANCER} | jq -r ".status.loadBalancer.ingress[0].ip"`
  #echo ${SERVICE_LOAD_BALANCER}
  if [ $SERVICE_LOAD_BALANCER != "null" ] && [ -n $SERVICE_LOAD_BALANCER ]; then
    GET_SERVICE_IP=0;
    echo "found_ip";
  #else
  # echo "ip is null";
  fi
  sleep 3
done
echo ${SERVICE_LOAD_BALANCER}

FIREWALL_RULE_NAME=hortonworks-network-ambari-access
FIREWALL_CONFIG=`gcloud compute firewall-rules describe ${FIREWALL_RULE_NAME} --format=json`
#echo ${FIREWALL_CONFIG} | jq
NEW_FW_RULE=$(echo ${FIREWALL_CONFIG} | jq --arg SERVICE_LOAD_BALANCER "$SERVICE_LOAD_BALANCER" '.sourceRanges += [$SERVICE_LOAD_BALANCER]' )
#echo ${NEW_FW_RULE}
NEW_SOURCE_RANGE=`echo ${NEW_FW_RULE} | jq -r ".sourceRanges"`
#echo ${NEW_SOURCE_RANGE}

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
#echo ${POD_IP}
POD_IP=`echo $POD_IP | sed -re 's/ //g'`
POD_IP=`echo $POD_IP | sed -re 's/IP://g'`
echo "POD_ID = ${POD_IP}"

FIREWALL_RULE_NAME=hortonworks-network-ambari-access
FIREWALL_CONFIG=`gcloud compute firewall-rules describe ${FIREWALL_RULE_NAME} --format=json`
#echo ${FIREWALL_CONFIG} | jq
NEW_FW_RULE=$(echo ${FIREWALL_CONFIG} | jq --arg POD_IP "$POD_IP" '.sourceRanges += [$POD_IP]' )
#echo ${NEW_FW_RULE}
NEW_SOURCE_RANGE=`echo ${NEW_FW_RULE} | jq -r ".sourceRanges"`
#echo ${NEW_SOURCE_RANGE}

NEW_SOURCE_RANGE=`echo $NEW_SOURCE_RANGE | sed -re 's/\/32/"/g'`
NEW_SOURCE_RANGE=`echo $NEW_SOURCE_RANGE | sed -re 's/([0-9])"/\1\/32"/g'`
NEW_SOURCE_RANGE=`echo $NEW_SOURCE_RANGE | sed -re 's/ //g'`
NEW_SOURCE_RANGE=`echo $NEW_SOURCE_RANGE | sed -e 's/"//g'`
NEW_SOURCE_RANGE=`echo $NEW_SOURCE_RANGE | sed -e 's/\[//g'`
NEW_SOURCE_RANGE=`echo $NEW_SOURCE_RANGE | sed -e 's/\]//g'`
NEW_SOURCE_RANGE=`echo $NEW_SOURCE_RANGE | sed -e 's/\]//g'`
gcloud compute firewall-rules update hortonworks-network-ambari-access --source-ranges="${NEW_SOURCE_RANGE}"

# Now you can access rdf4j-workbench and HBase

#CURRENT_DIR=`pwd`
#source $CURRENT_DIR/test-lite-container.sh
