---
name: to-tickets
description: Break a plan, spec, or the current conversation into a set of tracer-bullet tickets, each declaring its blocking edges, published as tasks on your local kanban board via the kb CLI.
disable-model-invocation: true
---

# To Tickets

Break a plan, spec, or conversation into a set of **tickets** - tracer-bullet vertical slices, each declaring the tickets that **block** it.

## Process

### 1. Gather context

Work from whatever is already in the conversation context. If the user passes a reference (a spec path, an issue number or URL) as an argument, fetch it and read its full body and comments.

### 2. Explore the codebase (optional)

If you have not already explored the codebase, do so to understand the current state of the code. Ticket titles and descriptions should use the project's domain glossary vocabulary, and respect ADRs in the area you're touching.

Look for opportunities to prefactor the code to make the implementation easier. "Make the change easy, then make the easy change."

### 3. Draft vertical slices

Break the work into **tracer bullet** tickets.

<vertical-slice-rules>

- Each slice cuts a narrow but COMPLETE path through every layer (schema, API, UI, tests) - vertical, NOT a horizontal slice of one layer
- A completed slice is demoable or verifiable on its own
- Each slice is sized to fit in a single fresh context window
- Any prefactoring should be done first

</vertical-slice-rules>

Give each ticket its **blocking edges** - the other tickets that must complete before it can start. A ticket with no blockers can start immediately.

**Wide refactors are the exception to vertical slicing.** A **wide refactor** is one mechanical change - rename a column, retype a shared symbol - whose **blast radius** fans across the whole codebase, so a single edit breaks thousands of call sites at once and no vertical slice can land green. Don't force it into a tracer bullet; sequence it as **expand-contract**. First expand: add the new form beside the old so nothing breaks. Then migrate the call sites over in batches sized by blast radius (per package, per directory), each batch its own ticket blocked by the expand, keeping CI green batch to batch because the old form still exists. Finally contract: delete the old form once no caller remains, in a ticket blocked by every migrate batch. When even the batches can't stay green alone, keep the sequence but let them share an integration branch that all block a final integrate-and-verify ticket - green is promised only there.

### 4. Quiz the user

Present the proposed breakdown as a numbered list. For each ticket, show:

- **Title**: short descriptive name
- **Blocked by**: which other tickets (if any) must complete first
- **What it delivers**: the end-to-end behaviour this ticket makes work

Ask the user:

- Does the granularity feel right? (too coarse / too fine)
- Are the blocking edges correct - does each ticket only depend on tickets that genuinely gate it?
- Should any tickets be merged or split further?

Iterate until the user approves the breakdown.

### 5. Publish the tickets to the board

Tickets live on your local kanban board via the `kb` CLI - one **task** per ticket. The mapping is **project = code repo**, **feature = label**, **ticket = task**. All output is available as JSON with the global `--out json` flag; use it whenever you need to capture an id.

**Resolve the project.** A project maps to a repo. List projects and match the current repo root:

```
kb --out json project list
```

Match the entry whose `path` equals `$(git rev-parse --show-toplevel)`. If none matches, create one and capture its `id`:

```
kb project new "<Repo name>" --path "$(git rev-parse --show-toplevel)"
```

**Create one task per ticket, in dependency order (blockers first)** so each dependent can reference blockers that already exist. Capture the `id` from each command's JSON and reuse it as a `--blocked-by` value for later tickets. Every ticket in one breakdown shares the same `-l <feature-slug>` label so the set can be listed together.

```
kb task new "<Ticket title>" \
  -p <project> \
  -l <relevant-labels> \
  -l <relevant-labels> \
  --priority <urgent|high|medium|low> \
  --blocked-by <blocker-id> [--blocked-by <blocker-id> ...] \
  --relevant-file <absolute-path> [--relevant-file <absolute-path> ...] \
  --dod "<Definition-of-done checkpoint>" [--dod "<checkpoint>" ...] \
  --constraint "<Hard constraint>" [--constraint "<constraint>" ...] \
  -d "$(cat <<'EOF'
<What to build: the end-to-end behaviour this ticket makes work, from the
user's perspective - not a layer-by-layer implementation list.>
EOF
)"
```

- **`--relevant-file`**: absolute paths to files this ticket touches or must read, when known at breakdown time. Use this instead of inlining file paths in the `-d` description - it's structured metadata on the board rather than prose that goes stale.
- **`--dod`**: one flag per acceptance criterion. Each is a concrete, checkable condition for the ticket to be demoable/verifiable.
- **`--constraint`**: hard constraints that scope the blast radius of the ticket - what the implementing agent must NOT touch or change - so it stays focused, avoids over-engineering, and doesn't make unintended broad changes.

In the `-d` description, avoid specific file paths - they go stale fast (use `--relevant-file` for paths). Exception: if a prototype produced a snippet that encodes a decision more precisely than prose can (state machine, reducer, schema, type shape), inline it and note briefly that it came from a prototype. Trim to the decision-rich parts - not a working demo, just the important bits.

### 6. Work the frontier

List the breakdown, blockers-first, and read the dependency state off the board:

```
kb task list -p <project> -l <feature-slug>
```

A ticket is on the **frontier** when every id in its `blocked_by` is `done` (`kb task get <id> -p <project>` shows the blockers and their state). For a purely linear chain that means top to bottom. Pick one frontier ticket, then:

1. `kb task move <id> inprogress -p <project>` - claim it.
2. Implement the slice. Append progress with `kb task note <id> "<what changed, decisions, gotchas>" -p <project>` so a fresh context can pick up where you left off.
3. When it is green and demoable: `kb task done <id> -p <project>` (or `kb task move <id> inreview -p <project>` if it awaits review before done).

Work the frontier one ticket at a time, clearing context between tickets. The board - not a scratch file - is the source of truth for what is done and what is unblocked.
