# ironicbadger/ocp4

This repo contains code to deploy Openshift 4 for my homelab. It focuses on UPI with vSphere 6.7u3. A full blog post will be coming soon on setting this up but the TLDR is:

> * This repo *requires* Terraform 0.13
> * Install `oc tools` with `./install-oc-tools.sh --latest 4.5`
> * This code use yamldecode - details here https://blog.ktz.me/store-terraform-secrets-in-yaml-files-with-yamldecode/

1. Configure DNS - https://blog.ktz.me/configure-unbound-dns-for-openshift-4/
2. Create `openshift/install-config.yaml`

```
apiVersion: v1
baseDomain: ktz.lan
compute:
- hyperthreading: Enabled
  name: worker
  replicas: 0
controlPlane:
  hyperthreading: Enabled
  name: master
  replicas: 3
metadata:
  name: ocp4
platform:
  vsphere:
    vcenter: 192.168.1.240
    username: administrator@vsphere.lan
    password: supersecretpassword
    datacenter: ktzdc
    defaultDatastore: nvme
fips: false 
pullSecret: 'YOUR_PULL_SECRET'
sshKey: 'YOUR_SSH_PUBKEY'
```

3. Customize `terraform/clusters/4.5/terraform.tfvars` with the relevant information. This repo assume you are doing mac address based DHCP reservations.
4. Run `make tfinit` to initialise Terraform modules
5. Run `make create` to create the VMs and generate/install ignition configs
6. Monitor install progress with `make wait-for-bootstrap`
7. Check and approve pending CSRs with `make get-csr` and `make approve-csr`
8. Run `make bootstrap-complete` to destroy the bootstrap VM
9. Run `make wait-for-install` and wait for the cluster install to complete
10. Enjoy!
