.PHONY: create-key-vault

## Initialize Backend ONLY - run `make initialize-backend`
initialize-backend:
		@echo "Initializing Backend"
		cd ./01-storage-accnt && \
		terraform init

## Create Backend ONLY - run `make create-backend`
create-backend:
		@echo "Initializing Backend"
		cd ./01-storage-accnt && \
		terraform init && \
		terraform plan  -var-file ../variables.tfvars -var-file ../04-secrets/varsec.tfvars && \
		terraform apply -var-file ../variables.tfvars -var-file ../04-secrets/varsec.tfvars --auto-approve 

## Delete Backend ONLY - run `make delete-backend`
delete-backend:
		@echo "Deleting storage backend"
		cd ./01-storage-accnt && \
		terraform destroy -var-file ../variables.tfvars -var-file ../04-secrets/varsec.tfvars --auto-approve	

## Create cluster creating environment - run `make create-env`
create-env:
		@echo "Initializing env backend in storage account"
		cd ./02-prepare-env && \
		terraform init && \
		echo "Planning cluster environment" && \
		terraform plan -var-file ../variables.tfvars -var-file ../04-secrets/varsec.tfvars && \
		echo "Creating network vault and other cluster dependency resources" && \
		terraform apply -var-file ../variables.tfvars -var-file ../04-secrets/varsec.tfvars --auto-approve 

## Recreate cluster creating environment - run `make recreate-env`
recreate-env:
		@echo "Destroying cluster environment"
		cd ./02-prepare-env && \
		terraform destroy -var-file ../variables.tfvars -var-file ../04-secrets/varsec.tfvars --auto-approve && \
		echo "Planning cluster environment" && \
		terraform plan -var-file ../variables.tfvars -var-file ../04-secrets/varsec.tfvars && \
		echo "Creating network vault and other cluster dependency resources" && \
		terraform apply -var-file ../variables.tfvars -var-file ../04-secrets/varsec.tfvars --auto-approve 

## Delete cluster creating environment - run `make delete-env`
delete-env:
		@echo "Deleting env"
		cd ./02-prepare-env && \
		terraform destroy -var-file ../variables.tfvars -var-file ../04-secrets/varsec.tfvars --auto-approve

## Create ARO cluster  - run `make create-cluster`
create-cluster:
		@echo "Creating ARO cluster"
		cd ./03-create-cluster && \
		terraform init && \
		terraform plan -var-file ../variables.tfvars -var-file ../04-secrets/varsec.tfvars && \
		terraform apply -var-file ../variables.tfvars -var-file ../04-secrets/varsec.tfvars --auto-approve

## Recreate ARO cluster  - run `make recreate-cluster`
recreate-cluster:
		@echo "Deleting ARO cluster"
		cd ./03-create-cluster && \
		terraform destroy -var-file ../variables.tfvars -var-file ../04-secrets/varsec.tfvars --auto-approve && \
		terraform apply -var-file ../variables.tfvars -var-file ../04-secrets/varsec.tfvars --auto-approve

## Delete ARO cluster  - run `make delete-cluster`
delete-cluster:
		@echo "Destroy ARO cluster"
		cd ./03-create-cluster && \
		terraform destroy -var-file ../variables.tfvars -var-file ../04-secrets/varsec.tfvars --auto-approve

## Delete whole environment  - run `make delete-all`
delete-all:
		@echo "Destroying Cluster"
		cd ./03-create-cluster && \
		terraform destroy -var-file ../variables.tfvars -var-file ../04-secrets/varsec.tfvars --auto-approve && \
		echo "Destroying ARO cluster environment" && \
		cd ./02-prepare-env && \
		terraform destroy -var-file ../variables.tfvars -var-file ../04-secrets/varsec.tfvars --auto-approve  && \
		echo "Destroying Backends" && \
		cd ./01-storage-accnt && \
		terraform destroy -var-file ../variables.tfvars -var-file ../04-secrets/varsec.tfvars --auto-approve

## Create whole environment  - run `make create-all`
create-all:
		@echo "Creating Backend"
		cd ./01-storage-accnt && \
		terraform init && \
		terraform plan -var-file ../variables.tfvars -var-file ../04-secrets/varsec.tfvars && \
		terraform apply -var-file ../variables.tfvars -var-file ../04-secrets/varsec.tfvars --auto-approve && \
		echo "Creating Installation Environment" && \
		cd ./02-prepare-env && \
		terraform init && \
		terraform plan -var-file ../variables.tfvars -var-file ../04-secrets/varsec.tfvars && \
		terraform apply -var-file ../variables.tfvars -var-file ../04-secrets/varsec.tfvars --auto-approve && \
		echo "Creating ARO cluster" && \
		cd ../03-create-cluster && \
		terraform init && \
		terraform plan -var-file ../variables.tfvars -var-file ../04-secrets/varsec.tfvars && \
		terraform apply -var-file ../variables.tfvars -var-file ../04-secrets/varsec.tfvars --auto-approve && \
