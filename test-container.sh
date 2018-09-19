export PROJECT_ID=quorum-360-187413
export COMPUTE_ZONE=europe-west1-b

gcloud config set project ${PROJECT_ID};
gcloud config set compute/zone ${COMPUTE_ZONE};

export K8_CLUSTER_NAME=test-cluster-2
gcloud container clusters get-credentials ${K8_CLUSTER_NAME} --zone "${COMPUTE_ZONE}"

# get IP address of service load balancer
SERVICE_LOAD_BALANCER=`kubectl get service ${deployment_name} -o=json` #set as variable
echo ${SERVICE_LOAD_BALANCER} | jq
#NEED TO HANDLE ARRAY IF IPs here
SERVICE_LOAD_BALANCER=`echo ${SERVICE_LOAD_BALANCER} | jq -r ".status.loadBalancer.ingress[0].ip"`
echo ${SERVICE_LOAD_BALANCER}

echo ${SERVICE_LOAD_BALANCER}
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
