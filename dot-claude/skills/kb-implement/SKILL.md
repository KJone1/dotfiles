---
name: kb-implement
description: Analyze task dependencies and code collisions, then implement selected local kanban tasks through verified parallel subagent execution using the kb CLI.
argument-hint: [task-id, task-ids, or all]
disable-model-invocation: true
---

# Kanban Implement

Implement selected tasks from the local kanban board with the `kb` CLI. Build dependency-aware execution waves, dispatch non-colliding tasks to dedicated subagents, and independently verify ticket compliance and engineering quality before accepting their changes.

## Process

### 1. Load tasks

Input:

- `<selection>`: one task ID, multiple task IDs, or `all`.

Steps:

1. If `<selection>` is `all`, list all `todo` tasks:

```bash
kb task list -s todo
```

2. If `<selection>` contains task IDs, use exactly those IDs.

3. Read every selected task:

```bash
kb task get "<task-id>"
```

Run this command once for each selected task ID.

4. Continue only with tasks whose status is `todo`. Ask the user before handling a selected task with another status.

5. Treat the current conversation as additional requirements and constraints.

Do not modify files or move tasks during this step.

### 2. Build the execution plan

Inputs:

- The selected `todo` tasks from Step 1.
- The current codebase.

Steps:

1. Build a dependency graph containing every selected task and its `blocked_by` relationships.

2. Read every referenced blocker:

```bash
kb task get "<blocker-task-id>"
```

Run this command once for each blocker ID.

3. Record each blocker's status. Treat a selected task as ready only when every blocker is `inreview` or `done`.

4. Explore the codebase areas related to each selected task.

5. Compare each task's description, relevant files, definition of done, and constraints with the current implementation and architecture.

6. Determine each task's actual blast radius, including shared files, symbols, contracts, schemas, generated artifacts, configuration, and tests.

7. Group ready tasks into execution waves. Place tasks in the same wave only when they can be implemented, tested, and reviewed independently.

8. Sequence tasks when their blast radii overlap or when one task changes behavior, contracts, or files used by another task.

9. Ask the user before continuing when a task is missing required context, has contradictory fields, exceeds one fresh context window, or requires work outside its approved scope.

Output:

- Tasks in each execution wave.
- Dependencies that block later waves.
- Collisions that require serial execution.

Do not modify files or move tasks during this step.

### 3. Dispatch the execution wave

Input:

- The next ready execution wave from Step 2.

Steps:

1. Dispatch one subagent for each non-colliding task. Respect the available agent limit.

2. If ready tasks collide, dispatch them one at a time in dependency and priority order.

3. Immediately before dispatching a task, claim it:

```bash
kb task move "<task-id>" inprogress
```

4. Give each subagent this prompt:

```text
Implement kb task <task-id>.

Read the complete task first:

kb task get "<task-id>"

Follow the full description, relevant files, definition of done, and constraints.

Explore the current codebase and choose an elegant, maintainable implementation that fits the existing architecture. Reject hacks, fragile workarounds, unnecessary duplication, and unrelated changes.

Stay within the task's atomic blast radius. Follow the project's existing conventions. Add or update the tests required by the definition of done and run the relevant verification commands.

Record a short progress note:

kb task note "<task-id>" "<one or two sentences on what now works>. Tests: <passed|failed>. <Anything noteworthy the user should be aware of, only if any>."

Keep the note under 40 words. Write the behavior, not the mechanics. No file names, no code, no per-test breakdown, no decision log.

Return:
- Files changed.
- Behavior implemented.
- Verification commands and results.
- Unmet definition-of-done checkpoints.
- Blockers or scope conflicts.

Do not move the task to inreview or done.
Do not commit or push.
```

5. Do not modify files owned by active subagents.

6. Wait for every subagent in the wave to finish before verifying the wave.

7. If dispatch fails after claiming a task, return it to `todo`:

```bash
kb task move "<task-id>" todo
```

### 4. Verify the execution wave

Inputs:

- The completed subagent results.
- The code changes produced by the execution wave.

Steps:

1. Read each task again:

```bash
kb task get "<task-id>"
```

2. Inspect the actual diff and surrounding code. Do not accept the subagent's summary or passing tests as sufficient evidence.

3. Apply two independent acceptance gates:

   - **Ticket compliance:** Confirm that the implementation satisfies the complete description, relevant files, definition of done, constraints, and atomic blast radius without unrelated or unapproved scope.
   - **Engineering quality:** Confirm that the solution is professional, production-ready, and appropriate for the codebase, not merely functional. Review all concerns relevant to the change:
     - Architectural fit: reuse established abstractions and patterns, preserve clear boundaries, and avoid unnecessary new paradigms.
     - Correctness depth: reason through normal, edge, failure, and recovery paths, including state transitions and cleanup where applicable.
     - Maintainability: require clear naming, cohesive responsibilities, minimal complexity, useful comments only where needed, and no dead code, debug residue, duplication, hacks, or fragile workarounds.
     - Compatibility and completeness: update affected callers, contracts, schemas, configuration, migrations, generated artifacts, and documentation when the change requires them.
     - Production concerns: assess security, data integrity, concurrency, performance, resource use, observability, and backward compatibility in proportion to the task's risk.
     - Test quality: require meaningful tests at the appropriate level that exercise changed behavior and important failure or regression paths. Reject tautological tests and tests coupled only to implementation details.
     - Scope discipline: do not demand speculative abstractions, unrelated cleanup, or scope expansion in the name of quality.

4. Independently run the relevant tests, type checks, linters, builds, and other verification required by the task. Add focused verification for risks discovered during review when existing checks do not cover them.

5. After every task passes both gates individually, verify the combined wave for integration failures and regressions.

6. If either gate fails, keep the task `inprogress`, record the deficiency, and return it to its subagent with precise correction instructions:

```bash
kb task note "<task-id>" "Verification failed: <ticket or quality deficiency>. Required correction: <correction>."
```

Repeat verification after the correction.

7. After the task and combined wave pass both gates and every check, record the result:

```bash
kb task note "<task-id>" "Verified: <commands and checks>. Result: passed. Ready for review."
```

8. Move the verified task to `inreview`:

```bash
kb task move "<task-id>" inreview
```

Do not move a task to `inreview` when any definition-of-done checkpoint is unmet or the engineering-quality gate fails.

Do not commit or push.

### 5. Advance through the remaining waves

Input:

- The task IDs selected in Step 1.

Steps:

1. After each verified wave, read every selected task:

```bash
kb task get "<task-id>"
```

Run this command once for each selected task ID.

2. Identify the selected tasks that remain `todo`.

3. Treat a remaining task as ready only when every task in its `blocked_by` field is `inreview` or `done`.

4. Rebuild the execution plan from Step 2 for the ready tasks. Recalculate blast radii and collisions against the updated codebase.

5. Dispatch and verify the next wave using Steps 3 and 4.

6. Repeat until every selected task is `inreview`.

7. If selected `todo` tasks remain but none are ready, stop and report each blocked task with its blocker IDs and statuses. Do not implement tasks outside the original selection.

8. Report the final status and verification result for every selected task.

Do not mark tasks `done`, commit, or push.
