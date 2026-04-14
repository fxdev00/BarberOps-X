## BarberOps — operational shortcuts
.PHONY: help init plan apply destroy connect

help:
	@echo "make init    — initialise terraform"
	@echo "make plan    — preview infrastructure changes"
	@echo "make apply   — create/update infrastructure"
	@echo "make connect — configure kubectl for the cluster"
	@echo "make destroy — DESTROY ALL RESOURCES"

init:
	cd terraform/environments/dev && terraform init

plan:
	cd terraform/environments/dev && terraform plan

apply:
	cd terraform/environments/dev && terraform apply

connect:
	gcloud container clusters get-credentials barberops-cluster \
	  --region europe-west2 \
	  --project $$(gcloud config get-value project)

destroy:
	kubectl delete -f k8s/ --recursive --ignore-not-found
	cd terraform/environments/dev && terraform destroy
