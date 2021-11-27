provider "tfe" {
  token = var.token
  version  = "0.26.1"
}
provider "aws" {
  region = var.region
}

locals {
  instance_name = "${terraform.workspace}-instacne"
}

resource "aws_instance" "webserver" {
  ami = var.ami
  instance_type = var.instance_type
}

# Create an organization
resource "tfe_organization" "org" {
  name = "tmrz-devops"
  email = "tamir.raz@gmail.com"
}

#Create a workspace
resource "tfe_workspace" "workspace" {
  name         = "tmrz-tfe-workspace"
  organization = tfe_organization.org.name
}

terraform {
  required_providers {
    github = {
      source  = "integrations/github"
      version = "~> 4.0"
    }
  }
}

# Configure the GitHub Provider
provider "github" {
  token = var.github_token
}

data "github_repository" "tfe" {
  full_name = "tmr-rz/tfe-aws"

}


resource "tfe_notification_configuration" "test" {
  name             = "my-test-notification-configuration"
  enabled          = true
  destination_type = "slack"
  triggers         = ["run:created", "run:planning", "run:errored"]
  url              = "https://hooks.slack.com/services/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"
  workspace_id     = "ws-1hTgnPtuGFsgPQnT"
}
