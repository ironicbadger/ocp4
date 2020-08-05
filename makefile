tfinit:
	cd terraform/clusters/4.5; terraform init

create:
	cd openshift; ./generate-configs.sh
	cd terraform/clusters/4.5; terraform apply -auto-approve

nuke:
	cd terraform/clusters/4.5; terraform destroy

wait-for-bootstrap:
	cd openshift/ignition-configs; openshift-install wait-for install-complete --log-level debug

wait-for-install:
	cd openshift/ignition-configs; openshift-install wait-for install-complete --log-level debug

bootstrap-complete:
	cd terraform/clusters/4.5; terraform apply -auto-approve -var 'bootstrap_complete=true'