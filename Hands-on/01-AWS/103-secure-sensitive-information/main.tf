provider "aws" {
}

resource "aws_db_instance" "example" {
  allocated_storage    = 20
  engine               = "mysql"
  engine_version       = "8.0"
  instance_class       = "db.t3.micro"
  db_name                 = "mydb"
  username             = var.db_username
  password             = var.db_password
  skip_final_snapshot  = true

  tags = {
    Name = "secure-env-demo-db"
  }
}
