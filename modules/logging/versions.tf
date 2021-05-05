terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 3.28"
    }
  }
  required_version = ">= 0.14"

  experiments = [module_variable_optional_attrs]
}
