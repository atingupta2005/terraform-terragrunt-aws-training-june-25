variable "aws_region" {
  description = "The AWS region"
  type        = string
  default     = "us-east-1"
}

variable "AMI" {
    type = map

    default = {
        eu-west-2 = "ami-03dea29b0216a1e03"
        us-east-1 = "ami-0c2a1acae6667e438"
    }
}


variable "PUBLIC_KEY_PATH" {
  type = string

  default = "ssh-keys"

}
