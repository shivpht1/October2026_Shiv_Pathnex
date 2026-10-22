cat > coding-practice/Day22/terraform/multi-region-clusters.tf <<'EOF'
terraform {
  required_version = ">= 1.5.0"

  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 5.0"
    }

    google = {
      source  = "hashicorp/google"
      version = "~> 6.0"
    }
  }
}

provider "aws" {
  region = var.aws_region
}

provider "google" {
  project = var.gcp_project_id
  region  = var.gcp_region
}

variable "aws_region" {
  description = "AWS region for the EKS cluster"
  type        = string
  default     = "us-east-1"
}

variable "gcp_project_id" {
  description = "Google Cloud project ID"
  type        = string
}

variable "gcp_region" {
  description = "Google Cloud region for the GKE cluster"
  type        = string
  default     = "us-central1"
}

variable "eks_subnet_ids" {
  description = "Existing subnet IDs for the EKS cluster"
  type        = list(string)

  validation {
    condition     = length(var.eks_subnet_ids) >= 2
    error_message = "Provide at least two subnet IDs in different availability zones."
  }
}

variable "eks_cluster_role_arn" {
  description = "ARN of an existing EKS cluster IAM role"
  type        = string
}

variable "gke_machine_type" {
  description = "Machine type for GKE worker nodes"
  type        = string
  default     = "e2-standard-2"
}

resource "aws_eks_cluster" "pathnex_eks" {
  name     = "pathnex-eks-cluster"
  role_arn = var.eks_cluster_role_arn
  version  = "1.31"

  vpc_config {
    subnet_ids = var.eks_subnet_ids
  }
}

resource "google_container_cluster" "pathnex_gke" {
  name     = "pathnex-gke-cluster"
  location = var.gcp_region

  initial_node_count       = 1
  deletion_protection      = true
  remove_default_node_pool = true

  network    = "default"
  subnetwork = "default"
}

resource "google_container_node_pool" "pathnex_gke_nodes" {
  name     = "pathnex-gke-node-pool"
  location = google_container_cluster.pathnex_gke.location
  cluster  = google_container_cluster.pathnex_gke.name

  node_count = 3

  node_config {
    machine_type = var.gke_machine_type
  }
}

output "eks_cluster_name" {
  value = aws_eks_cluster.pathnex_eks.name
}

output "gke_cluster_name" {
  value = google_container_cluster.pathnex_gke.name
}
EOF