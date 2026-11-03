---
name: create-worktree
description: This skill should always be used when user asks to start work on a new ticket or create a new git worktree
argument-hint: ticket-id
model: haiku
---

Create a worktree for the given ticket:

1. Run `git fetch origin master`.
2. Run `acli jira workitem view {ticket-id} --fields summary,description` to show the title and description.
3. Generate a short description from the ticket title and the changes made earlier in the session.
4. Run `wt switch --create {ticket-id}-{description} --base origin/master`, with `{description}` in kebab-case.
