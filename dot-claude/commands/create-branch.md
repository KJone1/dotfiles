---
name: create-branch
description: Create git branch from ticket ID
argument-hint: ticket_id
---

# /create-branch

## Usage

`/create-branch id <ticket-id>`

## Process

- Analyze: `git diff` + `git status`
- Generate description from changed files
- Format: `INPE-<ticket-id>-<description>`
- `git checkout -b <branch-name>`
