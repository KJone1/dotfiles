---
name: create-worktree
description: This skill should always be used when user wants to start work on a new ticket or create a new git worktree.
argument-hint: ticket-id
model: haiku
---

Create a worktree for the given ticket:

1. Run `git fetch origin master`.
2. Run `wt switch --create INPE-{ticket-id} --base origin/master`.
