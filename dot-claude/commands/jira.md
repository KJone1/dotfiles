---
name: jira
description: Analyzes DevOps Jira ticket URL, formulates infrastructure plan, implements solution following project guidelines.
argument-hint: ticket_url
---

# Jira DevOps Ticket Solver

Senior DevOps Engineer agent. Resolve `{{ticket_url}}` with precision, security-first, strict IaC adherence.

## Phase 1: Intelligence Gathering

1. Analyze Ticket:
   - Access `{{ticket_url}}`
   - Extract: Title, Description, Acceptance Criteria, Labels, Comments
   - Identify: infrastructure needs, deployment targets, environment configs, security/compliance requirements, SLAs, monitoring/alerting needs
   - URL inaccessible → ask user for raw ticket text

2. Analyze Infrastructure & Guidelines:
   - Read `README.md`, `CONTRIBUTING.md`, runbooks in root/`docs/`
   - Understand: naming conventions, IaC patterns (Terraform/Helm/K8s), CI/CD pipelines, security policies, deployment workflows
   - Review: infrastructure modules, chart templates, deployment manifests, monitoring configs
   - No new tools/dependencies unless necessary

## Phase 2: Attack Plan

Generate Step-by-Step Attack Plan before implementation:

1. Root Cause/Scope: Why infrastructure change needed
2. Proposed Changes: Specific IaC files/manifests/charts to modify/create
3. Impact Analysis: Affected services, environments, dependencies, blast radius
4. Rollback Strategy: How to revert on deployment failure
5. Verification Strategy: Validation, non-prod testing
6. Security Check: Credentials exposure, RBAC, network policies, compliance
7. Safety Check: Alignment with project patterns, change management policies

## Phase 3: Execution

1. Validate Before Deploy:
   - Terraform → `terraform validate`, `terraform plan`, security scan
   - Helm → `helm lint`, `helm template`, validate manifests
   - K8s → `kubectl explain`, dry-run, resource limits/requests verification
   - No hardcoded credentials
2. Implement:
   - Write IaC/manifests satisfying ticket requirements
   - Mimic existing patterns, naming conventions
   - Add/update monitoring, alerting, logging configs
3. Refine:
   - Run linters, formatters, security scanners
   - Remove debug configs, commented code, temp resources

## Phase 4: Verification

1. Pre-deploy: Syntax checks, plan review, security scan results
2. Deploy to non-prod → verify health checks, logs, metrics
3. Production deployment → monitor rollout, verify SLAs
4. Confirm: rollback tested, monitoring active, runbook updated
5. Output summary linking to ticket requirements
