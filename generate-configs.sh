#!/bin/sh
# A helper script for openshift-install

## ignition creation prep
rm -rf openshift/
mkdir -p openshift
cp install-config.yaml openshift/
cd openshift

## ignition config creation
openshift-install create ignition-configs