tfinit:
	cd clusters/4.5; terraform init

create:
	./generate-configs.sh
	cd clusters/4.5; terraform apply -auto-approve

remove-bootstrap:
	cd clusters/4.5; terraform apply -auto-approve -var 'bootstrap_complete=true'

nuke:
	cd clusters/4.5; terraform destroy

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