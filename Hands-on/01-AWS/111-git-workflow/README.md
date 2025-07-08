# 🔁 Using `terraform fmt`, `validate`, and `plan` in a Git Workflow
## 🎯 Objective

Learn how to integrate the following Terraform commands into your **Git workflow** for quality assurance:

* `terraform fmt` – for formatting
* `terraform validate` – for syntax correctness
* `terraform plan` – for change previews

We will implement this through:

* Manual usage in local Git development
* Automation with **Git pre-commit hooks**
* Integration in **CI/CD pipeline (GitHub Actions)**

---

## 🧱 Project Structure Example

```bash
terraform-git-workflow/
├── main.tf
├── variables.tf
├── outputs.tf
├── .gitignore
├── .pre-commit-config.yaml
└── .github/
    └── workflows/
        └── terraform.yml
```

---

## 🧪 1. Local Git-Based Terraform Workflow

### 🛠️ Commands to run before committing:

```bash
terraform fmt -recursive     # Format code
terraform validate           # Validate config syntax
terraform plan -out=plan.out # Preview infrastructure changes
```

### 📝 Example Git usage:

```bash
git checkout -b feature/add-vpc
terraform fmt -recursive
terraform validate
terraform plan -out=tfplan.out
git add .
git commit -m "Add VPC module and validate changes"
git push origin feature/add-vpc
```

This ensures code is **clean**, **valid**, and **reviewable** before it goes into the main branch.

---

## 🧪 2. Automate with Git Pre-Commit Hooks

### 🔹 Step 1: Install `pre-commit`

```bash
pip install pre-commit
pre-commit install
```

### 🔹 Step 2: Create `.pre-commit-config.yaml`

```yaml
repos:
  - repo: https://github.com/antonbabenko/pre-commit-terraform
    rev: v1.77.0
    hooks:
      - id: terraform_fmt
      - id: terraform_validate
```

This ensures `fmt` and `validate` are run automatically **before every Git commit**.

### 🔹 Step 3: Initialize pre-commit

```bash
pre-commit install
pre-commit run --all-files
```

Now whenever you run:

```bash
git commit -m "message"
```

Terraform `fmt` and `validate` will run first. If validation fails, the commit is blocked.

---

## 🚀 3. GitHub Actions CI: Auto-Run on Pull Request

You can automate `fmt`, `validate`, and `plan` as part of your **CI pipeline**.

### 🔹 Step 1: Create GitHub workflow file

**`.github/workflows/terraform.yml`**

```yaml
name: Terraform CI

on:
  pull_request:
    branches:
      - main

jobs:
  terraform:
    name: Validate Terraform Code
    runs-on: ubuntu-latest

    steps:
      - name: Checkout repo
        uses: actions/checkout@v3

      - name: Setup Terraform
        uses: hashicorp/setup-terraform@v2
        with:
          terraform_version: 1.6.6

      - name: Terraform Init
        run: terraform init

      - name: Terraform Format Check
        run: terraform fmt -check -recursive

      - name: Terraform Validate
        run: terraform validate

      - name: Terraform Plan
        run: terraform plan
```

### 🔹 Step 2: Commit and push

```bash
git add .github/workflows/terraform.yml
git commit -m "Add Terraform CI workflow"
git push origin feature/add-ci
```

Now every pull request will:

* **Reject unformatted code**
* **Stop on syntax/config errors**
* **Show plan output as preview**

---

## 📘 Recommended Git Workflow Summary

| Step | Command / Action                 | Purpose                             |
| ---- | -------------------------------- | ----------------------------------- |
| 1️⃣  | `terraform fmt -recursive`       | Keep code consistent                |
| 2️⃣  | `terraform validate`             | Catch syntax/config errors          |
| 3️⃣  | `terraform plan -out=tfplan.out` | Preview changes                     |
| 4️⃣  | `git commit`                     | Store clean code                    |
| 5️⃣  | Pre-commit / CI                  | Automate testing on every commit/PR |

---

## ✅ Best Practices

| Best Practice                    | Why It Matters                             |
| -------------------------------- | ------------------------------------------ |
| Use `fmt` on every commit        | Enforces style in team projects            |
| Use `validate` before apply      | Prevents avoidable runtime failures        |
| Use `plan` before apply or merge | Ensures safe and reviewable infrastructure |
| Use pre-commit hooks             | Block bad commits early                    |
| Use CI (GitHub/GitLab)           | Enforce quality across the team            |

---

## 🧠 Bonus: Team Review with Plan Output

In pull requests, paste the result of:

```bash
terraform plan -out=tfplan.out
terraform show tfplan.out
```

So reviewers can see what will change before applying.

---

## ✅ Final Output Example in CI:

```
Terraform has been successfully initialized!
Success! The configuration is valid.
No changes. Infrastructure is up-to-date.
```

