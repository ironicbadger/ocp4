#!/bin/sh
# A helper script for openshift-install

## ignition creation prep
rm -rf ignition-configs/
mkdir -p ignition-configs
cp install-config.yaml ignition-configs/
cp append-bootstrap.ign ignition-configs/
cd ignition-configs

## ignition config creation
openshift-install create ignition-configs