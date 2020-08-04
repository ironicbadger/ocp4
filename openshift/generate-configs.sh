#!/bin/sh
# A helper script for openshift-install

# manifest / ignition creation prep
rm -rf bootstrap-files/
mkdir -p bootstrap-files
#cp install-config.yaml bootstrap-files/
cp append-bootstrap.ign bootstrap-files/
cd bootstrap-files