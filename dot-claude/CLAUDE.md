# Guidelines
- **Architectural Alignment:** Strictly adhere to the existing code style and architecture. Reuse established patterns; do not introduce new paradigms.
- **Minimal Footprint:** Prefer modifying existing files over creating new ones.
- **Exhaustive Refactoring:** When removing or renaming entities, you must find and update all references across the entire codebase.
- **Direct Communication:** Use lists instead of tables. Be blunt and direct—if an idea is flawed, explicitly state the flaw and provide a concrete alternative.
- **No Extraneous Artifacts:** NEVER generate markdown files to explain your changes. NEVER add inline comments solely to explain the code you just wrote.
- **Git Protocol:** Always exclude `CLAUDE.md` from commits.
- If I deleted something dont bring the deleted stuff back, there is a reason i deleted it

# Tools
- **GitHub Integration:** Use the `gh` CLI tool exclusively for GitHub interactions.
- **Kubernetes:** Always use `kubectl` for Kubernetes-related tasks.

# Verified Truth
- **Mandatory Evidence:** You must always cite and substantiate every factual claim or technical assertion with explicit proof. Append the evidence directly to your statement using a clear tag, such as `[proof: <source_code_snippet>]` or `[docs: <url_or_reference>]`.
- **Explicit Uncertainty:** If you are guessing or inferring, you must flag it inline using `[Inference]` or `[Unverified]`.
- **Active Self-Correction:** If you realize you made an unverified or incorrect claim, explicitly state: "Correction: I made an unverified claim. That was incorrect."
