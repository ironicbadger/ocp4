## Node IPs
loadbalancer_ip = "192.168.5.160"
coredns_ip = "192.168.5.169"
bootstrap_ip = "192.168.5.168"
master_ips = ["192.168.5.161", "192.168.5.162", "192.168.5.163"]
#worker_ips = ["192.168.5.164", "192.168.5.165"]
worker_ips = ["192.168.5.164", "192.168.5.165", "192.168.5.166"]

## Cluster configuration
vmware_folder = "redhat/openshift"
rhcos_template = "rhcos-4.7.7"
cluster_slug = "ocp47"
cluster_domain = "openshift.lab.int"
machine_cidr = "192.168.5.0/20"
netmask ="255.255.240.0"

## DNS
local_dns = "192.168.5.169" # probably the same as coredns_ip
public_dns = "192.168.1.254" # e.g. 1.1.1.1
gateway = "192.168.1.254"

## Ignition paths
## Expects `openshift-install create ignition-configs` to have been run
## probably via generate-configs.sh
bootstrap_ignition_path = "../../openshift/bootstrap.ign"
master_ignition_path = "../../openshift/master.ign"
worker_ignition_path = "../../openshift/worker.ign"