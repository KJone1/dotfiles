---
name: kb-create-task
description: Turn an idea, plan, spec, or conversation into clear, actionable kanban tasks using the kb CLI. Use when you need to clarify requirements, define task boundaries and dependencies, and publish approved tasks.
disable-model-invocation: true
---

# Kanban Create Task

<objective>

Turn an idea, plan, specification, or conversation into independently useful kanban tasks using the `kb` CLI.

Design every task as a narrow, complete tracer-bullet vertical slice that can be implemented, reviewed, tested, and reverted independently.

Clarify material requirements, inspect the relevant codebase, obtain approval at each required checkpoint, and publish only the approved tasks.

</objective>

<inputs>

## Selection

Accept `<selection>` as:

* One idea ID.
* Multiple idea IDs.
* `all`.
* An inline idea.
* Requirements from the current conversation.

## Sources

Use:

* Selected idea records.
* Requirements from the current conversation.
* Relevant code.
* Existing tests.
* Current architecture.
* Project conventions.
* Existing dependencies and reusable patterns.

</inputs>

<clarification_rules>

## Inspect before asking

Inspect the selected ideas and relevant codebase before questioning the user.

Discover technical facts from the codebase. Do not ask the user to design the implementation.

## Resolve material gaps

Relentlessly resolve every open question that could change:

* Behavior.
* Scope.
* Dependencies.
* Acceptance criteria.
* Constraints.
* Task decomposition.

Ask one question at a time whenever a gap would otherwise force an assumption.

For each question:

* Give a clear recommendation.
* Explain the recommendation briefly.
* State the meaningful tradeoff.

Derive task metadata from the requirements and codebase without asking the user to confirm it.

## Grilling lenses

Before formulating the plan, examine every idea through the relevant lenses.

### Scope

Determine:

* What is explicitly included.
* What is explicitly excluded.
* What appears related but is not part of the work.

### Failure

Determine what happens for:

* Errors.
* Partial failures.
* Retries.
* Malformed input.
* Empty input.

### Intent

Confirm that the understood desired outcome matches the user's intent, not only the literal wording.

### Dependency and blast radius

Determine:

* What else in the codebase touches the change.
* What could break.
* What must land first.
* Which changes can remain independent.

### Verification

Determine how another person can verify completion without re-asking for requirements.

Ask about a grilling lens only when it reveals a real gap for the specific idea. Do not treat the lenses as a fixed questionnaire.

## Approval checkpoints

Require two separate approvals.

### Shared-understanding approval

Before formulating the plan:

1. Restate the problem and desired outcome in plain language.
2. Obtain explicit confirmation that the understanding is correct.

### Plan approval

After presenting the complete task plan:

1. Ask the user to approve the plan.
2. Revise and present the complete plan again when changes are requested.
3. Create tasks only after explicit approval.

Do not combine the shared-understanding approval with the plan approval.

</clarification_rules>

<guardrails>

## Repository changes

Do not modify files while loading input, analyzing the current state, formulating the plan, or presenting it.

## Solution quality

Create an elegant, robust, maintainable, and simple approach that fits the existing architecture.

Reject:

* Hacks.
* Fragile workarounds.
* Duplicated logic.
* Solutions that create unnecessary maintenance costs.

Consider alternative approaches only when they would materially change the task plan.

## Dependencies

Create prerequisite tasks only when they are required for safe implementation, not merely cleaner.

Add task dependencies only when required.

## Task creation

* Do not create tasks before explicit plan approval.
* Do not ask the user to confirm task metadata that can be derived from the requirements and codebase.
* Do not prescribe the technical implementation.
* Do not mark an idea as processed until all kanban tasks derived from that idea are created successfully.

</guardrails>

<workflow>

## 1. Load input

For `all`, load every open idea:

```bash
kb idea list -s open
```

For idea IDs, load each selected idea:

```bash
kb idea get "<idea-id>"
```

For an inline idea, use the idea supplied in the conversation.

Include requirements from the current conversation.

Resolve missing or conflicting requirements using the clarification rules.

Do not mark an idea as processed during this phase.

## 2. Analyze the current state

Inspect the relevant:

* Code.
* Tests.
* Architecture.
* Project conventions.

Identify:

* What already exists.
* What must change.
* Reusable patterns.
* Constraints.
* Dependencies.
* Risks.
* Actual blast radius.

Develop an elegant, robust, maintainable, and simple approach that fits the existing architecture.

Consider alternatives only when they would materially change the task plan.

Reject hacks, fragile workarounds, duplicated logic, and unnecessary maintenance costs.

Identify prerequisite tasks only when required for safe implementation.

Apply every relevant grilling lens.

Resolve remaining material decisions using the clarification rules.

Restate the problem and desired outcome in plain language and obtain shared-understanding approval.

Continue to plan formulation only after the user confirms the understanding.

Do not modify files during this phase.

## 3. Formulate the plan

Formulate the task plan and describe:

* What each task covers.
* What problem each task solves.
* What outcome each task produces.
* How the tasks relate.
* Which dependencies are required.

Apply the task-design contract to every proposed task.

Include prerequisite tasks identified during analysis.

Check the complete plan for:

* Missing work.
* Weak task boundaries.
* Incorrect dependencies.
* Unnecessary dependencies.
* Tasks that are not independently useful.
* Tasks that would leave the repository broken.

Resolve material issues using the clarification rules.

Keep plan revisions internal unless showing an affected task is useful for confirmation.

Do not create kanban tasks during this phase.

## 4. Present the plan

Present the planned ticket ideas in dependency order using the plan contract.

Ask the user to approve the complete plan.

If the user requests changes:

1. Revise the plan.
2. Present the complete plan again.
3. Ask for approval again.

Continue only after explicit approval.

Do not create kanban tasks during this phase.

## 5. Create the approved tasks

Derive every required task field from:

* Approved requirements.
* Codebase findings.
* The approved plan.

Do not ask the user to confirm derived metadata.

Create tasks in dependency order.

Create blocker tasks first and use their returned IDs in dependent tasks.

Create every task using the task-creation contract.

After every task derived from an idea is created successfully, mark the idea as processed:

```bash
kb idea done "<idea-id>"
```

Do not mark an idea as processed when any derived task remains uncreated.

</workflow>

<task_design>

## Vertical slices

Make every task a standalone, narrow, complete tracer-bullet vertical slice.

Each task must be independently:

* Implementable.
* Reviewable.
* Testable.
* Revertible.
* Completable within one context window.

## Split boundaries

Split work only when justified by:

* Domain boundaries.
* Blast radius.
* A real dependency.

Every resulting task must remain independently useful.

Do not split work merely to create smaller tasks.

## Repository integrity

Each task must leave the repository in a working state.

## Definition-of-done scope

Definition-of-done checkpoints describe the goal or outcome only.

Do not specify tests, test types, verification methods, or live/manual/QA testing in a definition-of-done checkpoint.

## Required decisions

For every task, settle:

* The problem.
* The desired outcome.
* The scope boundary.
* The blockers.

## Dependencies

Include required prerequisite tasks.

Add dependencies only when one task must land before another can be completed safely.

</task_design>

<plan_contract>

Present planned ticket ideas in dependency order.

For each ticket idea, output exactly:

```text
<ticket idea>: <the problem it solves and the desired outcome, in plain language>

Blocked by: <the ticket idea that must land first, or nothing>
```

After presenting the complete plan:

1. Ask the user to approve it.
2. Revise it when changes are requested.
3. Present the complete revised plan.
4. Continue only after explicit approval.

</plan_contract>

<task_creation_contract>

## Required fields

Derive every field for each approved task from the requirements and codebase:

* Concise title.
* Description containing context, problem, desired outcome, and original raw idea.
* Priority.
* `todo` status.
* Specific labels.
* Relevant absolute file paths.
* Concrete, verifiable definition-of-done checkpoints.
* Hard scope constraints.
* Required blocker task IDs.

## Worker handoff

Make the task description a self-contained worker handoff.

Include enough discovered context for the worker to understand:

* What must change.
* Why it must change.
* Where to start.
* Relevant current behavior.
* Relevant findings.
* Relevant files and symbols.
* Important constraints.
* How completion will be verified.

Encourage targeted exploration, but do not make the worker rediscover the problem from scratch.

## Implementation boundary

Do not prescribe the technical implementation.

Let the coding agent derive the implementation from the task context and validate it against the codebase.

## Creation order

Create tasks in dependency order.

Create blocker tasks first.

Use returned blocker task IDs when creating dependent tasks.

## Command

Create each task with every required field:

```bash
kb task new "<task-title>" \
  -d "$(cat <<'EOF'
Problem:
<The specific problem this task solves.>

Desired outcome:
<The behavior or state required after completion.>

Context:
<Relevant current state and findings.>

Original raw idea:
Idea ID: <idea-id>
<Copy the original idea without rewriting it.>
EOF
)" \
  --priority "<urgent|high|medium|low>" \
  -s todo \
  -l "<relevant-label>" \
  --blocked-by "<blocker-task-id>" \
  --relevant-file "<absolute-file-path>" \
  --dod "<verifiable completion checkpoint>" \
  --constraint "<hard scope constraint>"
```

## Flag rules

* Repeat flags when multiple values apply.
* Omit `--blocked-by` when there is no blocker.
* Include every original idea when a task comes from multiple ideas.
* Use absolute paths for every relevant file.
* Use concrete and independently verifiable definition-of-done checkpoints.
* Use hard scope constraints that prevent unrelated work.

## Idea completion

After all tasks derived from an idea are created successfully, mark the idea as processed:

```bash
kb idea done "<idea-id>"
```

Do not run this command before every derived task exists.

</task_creation_contract>

<output_contract>

Before task creation, produce:

* A confirmed statement of the problem and desired outcome.
* A complete approved plan in dependency order.

After task creation, report:

* Every created task ID and title.
* Required dependencies.
* Which ideas were marked as processed.
* Any task or idea that could not be created or completed.
* The failed command when a `kb` operation fails.

Do not report an idea as processed unless `kb idea done "<idea-id>"` succeeds.

</output_contract>
