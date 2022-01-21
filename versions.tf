terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 3.28"
    }
    kubernetes = {
      source  = "hashicorp/kubernetes"
      version = "~> 2.0, >= 2.0.1"
    }
    helm = {
      source  = "hashicorp/helm"
      version = "~> 2.1"
    }
    kubectl = {
      source  = "gavinbunney/kubectl"
      version = ">= 1.13"
    }
    http = {
      source  = "hashicorp/http"
      version = ">= 2.0"
    }
  }
  required_version = ">= 1.0"

  experiments = [module_variable_optional_attrs]
}
