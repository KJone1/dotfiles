---
name: kb-implement
description: Implement selected kanban tasks test-first with subagents, then use a dedicated kb-review subagent to independently review and accept their changes.
argument-hint: [task-id, task-ids, or all]
disable-model-invocation: true
---

# Kanban Implement

<objective>

Implement selected `todo` kanban tasks test-first with dedicated implementation subagents.

Build dependency-aware execution waves, run independent tasks concurrently, and sequence tasks that can collide.

After each wave, use a dedicated subagent following the complete `kb-review` skill to independently review the work and decide whether each task is accepted or returned for correction.

</objective>

<inputs>

## Selection

Accept `<selection>` as:

* One task ID.
* Multiple task IDs.
* `all`.

For `all`, select every `todo` task:

```bash
kb task list -s todo
```

Otherwise, use exactly the provided task IDs.

## Task authority

Treat each kanban task as the authoritative source of requirements.

The complete task includes:

* Description.
* Definition of done.
* Relevant files.
* Constraints.
* Blockers.

If the current conversation adds or changes a requirement, ask the user to update the task before continuing.

</inputs>

<guardrails>

## Scope

* Only handle selected tasks in `todo`.
* Ask the user before handling a selected task with another status.
* Do not implement tasks outside the original selection.
* Ask the user only when required information is missing or contradictory, or the task requires work outside its approved scope.

## Repository ownership

* Do not modify files before dispatching an approved execution wave.
* Do not modify files owned by active implementation subagents.
* Wait for every implementation subagent in a wave to finish before starting review.
* Implementation subagents must not commit or push.

## Status ownership

* Claim a task immediately before dispatching its implementation subagent.
* Leave incomplete implementations in `inprogress`.
* Only the review subagent following `kb-review` may move a task from `inreview` to `done` or back to `inprogress`.
* The main agent must not perform the review or move tasks out of `inreview`.
* Never move a corrected task directly to `done`.

## Review independence

* Use a dedicated review subagent for the entire execution wave.
* Do not give the reviewer implementation summaries, suspected findings, or proposed conclusions.
* The review subagent must not modify implementation files or fix findings.

</guardrails>

<workflow>

## 1. Load selected tasks

Resolve the selection using the input contract.

Read every selected task:

```bash
kb task get "<task-id>"
```

Verify that each selected task is in `todo`.

Stop and ask the user before handling a selected task with another status.

Do not modify files or move tasks during this phase.

## 2. Build the next execution wave

Read every referenced blocker that is not already loaded:

```bash
kb task get "<blocker-task-id>"
```

A task is ready only when every blocker is `done`.

Inspect the relevant code and identify:

* Task dependencies.
* Shared files.
* Shared contracts.
* Overlapping behavior.
* Overlapping tests.
* Other likely collisions.

Put independent, non-colliding tasks in the same execution wave.

Sequence tasks that overlap in files, contracts, behavior, or tests.

Report:

* The next execution wave.
* Tasks blocked by dependencies.
* Tasks that must run sequentially.

Resolve missing, contradictory, or out-of-scope requirements before dispatch.

Do not modify files or move tasks during this phase.

## 3. Dispatch the execution wave

Dispatch one dedicated implementation subagent per independent task.

Run colliding tasks sequentially.

Immediately before dispatching a task, claim it:

```bash
kb task move "<task-id>" inprogress
```

Give the implementation subagent the task ID.

Instruct it to:

1. Read the complete task before changing code.
2. Follow the implementation contract.
3. Run the required checks.
4. Record a concise progress note.
5. Move successful work to `inreview`.
6. Leave incomplete work in `inprogress` and report the blocker.
7. Avoid committing or pushing.

If dispatch fails after claiming a task, return it to `todo`:

```bash
kb task move "<task-id>" todo
```

Do not modify files owned by active implementation subagents.

Wait for every implementation subagent in the wave to finish.

## 4. Review the execution wave

Collect the exact task IDs that reached `inreview`.

Dispatch one dedicated review subagent for the entire wave.

Give it only:

* The exact task IDs in `inreview`.
* An instruction to follow the complete `kb-review` skill.

Do not give it implementation summaries, suspected findings, or proposed conclusions.

Wait for the review subagent to finish.

Handle each result using the review contract.

Repeat correction and review until every task in the wave is `done` or blocked.

## 5. Continue through remaining waves

After each reviewed wave, select the remaining original `todo` tasks whose blockers are now `done`.

Build the next wave using Step 2, then dispatch and review it using Steps 3 and 4.

Repeat until:

* Every selected task is `done`, or
* No selected task is ready.

If no task is ready, report every blocked task with its blocker IDs and statuses.

Do not implement tasks outside the original selection.

## 6. Report completion

Report the final status and review result for every selected task.

Suggest committing the accepted changes using the `commit` skill.

</workflow>

<implementation_contract>

## Vertical red-green cycles

For each non-trivial behavior (conditionals, calculations, state transitions, error handling, edge cases):

1. Identify the public interface where the behavior is observable.
2. Write one focused test that describes the required behavior, not the implementation.
3. Derive expected results from the task, specification, or a known example. Never repeat the implementation's calculation in the test.
4. Run the test and confirm it fails because the behavior is missing or incorrect, not because the test is broken.
5. Write the minimum production code needed to make that test pass.
6. Run the test and confirm it passes.
7. Repeat with the next behavior.
8. Run the relevant unit regression checks. Do not run live, manual, QA, or smoke tests.

## Test integrity

* Write unit tests only. Do not write, run, or request live, manual, QA, or smoke tests; the user performs those separately.
* Do not write all tests before all implementation.
* Do not write production code before its failing test.
* Test through public interfaces.
* Avoid testing private methods.
* Avoid mocking internal collaborators.
* Do not add tests only to satisfy a coverage percentage or for the sake of having a test.
* After confirming a test fails for the expected reason, do not weaken or rewrite it to accommodate the implementation.
* Change a test only when it contradicts the task or is itself incorrect.
* Refactor only while the tests are green.

If the behavior is trivial or boilerplate (configuration, wiring, pure refactors, pass-through code) or the task has no testable runtime behavior, use the appropriate deterministic verification (type check, lint, build) instead of creating an artificial test.

## Progress note

After implementation and checks, record a concise progress note:

```bash
kb task note "<task-id>" "<what now works>. Tests: <passed|failed>. <important caveat, if any>."
```

## Handoff to review

After successful implementation and required checks, record the progress note and move the task to `inreview`:

```bash
kb task move "<task-id>" inreview
```

If implementation or required checks are incomplete, leave the task in `inprogress` and report the blocker.

</implementation_contract>

<review_contract>

## Reviewer authority

The dedicated review subagent must follow the complete `kb-review` skill.

The main agent must not perform the review.

The review subagent must not modify implementation files or fix findings.

Only the review subagent may move a task from `inreview` to:

* `done` when accepted.
* `inprogress` when corrections are required.

## Result handling

Handle each reviewed task according to its resulting status.

### `done`

Accept the task.

### `inprogress`

1. Send the review findings to the same implementation subagent.
2. Require the same vertical red-green cycle before production changes when a correction changes behavior.
3. Wait for the implementation subagent to make the corrections and move the task back to `inreview`.
4. Send the exact task IDs to the same review subagent.
5. Instruct it to follow the complete `kb-review` skill again.
6. Wait for the review result.

Never move the corrected task directly to `done`.

### `inreview`

Treat the review as blocked.

Report the blocker or required user input.

### Any other status

Stop and report the unexpected transition.

## Completion condition

Repeat until every task is `done` or blocked.

</review_contract>

<failure_handling>

## Dispatch failure

If dispatch fails after a task was claimed, return it to `todo`:

```bash
kb task move "<task-id>" todo
```

Report the dispatch failure.

## Implementation failure

Leave the task in `inprogress` when implementation or required checks are incomplete.

Report:

* The blocker.
* Failed checks.
* Relevant command output.
* Required user input, when applicable.

## Review blockage

Leave the task in `inreview` when the reviewer cannot reach a conclusion.

Report the blocker or required user input.

## Dependency blockage

When no selected task is ready, report every blocked task with:

* Task ID.
* Blocker IDs.
* Blocker statuses.

</failure_handling>

<output_contract>

Before each execution wave, report:

* Tasks in the wave.
* Tasks blocked by dependencies.
* Tasks that must run sequentially.

After each execution wave, report:

* Implementation result for every dispatched task.
* Verification result for every dispatched task.
* Review result for every task that reached `inreview`.
* Blockers or required user input.

At completion, report:

* Final status for every selected task.
* Final independent review result for every selected task.
* Tasks that remain blocked and why.

Suggest using the `commit` skill only after the accepted changes are ready to commit.

</output_contract>

