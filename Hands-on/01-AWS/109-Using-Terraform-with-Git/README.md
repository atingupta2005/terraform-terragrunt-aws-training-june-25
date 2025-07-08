# 🔧 Using Terraform with Git (Version Control Best Practices)

## 🎯 Objective

Learn how to use **Git** effectively with **Terraform** to enable:

* Team collaboration
* Safe and versioned infrastructure changes
* Integration into CI/CD workflows

---

## 📘 Why Use Git with Terraform?

| Without Git                | With Git                            |
| -------------------------- | ----------------------------------- |
| Hard to track changes      | Full history of infrastructure code |
| No team visibility         | Easy collaboration                  |
| Risk of accidental changes | Pull request reviews                |
| Manual rollback (if any)   | Rollback to any commit/version      |

---

## 🧱 1. Recommended Terraform Project Structure with Git

```bash
terraform-infra/
├── modules/                 # Reusable building blocks
│   ├── vpc/
│   └── ec2/
├── environments/            # Separate folders for dev, stage, prod
│   ├── dev/
│   │   ├── main.tf
│   │   ├── variables.tf
│   │   └── terraform.tfvars
│   └── prod/
├── backend.tf               # Backend config for remote state
├── README.md
├── .gitignore
└── .terraform.lock.hcl      # Provider version lock file
```

---

## 🛡️ 2. Essential `.gitignore` Setup

Create a `.gitignore` file to exclude sensitive and system files:

```bash
# Terraform directories
.terraform/
*.tfstate
*.tfstate.backup

# Sensitive variable files
*.tfvars
*.tfvars.json

# Logs and plans
crash.log
*.tfplan

# MacOS/Linux/IDE junk
.DS_Store
.idea/
.vscode/
```

✅ This avoids pushing secrets, state files, and transient data to Git.

---

## 💼 3. Git Best Practices for Terraform

### ✅ Track Only Source Code

Track only these:

* `*.tf`, `*.tf.json`, `*.tfvars.example`
* `modules/`
* `README.md`
* `backend.tf`, `.terraform.lock.hcl`

Avoid tracking:

* `.terraform/`
* Actual `.tfvars` files (use example files instead)
* `.tfstate` and backup files

---

### ✅ Use `terraform fmt` and `validate` Before Every Commit

```bash
terraform fmt -recursive
terraform validate
```

---

### ✅ Commit Messages Example

```bash
git commit -m "Add VPC module with CIDR input"
```

Good messages = Better team communication + Git history

---

### ✅ Branching and Pull Requests

1. Work on a **feature branch**:

   ```bash
   git checkout -b feature/add-vpc
   ```

2. Make changes

3. Run `terraform plan` and `validate`

4. Commit and push:

   ```bash
   git push origin feature/add-vpc
   ```

5. Create a **pull request (PR)**

6. Team reviews the plan and `.tf` changes before merging

---

## 🔁 4. Terraform Workflow with Git

### Typical Team Flow:

```text
🧑‍💻 Developer clones repo
🔧 Creates a feature branch
✍️ Makes infrastructure changes
🧪 Runs `terraform plan`, `fmt`, `validate`
🆙 Commits and pushes code to Git
🔍 Team reviews and merges PR
🚀 CI/CD may auto-apply changes or run post-merge plan
```

---

