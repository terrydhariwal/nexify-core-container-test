#!/bin/sh

#GCP SETTINGS
export PROJECT_ID=quorum-360-187413
export COMPUTE_ZONE=europe-west1-b
export NETWORK=hortonworks-network
export FIREWALL_RULE_NAME=hortonworks-network-ambari-access
export CONTAINER_REGISTRY=gcr.io

#CUSTOMER AND APPLICATION SETTINGS
export CUSTOMER_NAME=nexify
export APPLICATION_NAME=quorum360

#DOCKER CONTAINER SETTINGS
export CONTAINER_BASE_NAME=quorum360
export JAVA_VERSION=1.8.0_181
export TOMCAT_VERSION=9.0.12
export TOMCAT_RAM=4096
export HBASE_VERSION=1.1.2
export HALYARD_VERSION=1.5

usage()
{
    #TODO
    echo "to implement"
    #echo "usage: source ./01-set-environment-variables.sh [[[-f PROJECT_ID ] [-i]] | [-h]]"
}

# Set defualt values
export PROJECT_ID=quorum-360-187413
export COMPUTE_ZONE=europe-west1-b
export NETWORK=hortonworks-network
export FIREWALL_RULE_NAME=hortonworks-network-ambari-access
export CONTAINER_REGISTRY=gcr.io
export CUSTOMER_NAME=nexify
export APPLICATION_NAME=quorum360
export JAVA_VERSION=1.8.0_181
export TOMCAT_VERSION=9.0.12
export TOMCAT_RAM=4096
export HBASE_VERSION=1.1.2
export HALYARD_VERSION=1.5

#OVERRIDE ANY VALUES HERE
while [ "$1" != "" ]; do
    case $1 in
        --project-id )             shift
                                   export PROJECT_ID=$1
                                   ;;
        --compute-zone )           shift
                                   export COMPUTE_ZONE=$1
                                   ;;
        --network )                shift
                                   export NETWORK=$1
                                   ;;
        --firewall-rule-name )     shift
                                   export FIREWALL_RULE_NAME=$1
                                   ;;
        --container-registry )     shift
                                   export CONTAINER_REGISTRY=$1
                                   ;;
        --customer-name )          shift
                                   export CUSTOMER_NAME=$1
                                   ;;
        --application-name )       shift
                                   export APPLICATION_NAME=$1
                                   ;;
        --java-version )           shift
                                   export JAVA_VERSION=$1
                                   ;;
        --tomcat-version )         shift
                                   export TOMCAT_VERSION=$1
                                   ;;
        --tomcat-ram )             shift
                                   export TOMCAT_RAM=$1
                                   ;;
        --hbase-version )          shift
                                   export HBASE_VERSION=$1
                                   ;;
        --halyard-version )        shift
                                   export HALYARD_VERSION=$1
                                   ;;
        -h | --help )              usage
                                   #exit
                                   ;;
        * )                        usage
                                   #exit 1
    esac
    shift
done

# echo "PROJECT_ID=${PROJECT_ID}"
# echo "COMPUTE_ZONE=${COMPUTE_ZONE}"
# echo "NETWORK=${NETWORK}"
# echo "FIREWALL_RULE_NAME=${FIREWALL_RULE_NAME}"
# echo "CONTAINER_REGISTRY=${CONTAINER_REGISTRY}"
# echo "CUSTOMER_NAME=${CUSTOMER_NAME}"
# echo "APPLICATION_NAME=${APPLICATION_NAME}"
# echo "JAVA_VERSION=${JAVA_VERSION}"
# echo "TOMCAT_VERSION=${TOMCAT_VERSION}"
# echo "TOMCAT_RAM=${TOMCAT_RAM}"
# echo "HBASE_VERSION=${HBASE_VERSION}"
# echo "HALYARD_VERSION=${HALYARD_VERSION}"

#IMAGE SETTINGS
export IMAGE_NAME=quorum360
export APPLICATION_DEPLOYMENT_NAME=${IMAGE_NAME}-${TOMCAT_RAM} # the deployment name will be generic across customers
export IMAGE_TAG=${CONTAINER_BASE_NAME}-java-${JAVA_VERSION}-tomcat-${TOMCAT_VERSION}-${TOMCAT_RAM}-hbase-${HBASE_VERSION}-halyard-${HALYARD_VERSION} # THE image tag will be generic across customers

# CLUSTER SETTINGS
export RAM_OVERHEAD=1024
while read line ; do
    line=`echo $line | sed -re 's/ //g'`
    line="export $line"
    eval $line
#the following script sets CLUSTER_NODE_CPUS & CLUSTER_NODE_RAM
done < <(python ./set_cluster_node_spec.py) #process subsitution https://stackoverflow.com/questions/4667509/shell-variables-set-inside-while-loop-not-visible-outside-of-it

export MACHINE_TYPE=custom-${CLUSTER_NODE_CPUS}-${CLUSTER_NODE_RAM}
export CLUSTER_NUM_NODES=1
export CLUSTER_NAME=${APPLICATION_NAME}-${CUSTOMER_NAME}-${CLUSTER_NODE_CPUS}-cores-${CLUSTER_NODE_RAM}-mb
