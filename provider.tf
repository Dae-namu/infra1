terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "5.96.0"
    }
    kubernetes = {
      source  = "hashicorp/kubernetes"
      version = ">=2.35.0"
    }
    helm = {
      source  = "hashicorp/helm"
      version = ">=2.11.0"
    }
    kubectl = {
      source  = "gavinbunney/kubectl"
      version = ">= 1.14.0"
    }
  }
}

provider "aws" {
  region = "ap-northeast-2"
}

