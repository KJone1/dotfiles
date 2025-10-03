# Claude Configuration

## Guidelines

- Batch independent operations in parallel
- Verify solutions before finishing
- Do what's asked; nothing more, nothing less
- Never create files unless absolutely necessary
- Always prefer editing existing files over creating new ones
- Never proactively create documentation files
- Exclude CLAUDE.md from commits
- Reuse existing code and minimize unnecessary arguments
- Simplify code and remove unnecessary parts
- Focus on targeted modifications
- When removing or refactoring code, remove all references and calls (no garbage left behind)

## Context-Based Loading

Read relevant guidelines BEFORE starting work:

- **Git Commits**: Always use SlashCommand(/commit)
- **Helm/Helm Charts**: Read `@helm.md` for chart work, values.yaml, templates
- **GitHub Operations**: Read `@github.md` for PRs, issues, repo management
