export CONTAINER_BASE_NAME=quorum360
export TOMCAT_VERSION=9.0.12
export JAVA_VERSION=1.8.0_181
export TOMCAT_RAM=4096
export RAM_OVERHEAD=1024
export HALYARD_VERSION=1.5
export HBASE_VERSION=1.1.2
export IMAGE_NAME=${CONTAINER_BASE_NAME}-java-${JAVA_VERSION}-tomcat-${TOMCAT_VERSION}-${TOMCAT_SIZE}-hbase-${HBASE_VERSION}-halyard-${HALYARD_VERSION}
python ./set_cluster_node_spec.py | while read line ; do
    line=`echo $line | sed -re 's/ //g'`
    echo $line
    eval $line
done
echo "CLUSTER_NODE_RAM = $CLUSTER_NODE_RAM"
echo "CLUSTER_NODE_CPUS = $CLUSTER_NODE_CPUS"
export MACHINE_TYPE=custom-${CLUSTER_NODE_CPUS}-${CLUSTER_NODE_RAM}
export CLUSTER_NAME=quorum360
export CLUSTER_NUM_NODES=1
export CLUSTER_NAME=quorum360-${CLUSTER_NODE_CPUS}-cores-${CLUSTER_NODE_RAM}-mb
