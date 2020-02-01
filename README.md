# GKE Terraform

minimalistic terraform module for deploying a GKE cluster.

## Authentication with GCP

Login into google cloud using gcloud cli (this project will use your credentials file for auth): 

```sh
gcloud auth application-default login --project <project_id>
gcloud config set account <project_id>
```

Create a service account if not already exists:

```sh
gcloud iam service-accounts create <service_account_name> --display-name <service_account_display_name>
```

Download the credentials:

```sh
gcloud iam service-accounts keys create ~/.config/gcloud/account.json --iam-account <service_account_name>@<project_id>.iam.gserviceaccount.com
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
//
```

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