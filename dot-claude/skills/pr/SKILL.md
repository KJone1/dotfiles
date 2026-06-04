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

Jira Ticket: [#{ticket_id}]({jira_ticket_url})
```

Resolve `{jira_ticket_url}` from user memory or infer it from context (git remotes, prior tickets in the repo, project config).
## Execution

1. Construct the title (`{ticket_id}: {description}`) and body.
2. Run `gh pr create` with the title and body.

### Example

```bash
gh pr create --title "PROJ-123: Add MaxUnavailable override for Argo Rollouts" --body "Set \`maxUnavailable\` to 25% for Argo Rollouts blue-green deployments.

Jira Ticket: [#PROJ-123](https://example.atlassian.net/browse/PROJ-123)"
```

The URL in the example is illustrative. Use the actual Jira base URL resolved at runtime.

## Rules

1. **One sentence max**: The body is one sentence. Not a paragraph. Not bullets. One sentence.
2. **No context, no explanation**: Do not explain what the technology is, how it works, or why it matters in general. Just state what changed.
3. **No filler**: Never use "In this PR...", "This change aims to...", "This wires...", "This adds support for...", or similar lead-ins. Start with the action directly.
4. **Commit-message tone**: Write like a commit message - tight, specific, lowercase ok. "Update X to Y" or "Set X for Y" is the target length and tone.
