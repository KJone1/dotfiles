---
name: kb-create-task
description: Turn an idea, plan, spec, or conversation into clear, actionable kanban tasks using the kb CLI. Use when you need to clarify requirements, define task boundaries and dependencies, and publish approved tasks.
disable-model-invocation: true
---

# Kanban Create Task

Turn the input into independently useful **kanban tasks**: tracer-bullet vertical slices.

## Grilling rules

Apply these rules throughout kanban task creation:

1. Inspect the selected ideas and relevant codebase before questioning the user.
2. Relentlessly resolve every open question that could change behavior, scope, dependencies, acceptance criteria, constraints, or task decomposition.
3. Ask one question at a time whenever a gap would otherwise force an assumption about a task's scope, behavior, dependencies, or acceptance criteria. Give a clear recommendation with a brief reason and meaningful tradeoff. Figure out task metadata from the requirements and codebase without asking the user to confirm it.
4. Discover technical facts from the codebase. Do not ask the user to design the implementation.
5. Before formulating the plan, examine every idea through each of these grilling lenses:
   - **Scope** — what is explicitly in and out of this work; what looks related but isn't part of it.
   - **Failure** — what happens on error, partial failure, retry, or malformed/empty input.
   - **Intent** — whether the agent's understanding of the desired outcome matches what the user meant, not just the literal wording.
   - **Dependency & blast radius** — what else in the codebase touches this, what could break, what must land first.
   - **Verification** — how anyone, not just the author, can check the work is done without re-asking.

   Ask the user about a grilling lens only when it surfaces a real gap for that specific idea; do not treat this as a fixed checklist of questions asked regardless of relevance.
6. Restate the problem and desired outcome in plain language and get explicit confirmation before formulating the plan in Step 3. This checkpoint is separate from the plan approval in Step 4.
7. Create tasks only after the user approves the plan.

## Process

### 1. Load input

`<selection>` can be one or more idea IDs, `all`, or an inline idea.

1. For `all`, load every open idea:

```bash
kb idea list -s open
```

2. For idea IDs, load each selected idea:

```bash
kb idea get "<idea-id>"
```

3. Include requirements from the current conversation.
4. Resolve missing or conflicting requirements using the grilling rules.
5. Do not mark an idea as processed until all derived kanban tasks are created.

### 2. Analyze the current state

1. Inspect the relevant code, tests, architecture, and project conventions.
2. Identify what exists, what must change, reusable patterns, constraints, dependencies, and risks.
3. Create an elegant, robust, maintainable, yet simple approach that fits the existing architecture. Consider alternatives only when they would materially change the task plan.
4. Reject hacks, fragile workarounds, duplicated logic, and solutions that create unnecessary maintenance costs.
5. Identify prerequisite tasks only when they are required for safe implementation, not merely cleaner.
6. Resolve remaining material decisions using the grilling rules, confirm shared understanding per Rule 6, then formulate the plan.

Do not modify files during this step.

### 3. Formulate the plan

Formulate the plan and the tickets it breaks down into: what each ticket covers and how the tickets relate.

1. Make each task a standalone, narrow, complete tracer-bullet vertical slice that can be implemented, reviewed, tested, and reverted independently within one context window.
2. Split work only when the boundary is justified by domain, blast radius, or a real dependency. Each resulting task must remain independently useful.
3. Include the prerequisite tasks identified in Step 2. Add dependencies only when required.
4. Each task must leave the repository working with its relevant tests passing.
5. For each task, settle its problem, desired outcome, scope boundary, and blockers.
6. Check the plan for missing work, weak boundaries, and incorrect dependencies.
7. Resolve material issues using the grilling rules. Keep revisions internal and show an affected task only when confirmation is useful.

### 4. Present the plan

1. Present the planned ticket ideas in dependency order. For each one, output exactly this and nothing else:

   ```
   <ticket idea>: <the problem it solves and the desired outcome, in plain language>

   Blocked by: <the ticket idea that must land first, or nothing>
   ```

2. Ask the user to approve the complete plan.
3. If changes are requested, revise it and present the complete plan again.
4. Continue only after explicit approval.

### 5. Create the approved tasks

1. Derive every field for each approved ticket idea from the requirements and codebase, without asking the user to confirm them:

   - Concise title.
   - Description with context, the problem, desired outcome, and original raw idea.
   - Priority and `todo` status.
   - Specific labels.
   - Relevant absolute file paths.
   - Concrete, verifiable definition-of-done checkpoints.
   - Hard scope constraints.

2. Give the worker enough discovered context to understand exactly what must change, why, where to start, and how completion will be verified. Include relevant behavior, findings, file paths, symbols, and constraints. Encourage targeted exploration, but do not make the worker rediscover the problem from scratch.
3. Do not prescribe the technical implementation. The coding agent must derive it from the task context as much as possible, then validate it against the codebase.
4. Create tasks in dependency order. Create blockers first and use their returned IDs in dependent tasks.
5. Create each task with every field, using the command below.
6. After all tasks for an idea are created, mark it as processed with `kb idea done "<idea-id>"`.

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

Repeat flags when multiple values apply. Omit `--blocked-by` when there is no blocker. Include each original idea when a task comes from multiple ideas.

The description must be a self-contained worker handoff. Include the relevant findings from Step 2 so the worker does not need to rediscover the problem, while leaving implementation decisions to the worker.
