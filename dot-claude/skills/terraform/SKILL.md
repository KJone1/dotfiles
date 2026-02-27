---
name: terraform
description: Expert guidance for Terraform development, testing, and architecture.
user-invocable: false
---

# Terraform Standards

## Development Workflow

<rules>
<rule>
NEVER apply/destroy/plan → validate/fmt only.
<example>
<intent>Verify configuration without execution.</intent>
<rationale>Safety first; only use non-destructive commands to validate logic.</rationale>
<good_example>
user: Check if my terraform is correct.
assistant: [run_shell_command(command="terraform validate && terraform fmt -check")]
explanation: Uses non-destructive validation and formatting checks to ensure code quality without risking infrastructure changes.
</good_example>
<bad_example>
user: Check if my terraform is correct.
assistant: [run_shell_command(command="terraform plan")]
explanation: Running a plan can be slow and may require active credentials/state access that isn't necessary for a simple syntax check.
</bad_example>
</example>
</rule>

<rule>
Init ALWAYS with `-upgrade` flag.
<example>
<intent>Initialize with latest provider versions.</intent>
<rationale>Ensures the environment uses the most recent compatible providers and modules.</rationale>
<good_example>
user: Initialize this directory.
assistant: [run_shell_command(command="terraform init -upgrade")]
explanation: The -upgrade flag ensures that all providers and modules are updated to the latest versions within the specified constraints.
</good_example>
<bad_example>
user: Initialize this directory.
assistant: [run_shell_command(command="terraform init")]
explanation: Standard init may use stale cached providers, missing critical bug fixes or features.
</bad_example>
</example>
</rule>

<rule>
Mirror existing project patterns → check for existing modules, similar resources, and conventions (naming, tagging, structure) before implementing.
<example>
<intent>Mirror existing project patterns and conventions.</intent>
<rationale>Consistency reduces cognitive load and prevents architectural drift by reusing established patterns and modules.</rationale>
<good_example>
user: Add a new S3 bucket.
assistant: [glob(pattern="**/modules/**/s3*")]
[grep_search(pattern="resource \"aws_s3_bucket\"")]
explanation: Identifies an existing S3 module and follows established naming and tagging conventions (e.g., 'Environment' and 'Owner' tags).
</good_example>
<bad_example>
user: Add a new S3 bucket.
assistant: resource "aws_s3_bucket" "my_new_bucket" { ... }
explanation: Creates a raw resource without checking for existing modules or following project-specific tagging standards.
</bad_example>
</example>
</rule>

<rule>
Verification lifecycle → Build, Lint, and Test before reporting completion.
<example>
<intent>Complete the full verification cycle.</intent>
<rationale>Ensures code quality and functional correctness before delivery.</rationale>
<good_example>
user: I've updated the module.
assistant: [run_shell_command(command="terraform validate && tflint && terraform test")]
explanation: Executes a comprehensive suite of checks (syntax, linting, and functional tests) to guarantee the change is correct.
</good_example>
<bad_example>
user: I've updated the module.
assistant: I have updated the files. You can now run terraform plan.
explanation: Reports completion without verifying that the new code is syntactically correct or follows linting rules.
</bad_example>
</example>
</rule>

<rule>
Validate schemas with Web Search or Provider Documentation → Search provider docs → Get resource schema → Identify block types.
</rule>
</rules>

## Error Solving

<rule>
Root cause first → address underlying IaC issues (e.g., circular dependencies, hardcoded values), not symptoms.
<example>
<intent>Fix the source of a configuration error.</intent>
<rationale>Addressing symptoms leads to technical debt and recurring errors.</rationale>
<good_example>
user: The module fails because the VPC ID is hardcoded for the wrong region.
assistant: [grep_search(pattern="vpc-0a1b2c3d4e5f6g7h8")]
explanation: Locates the hardcoded VPC ID and replaces it with a dynamic data source or variable to ensure regional compatibility.
</good_example>
<bad_example>
user: The module fails because the VPC ID is hardcoded for the wrong region.
assistant: I will create a new VPC in this region so the module works.
explanation: Creates redundant infrastructure instead of fixing the underlying configuration error.
</bad_example>
</example>
</rule>

## Data Source Preference

<rule>
ALWAYS use `data` sources instead of hardcoded IDs for existing infrastructure (e.g., VPCs, Subnets) to ensure environment portability.
<example>
<intent>Validate resource schema before implementation.</intent>
<rationale>Prevents syntax errors and incorrect block usage by verifying the provider's expected schema.</rationale>
<good_example>
user: Add a lifecycle rule to this S3 bucket to transition to Glacier after 30 days.
assistant: [google_web_search(query="terraform aws_s3_bucket lifecycle_rule schema")]
explanation: Verifies the exact block structure and attribute names from official documentation before writing code.
</good_example>
<bad_example>
user: Add a lifecycle rule to this S3 bucket to transition to Glacier after 30 days.
assistant: resource "aws_s3_bucket" "this" {
  lifecycle_rule = {
    transition = "GLACIER"
    days = 30
  }
}
explanation: Guesses the schema, leading to potential syntax errors (e.g., using an object instead of a block or incorrect attribute names).
</bad_example>
</example>
</rule>

## Configuration Standards

### Backend Configuration

<rules>
<rule>
ALWAYS require remote state configuration in `terraform {}` blocks.
</rule>
<rule>
NEVER allow local `.tfstate` files in production-ready code.
<example>
<intent>Configure a secure remote backend.</intent>
<rationale>Prevents state loss and enables collaboration by storing state in a shared, versioned location.</rationale>
<good_example>
terraform {
  backend "s3" {
    bucket         = "my-terraform-state"
    key            = "global/s3/terraform.tfstate"
    region         = "us-east-1"
    dynamodb_table = "terraform-locks"
    encrypt        = true
  }
}
explanation: Uses a remote S3 backend with state locking via DynamoDB for safety and collaboration.
</good_example>
<bad_example>
# No backend block defined
explanation: Defaults to local state, which is risky for team environments and production infrastructure.
</bad_example>
</example>
</rule>
</rules>

### Functional Validation (1.5+)

<rules>
<rule>
Use `check` blocks for continuous functional validation of infrastructure health.
</rule>
<rule>
The data block fetches information that you can reference in expressions in the assert block's condition argument.
</rule>
<rule>
Defining a data block in a check block is optional. You can only reference a nested data source within its parent check block.
</rule>
<rule>
If a nested data source's provider raises errors, they are masked as warnings and do not prevent the Terraform operation from continuing.
<example>
<intent>Implement functional health checks using scoped data sources.</intent>
<rationale>Ensures that infrastructure is not only deployed but also performing as expected, with errors in checks not blocking the main operation.</rationale>
<good_example>
check "web_server_health" {
  data "http" "this" {
    url = "https://${aws_instance.web.public_ip}"
  }

  assert {
    condition     = data.http.this.status_code == 200
    error_message = "Web server is not responding with 200 OK."
  }
}
explanation: Uses a check block with a nested data source to verify the actual availability of the deployed service.
</good_example>
<bad_example>
# No functional validation
explanation: Relies solely on resource creation success without verifying service health.
</bad_example>
</example>
</rule>
</rules>

## Code Structure Standards

### Resource Block Ordering

<rule>
Strict ordering for consistency:
1. `count` or `for_each` FIRST (blank line after)
2. Other arguments (alphabetical or logical grouping)
3. `tags` as last real argument
4. `depends_on` after tags
5. `lifecycle` at the very end
<example>
<intent>Maintain consistent resource block structure.</intent>
<rationale>Improves readability and ensures meta-arguments are easily visible.</rationale>
<good_example>
resource "aws_instance" "web" {
  count = var.create_instance ? 1 : 0

  ami           = data.aws_ami.ubuntu.id
  instance_type = "t3.micro"

  tags = {
    Name = "web-server"
  }

  lifecycle {
    create_before_destroy = true
  }
}
explanation: Follows a predictable order, placing meta-arguments like 'count' and 'lifecycle' at the boundaries.
</good_example>
<bad_example>
resource "aws_instance" "web" {
  ami           = data.aws_ami.ubuntu.id
  tags = { Name = "web-server" }
  count = var.create_instance ? 1 : 0
  instance_type = "t3.micro"
}
explanation: Mixing meta-arguments with resource-specific arguments makes the configuration harder to scan.
</bad_example>
</example>
</rule>

### Variable Definition Structure

<rules>
<rule>
Variable block ordering:
1. `description` (ALWAYS required; must be a meaningful sentence, not a repetition of the name)
2. `type`
3. `default`
4. `sensitive`
5. `nullable`
6. `validation`
</rule>
<rule>
Documentation Quality: The `description` must be a meaningful sentence, not just a repetition of the variable name.
<example>
<intent>Define robust variables with validation.</intent>
<rationale>Provides clear documentation and enforces strict input constraints.</rationale>
<good_example>
variable "environment" {
  description = "Deployment environment name."
  type        = string
  default     = "dev"
  nullable    = false

  validation {
    condition     = contains(["dev", "staging", "prod"], var.environment)
    error_message = "Environment must be one of: dev, staging, prod."
  }
}
explanation: Follows the strict ordering and includes all necessary metadata and validation.
</good_example>
<bad_example>
variable "env" {
  type = string
  validation { ... }
  description = "env"
}
explanation: Missing mandatory description quality, incorrect ordering, and lacks nullable/default specifications.
</bad_example>
</example>
</rule>
</rules>

### Output Structure

<rules>
<rule>
Pattern: `{name}_{type}_{attribute}`. Omit `this_` prefix. Use plural for lists.
</rule>
<rule>
Examples: `vpc_main_id`, `web_server_private_ip`, `public_subnet_ids`.
<example>
<intent>Standardize output naming.</intent>
<rationale>Consistent output names make module consumption predictable.</rationale>
<good_example>
output "security_group_id" {
  description = "The ID of the security group"
  value       = try(aws_security_group.this[0].id, "")
}

output "public_subnet_ids" {
  description = "List of IDs of public subnets"
  value       = aws_subnet.public[*].id
}
explanation: Uses clear, descriptive names without redundant prefixes and follows the pluralization rule for lists.
</good_example>
<bad_example>
output "this_security_group_id" {
  value = aws_security_group.this[0].id
}
explanation: Uses redundant 'this_' prefix and lacks a description.
</bad_example>
</example>
</rule>
</rules>

## Iteration Logic: Count vs For_Each

<rule>
Use `count` for: Boolean toggles (`var.enabled ? 1 : 0`) or simple numeric replication.
Use `for_each` for: Collections where items may be reordered/removed, or when stable resource addresses are required.
<example>
<intent>Use for_each for stable resource addressing.</intent>
<rationale>Prevents unnecessary resource recreation when items are reordered or removed from a list.</rationale>
<good_example>
resource "aws_subnet" "private" {
  for_each = toset(var.availability_zones)

  vpc_id            = aws_vpc.this.id
  availability_zone = each.key
}
explanation: Map-based iteration ensures that each subnet has a stable unique identifier in the state.
</good_example>
<bad_example>
resource "aws_subnet" "private" {
  count = length(var.availability_zones)

  vpc_id            = aws_vpc.this.id
  availability_zone = var.availability_zones[count.index]
}
explanation: List-based iteration causes all subsequent resources to be recreated if an item is removed from the middle of the list.
</bad_example>
</example>
</rule>

## Dependency Management

<rule>
Use `locals` + `try()` to hint explicit resource deletion order and avoid brittle `depends_on`.
<example>
<intent>Manage complex dependencies via locals.</intent>
<rationale>Ensures correct resource deletion order (e.g., subnets before secondary CIDR) without explicit depends_on.</rationale>
<good_example>
locals {
  vpc_id = try(
    aws_vpc_ipv4_cidr_block_association.this[0].vpc_id,
    aws_vpc.this.id,
    ""
  )
}

resource "aws_subnet" "public" {
  vpc_id = local.vpc_id
}
explanation: Uses a local variable to create a functional dependency that Terraform uses to determine the correct destruction order.
</good_example>
<bad_example>
resource "aws_subnet" "public" {
  vpc_id     = aws_vpc.this.id
  depends_on = [aws_vpc_ipv4_cidr_block_association.this]
}
explanation: Explicit depends_on is brittle and can make the dependency graph harder to manage.
</bad_example>
</example>
</rule>

## Modern Terraform Features (1.0+)

<rule>
Use modern functions and blocks:
- `try()` → Safe fallbacks.
- `optional()` → Optional object attributes with defaults (1.3+).
- `moved` → Refactor without destroy/recreate (1.1+).
- `provider functions` → Provider-specific transformation (1.8+).
- `cross-variable validation` → Validate relationships between variables (1.9+).
- `write-only arguments` → Secrets never stored in state (1.11+).
<example>
<intent>Use modern Terraform features for better validation and refactoring.</intent>
<rationale>Modern features improve code safety, maintainability, and secret handling.</rationale>
<good_example>
variable "storage_size" {
  type = number
  validation {
    condition     = var.instance_type == "t3.micro" ? var.storage_size <= 100 : true
    error_message = "Micro instances limited to 100GB."
  }
}

moved {
  from = aws_instance.old_name
  to   = aws_instance.new_name
}
explanation: Uses cross-variable validation (1.9+) and moved blocks (1.1+) for robust configuration and safe refactoring.
</good_example>
<bad_example>
# No validation between variables
# Manual state mv commands for renaming
explanation: Lacks automated validation and requires manual, error-prone state manipulation.
</bad_example>
</example>
</rule>

## Version Management

<rules>
<rule>
Versioning strategy:
- Terraform core → Pin minor version (`~> 1.9`).
- Providers → Pin major version (`~> 5.0`).
- Modules → Pin exact version in production (`5.1.2`).
</rule>
<rule>
Use `.terraform.lock.hcl` and commit it to source control.
<example>
<intent>Implement a stable versioning strategy.</intent>
<rationale>Prevents breaking changes from unexpected updates while allowing for patch/minor improvements.</rationale>
<good_example>
terraform {
  required_version = "~> 1.9"
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 5.0"
    }
  }
}
explanation: Uses pessimistic constraints to balance stability and updates.
</good_example>
<bad_example>
terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = ">= 4.0"
    }
  }
}
explanation: Using '>= 4.0' is risky as it allows major version upgrades (e.g., 5.0) which may contain breaking changes.
</bad_example>
</example>
</rule>
</rules>