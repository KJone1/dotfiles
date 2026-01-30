---
description: Create atomic git commits with JIRA ticket integration
---

# /commit

<rules>
- Follow workflow precisely
- Single-line messages (no body)
- Pre-commit hook fails → fix and retry. Never bypass
- No AI references in messages
- Never push
</rules>

## Workflow

<stage-files step="1">
1. `git status --short` → get modified files
2. Use `AskUserQuestion` with `multiSelect: true`:
   - Each option: label=filename, description=file status (M/D/A/?)
   - Header: "Files"
   - Question: "Which files do you want to stage for commit?"
3. `git add` selected files from user's answer
</stage-files>

<check-branch step="2">
`git branch --show-current`: `master`/`main` → Main Branch Workflow | Other → Feature Branch Workflow
</check-branch>

## Main Branch Workflow

<analyze-staged-changes step="3">
- `git diff --staged`
- Understand changes and file relationships
- Determine the goal these changes achieve
</analyze-staged-changes>

<create-message step="4">
- Start with action verb (Add/Fix/Update/Remove/Refactor/Improve/Style)
- Imperative mood
- Max 50 chars
- No periods
- Explain WHY, not HOW
</create-message>

<confirm step="5">
Present:

- Files to commit
- Commit message

Use `AskUserQuestion` with `multiSelect: false`:

- Header: "Approval"
- Question: "Do you approve this commit?"
- Options: "Yes" (proceed), "No" (abort)
- Proceed only if user selects "Yes"

</confirm>

<execute step="6">
`git commit -m "<message>"`
</execute>

## Feature Branch Workflow

<extract-jira-ticket step="3">
Extract ticket ID from branch name: `[LETTERS]-[NUMBER]` format
</extract-jira-ticket>

<create-message step="4">
- Check first commit: `git rev-list --count HEAD ^main` (or `^master`). Count 0 → first commit
- First → `TICKET-NUMBER: <summary>`
  - Derive a natural language summary from the branch name
  - Expand abbreviations and ensure a conversational, PR-friendly style
- Subsequent → `TICKET-NUMBER: update`
</create-message>

<execute step="5">
`git commit -m "<message>"`
</execute>
