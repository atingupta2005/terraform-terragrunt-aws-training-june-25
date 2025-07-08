# 🧠 Best Practices for Production-Like Terraform Code

## 🎯 Objective

Learn how to write **robust, scalable, and maintainable Terraform code** that is production-ready.
This guide focuses on **structure, quality, collaboration, security, and reusability**.

---

## 🧱 1. Project Structure and Organization

A well-organized Terraform project improves clarity and maintenance.

### ✅ Use a layered directory structure:

```
terraform/
├── modules/
│   ├── vpc/
│   ├── ec2/
│   └── rds/
├── environments/
│   ├── dev/
│   ├── stage/
│   └── prod/
├── main.tf
├── variables.tf
├── outputs.tf
```

### ✅ Separate concerns:

* **Modules** = reusable building blocks
* **Environments** = different `.tfvars` per stage (dev/stage/prod)
* Use `backend.tf` for remote state config

---

## 🧪 2. Input Variables and `terraform.tfvars`

Define clear, typed input variables.

```hcl
variable "instance_type" {
  description = "EC2 instance type"
  type        = string
  default     = "t3.micro"
}
```

Use `terraform.tfvars` or `dev.tfvars`, `prod.tfvars`, etc., for different settings.

```hcl
# dev.tfvars
instance_type = "t3.micro"
```

Run with:

```bash
terraform apply -var-file="dev.tfvars"
```

---

## 🔐 3. Secure Secrets Handling

**Never hard-code secrets or credentials** in Terraform files.

### ✅ Use these methods:

* **Environment variables** (`AWS_ACCESS_KEY_ID`, `AWS_SECRET_ACCESS_KEY`)
* **`terraform.tfvars` excluded from version control**
* Avoid committing `.tfstate` files to git

---

## 🔁 4. Use Remote State with Locking

Use a **backend** like S3 with DynamoDB for state locking.

```hcl
terraform {
  backend "s3" {
    bucket         = "my-terraform-state"
    key            = "envs/prod/terraform.tfstate"
    region         = "us-east-1"
    dynamodb_table = "terraform-locks"
  }
}
```

This ensures:

* **Team collaboration**
* **Locking prevents conflicts**
* **Reliable versioned storage**

---

## 🔄 5. Use Modules for Reusability

Avoid duplicating code across environments.

### ✅ Instead of this:

```hcl
resource "aws_vpc" "dev" { ... }
resource "aws_vpc" "stage" { ... }
```

### ✅ Do this:

```hcl
module "vpc" {
  source = "../modules/vpc"
  name   = "my-vpc"
  cidr   = "10.0.0.0/16"
}
```

---

## ✅ 6. Lifecycle and Resource Management

Use lifecycle blocks to control creation and destruction.

```hcl
lifecycle {
  prevent_destroy = true
  ignore_changes  = [user_data]
}
```

### 📌 Use Cases:

* Prevent accidental deletion (`prevent_destroy`)
* Skip unnecessary redeployments (`ignore_changes`)
* Control destroy order (`depends_on`)

---

## 📋 7. Validate and Format Code

Before applying changes, run:

```bash
terraform fmt -recursive   # Auto-format code
terraform validate         # Check for syntax/config errors
```

Use these in **CI pipelines** to enforce code quality.

---

## 🧪 8. Use `terraform plan` for Safe Changes

Always review before applying:

```bash
terraform plan -out=plan.tfplan
terraform apply plan.tfplan
```

This ensures:

* Full visibility
* Review approval flow
* Safer changes in teams

---

## 🧼 9. Clean and Clear Outputs

Keep outputs readable and minimal:

```hcl
output "app_url" {
  value       = "http://${aws_instance.web.public_ip}"
  description = "Public URL of the deployed app"
}
```

Avoid exposing secrets via outputs.

---

## 👥 10. Version Control & Collaboration

### ✅ Use Git Best Practices:

* Store only `.tf`, `.tfvars.example`, `.md`, and module files
* **Ignore**: `.terraform/`, `terraform.tfstate`, `*.tfvars`, `.backup`
* Use **branches + pull requests** for changes
* Document with `README.md`

---

## 📌 Summary Table

| Best Practice Area   | What to Do                                  |
| -------------------- | ------------------------------------------- |
| Project Structure    | Layered with modules and environments       |
| Input Variables      | Use types, descriptions, and tfvars         |
| Secrets Handling     | Avoid hard-coding, use SSM/IAM/env vars     |
| Remote State         | Use S3 + DynamoDB with locking              |
| Modules              | Extract reusable blocks                     |
| Lifecycle Management | Use `prevent_destroy`, `ignore_changes`     |
| Code Quality         | Run `fmt`, `validate`, use CI pipelines     |
| Change Safety        | Use `plan` before `apply`                   |
| Outputs              | Keep clean, avoid secrets                   |
| Git Workflow         | Version control, branches, .gitignore setup |

---
