---
description: Create atomic git commits with JIRA ticket integration
argument-hint: " all | staged | mod | <keyword> "
---

# /commit

## Rules

- Follow workflow precisely. If unclear, ask.
- Atomic commits only (single logical change). Multiple files OK if related to same change.
- If staged files have unrelated changes, split into separate commits.
- Single-line messages (no body, max 72 chars).
- If pre-commit hook fails, fix and retry. Never bypass.
- No AI references in messages.

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
- **Staged**: Skip
- **Mod**: `git add <file1> <file2>...` for Claude-modified files only

### 4. Analyze Staged Changes

- Run `git status` and `git diff --staged`
- Verify staged changes match intended scope
- If unrelated: `git reset HEAD`, create separate atomic commits
- Understand purpose for commit message

### 5. Create Message

Format:
- With ticket: `TICKET-123: Description`
- Without ticket: `Description`

Rules:
- Start with single action verb (Add/Fix/Update/Remove/Refactor/Improve), no prefixes
- Imperative mood
- Max 72 chars including ticket
- No periods
- Be specific: explain WHY this change was made, not HOW 

### 6. Confirm

Present:
- Files to commit
- Commit message

Ask: "Do you approve this commit? (y/n)"

- Accept: `y`, `yes` (case insensitive)
- Reject: `n`, `no`, or anything else

### 7. Execute

`git commit -sm "<message>"`

### 8. Validate

- Run `git log -1` to verify
- If Error found: amend with `git commit --amend`
- Never push (command ends after commit)
