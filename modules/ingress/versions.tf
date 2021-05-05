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
  }
  required_version = ">= 0.14"

  experiments = [module_variable_optional_attrs]
}
