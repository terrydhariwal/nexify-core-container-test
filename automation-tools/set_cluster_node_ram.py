import os


# using get will return `None` if a key is not present rather than raise a `KeyError`
#print(os.environ.get('tomcat_ram'))

# os.getenv is equivalent, and can also give a default value instead of `None`
# default_value=4096
# print(os.getenv('tomcat_ram', default_value))

# at minimum give cluster node 20% overhead over tomcat ram
percent_to_raise=int(os.getenv('percent_to_raise', 20))
cluster_node_ram=int(os.getenv('tomcat_ram', 4096))
cluster_node_ram+= cluster_node_ram / 100 * 20
print cluster_node_ram
