---
name: commit
description: Guide on how to create a commit. This skill should always be used when user want to create a new git commit.
model: haiku
---

# Commit

- Single-line messages (no body)
- Pre-commit hook fails → fix and retry. Never bypass
- No AI references in messages
- Never push

## Workflow

1. Identify files modified this session. Only stage what was touched this session unless the user specifies otherwise.
2. `git add <files>`
3. `git diff --staged` → understand the changes
4. `git branch --show-current` → main/master: plain message | other: feature branch message
5. `git commit -m "<message>"`

## Message Rules

- Action verb: Add / Fix / Update / Remove / Refactor / Improve / Style
- Imperative mood, max 50 chars, no periods
- Explain WHY not HOW

**Feature branch:** extract ticket ID (`[LETTERS]-[NUMBER]`) from branch name
- First commit (`git rev-list --count HEAD ^main` = 0): `TICKET: <natural summary from branch name>`
- Subsequent: `TICKET: update`
