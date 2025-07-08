# 🛠️ Terraform Hands-On: Managing Dependencies with `depends_on`

---

## 🎯 Objective

Understand how and when to use the **`depends_on`** meta-argument in Terraform to:

* Control **execution order** between resources
* Handle **indirect or hidden dependencies**
* Avoid **race conditions** in provisioning
* Ensure correct **create/destroy sequencing**

---

## 📘 Background

Terraform usually **automatically detects dependencies** between resources by examining **interpolations** (e.g., when one resource refers to the `id` of another).

But sometimes, dependencies are **not obvious**, especially when:

* Using **provisioners** (like `remote-exec`)
* Relying on **side effects**
* Dealing with **external resources**
* Using **modules, null\_resources, or templates**

In these cases, we need **`depends_on`** to make dependencies **explicit**.

---

## 📌 Key Syntax

```hcl
resource "resource_type" "name" {
  ...
  depends_on = [resource_type.other_resource]
}
```

---

## 🧪 Hands-On Scenario

### Goal:

Provision an EC2 instance and **run a custom provisioning script** **only after** a security group is created.

Even if the script **does not directly reference** the security group, we want Terraform to **wait** for it.

---

## 📁 Project Layout

```
terraform-depends-on-demo/
├── main.tf
├── outputs.tf
└── provision.sh.tpl
```

---

## 🔹 1. `main.tf` (Core Logic)

```hcl
provider "aws" {
  region = "us-east-1"
}

# Create Security Group
resource "aws_security_group" "web_sg" {
  name        = "web-sg"
  description = "Allow HTTP"
  vpc_id      = "vpc-xxxxxxxx"  # Replace with actual VPC ID

  ingress {
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}

# Create EC2 instance (uses SG so it already depends on it)
resource "aws_instance" "web" {
  ami           = "ami-0c02fb55956c7d316"
  instance_type = "t2.micro"
  key_name      = "your-key-name"
  vpc_security_group_ids = [aws_security_group.web_sg.id]

  tags = {
    Name = "depends-on-instance"
  }
}

# Provisioning step using null_resource (no automatic dependency)
resource "null_resource" "provision" {
  provisioner "local-exec" {
    command = "echo 'Provisioning tasks complete.'"
  }

  # Explicitly depend on EC2 and Security Group
  depends_on = [
    aws_instance.web,
    aws_security_group.web_sg
  ]
}
```

---

## 🔹 2. `outputs.tf`

```hcl
output "ec2_instance_id" {
  value = aws_instance.web.id
}
```

---

## 🔍 Without `depends_on`

If you **remove the `depends_on`** block from the `null_resource`, Terraform **may run the local-exec provisioner too early**, especially if it doesn’t detect any interpolations.

This could lead to:

* Commands failing because EC2 isn't ready
* Custom logic running before infrastructure is ready

---

## ✅ With `depends_on`

Terraform will **strictly enforce order**:

1. Create the Security Group
2. Launch the EC2 instance using the SG
3. Run the `null_resource` after both are complete

---

## 🧠 Key Use Cases for `depends_on`

| Situation                                       | Why Use `depends_on`                                    |
| ----------------------------------------------- | ------------------------------------------------------- |
| Using provisioners with no direct references    | To delay provisioning until resource is fully available |
| Using `null_resource` to trigger external steps | To force execution order                                |
| Working with modules                            | To ensure one module runs after another                 |
| Ensuring destroy order                          | Terraform destroys in reverse dependency order          |
| When implicit dependencies don't exist          | e.g., no attribute references                           |

---

## 🔁 Destroy Behavior

Terraform destroys **in reverse order of dependencies**.
So with `depends_on`, it will:

1. Destroy `null_resource`
2. Then `aws_instance.web`
3. Then `aws_security_group.web_sg`

This is essential to avoid **resource-in-use errors**.

---


## ✅ Summary

| Concept       | Description                                    |
| ------------- | ---------------------------------------------- |
| `depends_on`  | Explicitly declares the dependency order       |
| Implicit deps | Terraform handles automatically via references |
| Provisioners  | Often require `depends_on` to run correctly    |
| Destruction   | Respects reverse dependency order              |
| Use carefully | Overuse can hurt maintainability               |
