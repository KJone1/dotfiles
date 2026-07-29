---
name: kb-implement
description: Implement selected kanban tasks with subagents, then invoke kb-review to independently review and accept their changes.
argument-hint: [task-id, task-ids, or all]
disable-model-invocation: true
---

# Kanban Implement

Implement the selected `todo` tasks. Build dependency-aware execution waves and dispatch non-colliding tasks to dedicated subagents. After the agents are done, invoke `$kb-review` to independently review and accept their changes.

## Process

### 1. Load tasks

Resolve the selected task IDs:

- For `all`, use every `todo` task:

```bash
kb task list -s todo
```

- Otherwise, use exactly the provided task IDs.

Read each selected task:

```bash
kb task get "<task-id>"
```

Only handle tasks in `todo`. Ask the user before handling a task with another status. Treat the current conversation as additional requirements and constraints.

Do not modify files or move tasks yet.

### 2. Build execution waves

Read any referenced blocker not already loaded:

```bash
kb task get "<blocker-task-id>"
```

A task is ready only when every blocker is `done`.

Inspect the relevant code and identify dependencies and likely collisions. Put independent tasks in the same execution wave. Sequence tasks that overlap in files, contracts, behavior, or tests.

Report:

- The next execution wave.
- Tasks blocked by dependencies.
- Tasks that must run sequentially.

Ask the user only when required information is missing or contradictory, or the task requires work outside its approved scope.

Do not modify files or move tasks yet.

### 3. Dispatch the execution wave

Dispatch one subagent per independent task. Run colliding tasks sequentially.

Immediately before dispatching a task, claim it:

```bash
kb task move "<task-id>" inprogress
```

Give the subagent the task ID and relevant conversation context. It must read the complete task, implement it, run the relevant checks, and record a concise progress note:

```bash
kb task note "<task-id>" "<what now works>. Tests: <passed|failed>. <important caveat, if any>."
```

After successful implementation and checks, the subagent must record the progress note and move the task to `inreview`:

```bash
kb task move "<task-id>" inreview
```

If implementation or required checks are incomplete, leave the task in `inprogress` and report the blocker.

The subagent must not commit or push.

Do not modify files owned by active subagents. Wait for every subagent in the wave to finish.

If dispatch fails after claiming a task, return it to `todo`:

```bash
kb task move "<task-id>" todo
```

### 4. Review the execution wave with the kb-review skill

After the agents are done, invoke the `$kb-review` skill with the exact task IDs that reached `inreview`. Follow the complete skill and compare each implementation against its task from Step 1.

Handle the review result:

- `done`: accept the task.
- `inprogress`: send the review findings to the same implementation subagent. Wait for it to correct the implementation and move the task back to `inreview`, then invoke the `$kb-review` skill again.
- `inreview`: the review is blocked. Report the blocker or required user input.
- Any other status: stop and report the unexpected transition.

Repeat until every task is `done` or blocked.

Only the `$kb-review` skill may move a task from `inreview` to `done` or back to `inprogress`. Never move a corrected task to `done` directly. Run the `$kb-review` skill again and let it decide the transition.

### 5. Continue through the remaining waves

After each reviewed wave, take the remaining selected `todo` tasks whose blockers are now `done`. Build the next execution wave with Step 2, then dispatch and review it with Steps 3 and 4.

Repeat until every selected task is `done` or no task is ready.

If no task is ready, report each blocked task with its blocker IDs and statuses. Do not implement tasks outside the original selection.

Report the final status and review result for every selected task.

Suggest committing the changes using the `$commit` skill.
