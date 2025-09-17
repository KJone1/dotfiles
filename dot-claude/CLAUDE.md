# Claude Configuration

## Automatic Guideline Loading

**MANDATORY**: Claude must automatically read and implement the appropriate specialized guidelines based on the task context:

### On Every Session Start
- **ALWAYS read first**: `@workflow.md` - Contains the fundamental Explore, Plan, Code, Commit methodology that applies to ALL development tasks

### Context-Based Loading
When working with specific technologies, **MUST read the relevant guidelines BEFORE starting work**:

- **Helm/Helm Charts**: Read `@helm.md` first when tasks involve:
  - Helm chart creation, modification, or troubleshooting
  - Working with `values.yaml`, templates, or Chart.yaml files
  - Any Kubernetes deployment using Helm

- **GitHub Operations**: Read `@github.md` first when tasks involve:
  - Creating or managing pull requests
  - Working with GitHub issues
  - Repository management or collaboration
  - Any GitHub-related workflows

- **Git/Commit Operations**: **MANDATORY** - Read `@commit.md` first when tasks involve:
  - Any mention of "commit" command or variations
  - Committing changes to repositories
  - Creating commit messages
  - Git workflow operations
  - ANY git commit-related task or user request

## Specialized Guidelines

For reference, these specialized guideline files are available:

- **[Claude Code Workflow](@workflow.md)** - Explore, Plan, Code, Commit methodology (READ FIRST)
- **[Commit Commands](@commit.md)** - Commit workflow, commands, and message best practices
- **[Helm Charts](@helm.md)** - Comprehensive best practices for Helm chart development and testing
- **[GitHub Operations](@github.md)** - GitHub CLI operations and best practices

## Implementation Requirements

1. **Start every session** by reading `@workflow.md` to understand the fundamental development approach
2. **Before beginning any task**, identify the relevant technology context and read the appropriate specialized file
3. **Follow the guidelines** from the specialized files throughout the task execution
4. **Refer back** to the guidelines if questions arise during implementation

This ensures consistent, high-quality development practices across all tasks and technologies.