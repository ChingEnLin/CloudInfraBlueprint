#!/bin/bash
# Script: configure_ingress_ctl.sh
# Description: This script is used to configure the Ingress Controller using Helm.
# Author: Ching-En Lin
# Date: 2024-07-03

# Define variables from tf output file:
K8S_CLUSTER_RESOURCE_GROUP_NAME=$(jq -r '.child_k8s_cluster_resource_group_name.value' tf_output.json)
K8S_CLUSTER_NAME=$(jq -r '.child_k8s_cluster_name.value' tf_output.json)
CONTAINER_REGISTRY_URL=$(jq -r '.child_container_registry_url.value' tf_output.json)
CONTAINER_REGISTRY_ID=$(jq -r '.child_container_registry_id.value' tf_output.json)

# Install the helm chart via the helm repository
helm repo add ingress-nginx https://kubernetes.github.io/ingress-nginx
helm repo update

# Images that are required by the NGINX ingress controller Helm chart
# are imported into the created container registry.
REGISTRY_NAME=$(jq -r '.child_container_registry_name.value' tf_output.json)
ACR_URL=$CONTAINER_REGISTRY_URL
SOURCE_REGISTRY=registry.k8s.io
CONTROLLER_IMAGE=ingress-nginx/controller
CONTROLLER_TAG=v1.8.1
PATCH_IMAGE=ingress-nginx/kube-webhook-certgen
PATCH_TAG=v1.4.1
DEFAULTBACKEND_IMAGE=defaultbackend-amd64
DEFAULTBACKEND_TAG=1.5

az acr import --name $REGISTRY_NAME --source $SOURCE_REGISTRY/$CONTROLLER_IMAGE:$CONTROLLER_TAG --image $CONTROLLER_IMAGE:$CONTROLLER_TAG
az acr import --name $REGISTRY_NAME --source $SOURCE_REGISTRY/$PATCH_IMAGE:$PATCH_TAG --image $PATCH_IMAGE:$PATCH_TAG
az acr import --name $REGISTRY_NAME --source $SOURCE_REGISTRY/$DEFAULTBACKEND_IMAGE:$DEFAULTBACKEND_TAG --image $DEFAULTBACKEND_IMAGE:$DEFAULTBACKEND_TAG

# Grant kubernetes cluster permission to pull image from container registry
az aks update -n $K8S_CLUSTER_NAME -g $K8S_CLUSTER_RESOURCE_GROUP_NAME --attach-acr $CONTAINER_REGISTRY_ID

NAMESPACE="ingress-nginx"
# Create a namespace for the ingress controller if it does not exist

TARGET=("backend" "frontend")
ENVIRONMENT=("dev" "staging")

for target in "${TARGET[@]}"
    do
    for environment in "${ENVIRONMENT[@]}"
        do
        echo "Deploying Ingress Controller for $target-$environment"
        RELEASE_NAME="ingress-nginx-$target-$environment"
        INGRESS_CLASS="nginx-$target-$environment"
        INGRESS_CLASS_CONTROLLER_VALUE="k8s.io/$INGRESS_CLASS"
        DNS_LABEL=$(jq -r '.child_public_ip_domain_name.value."AKSPublicIP'$target-$environment'"' tf_output.json)
        STATIC_IP=$(jq -r '.child_public_ip_address.value."AKSPublicIP'$target-$environment'"' tf_output.json)

        helm upgrade --install $RELEASE_NAME ingress-nginx/ingress-nginx \
        --version 4.10.1 \
        --namespace $NAMESPACE \
        --create-namespace \
        --set controller.replicaCount=1 \
        --set controller.nodeSelector."kubernetes\.io/os"=linux \
        --set controller.image.registry=$ACR_URL \
        --set controller.image.image=$CONTROLLER_IMAGE \
        --set controller.image.tag=$CONTROLLER_TAG \
        --set controller.ingressClass=$INGRESS_CLASS \
        --set controller.ingressClassResource.name=$INGRESS_CLASS \
        --set controller.ingressClassResource.controllerValue=$INGRESS_CLASS_CONTROLLER_VALUE \
        --set controller.admissionWebhooks.patch.nodeSelector."kubernetes\.io/os"=linux \
        --set controller.service.annotations."service\.beta\.kubernetes\.io/azure-load-balancer-health-probe-request-path"=/healthz \
        --set controller.admissionWebhooks.patch.image.registry=$ACR_URL \
        --set controller.admissionWebhooks.patch.image.image=$PATCH_IMAGE \
        --set controller.admissionWebhooks.patch.image.tag=$PATCH_TAG \
        --set defaultBackend.nodeSelector."kubernetes\.io/os"=linux \
        --set defaultBackend.image.registry=$ACR_URL \
        --set defaultBackend.image.image=$DEFAULTBACKEND_IMAGE \
        --set defaultBackend.image.tag=$DEFAULTBACKEND_TAG \
        --set controller.service.annotations."service\.beta\.kubernetes\.io/azure-dns-label-name"=$DNS_LABEL \
        --set controller.service.loadBalancerIP=$STATIC_IP \
        -f manifests/ingress-external.yaml
        done
    done