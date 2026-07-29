---
name: kb-implement
description: Analyze task dependencies and code collisions, implement selected local kanban tasks through parallel subagent execution, and delegate independent acceptance review to kb-review using the kb CLI.
argument-hint: [task-id, task-ids, or all]
disable-model-invocation: true
---

# Kanban Implement

Implement selected tasks from the local kanban board with the `kb` CLI. Build dependency-aware execution waves, dispatch non-colliding tasks to dedicated subagents, and invoke `$kb-review` to independently review and accept their changes.

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

3. Record each blocker's status. Treat a selected task as ready only when every blocker is `done`.

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

6. Wait for every subagent in the wave to finish before reviewing the wave.

7. If dispatch fails after claiming a task, return it to `todo`:

```bash
kb task move "<task-id>" todo
```

### 4. Review the execution wave with kb-review

Inputs:

- The completed subagent results.
- The task IDs in the completed execution wave.

Steps:

1. Read every subagent result and each task:

```bash
kb task get "<task-id>"
```

2. If a subagent reports an unmet definition-of-done checkpoint, failed required check, blocker, or scope conflict, keep the task `inprogress` and return precise correction instructions to the same subagent.

3. Wait for every required correction to finish. Repeat Steps 1 and 2 until every task in the wave is ready for independent review.

4. Move each review-ready task to `inreview`:

```bash
kb task move "<task-id>" inreview
```

If any move fails, stop and report the failed command.

5. Invoke `$kb-review` with the exact task IDs in the wave. Load and follow its complete instructions without reproducing, abbreviating, or weakening its review process in this skill.

6. Read every reviewed task and handle its resulting status:

   - `done`: accept the task.
   - `inprogress`: return the `$kb-review` findings to the same implementation subagent as precise correction instructions.
   - `inreview`: treat the review as blocked. Stop the affected task and report the blocker or required user input.
   - Any other status: stop and report the unexpected transition.

7. Wait for every review correction to finish, then repeat Steps 1 through 5 for the corrected task IDs.

8. Repeat Steps 6 and 7 until every task in the wave is `done` or a review remains blocked.

Only `$kb-review` may move a task from `inreview` to `done` or back to `inprogress`.

Do not perform an independent code review in this skill, commit, or push.

### 5. Advance through the remaining waves

Input:

- The task IDs selected in Step 1.

Steps:

1. After each reviewed wave, read every selected task:

```bash
kb task get "<task-id>"
```

Run this command once for each selected task ID.

2. Identify the selected tasks that remain `todo`.

3. Treat a remaining task as ready only when every task in its `blocked_by` field is `done`.

4. Rebuild the execution plan from Step 2 for the ready tasks. Recalculate blast radii and collisions against the updated codebase.

5. Dispatch and review the next wave using Steps 3 and 4.

6. Repeat until every selected task is `done`.

7. If selected `todo` tasks remain but none are ready, stop and report each blocked task with its blocker IDs and statuses. Do not implement tasks outside the original selection.

8. Report the final status and review result for every selected task.

Do not commit or push.
