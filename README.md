# ironicbadger/ocp4

This repo contains code to deploy Openshift 4 for my homelab. It focuses on UPI with vSphere 6.7u3.

> Oct 20th 2020 - The code here is working against 4.6. This version of OCP uses Ignition v3 so is incompatible with prior releases of RHCOS.

## Usage

Code for each OCP release lives on a numbered branch. The master branch represents the latest stable iteration and will likely be behind branches. In otherwords, check the number branches first before looking at master.

> * This repo *requires* Terraform 0.13
> * Install `oc tools` with `./install-oc-tools.sh --latest 4.6`
> * This code use yamldecode - details here https://blog.ktz.me/store-terraform-secrets-in-yaml-files-with-yamldecode/

0. Create `~/.config/ocp/vsphere.yaml` for `yamldecode` use, sample content:

```
alex@mooncake ~ % cat .config/ocp/vsphere.yaml
vsphere-user: administrator@vsphere.lan
vsphere-password: "123!"
vsphere-server: 192.168.1.240
vsphere-dc: ktzdc
vsphere-cluster: ktzcluster
```

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

3. Customize `clusters/4.6-staticIPs/terraform.tfvars`, `clusters/4.6-staticIPs/main.tf`, and `clusters/4.6-staticIPs/variables.tf` with the relevant information. This repo assume you are doing mac address based DHCP reservations.

4. Run `make tfinit` to initialise Terraform modules
5. Run `make create` to create the VMs and generate/install ignition configs
6. Monitor install progress with `make wait-for-bootstrap`
7. Check and approve pending CSRs with `make get-csr` and `make approve-csr`
8. Run `make bootstrap-complete` to destroy the bootstrap VM
9. Run `make wait-for-install` and wait for the cluster install to complete
10. Enjoy!
