#!/bin/sh

# TODO - print env variables set in 01-set-environment-variables.#!/bin/sh
# and prompt user if they are sure deletion is ok
# use --quiet to force deletion w/o prompt

gcloud container clusters get-credentials ${CLUSTER_NAME} --zone "${COMPUTE_ZONE}"

# TODO - DEPLOYMENT_NAME needs to be passed in - need to be careful to NOT make this a env variable - do avoid deleting by accident
DEPLOYMENT_NAME=${APPLICATION_DEPLOYMENT_NAME}

# Delete service
kubectl delete service ${DEPLOYMENT_NAME}

# TODO
# get namespace for deployment
#kubectl get rs --all-namespaces
#HARD CODED FOR NOW
DEPLOYMENT_NAMESPACE=default
kubectl delete deployment ${DEPLOYMENT_NAME} --namespace=${DEPLOYMENT_NAMESPACE}
#kubectl get pods

#clean up firewall rules
# internal IP ------------------------------------------------------------------------------------------------------
POD_IP=`kubectl describe pod ${DEPLOYMENT_NAME} | grep IP` #set as variable
#echo ${POD_IP}
POD_IP=`echo $POD_IP | sed -re 's/ //g'`
POD_IP=`echo $POD_IP | sed -re 's/IP://g'`
#echo ${POD_IP}

FIREWALL_CONFIG=`gcloud compute firewall-rules describe ${FIREWALL_RULE_NAME} --format=json`
#echo ${FIREWALL_CONFIG} | jq
NEW_FW_RULE=$(echo ${FIREWALL_CONFIG} | jq --arg POD_IP "$POD_IP/32" '.sourceRanges -= [$POD_IP]' )
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
gcloud compute firewall-rules update ${FIREWALL_RULE_NAME} --source-ranges="${NEW_SOURCE_RANGE}"

# internal IP ------------------------------------------------------------------------------------------------------

# load balancer IP ------------------------------------------------------------------------------------------------------
#SERVICE_LOAD_BALANCER=`kubectl get service ${deployment_name} -o=json` #set as variable
SERVICE_LOAD_BALANCER=`kubectl get service -o=json` #set as variable
#echo ${SERVICE_LOAD_BALANCER} | jq
SERVICE_LOAD_BALANCER=`echo ${SERVICE_LOAD_BALANCER} | jq -r ".status.loadBalancer.ingress[0].ip"`
#echo ${SERVICE_LOAD_BALANCER}

FIREWALL_CONFIG=`gcloud compute firewall-rules describe ${FIREWALL_RULE_NAME} --format=json`
#echo ${FIREWALL_CONFIG} | jq
NEW_FW_RULE=$(echo ${FIREWALL_CONFIG} | jq --arg SERVICE_LOAD_BALANCER "$SERVICE_LOAD_BALANCER/32" '.sourceRanges -= [$SERVICE_LOAD_BALANCER]' )
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
gcloud compute firewall-rules update ${FIREWALL_RULE_NAME} --source-ranges="${NEW_SOURCE_RANGE}"
# load balancer IP ------------------------------------------------------------------------------------------------------
