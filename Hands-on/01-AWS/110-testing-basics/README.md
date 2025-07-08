# 🧪 Terraform Testing Basics: `validate`, `terraform fmt`, and Plan Check
---

## 🎯 Objective

Learn how to **test Terraform code** using built-in commands before deployment to ensure:

* Syntax is correct
* Code is well-formatted
* Changes are visible and controlled

These are essential **pre-apply checks** for safe, production-grade infrastructure.

---

## 🔍 Why Testing Terraform Code Matters

| Without Testing              | With Testing                    |
| ---------------------------- | ------------------------------- |
| Errors during apply          | Catch errors early              |
| Messy and inconsistent code  | Clean, team-friendly code       |
| Unpredictable infrastructure | Controlled and reviewed changes |

---

## 📦 Tools You'll Use

| Tool                 | Purpose                           |
| -------------------- | --------------------------------- |
| `terraform fmt`      | Auto-format code                  |
| `terraform validate` | Check syntax and config structure |
| `terraform plan`     | Preview changes before apply      |

---

## 🧪 1. `terraform fmt`: Format Your Code

### 📘 What It Does:

* Scans `.tf` files and reformats them to canonical style.
* Ensures consistent indentation, spacing, and braces.

### ▶️ Command:

```bash
terraform fmt -recursive
```

### 🧪 Example:

Before:

```hcl
resource "aws_instance" "demo"{ami="ami-0c02fb55956c7d316"instance_type="t2.micro"}
```

After `terraform fmt`:

```hcl
resource "aws_instance" "demo" {
  ami           = "ami-0c02fb55956c7d316"
  instance_type = "t2.micro"
}
```

### ✅ Best Practice:

* Run this before every commit
* Use with **pre-commit hooks** or CI checks

---

## 🧪 2. `terraform validate`: Syntax and Logical Structure Check

### 📘 What It Does:

* Verifies that all Terraform files are **syntactically valid**
* Checks that **resource references** and configurations make sense

### ▶️ Command:

```bash
terraform validate
```

### 🔍 What It Catches:

* Typing mistakes
* Incorrect resource arguments
* Missing required values
* Uninitialized variables (with no default)

### 🧪 Example:

```hcl
resource "aws_instance" "web" {
  ami           = "ami-xyz" # Invalid
  instance_type = "t2.micro"
  invalid_key   = "oops"     # Invalid key
}
```

`terraform validate` output:

```
Error: Unsupported argument
  on main.tf line 5, in resource "aws_instance" "web":
  5:   invalid_key = "oops"
An argument named "invalid_key" is not expected here.
```

### ✅ Best Practice:

* Run this after every `.tf` file change
* Add to CI/CD pipeline before merge

---

## 🧪 3. `terraform plan`: Show Proposed Changes

### 📘 What It Does:

* Compares the desired infrastructure (from `.tf`) with the actual infrastructure (from the state)
* Shows what will **change, be created, or be destroyed**

### ▶️ Command:

```bash
terraform plan -out=tfplan.out
```

This:

* Shows a human-readable diff
* Saves an execution plan (`tfplan.out`) for applying later

### 🧪 Example Output:

```
  # aws_instance.web will be created
  + resource "aws_instance" "web" {
      + ami           = "ami-0c02fb55956c7d316"
      + instance_type = "t2.micro"
      ...
    }
```

### ✅ Best Practice:

* Always run before `terraform apply`
* Use `-out` to save and reuse plans in pipelines or audits
* Share plan output in pull requests for visibility

---

## ⚙️ Putting It All Together in Workflow

```bash
terraform init
terraform fmt -recursive
terraform validate
terraform plan -out=tfplan.out
```

Add this to your dev script, Makefile, or CI config.

---

## ✅ Summary Table

| Command              | Purpose                   | When to Run            |
| -------------------- | ------------------------- | ---------------------- |
| `terraform fmt`      | Format `.tf` files        | Before commit / CI run |
| `terraform validate` | Syntax/config correctness | After changes to code  |
| `terraform plan`     | Preview changes           | Before every `apply`   |

---

