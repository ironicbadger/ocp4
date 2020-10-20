tfinit:
	cd clusters/4.5; terraform init
	cd clusters/4.5-staticIPs; terraform init
	cd clusters/4.6-staticIPs; terraform init

create:
	mkdir openshift/; cp generate-configs.sh openshift/
	cd openshift/; ./generate-configs.sh
	cd clusters/4.5; terraform apply -auto-approve

static45:
	./generate-configs.sh
	cd clusters/4.5-staticIPs; terraform apply -auto-approve

nuke45:
	cd clusters/4.6-staticIPs; terraform destroy

static46:
	./generate-configs.sh
	cd clusters/4.6-staticIPs; terraform apply -auto-approve

nuke46:
	cd clusters/4.6-staticIPs; terraform destroy	

remove-bootstrap:
	cd clusters/4.5; terraform apply -auto-approve -var 'bootstrap_complete=true'

wait-for-bootstrap:
	cd openshift; openshift-install wait-for install-complete --log-level debug

wait-for-install:
	cd openshift; openshift-install wait-for install-complete --log-level debug

check-install:
	oc --kubeconfig openshift/auth/kubeconfig get nodes && echo "" && \
	oc --kubeconfig openshift/auth/kubeconfig get co && echo "" && \
	oc --kubeconfig openshift/auth/kubeconfig get csr

lazy-install:
	oc --kubeconfig openshift/auth/kubeconfig get nodes && echo "" && \
	oc --kubeconfig openshift/auth/kubeconfig get co && echo "" && \
	oc --kubeconfig openshift/auth/kubeconfig get csr && \
	oc --kubeconfig openshift/auth/kubeconfig get csr -ojson | \
		jq -r '.items[] | select(.status == {} ) | .metadata.name' | \
		xargs oc --kubeconfig openshift/auth/kubeconfig adm certificate approve

get-co:
	oc --kubeconfig openshift/auth/kubeconfig get co

get-nodes:
	oc --kubeconfig openshift/auth/kubeconfig get nodes

get-csr:
	oc --kubeconfig openshift/auth/kubeconfig get csr

approve-csr:
	oc --kubeconfig openshift/auth/kubeconfig get csr -ojson | \
		jq -r '.items[] | select(.status == {} ) | .metadata.name' | \
		xargs oc --kubeconfig openshift/auth/kubeconfig adm certificate approve