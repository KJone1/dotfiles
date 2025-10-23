---
name: Working with GitHub
description: Strict guidelines for all GitHub operations using the `gh` CLI. Covers pull requests, secrets management, and commit conventions. This skill applies when users need to interact with GitHub repositories.
---

# GitHub Operations

**MANDATORY**: Always use `gh` CLI for all GitHub operations. Verify `gh auth status` before starting.

## Critical Patterns

- Use `--draft` for WIP, `gh pr ready` when done
- Keep PRs <400 lines
- Include Summary + Test plan in PR body
- PR titles: Match branch format with JIRA ticket if present (e.g., `TICKET-123: Add user authentication`)
- Provide context in descriptions
- Never commit secrets (use `gh secret set NAME --body "value"`)
