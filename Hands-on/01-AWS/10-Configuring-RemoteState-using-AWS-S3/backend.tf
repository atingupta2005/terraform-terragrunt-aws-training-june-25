# backend.tf

# store the terraform.tfstate file in an s3 bucket with STATE LOCK enabled
terraform {
    backend "s3" {
        bucket         = "atin-tf-remote-state-s3-bucket"
        key            = "terraform.tfstate"
        region         = "us-east-1"
        dynamodb_table = "s3-state-lock"      # Create table with partition key - LockID
    }
}
