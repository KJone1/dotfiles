---
name: pr
description: Guide on how to open a PR (Pull Request) on GitHub. This skill should always be used when user want to open a new PR.
---

# PR Creation Guide

This skill shows how to create PRs using the `gh` CLI according to user satisfaction.

## PR Body Structure

The PR body must start directly with the rationale, followed by the "Affected stuff" section and the Jira ticket reference:

```markdown
[Rationale/Problem being solved]

### Affected stuff
- [High-level components or systems impacted]

Jira Ticket: [#{ticket_id}]({jira_ticket_url})
```

Resolve `{jira_ticket_url}` from user memory or infer it from context (git remotes, prior tickets in the repo, project config).
## Execution

1. Construct the title (`{ticket_id}: {description}`) and body.
2. Run `gh pr create` with the title and body.

### Example

```bash
gh pr create --title "PROJ-123: close db connections on JWT validation error" --body "JWT validation leaked database connections on error, exhausting the pool under load.

### Affected stuff
- Auth middleware
- Database connection pool

Jira Ticket: [#PROJ-123](https://example.atlassian.net/browse/PROJ-123)"
```

The URL in the example is illustrative. Use the actual Jira base URL resolved at runtime.

## Strict Rules

1. **No Conversational Filler**: Never use phrases like "In this PR...", "I have updated...", or "This change aims to...".
2. **Specific Rationale**: Start directly with the technical reason for the change. One sentence, no extra context, no "consistent with X" or "which allows Y" addendums. Bad: "Enables automated review of Renovate dependency updates using Claude, consistent with the pattern in the charts repo." Good: "Enables automated review of Renovate dependency updates using Claude."
3. **High-Level Affected Stuff**: Do not list every file or function changed (the diff already shows this). List the general components, services, or systems affected.
