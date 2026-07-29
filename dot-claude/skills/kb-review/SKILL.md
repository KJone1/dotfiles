---
name: kb-review
description: Review selected local kanban tasks with the kb CLI, independently verify ticket compliance and engineering quality, and transition conclusive reviews to done or back to inprogress. Use when Codex needs to review one, several, or all tasks currently inreview.
---

# Kanban Review

Review selected tasks from the local kanban board with the `kb` CLI. Inspect the actual implementation, apply independent ticket-compliance and engineering-quality gates, and transition each task according to the review result.

## Process

### 1. Load tasks

Input:

- `<selection>`: one task ID, multiple task IDs, or `all`.

Steps:

1. If `<selection>` is `all`, list all `inreview` tasks:

```bash
kb task list -s inreview
```

2. If `<selection>` contains task IDs, use exactly those IDs.

3. Read every selected task:

```bash
kb task get "<task-id>"
```

Run this command once for each selected task ID.

4. Continue only with tasks whose status is `inreview`. Ask the user before handling a selected task with another status.

5. Treat the current conversation as additional requirements and constraints.

Do not modify files or move tasks during this step.

### 2. Build the review plan

Inputs:

- The selected `inreview` tasks from Step 1.
- The current codebase and working tree.

Steps:

1. Build a dependency graph containing every selected task and its `blocked_by` relationships.

2. Read every referenced blocker:

```bash
kb task get "<blocker-task-id>"
```

Run this command once for each blocker ID.

3. Record each blocker's status. Review selected blockers before their dependents.

4. Inspect the repository status, relevant diffs, task notes, surrounding code, and affected tests.

5. Map the implementation changes to each selected task's description, relevant files, definition of done, constraints, and actual blast radius.

6. Identify overlapping files, symbols, contracts, schemas, generated artifacts, configuration, and tests that require combined verification.

7. Ask the user before continuing when changes cannot be attributed to a task, required context is missing, task fields conflict, or a conclusive review would require work outside the selected scope.

Output:

- The task review order.
- Dependencies that prevent a task from reaching `done`.
- Overlapping changes that require combined verification.

Do not modify files or move tasks during this step.

### 3. Review each task

Inputs:

- The selected tasks and review plan from Steps 1 and 2.
- The implementation changes for each task.

Steps:

1. Read each task again:

```bash
kb task get "<task-id>"
```

2. Inspect the actual diff and surrounding code. Do not accept task notes, implementation summaries, or passing tests as sufficient evidence.

3. Apply two independent acceptance gates:

   - **Ticket compliance:** Confirm that the implementation satisfies the complete description, relevant files, definition of done, constraints, and atomic blast radius without unrelated or unapproved scope.
   - **Engineering quality:** Confirm that the solution is professional, production-ready, and appropriate for the codebase, not merely functional. Review all concerns relevant to the change:
     - Architectural fit: reuse established abstractions and patterns, preserve clear boundaries, and avoid unnecessary new paradigms.
     - Correctness depth: reason through normal, edge, failure, and recovery paths, including state transitions and cleanup where applicable.
     - Maintainability: require clear naming, cohesive responsibilities, minimal complexity, useful comments only where needed, and no dead code, debug residue, duplication, hacks, or fragile workarounds.
     - Compatibility and completeness: confirm affected callers, contracts, schemas, configuration, migrations, generated artifacts, and documentation are updated when the change requires them.
     - Production concerns: assess security, data integrity, concurrency, performance, resource use, observability, and backward compatibility in proportion to the task's risk.
     - Test quality: require meaningful tests at the appropriate level that exercise changed behavior and important failure or regression paths. Reject tautological tests and tests coupled only to implementation details.
     - Scope discipline: do not demand speculative abstractions, unrelated cleanup, or scope expansion in the name of quality.

4. Independently run the relevant tests, type checks, linters, builds, and other verification required by the task. Add focused read-only verification for risks discovered during review when existing checks do not cover them.

5. Record findings in severity order. Include the affected file and line when available, the concrete impact, and the required correction.

6. Assign one provisional result:

   - `passed`: both acceptance gates and every required check pass.
   - `failed`: at least one actionable ticket-compliance or engineering-quality deficiency remains.
   - `blocked`: missing context, an external verification failure, or an inseparable change prevents a reliable verdict.

Do not modify implementation files, commit, push, or change task status during this step.

### 4. Verify the combined change

Input:

- The provisional results from Step 3.

Steps:

1. Verify tasks with overlapping blast radii together.

2. Run the relevant integration and regression checks across the selected change set.

3. Attribute every combined-check failure to the responsible task or tasks.

4. Change the provisional result to `failed` when the combined change reveals an actionable deficiency.

5. Change the provisional result to `blocked` when a combined-check failure cannot be attributed reliably.

6. Confirm that every blocker is `done` or is a selected task with a final passing result before allowing a dependent task to pass.

Do not modify implementation files, commit, push, or change task status during this step.

### 5. Record and transition results

Inputs:

- The final review result for every selected task.
- The findings and verification evidence from Steps 3 and 4.

Steps:

1. Process tasks in dependency order.

2. For a failed task, record a concise deficiency note:

```bash
kb task note "<task-id>" "Review failed: <ticket or quality deficiency>. Required correction: <correction>."
```

3. After the failure note succeeds, move the task to `inprogress`:

```bash
kb task move "<task-id>" inprogress
```

4. For a passed task, record the verification result:

```bash
kb task note "<task-id>" "Review passed: <commands and checks>. Result: passed."
```

5. After the passing note succeeds, move the task to `done`:

```bash
kb task move "<task-id>" done
```

6. For a blocked task, record the blocker:

```bash
kb task note "<task-id>" "Review blocked: <reason>. Required next step: <action>."
```

Keep a blocked task in `inreview`.

7. If a note or move command fails, stop processing that task and report the failed command. Do not claim a status transition that did not succeed.

Do not move a task to `done` when any definition-of-done checkpoint is unmet, either acceptance gate fails, a required check fails, or a blocker is not `done`.

Do not modify implementation files, commit, or push.

### 6. Report the review

Input:

- The findings, verification evidence, and resulting task statuses.

Steps:

1. Report blocking findings first in severity order, with file and line references when available.

2. If no blocking findings remain, state that explicitly.

3. Report for every selected task:

   - The final review result.
   - The resulting kanban status.
   - The acceptance checks and commands run.
   - Any residual risk or verification gap.

4. Distinguish code deficiencies from external or environmental blockers.

Do not report a task as passed or `done` unless its note and status transition both succeeded.
