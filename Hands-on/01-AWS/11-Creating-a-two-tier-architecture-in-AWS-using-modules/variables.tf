# --- root/variables.tf ---

variable "aws_region" {
   default = "us-east-1"
}

variable "access_ip" {
  type  = string
  default = "0.0.0.0/0"
}
