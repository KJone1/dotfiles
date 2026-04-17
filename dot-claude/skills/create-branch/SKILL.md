---
name: create-branch
description: Guide on how to create a branch. This skill should always be used when users want to create a new git branch.
argument-hint: ticket-id
model: haiku
---

# Steps to create a branch

1. Run and analyze output of: `git checkout master && git pull && git diff && git status`
2. Generate description from changed files
3. `git checkout -b INPE-{ticket-id}-{description}`
