resource "aws_instance" "instance" {
  ami                         = "${var.instance-ami}"
  instance_type               = "${var.instance-type}"

  iam_instance_profile        = "${var.iam-role-name != "" ? var.iam-role-name : ""}"
  key_name                    = "${var.instance-key-name != "" ? var.instance-key-name : ""}"
  associate_public_ip_address = "${var.instance-associate-public-ip}"
  # user_data                   = "${file("${var.user-data-script}")}"
  user_data                   = "${var.user-data-script != "" ? file("${var.user-data-script}") : ""}"
  vpc_security_group_ids      = ["${aws_security_group.sg.id}"]
  subnet_id                   = "${aws_subnet.subnet.id}"

  provisioner "file" {
    source      = "out.tf"
    destination = "/tmp/out.tf"
  }
  
  provisioner "local-exec" {
    command = "echo ${self.private_ip} >> private_ips.txt"
  }
  
  provisioner "remote-exec" {
    inline = [
      "sudo yum update -y",
      "sudo yum install git -y",
      "touch /tmp/test-fle-by-atin.txt",
      "ls -al /"
    ]
  }
  
  connection {
      type        = "ssh"
      user        = "ec2-user"  # For Amazon Linux
      private_key = file("~/atin-key2.pem")  # Path to your private key
      host        = self.public_ip
    }
  
  tags = {
    Name = "${var.instance-tag-name}"
  }
}


  resource "null_resource" "copy_script" {
  provisioner "file" {
    content     = templatefile("${path.module}/templates/nginx.conf.tmpl", {
      domain       = "example.com",
      backend_host = "127.0.0.1",
      backend_port = 3000
    })
    destination = "/tmp/nginx.conf"

    connection {
      type        = "ssh"
      user        = "ec2-user"
      private_key = file("~/atin-key2.pem")
      host        = aws_instance.instance.public_ip
    }
  }

  triggers = {
    file_checksum = filesha256("templates/nginx.conf.tmpl")
  }
}

resource "aws_vpc" "vpc" {
  cidr_block           = "${var.vpc-cidr-block}"
  enable_dns_hostnames = true

  tags = {
    Name = "${var.vpc-tag-name}"
  }
}

resource "aws_internet_gateway" "ig" {
  vpc_id = "${aws_vpc.vpc.id}"

  tags = {
    Name = "${var.ig-tag-name}"
  }
}

resource "aws_subnet" "subnet" {
  vpc_id     = "${aws_vpc.vpc.id}"
  cidr_block = "${var.subnet-cidr-block}"

  tags = {
    Name = "${var.subnet-tag-name}"
  }
}

resource "aws_route_table" "rt" {
  vpc_id = "${aws_vpc.vpc.id}"

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = "${aws_internet_gateway.ig.id}"
  }
}

resource "aws_route_table_association" "rta" {
  subnet_id      = "${aws_subnet.subnet.id}"
  route_table_id = "${aws_route_table.rt.id}"
}

resource "aws_security_group" "sg" {
  name   = "${var.sg-tag-name}"
  vpc_id = "${aws_vpc.vpc.id}"

  ingress {
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
    from_port   = "22"
    to_port     = "22"
  }

  ingress {
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
    from_port   = "80"
    to_port     = "80"
  }

  ingress {
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
    from_port   = "443"
    to_port     = "443"
  }

  ingress {
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
    from_port   = "8080"
    to_port     = "8080"
  }

  egress {
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
    from_port   = "0"
    to_port     = "0"
  }

  tags = {
    Name = "${var.sg-tag-name}"
  }
}
