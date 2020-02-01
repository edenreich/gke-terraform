# GKE Terraform

minimalistic terraform module for deploying a GKE cluster.

## Requirements

* terraform v0.12.20
* gcloud v2.20.1

Download and install google SDK:

```sh
    curl sdk.cloud.google.com | bash
    gcloud version
```

Download and install terraform:

```sh
    wget https://releases.hashicorp.com/terraform/0.12.20/terraform_0.12.20_linux_amd64.zip
    unzip terraform_0.12.20_linux_amd64.zip
    sudo mv terraform /usr/local/bin/terraform
    rm -rf terraform_0.12.20_linux_amd64.zip
    terraform version
```

## Authentication with GCP

Login into google cloud using gcloud cli (this project will use your credentials file for auth): 

```sh
gcloud auth application-default login --project <project_id>
gcloud config set account <project_id>
```

Create a service account if not already exists:

```sh
gcloud iam service-accounts create <service_account_name> \
    --display-name <service_account_display_name> \
    --description 'service account for managing terraform'
```

Assign owner role to service account (Bad practice - should be limited to specific resources by attached policy).

```sh
gcloud projects add-iam-policy-binding <project_id> \
  --member serviceAccount:<service_account_name>@<project_id>.iam.gserviceaccount.com \
  --role roles/owner
```

OR

Assign IAM policy to service account (Considered better practice):

```sh
gcloud iam service-accounts set-iam-policy \
    <service_account_name>@<project_id>.iam.gserviceaccount.com policies/main.json
```

Download the service account credentials:

```sh
gcloud iam service-accounts keys create ~/.config/gcloud/account.json \
    --iam-account <service_account_name>@<project_id>.iam.gserviceaccount.com
```

Activate the service account:

```sh
gcloud auth activate-service-account <service_account_name>@<project_id>.iam.gserviceaccount.com --key-file=$HOME/.config/gcloud/account.json
```

## Build

Before build you should set the following variables:

```sh
export TF_VAR_project=<project_id>
export TF_VAR_region=<region>
export TF_VAR_zone=<zone>
export TF_VAR_master_node_username=<master_node_username>
export TF_VAR_master_node_password=<master_node_password>
```

1. Create a backend, so terraform can store it's state and read from it remotely:

```sh
GOOGLE_APPLICATION_CREDENTIALS=$HOME/.config/gcloud/account.json BUCKET_NAME=<bucket-name> gcloud compute backend-buckets create $BUCKET_NAME --gcs-bucket-name=$BUCKET_NAME --description='stores the state of terraform'
```

Note: If gcloud bucket creation not working you will probably have to create the bucket manually.


2. First download all plugins: 

```sh
GOOGLE_APPLICATION_CREDENTIALS=$HOME/.config/gcloud/account.json terraform init
```

3. Checkout the plan: 

```sh
GOOGLE_APPLICATION_CREDENTIALS=$HOME/.config/gcloud/account.json terraform plan
```

4. If you are happy with this resources, apply them: 

```sh
GOOGLE_APPLICATION_CREDENTIALS=$HOME/.config/gcloud/account.json terraform apply -auto-approve
```

Note: when running apply for the first time it's going to take around 5min to create the cluster.

## Cleanup

Run `terraform destroy`