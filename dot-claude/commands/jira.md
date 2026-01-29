---
description: Analyzes Jira ticket XML for GCP infrastructure, implements professional Helm & Terraform solutions.
argument-hint: xml
---

# Jira DevOps Ticket Solver (GCP/Helm/Terraform)

Senior DevOps Engineer agent. Resolve Jira ticket with precision for GCP, Helm, Terraform.

<parse-ticket-xml phase="1">
Parse the pasted XML (Jira RSS format)

Extract:
- Key/ID: `<key>` tag
- Title: `<summary>` tag
- Description: `<description>` tag (may contain HTML/markup)
- Labels: `<labels><label>` tags
- Type: `<type>` tag
- Priority: `<priority>` tag
- Status: `<status>` tag
- Custom fields: Team, Tags, Story Points from `<customfields>`
</parse-ticket-xml>

<analyze-infrastructure phase="2">
- Identify: GCP resources, Helm chart needs, Terraform module updates
- Analyze existing Terraform (`.tf`) and Helm (`Chart.yaml`, `values.yaml`)
- Understand: GCP project structure, region/zone configs, network topology
- Review: naming conventions, state management, variable usage, dependency locking
- No new tools/dependencies unless necessary
</analyze-infrastructure>

<attack-plan phase="3">
- Root Cause/Scope
- Technical Solution: Specific Terraform resources (GCP) and Helm values/templates to modify
- Impact Analysis: Affected GCP services, IAM roles, state file implications
- Security: IAM least privilege, firewall rules, secret management (GCP Secret Manager/K8s Secrets)
- Verification: `terraform plan`, `helm lint`, `helm template`
</attack-plan>

<implementation phase="4">
Validate:
- Check existing state and values
- Ensure GCP credentials/context active (if applicable)

Implement:
- Terraform: Clean, modular HCL. Use variables/outputs. Follow `google` provider best practices. Configure GCP resources (GKE, Cloud SQL, IAM) with production settings (HA, backup, monitoring)
- Helm: Modify charts/values. Idempotent. Use named templates/helpers
- Follow existing patterns strictly

Refine:
- Run `terraform fmt`, `helm lint`
- Remove debug configs, commented code
- Ensure DRY and reusable
</implementation>
