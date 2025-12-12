---
name: terraform
description: Comprehensive guidelines for creating, editing, and managing Terraform/OpenTofu configurations. Covers modern IaC patterns, module design, state management, security, and multi-environment setups. Applied when creating, modifying, or reviewing Terraform files (`.tf`, `.tfvars`).
---

## CRITICAL CONSTRAINTS

- NEVER apply/destroy → ONLY plan/validate
- Write configs NOT deploy
- MUST analyze project first → match structure, style, naming, conventions exactly
- Mirror existing patterns

## Repository Organization

### Dual Strategy

Service-First (Root):
- `/jfrog`, `/github`, `/coralogix`, `/hex`, `/snowflake`, `/okta`, `/opsgenie`, `/open-ai`, `/sentra`, `/mapbox`, `/doit`, `/arcgis` → cross-environment
- `/aws`, `/azure` → cloud-specific
- `/modules` → reusable local
- `/org` → GCP org-level (policies, custom roles, SAs)
- `/iam` → global IAM
- `/dns_zones`, `/domains` → DNS

Environment-First (`/us`):
- `/us/{dev|staging|prod}/app-infra/{service}/` → service-specific
  - Services: `analysts`, `bi`, `dps`, `feedx`, `gtm`, `guru`, `incubation`, `ingestion`, `insights-analyst`, `marketing`, `mip`, `octo`, `poi`, `retail-sales`
- `/us/{dev|staging|prod}/infra/{component}/` → shared
  - Components: `jenkins`, `databricks`, `vault`, `k8s`, `artifact-registry`, `mlflow`, `grafana`, `holmesgpt`
- `/us/{dev|staging|prod}/buckets/{service}/` → GCS buckets
- `/us/{dev|staging|prod}/hierarchy/{project}/` → GCP projects
- `/us/network/` → shared VPC (env-agnostic)
- `/us/certificates/` → SSL

Cell Architecture:
- Each dir = independent root module
- Isolated state per component
- `/us/{env}` → env-specific, root → cross-env

## State Management

Backend (GCS only):
```hcl
terraform {
  backend "gcs" {
    bucket = "placer-terraform-boot-bucket"
    prefix = "<path-matching-directory>"
  }
}
```

Examples:
- `/dns_zones/` → `"dns_zones"`
- `/us/dev/infra/holmesgpt/` → `"dev/infra/holmesgpt"`
- `/us/prod/app-infra/guru/quota-management/postgres/` → `"prod/app-infra/guru/quota-management/postgres"`

Rules:
- Prefix mirrors directory path
- Isolated per component
- No shared state

## Naming

Service Accounts: `<service>-<env>-<purpose>-sa`
```
bi-dev-scheduledqs-sa@bi-dev-services.iam.gserviceaccount.com
guru-composer-sa@guru-dev-services.iam.gserviceaccount.com
```

Projects: `{service}-{env}-services`
```
placer-management-services
bi-dev-services
guru-prod-services
```

Resources: `{service}_{component}`
```hcl
resource "google_service_account" "doit_cmp_sa" { ... }
```

Databases: `${app_name}-db`
```hcl
locals { app_name = "quota-management" }
module "pgsql" { name = "${local.app_name}-db" }
```

## Providers

Primary:
- GCP → main cloud
- Vault → secrets (`https://vault-prod.placer.team/`)

Cloud: AWS, Azure, Snowflake, Databricks

Platform: Okta, GitHub, Artifactory, Airflow, Kafka, Kubernetes, OpenAI, Coralogix, Opsgenie, DNSimple

Version Constraints:
```hcl
version = "< 7.9"                    # Upper bound (preferred)
version = ">= 0.9.1, < 1.0.0"        # Range
version = "2.9.0"                    # Exact
```

Aliases:
```hcl
provider "snowflake" { alias = "snowflake_aws" }
provider "snowflake" { alias = "snowflake_gcp" }
provider "aws" { alias = "org" }
```

## Modules

Structure:
```
/modules/{name}/
  main.tf
  variables.tf
  outputs.tf
  providers.tf
  locals.tf
```

Sourcing:
```hcl
# External versioned
source = "git@github.com:placer-engineering/placer-terraform-mod-gke.git?ref=2.15.0"
source = "git@github.com:placer-engineering/terraform-google-composer.git//modules/create_environment_v2?ref=v4.0.2"

# Local
source = "../../../modules/openai-project-key"
```

Wrapping (local wraps external):
```hcl
# /modules/google-composer/main.tf
module "composer_environment_v2" {
  source = "git@github.com:placer-engineering/terraform-google-composer.git//modules/create_environment_v2?ref=v4.0.2"
}
```

Database:
```hcl
module "pgsql" {
  source = "git@github.com:placer-engineering/placer-terraform-mod-gcp-sql.git//postgres?ref=3.22.0"
  name                     = "${local.app_name}-db"
  team                     = local.team
  env                      = local.env
  vault_path               = "kv/${local.env}/apps/${local.app_name}/db"
  deletion_protection      = true
  enable_vault_integration = false
}
```

## Security & Lifecycle

Prevent Destroy (for Artifactory repos, Okta apps, AWS accounts, SAML):
```hcl
lifecycle { prevent_destroy = true }
```

Ignore Changes:
```hcl
lifecycle { ignore_changes = [users_names, groups, member] }      # Externally managed
lifecycle { ignore_changes = [key_algorithm] }                     # Certs
lifecycle { ignore_changes = [url] }                               # External updates
lifecycle { ignore_changes = [log_config, headers, end_date] }     # Auto-managed
```

Ephemeral Secrets (Terraform 1.10+):
```hcl
ephemeral "vault_kv_secret_v2" "okta_credentials" {
  mount = "kv"
  name  = "devops/okta/credentials"
}

provider "okta" {
  org_name  = ephemeral.vault_kv_secret_v2.okta_credentials.data["org_name"]
  api_token = ephemeral.vault_kv_secret_v2.okta_credentials.data["api_token"]
}
```

Vault Token:
```hcl
data "google_secret_manager_secret_version" "vault_token" {
  secret  = "vault_prod_root_token"
  project = "placer-management-services"
}

provider "vault" {
  address = "https://vault-prod.placer.team/"
  token   = data.google_secret_manager_secret_version.vault_token.secret_data
}
```

Workload Identity (K8s-GCP):
```hcl
resource "google_project_iam_member" "vertex_ai" {
  member = "principal://iam.googleapis.com/projects/${data.google_project.project.number}/locations/global/workloadIdentityPools/${data.google_project.project.name}.svc.id.goog/subject/ns/${local.namespace}/sa/${local.service_account_name}"
  role   = "roles/aiplatform.user"
}
```

## Configuration

Locals over tfvars:
```hcl
locals {
  env            = "prod"
  app_name       = "quota-management"
  team           = "guru"
  gcp_project_id = "guru-prod-services"
  dataset_access = {
    "team-a" = ["dataset1", "dataset2"]
    "team-b" = ["dataset3"]
  }
}
```

Tfvars usage: Only `/us/network/` for VPC config

Hierarchy (`/us/{env}/hierarchy/`):
```hcl
module "project" {
  source = "git@github.com:placer-engineering/placer-terraform-mod-project.git?ref=1.18.0"
  prefix      = local.project_logical_name
  environment = local.env
  iam = { dataflow_vpc_access = true, metastore_vpc_access = true }
  labels = { division = "ingestion", team = "poi" }
}
```

Network (`/us/network/shared-net/`):
- Single shared VPC, 100+ subnets
- Subnets: `{service}-{env}-{purpose}`
- Secondary ranges for K8s
- IP planning in `terraform.tfvars`

## CI/CD

GitHub Actions (primary):
- PR Agent: Claude Sonnet 4 (`vertex_ai/claude-sonnet-4@20250514`), fallback Gemini 2.5 Pro
- Workload Identity auth
- Non-DevOps only

TFLint:
```hcl
plugin "google" { enabled = true, version = "0.36.0" }
plugin "aws" { enabled = true, version = "0.43.0" }
```
Disabled: `terraform_module_pinned_source`, `terraform_typed_variables`, `terraform_documented_variables`, `terraform_required_providers`, `terraform_required_version`

Jenkins (legacy): Docker builds, `/docker/Jenkinsfile`, `/jobs/*/Jenkinsfile`

## Core Features

Resources:
- `resource` → create infra
- `data` → external data, computed values
- `for_each`, `count` → iteration
- `dynamic` → nested blocks
- Conditionals → `count = var.enabled ? 1 : 0`

Variables:
- `variable` → inputs
- `locals` → computed (prefer over tfvars)
- `output` → expose
- Types: `string`, `number`, `bool`, `list(type)`, `map(type)`, `object({...})`
- Validation: `validation { condition, error_message }`

Modules:
- Hierarchical
- Dependency injection via variables/outputs
- Minimal interfaces
- Git refs for versions

Functions:
- Template: `templatefile()`, `jsonencode()`, `yamlencode()`
- File: `file()`, `filebase64()`
- String: `join()`, `split()`, `replace()`, `regex()`
- Collection: `concat()`, `merge()`, `flatten()`, `lookup()`
- Validation: precondition/postcondition

## Multi-Environment

Structure:
- `/us/{dev|staging|prod}/{app-infra|infra|buckets|hierarchy}/`
- `/us/network/` (env-agnostic)

State:
- Isolated per env
- Prefix: `{env}/infra/k8s`
- No workspaces → separate dirs

Config:
- `locals.tf` for env values
- Minimal tfvars
- `env = "dev"` in locals

Promotion: dev → staging → prod, same module versions, env values in locals

## Multi-Cloud

Abstraction:
- GCP → compute, storage, network
- AWS → specific services, cross-account
- Azure → blobs, service principals
- Snowflake → data warehouse
- Databricks → analytics

Dependencies: Data sources, outputs between clouds

Cost: Labels (GCP) / tags (AWS): `division`, `team`, env via locals

## Troubleshooting

State:
- `terraform state list|show|mv|rm|import`
- Never manual edit

Resources:
- `terraform plan -target=resource.name`
- `terraform refresh`
- `terraform apply -replace=resource.name`

Providers:
- `terraform init -upgrade`
- Lock: `terraform.lock.hcl`
- Cache: `.terraform/providers/`

Drift: Plan regularly, update or revert manual changes, data sources for external

Upgrades:
- Update Git ref `?ref=new-version`
- Test in dev
- Review CHANGELOG
- `terraform init -upgrade`

## Behavioral Traits

Safety: NEVER apply/destroy → plan/validate only, protect state, `prevent_destroy` for stateful

Consistency: Analyze first, match patterns, dual org strategy, mirror interfaces

Design: DRY, version constraints, data > hardcoded, locals > tfvars

Simplicity: KISS, flat hierarchies, clear names

Quality: TFLint, AI reviews, Workload Identity, ephemeral secrets, lifecycle rules

Scale: Multi-env consistency, isolated state, scalable modules, separation of concerns

Documentation: Clear interfaces, READMEs, upgrade strategies

## Workflow

1. Analyze project → patterns, conventions, structure
2. Identify env → dev/staging/prod or cross-env
3. Determine location → `/us/{env}/` vs root
4. Design module → local wrapper vs external versioned
5. Apply naming → SAs, projects, resources
6. Configure backend → GCS, prefix matches dir
7. Use locals for env values
8. Security → prevent_destroy, Workload Identity, ephemeral secrets
9. Providers → version constraints, aliases
10. Run `terraform plan` ONLY
11. Validate with TFLint
12. Document → rationale, dependencies, upgrades
