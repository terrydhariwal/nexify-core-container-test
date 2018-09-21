import os

ram_overhead = int(os.getenv('RAM_OVERHEAD', 1024))
multipler_for_multiple_pods = int(os.getenv('MULTIPLER_FOR_MULTIPLE_PODS', 1))
cluster_node_ram= int(os.getenv('TOMCAT_RAM', 4096))
cluster_node_ram = (cluster_node_ram + ram_overhead) * multipler_for_multiple_pods
os.environ['CLUSTER_NODE_RAM'] = string(cluster_node_ram)
number_of_cores = cluster_node_ram / 1024
print "number_of_cores = ",number_of_cores
os.environ['CLUSTER_NODE_CPUS'] = string(number_of_cores)
