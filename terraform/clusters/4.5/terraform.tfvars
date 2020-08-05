## Node IPs
loadbalancer_ip = "192.168.1.160"
bootstrap_ip = "192.168.1.169"
master_ips = ["192.168.1.161", "192.168.1.162", "192.168.1.163"]
worker_ips = ["192.168.1.164", "192.168.1.165"]
#worker_ips = ["192.168.1.164", "192.168.1.165", "192.168.1.166"]

## Ignition paths
## Expects `openshift-install create ignition-configs` to have been run
bootstrap_ignition_path = "../../../openshift/ignition-configs/bootstrap.ign"
master_ignition_path = "../../../openshift/ignition-configs/master.ign"
worker_ignition_path = "../../../openshift/ignition-configs/worker.ign"