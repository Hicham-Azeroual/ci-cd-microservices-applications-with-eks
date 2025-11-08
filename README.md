# Microservices E-Commerce Application on AWS EKS

This project provides a comprehensive guide and implementation for deploying a full-fledged microservices e-commerce application on Amazon Elastic Kubernetes Service (EKS). It covers infrastructure automation with Terraform, continuous integration and continuous deployment (CI/CD) with Jenkins, and robust observability using Prometheus and Grafana.

## Table of Contents
- [Project Overview](#project-overview)
- [Features](#features)
- [Architecture](#architecture)
- [Microservices](#microservices)
- [Prerequisites](#prerequisites)
- [Deployment Guide](#deployment-guide)
  - [1. Clone the Repository](#1-clone-the-repository)
  - [2. Configure AWS Keys](#2-configure-aws-keys)
  - [3. Create S3 Buckets for Terraform State](#3-create-s3-buckets-for-terraform-state)
  - [4. Create Network Infrastructure (EC2 Jumphost)](#4-create-network-infrastructure-ec2-jumphost)
  - [5. Jenkins Setup](#5-jenkins-setup)
  - [6. Create EKS Cluster](#6-create-eks-cluster)
  - [7. Create Elastic Container Registry (ECR)](#7-create-elastic-container-registry-ecr)
  - [8. Build and Push Docker Images to ECR](#8-build-and-push-docker-images-to-ecr)
  - [9. Deploy with ArgoCD](#9-deploy-with-argocd)
  - [10. Observability with Prometheus & Grafana](#10-observability-with-prometheus--grafana)
- [CI/CD Pipeline](#cicd-pipeline)
- [Observability](#observability)
- [Conclusion](#conclusion)
- [Next Steps](#next-steps)

## Project Overview
This project demonstrates a robust DevOps workflow for an e-commerce platform, leveraging AWS services and popular open-source tools. The goal is to provide a scalable, resilient, and observable microservices application.

## Features
-   **Microservices Architecture**: 11 distinct microservices for various e-commerce functionalities.
-   **Infrastructure as Code (IaC)**: Terraform for provisioning AWS resources (S3, EC2, EKS, ECR).
-   **CI/CD with Jenkins**: Automated build, test, and deployment pipelines for each microservice.
-   **Containerization**: Docker for packaging applications.
-   **Container Orchestration**: Kubernetes on AWS EKS for managing and scaling microservices.
-   **GitOps with ArgoCD**: Declarative, Git-centric continuous delivery for Kubernetes.
-   **Observability**: Prometheus for metrics collection, Grafana for visualization, and Alertmanager for notifications.
-   **Security Scanning**: Trivy for vulnerability scanning of file systems and Docker images.
-   **Code Quality**: SonarQube integration for static code analysis.
-   **Dependency Scanning**: OWASP Dependency-Check for identifying known vulnerabilities in dependencies.

## Architecture
The application follows a microservices architecture deployed on AWS EKS. Key components include:
-   **Frontend**: User interface for the e-commerce store.
-   **Backend Services**: Various microservices handling product catalog, cart, checkout, shipping, payments, recommendations, ads, email, and currency.
-   **Redis**: Used for caching (e.g., cart data).
-   **AWS EKS**: Managed Kubernetes service.
-   **AWS ECR**: Docker image registry.
-   **Jenkins**: CI/CD server.
-   **ArgoCD**: GitOps controller for Kubernetes deployments.
-   **Prometheus & Grafana**: Monitoring and visualization stack.

## Microservices
The project comprises the following microservices:
1.  `adservice`
2.  `cartservice`
3.  `checkoutservice`
4.  `currencyservice`
5.  `emailservice`
6.  `frontend`
7.  `loadgenerator`
8.  `paymentservice`
9.  `productcatalogservice`
10. `recommendationservice`
11. `shippingservice`

## Prerequisites
Before you begin, ensure you have the following:
-   An AWS Account
-   AWS CLI configured with appropriate credentials
-   Git
-   Docker
-   kubectl
-   Helm
-   Terraform
-   Jenkins (will be set up as part of the deployment)
-   Trivy (for local scanning, integrated into Jenkins)

## Deployment Guide
Follow these high-level steps to deploy the microservices e-commerce application. Refer to the original documentation (readme.txt) for detailed commands and configurations.

### 1. Clone the Repository
```bash
git clone https://github.com/Hicham-Azeroual/ci-cd-microservices-applications-with-eks.git
cd ci-cd-microservices-applications-with-eks
```

### 2. Configure AWS Keys
Ensure your AWS CLI is configured:
```bash
aws configure
```

### 3. Create S3 Buckets for Terraform State
Navigate to the `terraform-of-s3-bucket` directory and apply Terraform:
```bash
cd terraform-of-s3-bucket
terraform init
terraform plan
terraform apply -auto-approve
```

### 4. Create Network Infrastructure (EC2 Jumphost)
Navigate to the `terraform-for-ec2` directory and apply Terraform to set up the jumphost:
```bash
cd ../terraform-for-ec2
terraform init
terraform plan
terraform apply -auto-approve
```
Connect to the EC2 jumphost to verify installed DevOps tools and retrieve Jenkins admin password.

### 5. Jenkins Setup
Access Jenkins via `http://<EC2 Public IP>:8080` and complete the initial setup, including plugin installation.

### 6. Create EKS Cluster
Create a Jenkins pipeline job named `eks-terraform` using the `terraform-for-eks-jenkisfile/jenkinsfile` script path. Run the pipeline with `ACTION: apply` to provision your EKS cluster.

### 7. Create Elastic Container Registry (ECR)
Create a Jenkins pipeline job named `ecr-terraform` using the `terrafrom-for-ecr/jenkinsfile` script path. Run the pipeline with `ACTION: apply` to create ECR repositories for your microservices.

### 8. Build and Push Docker Images to ECR
For each microservice, create a dedicated Jenkins pipeline job (e.g., `emailservice`, `checkoutservice`, `cartservice`, etc.) using the respective Jenkinsfile in the `jenkisfiles/` directory. These pipelines will build Docker images, run security and quality checks, and push images to ECR.

### 9. Deploy with ArgoCD
(Details for ArgoCD deployment are expected to be in the full documentation. This section will be expanded if more details are provided or inferred.)

### 10. Observability with Prometheus & Grafana
Deploy the Prometheus and Grafana stack to your EKS cluster. Configure Grafana dashboards (e.g., using Dashboard ID 14584 for Argo CD). Set up Alertmanager for email notifications based on defined alert rules (e.g., high CPU usage).

## CI/CD Pipeline
The project utilizes Jenkins for its CI/CD pipelines. Each microservice has its own Jenkinsfile (`jenkisfiles/<service-name>`) which automates the following stages:
-   **Cleaning Workspace**: Ensures a clean build environment.
-   **Checkout from Git**: Fetches the latest code.
-   **Build & Test**: Compiles the application and runs unit tests.
-   **Trivy File Scan**: Scans the codebase for vulnerabilities.
-   **SonarQube Analysis**: Performs static code analysis for quality.
-   **Quality Gate**: Enforces code quality standards.
-   **Dependency Check (SCA)**: Scans for known vulnerabilities in dependencies.
-   **Docker Image Build**: Builds the Docker image for the microservice.
-   **ECR Image Pushing**: Pushes the Docker image to AWS ECR.
-   **Trivy Scan Image**: Scans the Docker image for vulnerabilities.
-   **Update Deployment file**: Updates the Kubernetes deployment YAML with the new image version and pushes changes to Git (for ArgoCD).

## Observability
The application's observability is powered by:
-   **Prometheus**: Collects metrics from the Kubernetes cluster and applications.
-   **Grafana**: Visualizes the collected metrics through interactive dashboards.
-   **Alertmanager**: Manages and sends alerts based on predefined rules (e.g., email notifications for high CPU usage).

## Screenshots
Here are some visual aids to better understand the project:

### Jenkins Pipeline
![Jenkins Pipeline 1](images/jenkins-pipeline-1.png)
![Jenkins Pipeline 2](images/jenkins-pipeline-2.png)

### Architecture Diagrams
![Architecture Diagram 1](images/architecture-diagram-1.png)
![Architecture Diagram 2](images/architecture-diagram-2.png)
![Architecture Diagram 3](images/architecture-diagram-3.png)
![Website Screenshot 1](images/website-screenshot-1.png)
![Website Screenshot 2](images/website-screenshot-2.png)

### Grafana Dashboards
![Grafana Dashboard 1](images/grafana-dashboard-1.png)
![Grafana Dashboard 2](images/grafana-dashboard-2.png)
![ArgoCD Dashboard](images/argocd-dashboard.png)

## Conclusion
This project provides a robust foundation for deploying and managing microservices on AWS EKS with a strong emphasis on automation, CI/CD, and observability. By following the detailed steps, you can achieve a production-ready setup for your e-commerce application.

## Next Steps
-   Add more dashboards tailored to your specific application needs.
-   Set up advanced alerts for various metrics like latency and error rates.
-   Explore integrations with tools like Loki for log monitoring and Tempo for distributed tracing.
-   Implement blue/green or canary deployments with ArgoCD.