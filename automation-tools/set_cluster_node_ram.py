import os

# at minimum increase ram by 1024
ram_overhead=int(os.getenv('RAM_OVERHEAD', 1024))
multipler_for_multiple_pods=int(os.getenv('MULTIPLER_FOR_MULTIPLE_PODS', 1))
cluster_node_ram=int(os.getenv('TOMCAT_RAM', 4096))
cluster_node_ram+= (cluster_node_ram + ram_overhead) * multipler_for_multiple_pods
cluster_node_ram
print cluster_node_ram
