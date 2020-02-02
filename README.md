# GKE Terraform

minimalistic terraform module for deploying a GKE cluster.

## Requirements

* project id from GCP console
* terraform v0.12.20
* gcloud v2.20.1
* kubectl v1.17.0

Download and install google SDK:

```sh
curl sdk.cloud.google.com | bash
gcloud version
```

Download and install terraform:

```sh
wget https://releases.hashicorp.com/terraform/0.12.20/terraform_0.12.20_linux_amd64.zip
unzip terraform_0.12.20_linux_amd64.zip
chmod +x kubectl && sudo mv terraform /usr/local/bin/terraform
rm -rf terraform_0.12.20_linux_amd64.zip
terraform version
```

Download and install kubectl:

```sh
curl -LO https://storage.googleapis.com/kubernetes-release/release/v1.17.0/bin/linux/amd64/kubectl
chmod +x kubectl && sudo mv kubectl /usr/local/bin/kubectl
kubectl version --client
```

## Environment / Configurations

```sh
export GOOGLE_PROJECT_ID=<project_id>
export GOOGLE_SERVICE_ACCOUNT_NAME=acme-123 # could be anything unique
export GOOGLE_APPLICATION_CREDENTIALS=$HOME/.config/gcloud/account.json

export TF_VAR_project=$GOOGLE_PROJECT_ID
export TF_VAR_service_account=$GOOGLE_SERVICE_ACCOUNT_NAME
export TF_VAR_environment=<environment>
export TF_VAR_region=<region>
export TF_VAR_zone=<zone>
export TF_VAR_cluster_name=<cluster_name>
export TF_VAR_initial_node_count=1
export TF_VAR_node_count=1

# Autoscaling (optional, default to 5)
export TF_VAR_min_node_count=1
export TF_VAR_max_node_count=5

# Authentication - left blank on purpose, to disable basic authentication
export TF_VAR_master_node_username=''
export TF_VAR_master_node_password=''
```

## Authentication with GCP

Login into google cloud using gcloud cli (this project will use your credentials file for auth): 

```sh
gcloud init --console-only --project $GOOGLE_PROJECT_ID
```

Create a service account if not already exists:

```sh
gcloud iam service-accounts create $GOOGLE_SERVICE_ACCOUNT_NAME \
    --display-name 'GKE-Terraform Account' \
    --description 'Service account for managing GKE via terraform'
```

Assign minimum roles to service account for required actions:

```sh
declare -a roles=(
  "storage.objectAdmin" 
  "monitoring.viewer" 
  "monitoring.metricWriter" 
  "logging.logWriter" 
  "iam.serviceAccountUser" 
  "compute.serviceAgent" 
  "compute.admin" 
  "container.serviceAgent" 
  "container.admin"
)

for role in "${roles[@]}"
do
gcloud projects add-iam-policy-binding $GOOGLE_PROJECT_ID \
  --member "serviceAccount:${GOOGLE_SERVICE_ACCOUNT_NAME}@${GOOGLE_PROJECT_ID}.iam.gserviceaccount.com" \
  --role "roles/${role}"
done
```

Download the service account credentials:

```sh
gcloud iam service-accounts keys create ~/.config/gcloud/account.json \
    --iam-account ${GOOGLE_SERVICE_ACCOUNT_NAME}@${GOOGLE_PROJECT_ID}.iam.gserviceaccount.com
```

Activate the service account:

```sh
gcloud auth activate-service-account ${GOOGLE_SERVICE_ACCOUNT_NAME}@${GOOGLE_PROJECT_ID}.iam.gserviceaccount.com \
    --key-file=$HOME/.config/gcloud/account.json
```

## Build

1. Create a backend, so terraform can store it's state and read from it remotely (necessary when collaborating with other teams, that way everyone can apply the changes to the remote state):

```sh
BUCKET_NAME=<bucket-name> \
    gcloud compute backend-buckets create $BUCKET_NAME \
    --gcs-bucket-name=$BUCKET_NAME \
    --description='stores the state of terraform'
```

Note: If gcloud bucket creation not working you will probably have to create the bucket manually.

2. First download all plugins: 

```sh
terraform init
```

3. Choose the workspace (staging|production):

```sh
terraform workspace select $TF_VAR_environment || terraform workspace new $TF_VAR_environment
```

4. Checkout the plan: 

```sh
terraform plan
```

5. If you are happy with this resources, apply them: 

```sh
terraform apply -auto-approve
```

Note: when running apply for the first time it's going to take around 5min to create the cluster.

## Update Infrastructure

Terraform idempotent code could run as many time as needed and keep track on the current state of the infrastructure,
therefore in order to make changes (for example - add nodes or delete nodes etc..) you need to:

1. Modifiy the configurations .tf files.

2. Plan the changes:

```sh
terraform plan
```

3. Apply the changes:

```sh
terraform apply -auto-approve
```

## Connect to GKE

1. First download the kubernetes config file:

```sh
gcloud container clusters get-credentials $TF_VAR_cluster_name \
    --zone=$TF_VAR_zone
```

2. Test that you can fetch informations from the cluster:

```sh
kubectl cluster-info
kubectl get nodes
```

## Cleanup

To cleanup all resources that has been created by this project from GCP, run:

```sh
terraform destroy
```

## Visualize

To visualize infrastructure dependency tree, run:

```sh
sudo apt install graphviz
terraform graph | dot -Tsvg > graph.svg
```