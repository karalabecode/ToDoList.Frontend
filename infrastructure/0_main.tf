terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 5.0"
    }
  }

  backend "s3" {
    bucket               = "terraform-state-oafi"
    key                  = "ToDoList.Frontend/terraform.tfstate"
    workspace_key_prefix = "ToDoList"
    region               = "eu-central-1"
  }
}

locals {
  tags = {
    "App" = "ToDoList"
  }
}

module "validator" {
  source             = "./validator"
  allowed_workspaces = ["dev"]
}
