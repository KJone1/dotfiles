---
description: Create atomic git commits with JIRA ticket integration
argument-hint: " all | staged | mod | <keyword> "
---

# /commit

## Rules

- Follow workflow precisely. Ask if unclear
- Atomic commits (single logical change)
- Single-line messages (no body)
- If pre-commit hook fails, fix and retry. Never bypass
- No AI references in messages

## Workflow

### 1. Determine Scope

From `$ARGUMENTS`:

- Empty → all changes
- `staged` → staged only
- `mod` → files Claude modified this session (Read/Write/Edit/NotebookEdit)
- `<keyword>` → files matching keyword

### 2. Extract JIRA Ticket

- Get branch name: `git branch --show-current`
- Extract ticket ID: `[LETTERS]-[NUMBER]` format
- If multiple found, use first

### 3. Stage Files

- All: `git add -A`
- Keyword: Grep (`output_mode: "files_with_matches"`) + Glob (`**/*<keyword>*`), then `git add` matches
- Staged: Skip
- Mod: `git add <file1> <file2>...` for Claude-modified files

### 4. Analyze Staged Changes

- Run `git status` and `git diff --staged`
- Verify staged matches intended scope
- Understand purpose for message

### 5. Create Message

Format:
- With ticket: `TICKET-123: Description`
- Without ticket: `Description`

Rules:
- Start with action verb (Add/Fix/Update/Remove/Refactor/Improve)
- Imperative mood
- Max 72 chars with ticket, 50 chars without
- No periods
- Explain WHY, not HOW

### 6. Confirm

Present:
- Files to commit
- Commit message

Ask: "Do you approve this commit? (y/n)"

Accept: `y`, `yes` (case insensitive)
Reject: `n`, `no`, or anything else

### 7. Execute

`git commit -m "<message>"`

### 8. Validate

- `git log -1` to verify
- Error found → amend with `git commit --amend`
- Never push (ends after commit)
