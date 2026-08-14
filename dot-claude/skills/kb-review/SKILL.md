---
name: kb-review
description: Review selected local kanban tasks with the kb CLI, independently verify ticket compliance and engineering quality, and transition conclusive reviews to done or back to inprogress. Use when Codex needs to review one, several, or all tasks currently inreview.
---

# Kanban Review

<objective>

Independently review selected local kanban tasks using the `kb` CLI.

Inspect the actual implementation, apply separate ticket-compliance and engineering-quality gates, verify the selected change set, and transition each task according to its final verdict.

</objective>

<inputs>

## Selection

Accept `<selection>` as:

- One task ID.
- Multiple task IDs.
- `all`.

## Required task status

Review only tasks currently in `inreview`.

Ask the user before handling a selected task with another status.

## Review sources

Use:

- The complete task record.
- Referenced blocker tasks.
- The current codebase.
- The working tree.
- Repository status and diffs.
- Task notes.
- Surrounding code.
- Affected tests.

</inputs>

<guardrails>

## Independence

- Inspect the actual implementation independently.
- Do not accept task notes, implementation summaries, or passing tests as sufficient evidence.
- Do not modify implementation files or fix findings.
- Do not commit or push.

## Board mutations

- Do not move tasks before the transition phase.
- Write task notes and move tasks only through the defined transition rules.
- Never claim a note or status transition that did not succeed.

## Clarification boundaries

Ask the user before continuing when:

- A selected task is not `inreview`.
- Changes cannot be attributed to a selected task.
- Required context is missing.
- Task fields conflict.
- A conclusive review requires work outside the selected scope.

</guardrails>

<workflow>

## 1. Load tasks

For `all`, list every `inreview` task:

```bash
kb task list -s inreview
```

For explicit task IDs, use exactly the supplied IDs.

Read every selected task:

```bash
kb task get "<task-id>"
```

Run the command once for each selected task.

Continue only with tasks whose status is `inreview`. Apply the clarification boundaries when a selected task has another status.

Do not modify files or move tasks during this phase.

## 2. Build the review plan

Build a dependency graph containing every selected task and its `blocked_by` relationships.

Read every referenced blocker:

```bash
kb task get "<blocker-task-id>"
```

Run the command once for each blocker ID.

Record each blocker's status. Review selected blockers before their dependents.

Inspect:

- Repository status.
- Relevant diffs.
- Task notes.
- Surrounding code.
- Affected tests.

Map the implementation changes to each selected task's:

- Description.
- Relevant files.
- Definition of done.
- Constraints.
- Actual blast radius.

Identify overlapping changes that require combined verification across:

- Files.
- Symbols.
- Contracts.
- Schemas.
- Generated artifacts.
- Configuration.
- Tests.

Apply the clarification boundaries when the available evidence does not support a conclusive, properly scoped review.

Report the review plan before reviewing tasks:

- Task review order.
- Dependencies that prevent a task from reaching `done`.
- Overlapping changes that require combined verification.

Do not modify files or move tasks during this phase.

## 3. Review each task

Read the task again immediately before reviewing it:

```bash
kb task get "<task-id>"
```

Use this second read as the current task state and review contract.

Inspect the actual diff and surrounding code.

Apply both acceptance gates defined in the review criteria:

1. Ticket compliance.
2. Engineering quality.

Independently run the verification appropriate to the task:

- Tests.
- Type checks.
- Linters.
- Builds.
- Checks required by the task.
- Focused read-only verification for risks discovered during review when existing checks do not cover them.

Record findings in severity order. For every finding, include when available:

- Affected file and line.
- Concrete impact.
- Required correction.

Assign a provisional verdict using the verdict definitions.

Do not modify implementation files, commit, push, or change task status during this phase.

## 4. Verify the combined change

Verify tasks with overlapping blast radii together.

Run the relevant integration and regression checks across the selected change set.

Attribute every combined-check failure to the responsible task or tasks.

Change a provisional verdict to `failed` when combined verification reveals an actionable deficiency.

Change a provisional verdict to `blocked` when a combined-check failure cannot be attributed reliably.

Before allowing a dependent task to pass, confirm every blocker is:

- `done`, or
- A selected task with a final passing verdict.

Do not modify implementation files, commit, push, or change task status during this phase.

## 5. Record and transition results

Use:

- The final review result for every selected task.
- The findings and verification evidence from the individual and combined reviews.

Process tasks in dependency order.

Apply the transition rule matching each task's final verdict.

If a note or move command fails:

1. Stop processing that task.
2. Report the failed command.
3. Do not claim the note or status transition succeeded.

## 6. Report the review

Follow the output contract after all attempted notes and transitions complete.

</workflow>

<review_criteria>

## Ticket compliance

Confirm that the implementation satisfies the complete:

- Description.
- Relevant files.
- Definition of done.
- Constraints.
- Atomic blast radius.

Reject unrelated or unapproved scope.

## Engineering quality

Confirm that the solution is professional, production-ready, and appropriate for the codebase, not merely functional.

Review every concern relevant to the change.

### Architectural fit

- Reuse established abstractions and patterns.
- Preserve clear boundaries.
- Avoid unnecessary new paradigms.

### Correctness depth

Reason through:

- Normal paths.
- Edge cases.
- Failure paths.
- Recovery paths.
- State transitions.
- Cleanup where applicable.

### Maintainability

Require:

- Clear naming.
- Cohesive responsibilities.
- Minimal complexity.
- Useful comments only where needed.
- No dead code.
- No debug residue.
- No duplication.
- No hacks.
- No fragile workarounds.

### Compatibility and completeness

Confirm that affected items are updated when required:

- Callers.
- Contracts.
- Schemas.
- Configuration.
- Migrations.
- Generated artifacts.
- Documentation.

### Production concerns

Assess in proportion to the task's risk:

- Security.
- Data integrity.
- Concurrency.
- Performance.
- Resource use.
- Observability.
- Backward compatibility.

### Test quality

Require meaningful tests at the appropriate level that exercise:

- Changed behavior.
- Important failure paths.
- Important regression paths.

Reject:

- Tautological tests.
- Tests coupled only to implementation details.

### Scope discipline

Do not demand:

- Speculative abstractions.
- Unrelated cleanup.
- Scope expansion in the name of quality.

</review_criteria>

<verdicts>

## Passed

Assign `passed` only when:

- Ticket compliance passes.
- Engineering quality passes.
- Every required check passes.
- Every definition-of-done checkpoint is met.
- Every blocker is `done` or is a selected task with a final passing verdict.

## Failed

Assign `failed` when at least one actionable ticket-compliance or engineering-quality deficiency remains.

## Blocked

Assign `blocked` when a reliable verdict is prevented by:

- Missing context.
- An external verification failure.
- An inseparable change.
- A combined-check failure that cannot be attributed reliably.

</verdicts>

<transitions>

## Failed

Record a concise deficiency note:

```bash
kb task note "<task-id>" "Review failed: <ticket or quality deficiency>. Required correction: <correction>."
```

After the note succeeds, move the task to `inprogress`:

```bash
kb task move "<task-id>" inprogress
```

## Passed

Record the verification result:

```bash
kb task note "<task-id>" "Review passed: <commands and checks>. Result: passed."
```

After the note succeeds, move the task to `done`:

```bash
kb task move "<task-id>" done
```

## Blocked

Record the blocker:

```bash
kb task note "<task-id>" "Review blocked: <reason>. Required next step: <action>."
```

Keep the task in `inreview`.

## Transition invariants

- Process tasks in dependency order.
- Write the task note before attempting its status transition.
- Move a task only after its note succeeds.
- Stop processing a task when its note or move command fails.
- Do not move a task to `done` when any definition-of-done checkpoint is unmet.
- Do not move a task to `done` when either acceptance gate fails.
- Do not move a task to `done` when a required check fails.
- Do not move a task to `done` when a blocker is not `done`.
- Do not modify implementation files, commit, or push.

</transitions>

<output_contract>

Report blocking findings first in severity order.

Include file and line references when available.

If no blocking findings remain, state that explicitly.

For every selected task, report:

- Final review verdict.
- Resulting kanban status.
- Acceptance checks performed.
- Commands and verification run.
- Residual risk.
- Verification gaps.

Distinguish:

- Code deficiencies.
- External blockers.
- Environmental blockers.

Do not report a task as passed or `done` unless its note and status transition both succeeded.

</output_contract>
