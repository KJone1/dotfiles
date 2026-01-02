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

- `git status --short` → get modified files
- Use `AskUserQuestion` with `multiSelect: true`:
  - Each option: label=filename, description=file status (M/D/A/?)
  - Header: "Files"
  - Question: "Which files do you want to stage for commit?"
- `git add` selected files from user's answer

### 2. Check Branch

`git branch --show-current`: `master`/`main` → Main Branch Workflow | Other → Feature Branch Workflow

---

## Main Branch Workflow

### 3. Analyze Staged Changes

- `git diff --staged`
- Understand changes and file relationships
- Determine the goal these changes achieve

### 4. Create Message

- Start with action verb (Add/Fix/Update/Remove/Refactor/Improve/Style)
- Imperative mood
- Max 50 chars
- No periods
- Explain WHY, not HOW

### 5. Confirm

Present:

- Files to commit
- Commit message

Use `AskUserQuestion` with `multiSelect: false`:

- Header: "Approval"
- Question: "Do you approve this commit?"
- Options: "Yes" (proceed), "No" (abort)
- Proceed only if user selects "Yes"

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
