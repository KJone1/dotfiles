---
description: Create atomic git commits with JIRA ticket integration
argument-hint: " all | staged | mod | <keyword> "
---

# /commit Workflow

## Rules

- Follow this workflow precisely. If unclear, ask the user.
- Atomic commits only (single logical change).
- Single-line commit messages only (no body, max 72 chars).
- If pre-commit hook fails, fix issues and retry. Don't bypass.
- Never include AI references in commit messages.

## Workflow

### 1. Determine Scope

From `$ARGUMENTS`:

- Empty → all changes
- `staged` → staged files only
- `mod` → files modified by Claude this session (via Read/Write/Edit/NotebookEdit tools)
- `<keyword>` → files matching keyword

### 2. Extract JIRA Ticket

- Get branch name: `git branch --show-current`
- Extract ticket ID: `[LETTERS]-[NUMBER]` format
- If multiple found, use first

### 3. Stage Files

- **All**: `git add -A`
- **Keyword**: Use Grep tool (`output_mode: "files_with_matches"`) and Glob tool (`**/*<keyword>*`), then `git add` matching files
- **Staged**: Skip (no new staging)
- **Mod**: `git add <file1> <file2>...` for Claude-modified files only

### 4. Analyze Staged Changes

- Run `git status` and `git diff --staged`
- Verify staged changes match intended scope
- Understand purpose for commit message

### 5. Create Commit Message

Format:

- With ticket: `TICKET-123: Description`
- Without: `Description`

Rules:

- Start with action verb (Add/Fix/Update/Remove/Refactor/Improve/Docs/Test/Chore/Style)
- Imperative mood
- Max 72 chars including ticket
- No period at end

### 6. Confirm with User

Present:

- Files to commit
- Commit message

Ask: "Do you approve this commit? (y/n)"

- Accept: `y`, `yes` (case insensitive)
- Reject: `n`, `no`, or anything else

### 7. Execute Commit

`git commit -sm "<message>"`

### 8. Validate

- Run `git log -1` to verify
- If error found, amend with `git commit --amend`
- Never push (command ends after commit)
