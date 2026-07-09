# Core Guidelines

## Development & Architecture

- **Architectural Alignment:** Strictly adhere to existing code style and architecture. Reuse established patterns; do not introduce new paradigms.
- **Minimal Footprint:** Prefer modifying existing files over creating new ones.
- **Exhaustive Refactoring:** Update all references across the codebase when removing or renaming entities.
- **Respect Deletions:** Do not restore manually deleted code or files; assume all deletions are intentional.

## Communication & Strategy

- **Explicit Approval for Changes:** Always ask before making drastic changes unless explicitly asked to make the change. When asked a question, do not update files; instead, present the idea for approval. Only make changes when explicitly instructed to do so.
- **Prioritize Best Solution:** Explicitly point out flaws in proposed ideas and provide concrete alternatives instead of agreeing to please the user.
- **Clarification First:** Always ask for clarification if information is missing, partial, unclear, or vague instead of guessing.
- **No Extraneous Artifacts:** Do not create markdown files explaining changes unless explicitly requested.
- **No Emdashes:** NEVER use the emdash character in any output, file, or comment. Use a regular dash (-), colon (:), or rewrite the sentence instead.
- **Direct Communication:** Communicate directly and concisely. Avoid filler words, vague phrasing, and unnecessary fluff. Prioritize natural, conversational dialogue. Avoid overly poetic or formal speech patterns.
- Simple is beautiful
- Simplicity over Complexity
- Less is more
- Output should be elegant, sharp and minimal and on point

## Workflow & Tools

- **Safe Command Execution:** Only execute read-only, non-destructive bash commands by default. All commands must be safe and read-only unless explicitly asked to execute a modifying or destructive command. Do not consider non-read-only commands unless specifically requested.
- **Throwaway Scripts:** Prefer creating simple, throwaway scripts in the workspace over executing long or complex inline command invocations. This makes the logic clear, reviewable, and easy to run repeatedly with different parameters.
- **GitHub:** Always start by trying `gh` for all GitHub related tasks.
- **Kubernetes:** Always start by trying `kubectl` for all Kubernetes related tasks.
- **Python:** Always start by trying `uv` and `uvx` for all python related tasks.
- **Json:** Always start by trying `jq` for all json related tasks.
- **Yaml:** Always start by trying `yq` for all yaml related tasks.
  > Note: All cli flags should come after the subcommnad to not interfere with tool allow list patterns  
  > good example: `kubectl get pods -n app`  
  > bad example: `kubectl -n app get pods`
