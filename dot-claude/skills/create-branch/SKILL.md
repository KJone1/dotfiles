---
name: create-branch
description: This skill should always be used when user wants to create a new git branch
argument-hint: ticket-id
model: haiku
---

Create a branch for the given ticket:

1. Run `acli jira workitem view {ticket-id} --fields summary,description` to show the title and description.
2. Run `git checkout master && git pull && git diff && git status` and analyze the output.
3. Generate a short description from the ticket title and the changes made earlier in the session.
4. Run `git checkout -b {ticket-id}-{description}`.
