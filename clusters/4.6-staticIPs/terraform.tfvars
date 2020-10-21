## Node IPs
loadbalancer_ip = "192.168.5.160"
coredns_ip = "192.168.5.169"
bootstrap_ip = "192.168.5.168"
master_ips = ["192.168.5.161", "192.168.5.162", "192.168.5.163"]
worker_ips = ["192.168.5.164", "192.168.5.165"]
#worker_ips = ["192.168.5.164", "192.168.5.165", "192.168.5.166"]

## DNS
dns_address = "192.168.5.169"
coredns_upstream_dns = "192.168.1.254"
gateway = "192.168.1.254"
machine_cidr = "192.168.5.0/16"
cluster_domain = "ocp46.openshift.lab.int"
netmask ="255.255.0.0"

## Ignition paths
## Expects `openshift-install create ignition-configs` to have been run
bootstrap_ignition_path = "../../openshift/bootstrap.ign"
master_ignition_path = "../../openshift/master.ign"
worker_ignition_path = "../../openshift/worker.ign"