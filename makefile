init:
	cd terraform/infra/4.5; terraform init

create:
	cd openshift; ./generate-configs.sh
	cd terraform/infra/4.5; terraform apply -auto-approve

nuke:
	cd terraform/infra/4.5; terraform destroy