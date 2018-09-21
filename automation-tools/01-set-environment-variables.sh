export PROJECT_ID=quorum-360-187413
export COMPUTE_ZONE=europe-west1-b
export CONTAINER_BASE_NAME=quorum360
export TOMCAT_VERSION=9.0.12
export JAVA_VERSION=1.8.0_181
export TOMCAT_RAM=4096
export RAM_OVERHEAD=1024
export HALYARD_VERSION=1.5
export HBASE_VERSION=1.1.2
export IMAGE_NAME=quorum360
export NETWORK=hortonworks-network
export FIREWALL_RULE_NAME=hortonworks-network-ambari-access
export CONTAINER_REGISTRY=gcr.io
export IMAGE_TAG=${CONTAINER_BASE_NAME}-java-${JAVA_VERSION}-tomcat-${TOMCAT_VERSION}-${TOMCAT_RAM}-hbase-${HBASE_VERSION}-halyard-${HALYARD_VERSION}

while read line ; do
    line=`echo $line | sed -re 's/ //g'`
    line="export $line"
    eval $line
done < <(python ./set_cluster_node_spec.py) #process subsitution https://stackoverflow.com/questions/4667509/shell-variables-set-inside-while-loop-not-visible-outside-of-it

export MACHINE_TYPE=custom-${CLUSTER_NODE_CPUS}-${CLUSTER_NODE_RAM}
export CLUSTER_NAME=quorum360
export CLUSTER_NUM_NODES=1
export CLUSTER_NAME=quorum360-${CLUSTER_NODE_CPUS}-cores-${CLUSTER_NODE_RAM}-mb
