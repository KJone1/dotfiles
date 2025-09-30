# Claude Configuration

## Automatic Guideline Loading

**MANDATORY**: Claude must automatically read and implement the appropriate specialized guidelines based on the task context:

## AI Guidance

- After receiving tool results, carefully reflect on their quality and determine optimal next steps before proceeding. Use your thinking to plan and iterate based on this new information, and then take the best next action.
- For maximum efficiency, whenever you need to perform multiple independent operations, invoke all relevant tools simultaneously rather than sequentially.
- Before you finish, please verify your solution
- Do what has been asked; nothing more, nothing less.
- NEVER create new files unless they're absolutely necessary for achieving your goal.
- ALWAYS prefer editing an existing file to creating a new one.
- NEVER proactively create documentation files (\*.md) or README files. Only create documentation files if explicitly requested by the User.
- When asked to commit changes, exclude CLAUDE.md from any commits.
- Reuse existing code wherever possible and minimize unnecessary arguments.
- Look for opportunities to simplify the code or remove unnecessary parts.
- Focus on targeted modifications rather than large-scale changes.

## Context-Based Loading

When working with specific technologies, **MUST read the relevant guidelines BEFORE starting work**:

- **Git Commits**: **ALWAYS use the `/commit` command** when the prompt requires committing changes. Pass all relevant context and changes to the command.

- **Helm/Helm Charts**: Read `@helm.md` first when tasks involve:
  - Helm chart creation, modification, or troubleshooting
  - Working with `values.yaml`, templates, or Chart.yaml files
  - Any Kubernetes deployment using Helm

- **GitHub Operations**: Read `@github.md` first when tasks involve:
  - Creating or managing pull requests
  - Working with GitHub issues
  - Repository management or collaboration
  - Any GitHub-related workflows

## Specialized Guidelines

For reference, these specialized guideline files are available:

- **[Helm Charts](@helm.md)** - Comprehensive best practices for Helm chart development and testing
- **[GitHub Operations](@github.md)** - GitHub CLI operations and best practices

## Implementation Requirements

2. **Before beginning any task**, identify the relevant technology context and read the appropriate specialized file
3. **Follow the guidelines** from the specialized files throughout the task execution
4. **Refer back** to the guidelines if questions arise during implementation

This ensures consistent, high-quality development practices across all tasks and technologies.
