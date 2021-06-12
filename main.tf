variable "region" {
  type    = string
  default = "us-east-1"
}

variable "name" {
  type    = string
  default = "nomatic-stack"
}

variable "tag" {
  type    = string
  default = "nomatic-stack"
}

provider "aws" {
  region  = var.region
}

resource "aws_s3_bucket" "state_bucket" {
  bucket = "${var.name}-state"
  acl    = "private"

  versioning {
    enabled = true
  }

  server_side_encryption_configuration {
    rule {
      apply_server_side_encryption_by_default {
        sse_algorithm = "AES256"
      }
    }
  }

  tags = {
    Name = var.tag
  }
}

resource "aws_dynamodb_table" "terraform_locks" {
  name         = "${var.name}-lock"
  billing_mode = "PAY_PER_REQUEST"
  hash_key     = "LockID"
  attribute {
    name = "LockID"
    type = "S"
  }
}

output "bucket-name" {
  value = aws_s3_bucket.state_bucket.id
}

output "bucket-domain" {
  value = aws_s3_bucket.state_bucket.bucket_domain_name
}

output "table-name" {
  value = aws_dynamodb_table.terraform_locks.id
}