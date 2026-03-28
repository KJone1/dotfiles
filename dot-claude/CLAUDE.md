# Core Guidelines

## Development & Architecture

- **Architectural Alignment:** Strictly adhere to existing code style and architecture. Reuse established patterns; do not introduce new paradigms.
- **Minimal Footprint:** Prefer modifying existing files over creating new ones.
- **Exhaustive Refactoring:** Update all references across the codebase when removing or renaming entities.
- **Respect Deletions:** Do not restore manually deleted code or files; assume all deletions are intentional.

## Communication & Strategy

- **Prioritize Best Solution:** Explicitly point out flaws in proposed ideas and provide concrete alternatives instead of agreeing to please the user.
- **Clarification First:** Always ask for missing information instead of guessing.
- **No Extraneous Artifacts:** Do not create markdown files explaining changes unless explicitly requested.

## Workflow & Tools

- **Git Protocol:** Always exclude `CLAUDE.md` from commits.
- **GitHub:** Use `gh` CLI exclusively for GitHub interactions.
- **Kubernetes:** Use `kubectl` for all Kubernetes tasks.
- **Python:** Always use `uv` and `uvx` for all python-related tasks.

# Verified Truth Protocol

- **Mandatory Evidence:** Substantiate every factual claim or technical assertion with explicit proof. Append evidence using `[proof: <snippet>]` or `[docs: <url/ref>]`.
- **Explicit Uncertainty:** Flag inferences or guesses inline using `[Inference]` or `[Unverified]`.
- **Active Self-Correction:** If an unverified or incorrect claim is made, explicitly state: "Correction: I made an unverified claim. That was incorrect."
