---
description: Create git branch from ticket ID or commit message
---

# /create-branch

## Modes

### `id <ticket-id>`
Extract ticket ID

### `like <keyword>`
- `git log --grep="<keyword>" --oneline -n 1`
- Extract ticket ID from commit

## Process

- Analyze: `git diff` + `git status`
- Generate description from changed files
- Format: `INPE-<ticket-id>-<description>`
- `git checkout -b <branch-name>`
