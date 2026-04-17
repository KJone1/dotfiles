---
name: commit
description: Guide on how to create a commit. This skill should always be used when user want to create a new git commit.
model: haiku
---

# Commit

- Follow workflow precisely
- Single-line messages (no body)
- Pre-commit hook fails → fix and retry. Never bypass
- No AI references in messages
- Never push

## Workflow

1. `git status --short` → get modified files
2. Use `AskUserQuestion` with `multiSelect: true`:
  - Each option: label=filename, description=file status (M/D/A/?)
  - Header: "Files"
  - Question: "Which files do you want to stage for commit?"
3. `git add` selected files from user's answer
4. `git branch --show-current`: `master`/`main` → Main Branch Workflow | Other → Feature Branch Workflow

## Main Branch Workflow

### Step 3: Analyze staged changes

- `git diff --staged`
- Understand changes and file relationships
- Determine the goal these changes achieve

### Step 4: Create message

1. Formulate a message based on the following rules:
  - Start with action verb (Add/Fix/Update/Remove/Refactor/Improve/Style)
  - Imperative mood
  - Max 50 chars
  - No periods
  - Explain WHY, not HOW
2. `git commit -m "<message>"`

## Feature Branch Workflow

1. Extract ticket ID from branch name: `[LETTERS]-[NUMBER]` format
2. Check first commit: `git rev-list --count HEAD ^main` (or `^master`). Count 0 → first commit
  - for first commit → `TICKET-NUMBER: ` then derive a natural language summary from the branch name - expand abbreviations and ensure a conversational, PR-friendly style
  - Subsequent → `TICKET-NUMBER: update`
3. `git commit -m "<message>"`
