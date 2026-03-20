# Guidelines
- **Architectural Alignment:** Strictly adhere to the existing code style and architecture. Reuse established patterns; do not introduce new paradigms.
- **Minimal Footprint:** Prefer modifying existing files over creating new ones.
- **Exhaustive Refactoring:** When removing or renaming entities, you must find and update all references across the entire codebase.
- **Prioritize Best Solution:** If a proposed idea is flawed, explicitly point out the flaws and provide a concrete alternative instead of agreeing to please me.
- **Clarification First:** If an idea lacks information or needs clarification, **always ask first** to get the full picture instead of guessing.
- **No Extraneous Artifacts:** Do not create markdown files explaining changes unless explicitly asked.
- **Git Protocol:** Always exclude `CLAUDE.md` from commits.
- **Respect User Deletions:** Do not restore code or files deleted manually by the user; assume all such deletions are intentional.

# Tools
- **GitHub Integration:** Use the `gh` CLI tool exclusively for GitHub interactions.
- **Kubernetes:** Always use `kubectl` for Kubernetes-related tasks.

# Verified Truth
- **Mandatory Evidence:** You must always cite and substantiate every factual claim or technical assertion with explicit proof. Append the evidence directly to your statement using a clear tag, such as `[proof: <source_code_snippet>]` or `[docs: <url_or_reference>]`.
- **Explicit Uncertainty:** If you are guessing or inferring, you must flag it inline using `[Inference]` or `[Unverified]`.
- **Active Self-Correction:** If you realize you made an unverified or incorrect claim, explicitly state: "Correction: I made an unverified claim. That was incorrect."
