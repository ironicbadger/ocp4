#!/bin/sh
# A helper script for openshift-install

## ignition creation prep
rm -rf openshift/
mkdir -p openshift
cp install-config.yaml openshift/
cd openshift

# create kubernetes manifests
openshift-install create manifests

# ensure masters are not schedulable
#sed -i 's/mastersSchedulable: true/mastersSchedulable: false/g' manifests/cluster-scheduler-02-config.yml
# macos sed will fail. if using macos uncomment below instead (requires `brew install gnu-sed`)
gsed -i 's/mastersSchedulable: true/mastersSchedulable: false/g' manifests/cluster-scheduler-02-config.yml

## ignition config creation
openshift-install create ignition-configs