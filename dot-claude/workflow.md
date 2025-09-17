# Claude Code Workflow

Follow this structured workflow for all development tasks to ensure thorough understanding, proper planning, and quality implementation:

## Core Principles
- **Follow the Explore → Plan → Code → Commit workflow** for all development tasks
- **Use TodoWrite for complex tasks** (3+ steps or non-trivial planning required)

## 1. Explore Phase

**Understand the codebase and requirements before making any changes:**

- **Read and analyze**: Use Read, Grep, and Glob tools to understand existing code structure
- **Search comprehensively**: Look for related functionality, patterns, and conventions
- **Identify dependencies**: Find files, functions, and components that might be affected
- **Understand context**: Review documentation, comments, and existing implementations
- **Ask clarifying questions**: If requirements are unclear, ask the user for clarification

**Example exploration activities:**
```bash
# Search for existing implementations
grep -r "similar_functionality" .
# Find related files
find . -name "*related*" -type f
# Understand project structure
ls -la && cat README.md
```

## 2. Plan Phase

**Create a detailed plan before writing any code:**

- **Use TodoWrite tool**: ALWAYS create a todo list for complex tasks (3+ steps)
- **Break down the task**: Divide large tasks into smaller, manageable steps
- **Identify risks**: Consider potential issues, edge cases, and breaking changes
- **Plan testing strategy**: Determine how changes will be tested and validated
- **Consider backwards compatibility**: Ensure changes don't break existing functionality
- **Review with user**: For complex changes, present the plan for user approval using ExitPlanMode

**TodoWrite criteria:**
- Complex multi-step tasks requiring 3+ distinct actions
- Non-trivial tasks requiring careful planning
- When user provides multiple tasks or requirements
- Any task that benefits from progress tracking

## 3. Code Phase

**Implement the planned changes systematically:**

- **Follow existing conventions**: Match the codebase's style, patterns, and architecture
- **Implement incrementally**: Work through todo items one at a time
- **Update todo status**: Mark tasks as in_progress and completed in real-time
- **Test as you go**: For Helm charts, use `helm template --set` to test each change
- **Handle edge cases**: Implement proper error handling and validation
- **Document changes**: Add necessary comments and documentation

**Key principles:**
- One task in_progress at a time in the todo list
- Test every change immediately after implementation
- Follow security best practices
- Ensure proper error handling

## 4. Commit Phase

**Commit changes following the established commit workflow:**

- **Follow commit command guidelines**: Use the commit commands as defined in this document
- **Create meaningful commits**: Write clear, descriptive commit messages
- **Test before committing**: Run linting, type checking, and tests
- **Commit incrementally**: Make logical, atomic commits for related changes
- **Extract JIRA tickets**: Parse branch names for ticket information
- **No Claude attribution**: Never include Claude watermarks in commits

**Commit workflow:**
1. Analyze all changes with `git status` and `git diff`
2. Extract JIRA ticket from branch name if present
3. Stage relevant files based on scope (all, keyword-filtered, or staged-only)
4. Create descriptive commit message following best practices
5. Commit without Claude attribution or watermarks

## Workflow Examples

**Simple Task (No TodoWrite needed):**
```
User: "Fix the typo in README.md"
1. Explore: Read README.md to find the typo
2. Plan: (minimal - just fix the typo)
3. Code: Fix the typo
4. Commit: Create commit with clear message
```

**Complex Task (TodoWrite required):**
```
User: "Add dark mode support to the application"
1. Explore: Search codebase for existing theme/styling patterns
2. Plan: Create TodoWrite with steps:
   - Research existing CSS/styling architecture
   - Design theme switching mechanism
   - Implement dark theme styles
   - Add theme toggle component
   - Test theme switching
   - Update documentation
3. Code: Work through each todo item systematically
4. Commit: Make logical commits for each major change
```

## Quality Gates

**Before moving to the next phase:**

- **Explore → Plan**: Ensure thorough understanding of requirements and codebase
- **Plan → Code**: Have clear, actionable steps and user approval if needed
- **Code → Commit**: All tests pass, linting succeeds, functionality verified
- **After Commit**: Code is clean, documented, and ready for review/deployment

## Best Practices

- **Be thorough in exploration**: Better to over-research than miss critical context
- **Plan before coding**: Rushed implementation leads to technical debt
- **Test continuously**: Catch issues early in the development process
- **Communicate clearly**: Keep the user informed of progress and any blockers
- **Follow conventions**: Consistency is more important than personal preferences