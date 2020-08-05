# ironicbadger/ocp4

This repo contains code to deploy Openshift 4 for my homelab. It focuses, at least for now, on UPI with vSphere 6.7u3. A full blog post will be coming soon on setting this up but the TLDR is:

> * This repo *requires* Terraform 0.13
> * Install `oc tools` with `./install-oc-tools.sh --latest 4.5`

1. Configure DNS - https://blog.ktz.me/configure-unbound-dns-for-openshift-4/
2. Update install_vars with the correct information to populate install-config.yaml

```
DOMAIN=example.com
CLUSTERID=openshift
VCENTER_SERVER=vcenter.lab.int
VCENTER_USER="Administrator@vsphere.local"
VCENTER_PASS='Rand0passw0rd-oh!'
VCENTER_DC=DC1
VCENTER_DS=ds1
PULL_SECRET=$(cat ~/.openshift/pull-secret.json)
OCP_SSH_KEY=$(cat ~/.ssh/id_rsa.pub)

```

3. Customize `terraform/clusters/4.5/terraform.tfvars` with the relevant information. This repo assume you are doing mac address based DHCP reservations.
4. Run `make tfinit` to initialise Terraform modules
5. Run `make create` to create the VMs and generate/install ignition configs
6. Monitor install progress with `make wait-for-bootstrap`
7. Check and approve pending CSRs with `make get-csr` and `make approve-csr`
8. Run `make bootstrap-complete` to destroy the bootstrap VM
9. Run `make wait-for-install` and wait for the cluster install to complete
10. Enjoy!
