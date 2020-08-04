init:
	cd terraform/infra/4.5; terraform init

create:
	cd terraform/infra/4.5; terraform apply

nuke:
	cd terraform/infra/4.5; terraform destroy