#!/bin/bash
# Script: deploy_infra.sh
# Description: This script is used to deploy infrastructure using Terraform and helm.
# Author: Ching-En Lin
# Date: 2024-07-03

# Initialize Terraform
terraform init

# Apply the Terraform configuration and save the output to tf_output.json
terraform apply -auto-approve
terraform output -json > tf_output.json

# Read the output from the tf_output.json file and set the variables
K8S_CLUSTER_RESOURCE_GROUP_NAME=$(jq -r '.child_k8s_cluster_resource_group_name.value' tf_output.json)
K8S_CLUSTER_NAME=$(jq -r '.child_k8s_cluster_name.value' tf_output.json)

# Merge credentials into the kubeconfig file
az aks get-credentials --name $K8S_CLUSTER_NAME --resource-group $K8S_CLUSTER_RESOURCE_GROUP_NAME --overwrite-existing 
# Verify the connection to the Kubernetes cluster
kubectl get nodes



# Install the Helm chart
# Define release name
RELEASE_NAME="aks-cluster-v-patients"
# Install the Helm chart
helm install $RELEASE_NAME ./helm_charts