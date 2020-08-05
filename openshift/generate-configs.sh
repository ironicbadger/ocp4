#!/bin/sh
# A helper script for openshift-install

#Source variables for install-config.yaml
. ../install_vars

## ignition creation prep
rm -rf ignition-configs/
mkdir -p ignition-configs
cd ignition-configs || return

cat <<EOF > install-config.yaml
apiVersion: v1
baseDomain: ${DOMAIN}
compute:
- hyperthreading: Enabled
  name: worker
  replicas: 2
controlPlane:
  hyperthreading: Enabled
  name: master
  replicas: 3
metadata:
  name: ${CLUSTERID}
networking:
  clusterNetworks:
  - cidr: 10.254.0.0/16
    hostPrefix: 24
  networkType: OpenShiftSDN
  serviceNetwork:
  - 172.30.0.0/16
platform:
  vsphere:
    vcenter: ${VCENTER_SERVER}
    username: ${VCENTER_USER}
    password: ${VCENTER_PASS}
    datacenter: ${VCENTER_DC}
    defaultDatastore: ${VCENTER_DS}
pullSecret: '${PULL_SECRET}'
sshKey: '${OCP_SSH_KEY}'
EOF

## ignition config creation
openshift-install create ignition-configs
