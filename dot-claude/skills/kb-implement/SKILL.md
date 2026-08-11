---
name: kb-implement
description: Implement selected kanban tasks test-first with subagents, then use a dedicated kb-review subagent to independently review and accept their changes.
argument-hint: [task-id, task-ids, or all]
disable-model-invocation: true
---

# Kanban Implement

Implement the selected `todo` tasks. Build dependency-aware execution waves and dispatch non-colliding tasks to dedicated subagents. After the agents are done, dispatch a dedicated subagent using the `kb-review` skill to independently review and accept their changes.

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

Only handle tasks in `todo`. Ask the user before handling a task with another status. Treat the task as the authoritative source of requirements. If the current conversation adds or changes a requirement, ask the user to update the task before continuing.

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

Give the subagent the task ID. It must read the complete task, including its description, definition of done, relevant files, and constraints, before changing code.

For each testable behavior, the subagent must work in vertical red-green cycles:

1. Identify the public interface where the behavior is observable.
2. Write one focused test that describes the required behavior, not the implementation.
3. Derive expected results from the task, specification, or a known example, never by repeating the implementation's calculation.
4. Run the test and confirm it fails because the behavior is missing or incorrect, not because the test is broken.
5. Write the minimum production code needed to make that test pass.
6. Run the test and confirm it passes.
7. Repeat with the next behavior, then run the relevant regression checks.

Do not write all tests before all implementation. Do not write production code before its failing test. Test through public interfaces, avoid testing private methods or mocking internal collaborators, and do not add tests to satisfy a coverage percentage. After confirming a test fails for the expected reason, do not weaken or rewrite it to accommodate the implementation. Change it only when it contradicts the task or is itself incorrect. Refactor only while the tests are green. If the task has no testable runtime behavior, use the appropriate deterministic verification instead of creating an artificial test.

After implementation and checks, record a concise progress note:

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

### 4. Review the execution wave with an independent subagent

After all implementation subagents in the wave finish, dispatch one dedicated review subagent for the entire wave. Give it the exact task IDs that reached `inreview` and instruct it to follow the complete `kb-review` skill. Do not give it implementation summaries, suspected findings, or proposed conclusions. Wait for it to finish.

The main agent must not perform the review or move tasks out of `inreview`. The review subagent must not modify implementation files or fix findings.

Handle the review result:

- `done`: accept the task.
- `inprogress`: send the review findings to the same implementation subagent. For corrections that change behavior, require the same vertical red-green cycle before modifying production code. Wait for it to correct the implementation and move the task back to `inreview`, then send the exact task IDs to the same review subagent and instruct it to follow the complete `kb-review` skill again.
- `inreview`: the review is blocked. Report the blocker or required user input.
- Any other status: stop and report the unexpected transition.

Repeat until every task is `done` or blocked.

Only the review subagent following the `kb-review` skill may move a task from `inreview` to `done` or back to `inprogress`. Never move a corrected task to `done` directly. Send it back to the same review subagent and let that subagent decide the transition.

### 5. Continue through the remaining waves

After each reviewed wave, take the remaining selected `todo` tasks whose blockers are now `done`. Build the next execution wave with Step 2, then dispatch and review it with Steps 3 and 4.

Repeat until every selected task is `done` or no task is ready.

If no task is ready, report each blocked task with its blocker IDs and statuses. Do not implement tasks outside the original selection.

Report the final status and review result for every selected task.

Suggest committing the changes using the `commit` skill.
