# Commit Command and Best Practices

## Quick Reference

### Commit Commands
- `commit` - Commit all changes
- `commit <keyword>` - Commit files related to keyword/feature
- `commit staged` - Commit only staged files

### Core Principle
- **No Claude attribution** in commits

## Commit Command Usage

### Usage:
- `commit` - Commit all changes
- `commit <feature/keyword>` - Commit only files related to the specified feature/keyword
- `commit staged` - Commit only the currently staged files without staging any additional files

When the user writes "commit", perform the following steps:

1. **Determine scope**:
   - If just "commit": Include all modified/new files
   - If "commit <keyword>": Only include files that are related to the keyword/feature (by filename, path, or content)
   - If "commit staged": Only commit currently staged files without staging any additional files

2. **Extract JIRA ticket from branch name**: Parse the current git branch name to extract JIRA ticket information in the format `[LETTERS]-[NUMBER]` (e.g., INPE-11041, ABC-123, etc.)

3. **Analyze changes**:
   - For "commit" or "commit <keyword>": Use `git status` and `git diff` (for unstaged changes) to understand what has been modified
   - For "commit staged": Use `git status` and `git diff --cached` to see only staged changes

4. **Filter files** (if keyword provided):
   - Identify files that match the keyword in their path, filename, or contain relevant changes
   - Only stage and commit those specific files
   - Ignore other modified files

5. **Create commit message**: Generate a clear, descriptive commit message that:
   - Starts with the JIRA ticket (if found) in format: `TICKET-123: `
   - Uses imperative mood (e.g., "Add", "Fix", "Update", "Remove")
   - Clearly describes what the change accomplishes
   - Is concise but informative
   - MUST be a single line (no multi-line commit messages) - ALWAYS enforce this rule
   - Does NOT include any Claude watermarks or attribution

6. **Stage and commit**:
   - For "commit" or "commit <keyword>": Add relevant files to staging then commit
   - For "commit staged": Skip staging step and commit only what is already staged
   - Do NOT include Claude attribution or watermarks

## Examples

**Full commit:**
- Command: `commit`
- Branch: `INPE-11041-Make-LangFuse-prod-ready`
- Changes: Added redis config, updated charts, modified values
- Commit: `INPE-11041: Add redis configuration for production deployment`

**Selective commit:**
- Command: `commit redis`
- Branch: `INPE-11041-Make-LangFuse-prod-ready`
- Changes: Multiple files modified, but only redis-related files committed
- Files: `clusters/prod/langfuse-redis/values.yaml`
- Commit: `INPE-11041: Add redis configuration`

**No JIRA ticket:**
- Command: `commit auth`
- Branch: `feature/user-authentication`
- Changes: Fixed login validation, updated auth middleware
- Files: Only auth-related files
- Commit: `Fix user authentication validation and middleware`

**Staged files only:**
- Command: `commit staged`
- Branch: `INPE-11041-Make-LangFuse-prod-ready`
- Staged changes: Modified values.yaml and deployment template
- Action: Commit only the staged files without staging additional files
- Commit: `INPE-11041: Update values and deployment template`

## Commit Message Best Practices

When creating commit messages, follow these guidelines:

### Structure
- **Format**: `TICKET-123: Brief description of what changed`
- **Length**: Keep the entire message under 72 characters
- **Tone**: Use imperative mood (e.g., "Add", "Fix", "Update", "Remove")

### Content Guidelines
- **Be specific**: Describe WHAT changed, not HOW it was implemented
- **Focus on impact**: What does this change accomplish for the user/system?
- **Avoid technical details**: Keep implementation details out of the subject line
- **Use consistent verbs**:
  - `Add` - New features, files, or functionality
  - `Fix` - Bug fixes or corrections
  - `Update` - Modifications to existing features
  - `Remove` - Deletion of features, files, or functionality
  - `Refactor` - Code restructuring without functional changes
  - `Improve` - Performance or quality enhancements

### Examples of Good Commit Messages
- `INPE-11041: Add tolerations and nodeSelector support for ClickHouse`
- `INPE-11041: Fix vault path construction for dynamic environments`
- `INPE-11041: Update ExternalSecret refresh interval to 1 minute`
- `INPE-11041: Remove deprecated configuration options`

### Examples of Poor Commit Messages
- ❌ `INPE-11041: Updated some files and fixed stuff`
- ❌ `INPE-11041: Changed the template to use .Values.clickhouseServer.tolerations instead of hardcoded values`
- ❌ `fix bugs`
- ❌ `WIP: working on ClickHouse improvements`

### Multi-Change Commits
When a commit includes multiple related changes:
- **Lead with the primary change**: Start with the most important modification
- **Use "and" sparingly**: Only combine truly related changes
- **Consider separate commits**: If changes are logically independent, split them

**Good**: `INPE-11041: Reorganize ClickHouse chart with global values and pod labels`
**Better**: Two commits:
1. `INPE-11041: Add global values support to ClickHouse chart`
2. `INPE-11041: Add pod labels for environment and team tracking`