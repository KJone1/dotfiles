---
name: commit
description: Create a Git commit when the user asks.
model: haiku
---

# Commit

* Single-line messages with no body or AI references
* Pre-commit hook fails → fix and retry. Never bypass
* Never push

## Workflow

1. Identify files modified this session. Only stage what was touched this session unless the user specifies otherwise.
2. Split changes into the smallest practical standalone commits. Keep related changes together and unrelated changes separate. Do not modify files or use complex Git surgery solely to split commits.
3. `git add <files>` for one well-scoped change.
4. `git diff --staged` → understand the changes
5. `git branch --show-current` → main/master: plain message | other: feature branch message
6. `git commit -m "<message>"`, then repeat for remaining standalone changes.

## Message Rules

* Start the summary with Add, Fix, Update, Remove, Refactor, Improve, or Style
* Imperative mood, max 50 chars, no periods
* Describe what the commit accomplishes, not its implementation details

**Feature branch:** extract ticket ID (`[LETTERS]-[NUMBER]`) from branch name

* First commit (`git rev-list --count HEAD ^master` = 0): `TICKET: <natural summary from branch name>`
* Subsequent: `TICKET: update`
