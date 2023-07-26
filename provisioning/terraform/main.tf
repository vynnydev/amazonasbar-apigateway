provider "aws" {
  region = var.region

  # Make it faster by skipping checks
  # skip_get_ec2_platforms      = true
  skip_metadata_api_check     = true
  skip_region_validation      = true
  skip_credentials_validation = true
  skip_requesting_account_id  = false
}

resource "random_pet" "stack" {
  prefix = var.stack_prefix
  length = 2
}

data "aws_caller_identity" "current" {
}

data "aws_iam_policy" "boundary" {
  count = var.use_permissions_boundary ? 1: 0
  arn = "arn:aws:iam::${data.aws_caller_identity.current.account_id}:policy/${var.permissions_boundary_policy}"
}