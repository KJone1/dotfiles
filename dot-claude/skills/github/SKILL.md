---
name: github
description: Use when asked about GitHub operations, PRs, or commit conventions.
user-invocable: false
---

# GitHub Operations

**MANDATORY**: Always use `gh` CLI for all GitHub operations. Verify `gh auth status` before starting.

## Critical Patterns

- Use `--draft` for WIP, `gh pr ready` when done
- Keep PRs <400 lines
- Include Summary + Test plan in PR body
- PR titles: Match branch format with JIRA ticket if present (e.g., `TICKET-123: Add user authentication`)
- Provide context in descriptions
