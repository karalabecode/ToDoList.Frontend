variable "allowed_workspaces" {
  type = list(string)
}

resource "terraform_data" "workspace_check" {
  lifecycle {
    precondition {
      condition = contains(var.allowed_workspaces, terraform.workspace)
      error_message = "Invalid workspace: ${terraform.workspace}, must be one of: [${join(", ", var.allowed_workspaces)}]! Did you forget to `tf workspace select`?"
    }
  }
}
