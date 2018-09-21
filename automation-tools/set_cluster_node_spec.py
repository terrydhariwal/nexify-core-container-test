import os

ram_overhead = int(os.getenv('RAM_OVERHEAD', 1024))
multipler_for_multiple_pods = int(os.getenv('MULTIPLER_FOR_MULTIPLE_PODS', 1))
cluster_node_ram= int(os.getenv('TOMCAT_RAM', 4096))
cluster_node_ram = (cluster_node_ram + ram_overhead) * multipler_for_multiple_pods
# not possible to change the environment variables of parent processes!
# os.environ['CLUSTER_NODE_RAM'] = str(cluster_node_ram)
# os.putenv('CLUSTER_NODE_RAM', str(cluster_node_ram))
print "CLUSTER_NODE_RAM=",cluster_node_ram

if cluster_node_ram % 1024:
    number_of_cores = (cluster_node_ram / 1024)
    print "number_of_cores=",number_of_cores
else:
    number_of_cores = (cluster_node_ram / 1024) + 1
    print "number_of_cores=",number_of_cores
# not possible to change the environment variables of parent processes!
# os.environ['CLUSTER_NODE_CPUS'] = str(number_of_cores)
# os.putenv('CLUSTER_NODE_CPUS', str(number_of_cores))
print "CLUSTER_NODE_CPUS=",number_of_cores
