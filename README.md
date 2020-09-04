# ironicbadger/ocp4

This repo contains code to deploy Openshift 4 for my homelab. It focuses on UPI with vSphere 6.7u3. 

## Usage

Code for each OCP release lives on a numbered branch. The master branch represents the latest stable iteration and will likely be behind branches. In otherwords, check the number branches first before looking at master.

> * This repo *requires* Terraform 0.13
> * Install `oc tools` with `./install-oc-tools.sh --latest 4.5`
> * This code use yamldecode - details here https://blog.ktz.me/store-terraform-secrets-in-yaml-files-with-yamldecode/

1. Configure DNS - https://blog.ktz.me/configure-unbound-dns-for-openshift-4/
2. Create `install-config.yaml`

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

3. Customize `clusters/4.5/terraform.tfvars`, `clusters/4.5/main.tf`, and `clusters/4.5/variables.tf` with the relevant information. This repo assume you are doing mac address based DHCP reservations.
4. create `~/.config/ocp/vsphere.yaml` that looks like this: 

```
vsphere-user: administrator@vsphere.lan
vsphere-password: supersecretpassword
vsphere-server: 192.168.1.240
vsphere-dc: ktzdc
vsphere-cluster: nvme
```

5. Run `make tfinit` to initialise Terraform modules
6. Run `make create` to create the VMs and generate/install ignition configs
7. Monitor install progress with `make wait-for-bootstrap`
8. Check and approve pending CSRs with `make get-csr` and `make approve-csr`
9. Run `make bootstrap-complete` to destroy the bootstrap VM
10. Run `make wait-for-install` and wait for the cluster install to complete
11. Enjoy!
