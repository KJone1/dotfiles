---
description: Create git branch from ticket ID
argument-hint: ticket_id
---

# /create-branch

<steps>
1. Run and analyze output of: `git checkout master && git pull && git diff && git status`
2. Generate description from changed files
3. `git checkout -b INPE-{ticket-id}-{description}`
</steps>
