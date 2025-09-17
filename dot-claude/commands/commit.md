# /commit - Git Commit Workflow

## Usage

- `/commit` - Commit all changes
- `/commit staged` - Commit only staged files
- `/commit <keyword>` - Commit files related to keyword/feature

## Workflow Steps

### 1. Determine Scope

- **All changes**: Include all modified/new files
- **Staged only**: Only commit currently staged files without staging additional files
- **Keyword filter**: Only include files that match the keyword in filename, path, or content

### 2. Extract JIRA Ticket

Parse current git branch name to extract JIRA ticket in format `[LETTERS]-[NUMBER]` (e.g., INPE-11041, ABC-123)

### 3. Analyze Changes

- **For all/keyword**: Use `git status` and `git diff` for unstaged changes
- **For staged**: Use `git status` and `git diff --cached` for staged changes only

### 4. Filter Files (if keyword provided)

- Identify files matching keyword in path, filename, or relevant changes
- Stage and commit only those specific files
- Ignore other modified files

### 5. Create Commit Message

Generate single-line commit message that:

- Starts with JIRA ticket if found: `TICKET-123: `
- Uses imperative mood (Add, Fix, Update, Remove)
- Describes what the change accomplishes
- Is concise but informative
- **NO Claude watermarks or attribution**

### 6. Execute Commit

- **All/keyword**: Stage relevant files then commit
- **Staged**: Skip staging, commit only what's already staged

## Commit Message Standards

### Format

`TICKET-123: Brief description of what changed`

### Importance of Concise Messages

- **Keep it short**: Aim for 50 characters or less for the subject line
- **Be specific**: Focus on the key change, not implementation details
- **Avoid redundancy**: Don't repeat information that's obvious from the diff
- **Use active voice**: "Fix bug" not "Bug was fixed"
- **Skip periods**: End the message without punctuation

### Verbs

- `Add` - New features, files, or functionality
- `Fix` - Bug fixes or corrections
- `Update` - Modifications to existing features
- `Remove` - Deletion of features, files, or functionality
- `Refactor` - Code restructuring without functional changes
- `Improve` - Performance or quality enhancements

### Examples

- `INPE-11041: Add redis configuration for production deployment`
- `INPE-11041: Fix vault path construction for dynamic environments`
- `Update authentication middleware validation`
