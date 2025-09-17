# GitHub Operations

When working with GitHub repositories, follow these guidelines to ensure consistent and efficient operations:

## Core Principle
- **Use GitHub CLI for all operations**: Always use `gh` CLI instead of web interfaces or manual processes

## Mandatory Use of GitHub CLI

- **ALWAYS use `gh` CLI**: For ALL GitHub-related operations, you MUST use the GitHub CLI (`gh`) command rather than web interfaces or manual processes
- **Supported operations include**:
  - Creating and managing pull requests
  - Working with issues
  - Repository management
  - Release management
  - Workflow and action management
  - Repository settings and configuration

## Pull Request Management

- **Create PRs with `gh pr create`**: Use the CLI to create pull requests with proper titles and descriptions
- **View PR details**: Use `gh pr view` to see PR information, comments, and status
- **Manage PR reviews**: Use `gh pr review` for approving, requesting changes, or commenting
- **Example PR creation**:
  ```bash
  gh pr create --title "Add tolerations support to ClickHouse chart" --body "$(cat <<'EOF'
  ## Summary
  - Add configurable tolerations support
  - Update values.yaml with toleration examples
  - Test with multiple toleration scenarios

  ## Test plan
  - [ ] Test with node tolerations
  - [ ] Test with empty tolerations
  - [ ] Verify backward compatibility
  EOF
  )"
  ```

## Issue Management

- **Create issues**: Use `gh issue create` for bug reports and feature requests
- **List and filter issues**: Use `gh issue list` with filters for project management
- **Link PRs to issues**: Reference issues in PR descriptions for automatic linking

## Repository Operations

- **Clone repositories**: Use `gh repo clone` for authenticated cloning
- **Fork repositories**: Use `gh repo fork` for creating forks
- **View repository information**: Use `gh repo view` for repository details

## Release Management

- **Create releases**: Use `gh release create` for version releases
- **Upload assets**: Use `gh release upload` for adding release artifacts
- **View releases**: Use `gh release list` and `gh release view` for release information

## Authentication and Configuration

- **Authenticate properly**: Use `gh auth login` for secure authentication
- **Configure defaults**: Set default repository and user preferences with `gh config`
- **Check authentication status**: Use `gh auth status` to verify login state

## Best Practices

- **Use descriptive titles**: Write clear, concise titles for PRs and issues
- **Provide context**: Include relevant information in descriptions and comments
- **Tag appropriately**: Use labels and milestones for organization
- **Follow templates**: Use issue and PR templates when available
- **Automate workflows**: Leverage GitHub Actions integration through `gh workflow`