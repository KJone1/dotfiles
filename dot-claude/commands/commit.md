---
name: commit
description: Create atomic git commits with JIRA ticket integration
arguments: "[all|staged|mod|<keyword>]"
examples:
  - /commit
  - /commit staged
  - /commit mod
  - /commit <keyword>
---

# /commit - Git Commit Workflow

## Overarching Directive: No Guessing

- **This is your bible**: This document is the absolute and only source of truth for the `/commit` command. YOU MUST follow this workflow precisely.
- **No Acting on a Whim**: If any part of the process is unclear, or if an unexpected situation arises that is not covered by these rules, YOU MUST NOT guess or improvise.
- **Ask for Confirmation**: Your only course of action in a state of ambiguity is to halt, state what is unclear, and ask the user for explicit instructions.

## Prerequisites

- **Git Repository**: YOU MUST be operating inside a valid git repository.
- **Git Installation**: The `git` command line tool MUST be installed and available in the system's PATH.

## Core Principles

- **ATOMIC COMMITS**: YOU MUST ensure every commit is ATOMIC (representing a single, complete logical change), as this simplifies code reviews, aids debugging (`git bisect`), and makes changes easier to revert. DO NOT bundle multiple unrelated changes into one commit.
- **SINGLE-LINE MESSAGES**: YOU MUST write the entire commit message on a single line to maintain a clean, readable history that is easy to parse with standard Git tools. YOU MUST NEVER use a commit body or multi-line commit messages.

## Error Handling

- **Pre-commit Hooks**: If the `git commit` command fails due to a pre-commit hook (e.g., a linter or test runner), YOU MUST analyze the error output, fix the underlying issues in the code, and then re-attempt the commit. DO NOT bypass the hook.

## UX Principles

- **Provide Constant Feedback**: YOU MUST report on the outcome of each step in the workflow. For example: "Found JIRA Ticket: ...", "Staging 5 files...", "Commit successful. Hash: ...".

## Usage

The input to the commit command is $ARGUMENTS.

Options:

- `/commit` - Commit all changes
- `/commit staged` - Commit only staged files
- `/commit mod` - Commit only files modified by Claude during the current session
- `/commit <keyword>` - Commit files related to a keyword/feature

## Workflow Steps

### 1. YOU MUST Determine Files for Commit

- **Check Input**: Examine the input from `$ARGUMENTS` and determine:
  - If empty: Commit all changes
  - If "staged": Commit only staged files
  - If "mod": Commit only files modified by Claude during the current session
  - If contains keyword: Commit files related to that keyword/feature

### 2. YOU MUST Extract JIRA Ticket

- **Parse Branch**: Execute commands to get the current git branch name.
- **Extract Ticket**: Find and extract the JIRA ticket ID in the format `[LETTERS]-[NUMBER]` from the branch name.
- **Handle Duplicates**: If multiple ticket IDs are found in the branch name, YOU MUST use the first one that appears.

### 3. YOU MUST Stage Files for Commit

- **For All Changes**: If committing all changes (no keyword), YOU MUST run `git add -A` to stage all modifications and new files.
- **For Keyword-based Commits**:
  - **Identify Matches**: To pinpoint the exact files matching the keyword, YOU MUST use the following methods:
    - Use the Grep tool to find files with matching content: search for the keyword pattern with `output_mode: "files_with_matches"`.
    - Use the Glob tool to find files with matching names or paths: search for patterns like `**/*<keyword>*`.
  - **Stage Files**: Stage only the identified files for the commit.
- **For Staged-only Commits**: DO NOT stage any new files. Proceed to the next step.
- **For Modified-only Commits** (when `mod` is specified):
  - **Track Session Files**: YOU MUST maintain awareness of which files you (Claude) have modified during the current conversation session using the Read, Write, Edit, or NotebookEdit tools.
  - **Identify Modified Files**: Only include files that were modified by Claude during this session, excluding files that were already modified before the session started.
  - **Stage Files**: Stage only the files modified by Claude during this session using `git add <file1> <file2> ...` for each identified file.

### 4. YOU MUST Analyze Staged Changes

- **Execute Analysis**: Run `git status` and `git diff --staged` to analyze the changes that are now staged for commit.
- **Understand the Goal**: The analysis MUST inform the commit message by clearly identifying the purpose of the changes that will actually be committed.
- **Verify Scope**: Ensure the staged changes align with the intended scope (all changes, staged only, modified only, or keyword-based).

### 5. YOU MUST Create the Commit Message

**CRITICAL**: YOU MUST NEVER include ANY AI references, watermarks, or attribution in commit messages. The commit MUST appear entirely human-authored.

**Generate a single-line commit message that follows these rules:**

- **Start with JIRA Ticket**: If a ticket was found, it MUST be the first part of the message (e.g., `TICKET-123: `). If no ticket is found, YOU MUST omit the prefix.
- **Use Imperative Mood**: Start the description with an action verb (e.g., Add, Fix, Update).
- **Describe the Change**: Concisely explain what the change accomplishes.
- **Set Strict Length**: The entire message, including the JIRA prefix, MUST NOT exceed 72 characters.
- **Summarize the Goal**: The description MUST summarize the original user request or the problem being solved.

### 6. YOU MUST Confirm with User

- **Summarize Plan**: Before executing the commit, YOU MUST ALWAYS present a summary of the plan to the user. This includes the files to be committed and the generated commit message.
- **Request Approval**: YOU MUST ALWAYS ask for explicit user approval using the exact format: "Do you approve this commit? (y/n)". Only accept these responses:
  - **Valid YES responses**: `y`, `yes` (case insensitive)
  - **Valid NO responses**: `n`, `no` (case insensitive)
  - **Invalid responses**: Any other input is interpreted as NO and the commit is cancelled.

### 7. YOU MUST Execute the Commit

- **Commit**: Upon approval, run the `git commit -sm "<generated_message>"` command with the generated message.

### 8. YOU MUST Validate the Final Commit

- **Verify Log**: After committing, YOU MUST run `git log -1` to verify the final commit is correct.
- **Amend if Necessary**: If you find an error in the last commit, YOU MUST correct it. To do this, first stage the corrected files, then run `git commit --amend`. This will allow you to edit the previous commit message. DO NOT create a new commit to fix a mistake in the previous one.
- **DO NOT PUSH**: This command's responsibility ends after the commit. YOU MUST NEVER push the commit to the remote repository.

## Commit Message Standards

### Format

**With JIRA ticket**: `TICKET-123: Brief description of what changed`

**Without JIRA ticket**: `Update auth validation`

### IMPORTANT: Rules for Concise and Clear Messages

- **SINGLE-LINE ONLY**: As stated in the core principles, YOU MUST use only a single line.
- **Be Specific**: YOU MUST focus on the key change, not implementation details.
- **Avoid Redundancy**: DO NOT repeat information obvious from the project or directory context.
- **Avoid Filler Words**: YOU MUST NOT use fluff or unnecessary filler words. Messages must be direct and concise.
- **Use Active Voice**: Write "Fix bug," not "Bug was fixed."
- **No Periods**: YOU MUST NOT end the message with a period.

### Action Verbs

- `Add` - New features, files, or functionality.
- `Fix` - Bug fixes or corrections.
- `Update` - Modifications to existing features.
- `Remove` - Deletion of features, files, or functionality.
- `Refactor` - Code restructuring without functional changes.
- `Improve` - Performance or quality enhancements.
- `Docs` - Changes to documentation only.
- `Test` - Adding missing tests or correcting existing tests.
- `Chore` - Changes to the build process, tooling, or other maintenance tasks.
- `Style` - Code formatting changes that don't alter logic (e.g., white-space).
