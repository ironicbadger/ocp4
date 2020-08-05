# ironicbadger/ocp4

This repo contains code to deploy Openshift 4 for my homelab. It focuses, at least for now, on UPI with vSphere 6.7u3. A full blog post will be coming soon on setting this up but the TLDR is:

1. Configure DNS - https://blog.ktz.me/configure-unbound-dns-for-openshift-4/
2. Create `openshift/install-config.yaml`

```
apiVersion: v1
baseDomain: ktz.lan
compute:
- hyperthreading: Enabled
  name: worker
  replicas: 2
controlPlane:
  hyperthreading: Enabled
  name: master
  replicas: 3
metadata:
  name: ocp4
networking:
  clusterNetworks:
  - cidr: 10.254.0.0/16
    hostPrefix: 24
  networkType: OpenShiftSDN
  serviceNetwork:
  - 172.30.0.0/16
platform:
  none: {}
pullSecret: 'YOUR_PULL_SECRET'
sshKey: 'YOUR_SSH_PUBKEY'
```

3. Customize `terraform/clusters/4.5/terraform.tfvars` with the relevant information. This repo assume you are doing mac address based DHCP reservations.
4. Run `make tfinit` to initialise Terraform modules
5. Run `make create` to create the VMs and generate/install ignition configs
6. Monitor install progress with `make wait-for-bootstrap`
7. Run `make bootstrap-complete` to destroy the bootstrap VM.
8. Run `make wait-for-install` and wait for the cluster install to complete.
9. Enjoy.