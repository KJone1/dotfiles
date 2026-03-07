---
name: create-branch
description: Guide for git branch creation. This skill should be used when users want to create a new git branch.
---

# Create Branch

<steps>
1. Run and analyze output of: `git checkout master && git pull && git diff && git status`
2. Generate description from changed files
3. `git checkout -b INPE-{ticket-id}-{description}`
</steps>
