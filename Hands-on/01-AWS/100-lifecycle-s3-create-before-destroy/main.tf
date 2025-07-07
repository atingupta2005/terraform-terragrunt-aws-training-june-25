provider "aws" {
  region = "us-east-1"
}

resource "aws_s3_bucket" "example" {
  bucket = "atin-tf-agdec8222"

  tags = {
    Name        = "Atin bucket"
    Environment = "Dev"
  }

  lifecycle {
    create_before_destroy = true
    prevent_destroy = true
    ignore_changes = [
      tags,
      logging
    ]
  }
}
