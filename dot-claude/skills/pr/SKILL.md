---
name: pr
description: Guide for opening Pull Requests on GitHub. This skill should be used when users want to open a new PR (Pull Request).
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

1. Construct the title (`{ticket-id} {description}`) and body.
2. Show the user the proposed PR body and wait for approval:
   ```
   Here's the proposed PR body:
   [body]
   Approve?
   ```
3. Only after approval, run `gh pr create`.

### Example

```bash
gh pr create --title "PROJ-123 resolve memory leak in auth middleware" --body "The JWT validation logic was failing to close database connections on error, causing connection pool exhaustion under high load.

### Affected stuff
- Auth middleware
- Database connection pool management

Jira Ticket: #PROJ-123"
```

## Strict Rules

1. **No Conversational Filler**: Never use phrases like "In this PR...", "I have updated...", or "This change aims to...".
2. **Specific Rationale**: Start directly with the technical reason for the change (e.g., "The connection pool was being exhausted because..." instead of "Improving database performance").
3. **High-Level Affected Stuff**: Do not list every file or function changed (the diff already shows this). List the general components, services, or systems affected.