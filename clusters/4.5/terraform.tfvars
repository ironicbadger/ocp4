## Node IPs
loadbalancer_ip = "192.168.4.160"
bootstrap_ip = "192.168.4.169"
master_ips = ["192.168.4.161", "192.168.4.162", "192.168.4.163"]
worker_ips = ["192.168.4.164", "192.168.4.165"]
#worker_ips = ["192.168.4.164", "192.168.4.165", "192.168.4.166"]

## Ignition paths
## Expects `openshift-install create ignition-configs` to have been run
bootstrap_ignition_path = "../../openshift/bootstrap.ign"
master_ignition_path = "../../openshift/master.ign"
worker_ignition_path = "../../openshift/worker.ign"