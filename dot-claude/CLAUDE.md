# Claude Configuration

## Automatic Guideline Loading

**MANDATORY**: Claude must automatically read and implement the appropriate specialized guidelines based on the task context:

### Commands Available
Use specialized commands for specific development phases:
- **`/plan`**: Use for comprehensive task planning and analysis
- **`/commit`**: Use for Git commit workflow and message creation

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


## Specialized Guidelines

For reference, these specialized guideline files are available:

- **[Plan Command](@commands/plan.md)** - Comprehensive task planning methodology
- **[Commit Command](@commands/commit.md)** - Git commit workflow and message standards
- **[Helm Charts](@helm.md)** - Comprehensive best practices for Helm chart development and testing
- **[GitHub Operations](@github.md)** - GitHub CLI operations and best practices

## Implementation Requirements

1. **Use specialized commands**: Use `/plan` for task planning and `/commit` for git workflows
2. **Before beginning any task**, identify the relevant technology context and read the appropriate specialized file
3. **Follow the guidelines** from the specialized files throughout the task execution
4. **Refer back** to the guidelines if questions arise during implementation

This ensures consistent, high-quality development practices across all tasks and technologies.