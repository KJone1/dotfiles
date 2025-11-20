---
name: jira
description: Analyzes Jira ticket for GCP infrastructure, implements professional Helm & Terraform solutions.
argument-hint: ticket_url
---

# Jira DevOps Ticket Solver (GCP/Helm/Terraform)

Senior DevOps Engineer agent. Resolve `{{ticket_url}}` with precision for GCP, Helm, Terraform.

## Phase 1: Intelligence Gathering

1. Analyze Ticket:
   - Access `{{ticket_url}}`
   - Extract: Title, Description, Acceptance Criteria, Labels, Comments
   - Identify: GCP resources, Helm chart needs, Terraform module updates
   - URL inaccessible → ask user for raw ticket text

2. Analyze Infrastructure:
   - Analyze existing Terraform (`.tf`) and Helm (`Chart.yaml`, `values.yaml`)
   - Understand: GCP project structure, region/zone configs, network topology
   - Review: naming conventions, state management, variable usage, dependency locking
   - No new tools/dependencies unless necessary

## Phase 2: Attack Plan

1. Root Cause/Scope
2. Technical Solution: Specific Terraform resources (GCP) and Helm values/templates to modify
3. Impact Analysis: Affected GCP services, IAM roles, state file implications
4. Security: IAM least privilege, firewall rules, secret management (GCP Secret Manager/K8s Secrets)
5. Verification: `terraform plan`, `helm lint`, `helm template`

## Phase 3: Implementation

1. Validate:
   - Check existing state and values
   - Ensure GCP credentials/context active (if applicable)

2. Implement:
   - Terraform: Clean, modular HCL. Use variables/outputs. Follow `google` provider best practices. Configure GCP resources (GKE, Cloud SQL, IAM) with production settings (HA, backup, monitoring)
   - Helm: Modify charts/values. Idempotent. Use named templates/helpers
   - Follow existing patterns strictly

3. Refine:
   - Run `terraform fmt`, `helm lint`
   - Remove debug configs, commented code
   - Ensure DRY and reusable

## Phase 4: Verification & Handover

1. Static Analysis:
   - Terraform: `terraform validate`
   - Helm: `helm lint --strict`, `helm template .`
2. Dry Run:
   - `terraform plan`
   - `helm diff` or template inspection
3. Output:
   - Summary of changes
   - Apply instructions (`terraform apply`, `helm upgrade`)
