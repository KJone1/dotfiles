---
description: Create atomic git commits with JIRA ticket integration
---

# /commit

## Rules

- Follow workflow precisely. Ask if unclear
- Atomic commits (single logical change)
- Single-line messages (no body)
- Pre-commit hook fails → fix and retry. Never bypass
- No AI references in messages
- Never push

## Workflow

### 1. Stage Files

- `git status --short` → show numbered modified files
- User selects files
- `git add` selected

### 2. Check Branch

`git branch --show-current`: `master`/`main` → Main Branch Workflow | Other → Feature Branch Workflow

---

## Main Branch Workflow

### 3. Analyze Staged Changes

- `git status` + `git diff --staged`
- Understand changes and file relationships
- Determine the goal these changes achieve

### 4. Create Message

- Start with action verb (Add/Fix/Update/Remove/Refactor/Improv/Style)
- Imperative mood
- Max 50 chars
- No periods
- Explain WHY, not HOW

### 5. Confirm

Present:

- Files to commit
- Commit message

Ask: "Do you approve this commit? (y/n)"
Accept: `y`, `yes` (case insensitive)
Reject: anything else

### 6. Execute

`git commit -m "<message>"`

---

## Feature Branch Workflow

### 3. Extract JIRA Ticket

- Extract ticket ID from branch name: `[LETTERS]-[NUMBER]` format
- Multiple found → use first

### 4. Create Message

- Check first commit: `git rev-list --count HEAD ^main` (or `^master`). Count 0 → first commit
- First → `TICKET-NUMBER: <branch-name-description>`
  - Branch name with ticket prefix removed, hyphens → spaces, capitalize first letter
- Subsequent → `TICKET-NUMBER: update`

### 5. Execute

`git commit -m "<message>"`
