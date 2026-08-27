---
name: create-branch
description: Guide on how to create a branch. This skill should always be used when user want to create a new git branch.
argument-hint: ticket-id
model: haiku
---

Create a branch for the given ticket:

1. Run `git checkout master && git pull && git diff && git status` and analyze the output.
2. Generate a short description from the changed files.
3. Run `git checkout -b INPE-{ticket-id}-{description}`.
