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
3. Ask one question at a time only when user input is required to draft correct tasks. Give a clear recommendation with a brief reason and meaningful tradeoff. Infer task metadata from the requirements and codebase without asking the user to confirm it.
4. Discover technical facts from the codebase. Do not ask the user to design the implementation.
5. Publish only after the user approves the final task plan.

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
5. Do not mark an idea as processed until all derived kanban tasks are published.

### 2. Analyze the current state

1. Inspect the relevant code, tests, architecture, and project conventions.
2. Identify what exists, what must change, reusable patterns, constraints, dependencies, and risks.
3. Create an elegant, robust, maintainable, yet simple approach that fits the existing architecture. Consider alternatives only when they would materially change the task plan.
4. Reject hacks, fragile workarounds, duplicated logic, and solutions that create unnecessary maintenance costs.
5. Create prerequisite tasks only when they are required for safe implementation, not merely cleaner.
6. Decide whether the work needs one or multiple tracer-bullet vertical slices. Split only work that can be implemented, reviewed, and tested independently.
7. Resolve remaining material decisions using the grilling rules, then draft the tasks.

Do not modify files during this step.

### 3. Draft kanban tasks

1. Make each task a standalone, narrow, complete tracer-bullet vertical slice that can be implemented, reviewed, tested, and reverted independently within one context window.
2. Split work only when the boundary is justified by domain, blast radius, or a real dependency. Each resulting task must remain independently useful.
3. Create the prerequisite tasks identified in Step 2. Add dependencies only when required.
4. Each task must leave the repository working with its relevant tests passing.
5. Populate every task field:

   - Concise title.
   - Description with context, the problem, desired outcome, and original raw idea.
   - Priority and `todo` status.
   - Specific labels.
   - Blocking tasks, when applicable.
   - Relevant absolute file paths.
   - Concrete, verifiable definition-of-done checkpoints.
   - Hard scope constraints.

6. Give the worker enough discovered context to understand exactly what must change, why, where to start, and how completion will be verified. Include relevant behavior, findings, file paths, symbols, and constraints. Encourage targeted exploration, but do not make the worker rediscover the problem from scratch.
7. Do not prescribe the technical implementation. The coding agent must derive it from the task context as much as possible, then validate it against the codebase.
8. Confirm that every selected idea and requirement is covered.

### 4. Review the task plan

1. Check for missing work, weak boundaries, incorrect dependencies, and unverifiable definition-of-done checkpoints.
2. Resolve material issues using the grilling rules. Keep revisions internal and show an affected task only when confirmation is useful.
3. Present the complete plan in dependency order. For each task, output exactly these three fields and nothing else:

   ```
   Title: <title>

   Desc: <description>

   Blocked by: <blocker-ticket>
   ```

   Do not show priority, labels, relevant files, definition of done, constraints, or the original raw idea.

4. Ask the user to approve the complete plan.
5. If changes are requested, revise it and present the complete plan again.
6. Publish only after explicit approval.

### 5. Publish the approved tasks

1. Create tasks in dependency order. Create blockers first and use their returned IDs in dependent tasks.
2. Create each task with every drafted field:

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

3. After all tasks for an idea are created, mark it as processed:

```bash
kb idea done "<idea-id>"
```
