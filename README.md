# Cloud Infrastructure Blueprint Project

This project provides a boilerplate code for setting up web application, including IaC workspace, helm charts, scripts, and other resources. 
The modules are designed to be reusable and can be used to create infrastructure for different environments. 

## Introduction

The project serves the purpose of deployment backend and frontend applications in Azure. The backend application is a simple REST API that is deployed in a Kubernetes cluster. The frontend application is a React application that is deployed in a Kubernetes cluster. The frontend application communicates with the backend application using the backend application's public IP address.

## Technologies

The project uses the following technologies:

- Azure Kubernetes Service (AKS)
- Azure Container Registry (ACR)
- Azure Public IP
- Azure VPN Gateway
- Terraform
- Helm
- Kubernetes

## Prerequisites

- Azure CLI
- Terraform v0.14.0 or later
- Helm v3.0.0 or later
- Kubectl v1.14.0 or later

## Project Structure

The project has the following structure:

```
.
├── README.md
├── LICENSE.md
├── scripts
│   ├── deploy_infra.sh
│   └── configure_ingress_ctl.sh
├── terraform_modules
│   │── container_registry
│   │── kubernetes_service
│   │── public_ip
│   └── vpn
└── helm_charts
    ├── templates
    │   ├── hpa.yaml
    │   ├── ingress.yaml
    │   ├── service.yaml
    │   └── issuer.yaml
    └── values.yaml
```

- `scripts`: Contains scripts for deploying the application and configuring the ingress controller.
- `terraform_modules`: Contains Terraform modules for creating resources in Azure.
- `helm_charts`: Contains Helm charts for deploying the application.
- `helm_charts/templates`: Contains Kubernetes manifests for the application.
- `helm_charts/values.yaml`: Contains the default values for the Helm chart.

## Usage

1. Install the prerequisites.
2. Clone this repository.
3. Make sure you have the necessary permissions to create resources in Azure.
4. Create a service principal in Azure and assign the necessary roles to it.
   1. Run `az login` to login to Azure.
   2. Run `az account set --subscription <subscription_id>` to set the subscription.
   3. Run `az ad sp create-for-rbac --role="Contributor" --scopes="/subscriptions/<subscription_id>"` to create a service principal.
5. Run `terraform init` to initialize the Terraform workspace.
6. Run `terraform apply` to create the resources.
7. Run `scripts/deploy_infra.sh` to deploy the application.
8. Run `scripts/configure_ingress_ctl.sh` to configure the ingress controller.

## License

This project is licensed under the MIT License - see the LICENSE.md file for details.