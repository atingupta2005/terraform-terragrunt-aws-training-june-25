provider "aws" {
}

resource "aws_instance" "example" {
  ami           = "ami-03598bf9d15814511"  # Amazon Linux 2 (change as needed)
  instance_type = var.instance_type

  tags = {
    Name = "ec2-${terraform.workspace}"
    Env  = terraform.workspace
  }
}
