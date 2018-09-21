import os

# at minimum increase ram by 1024
ram_overhead=int(os.getenv('ram_overhead', 1024))
multipler_for_multiple_pods=int(os.getenv('multipler_for_multiple_pods', 1))
cluster_node_ram=int(os.getenv('tomcat_ram', 4096))
cluster_node_ram+= (cluster_node_ram + ram_overhead) * multipler_for_multiple_pods
cluster_node_ram
return cluster_node_ram
