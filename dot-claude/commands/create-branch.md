---
description: Create git branch from ticket ID
argument-hint: ticket_id
---

# /create-branch

<steps>
1. `git checkout master && git pull`
2. Analyze: `git diff` + `git status`
3. Generate description from changed files
4. `git checkout -b INPE-{ticket-id}-{description}`
</steps>
