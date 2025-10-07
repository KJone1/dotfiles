---
description: Create atomic git commits with JIRA ticket integration
argument-hint: " all | staged | mod | <keyword> "
---

# /commit

## Rules

- Follow workflow precisely. Ask if unclear
- Atomic commits (single logical change)
- Single-line messages (no body)
- Pre-commit hook fails → fix and retry. Never bypass
- No AI references in messages

## Workflow

### 1. Determine Scope & Stage Files

`$ARGUMENTS`:

- Empty → `git status --short` → show numbered modified files → user selects → `git add` selected
- `staged` → staged only: Skip
- `mod` → Claude-modified files: `git add <file1> <file2>...`
- `<keyword>` → files matching keyword: Grep (`output_mode: "files_with_matches"`) + Glob (`**/*<keyword>*`) → `git add` matches

### 2. Check Branch

`git branch --show-current`: `master`/`main` → Main Branch Workflow | Other → Feature Branch Workflow

---

## Main Branch Workflow

### 3. Analyze Staged Changes

- `git status` + `git diff --staged`
- Verify staged matches scope
- Understand purpose for message

### 4. Create Message

Rules:

- Start with action verb (Add/Fix/Update/Remove/Refactor/Improve)
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

### 7. Validate

- `git log -1` to verify
- Error found → `git commit --amend`
- Never push

---

## Feature Branch Workflow

### 3. Extract JIRA Ticket

- Extract ticket ID from branch name: `[LETTERS]-[NUMBER]` format
- Multiple found → use first

### 4. Create Message

Format: `TICKET-123: wip`

### 5. Execute

`git commit -m "<message>"`

### 6. Validate

- `git log -1` to verify
- Error found → `git commit --amend`
- Never push
