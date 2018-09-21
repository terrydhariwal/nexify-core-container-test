# DEPLOYMENT_NAME needs to be passed in - need to be careful to NOT make this a env variable - do avoid deleting by accident
DEPLOYMENT_NAME=quorum360-4096

gcloud container clusters get-credentials ${CLUSTER_NAME} --zone "${COMPUTE_ZONE}"

# get IP address of service load balancer
#SERVICE_LOAD_BALANCER=`kubectl get service ${deployment_name} -o=json` #set as variable
SERVICE_LOAD_BALANCER=`kubectl get service -o=json` #get all load balacners
#echo ${SERVICE_LOAD_BALANCER} | jq
#NEED TO HANDLE ARRAY OF IPs here
# from the various list of load balancers, find the one matchuing our deployment_name, and get its IP
SERVICE_LOAD_BALANCER=`echo ${SERVICE_LOAD_BALANCER} | jq --arg deployment_name "$DEPLOYMENT_NAME" '.items[]  | select(.metadata.name == $deployment_name)| .status.loadBalancer.ingress[].ip'`
#echo ${SERVICE_LOAD_BALANCER}

#Strip off ""
SERVICE_LOAD_BALANCER=`echo $SERVICE_LOAD_BALANCER | sed -e 's/"//g'`
#echo ${SERVICE_LOAD_BALANCER}

CONTAINER_PORT=8080

# TEST TOMCAT HOMEPAGE
echo http://${SERVICE_LOAD_BALANCER}:${CONTAINER_PORT}

# TEST TOMCAT Manager App (admin/tomcat)
echo http://${SERVICE_LOAD_BALANCER}:${CONTAINER_PORT}/manager/html

# TEST odata2sparql
echo http://${SERVICE_LOAD_BALANCER}:${CONTAINER_PORT}/odata2sparql/
echo http://${SERVICE_LOAD_BALANCER}:${CONTAINER_PORT}/odata2sparql/northwind/$metadata
echo http://${SERVICE_LOAD_BALANCER}:${CONTAINER_PORT}/odata2sparql/NHS/$metadata

# TEST lens2odata
echo http://${SERVICE_LOAD_BALANCER}:${CONTAINER_PORT}/lens2odata/?apartment=northwind
echo http://${SERVICE_LOAD_BALANCER}:${CONTAINER_PORT}/lens2odata/?apartment=NHS
