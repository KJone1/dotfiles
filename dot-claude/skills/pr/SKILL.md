---
name: pr
description: Guide for creating Pull Requests on GitHub. This skill should be used when users want to create a new PR (Pull Request).
model: haiku
---

# PR Creation Guide

This skill shows how to create PRs using the `gh` CLI according to user satisfaction.

## PR Body Structure

The PR body must start directly with the rationale, followed by the "Affected stuff" section and the Jira ticket reference:

```markdown
[Rationale/Problem being solved]

### Affected stuff
- [High-level components or systems impacted]

Jira Ticket: #{ticket_id}
```

## Execution

Run the `gh pr create` command directly. Construct the body string to match the template exactly.

### Example

```bash
gh pr create --title "fix: resolve memory leak in auth middleware" --body "The JWT validation logic was failing to close database connections on error, causing connection pool exhaustion under high load.

### Affected stuff
- Auth middleware
- Database connection pool management

Jira Ticket: #PROJ-123"
```

## Strict Rules

1. **No Conversational Filler**: Never use phrases like "In this PR...", "I have updated...", or "This change aims to...".
2. **Specific Rationale**: Start directly with the technical reason for the change (e.g., "The connection pool was being exhausted because..." instead of "Improving database performance").
3. **High-Level Affected Stuff**: Do not list every file or function changed (the diff already shows this). List the general components, services, or systems affected.