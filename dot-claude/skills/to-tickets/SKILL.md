---
name: to-tickets
description: Break a plan, spec, or the current conversation into a set of tracer-bullet tickets, each declaring its blocking edges, published as tasks on your local kanban board via the kb CLI.
disable-model-invocation: true
---

# To Tickets

Break a plan, spec, or conversation into a set of **tickets** - tracer-bullet vertical slices, each declaring the tickets that **block** it.

## Process

### 1. Load ideas

Input:

- `<selection>`: one idea ID, multiple idea IDs, `all`, or an inline raw ticket idea.

Steps:

1. If `<selection>` is `all`, list all open ideas:

```bash
kb idea list -s open
```

2. If `<selection>` contains idea IDs, use exactly those IDs.

3. Read every selected idea:

```bash
kb idea get "<idea-id>"
```

Run this command once for each selected idea ID.

4. Treat the current conversation as additional requirements.

5. Ask the user to resolve missing or conflicting requirements before continuing.

6. Do not mark an idea as processed until all derived tickets are published successfully.

### 2. Analyze the current state

Inputs:

- The ideas loaded in Step 1.
- The current codebase.

Steps:

1. Explore the codebase areas related to each idea.

2. Compare each requirement with the current implementation, architecture, tests, and project conventions.

3. Identify existing behavior, missing behavior, constraints, dependencies, risks, and reusable patterns.

4. Formulate an elegant, robust approach that fits the existing architecture and remains maintainable over time.

5. Reject hacks, fragile workarounds, duplicated logic, and solutions that create unnecessary maintenance costs.

6. Consider alternative approaches and explain their meaningful tradeoffs.

7. Identify any prerequisite work, including behavior-preserving refactors, that would make the implementation safer, cleaner, or easier to maintain. Draft each prerequisite as a separate ticket in Step 3 and make it block every ticket that depends on it.

8. Ask the user when an unresolved decision would materially change the scope, behavior, or technical approach.

Do not modify files during this step.

### 3. Draft atomic tickets

Inputs:

- The selected ideas.
- The requirements, approach, and prerequisites identified in Step 2.

Steps:

1. Draft a separate ticket for every prerequisite identified in Step 2.

2. Split work by domain and blast radius. Create separate tickets for backend, frontend, CLI, infrastructure, migrations, and any other independently changeable area.

3. Keep each ticket atomic within its blast radius. Within its domain, make it a narrow but complete path through every required layer and its tests. Do not combine changes that can be implemented, reviewed, tested, or reverted independently.

4. Add dependencies between domain tickets only when required. For example, make a frontend or CLI ticket depend on a backend ticket when it consumes a contract introduced by that backend ticket.

5. Keep each ticket within one fresh context window. Require it to leave the repository working with its relevant tests passing.

6. Populate every ticket field:

   - A concise title.
   - A description containing context, what the ticket solves, the desired outcome, and the original raw idea.
   - A priority.
   - The `todo` status.
   - Specific relevant labels such as `bug`, `ui`, `cli`, `api`, `permissions`, `migration`, or `refactor`.
   - Every blocking ticket, when blockers exist.
   - Every relevant absolute file path.
   - Concrete, verifiable definition-of-done checkpoints.
   - Hard scope constraints.

Do not prescribe the technical implementation approach in the description. The coding agent must derive it from the ticket context and current codebase.

7. For a wide mechanical refactor that cannot remain working as one ticket, draft separate expand-contract tickets:

   - **Expand**: introduce the new form without removing the old form.
   - **Migrate**: move callers in independently verifiable batches.
   - **Contract**: remove the old form after all migration tickets are complete.

8. Make each migration ticket depend on the expand ticket. Make the contract ticket depend on every migration ticket.

9. Confirm that every selected idea and requirement is covered by at least one ticket.

### 4. Review the ticket plan with the user

Input:

- The ticket plan drafted in Step 3.

Steps:

1. Present the tickets in dependency order as a numbered list.

2. Show the following for every ticket:

   - Title.
   - Domain and blast radius.
   - Blocking tickets.
   - What the ticket solves.
   - Desired outcome.
   - Priority and labels.

3. Ask the user to review:

   - Whether each ticket is atomic and focused on one domain.
   - Whether any prerequisite or ticket is missing.
   - Whether any tickets should be split or merged.
   - Whether every dependency is required and correctly ordered.
   - Whether the priority and labels are correct.

4. Ask targeted questions only when the answer changes a ticket field. Clarify missing behavior, edge cases, failure states, permissions, acceptance criteria, or scope boundaries.

5. Do not ask the user to choose the technical implementation approach. The coding agent must derive it from the approved ticket context and current codebase.

6. Update the ticket plan after each answer and present the revised plan.

7. Repeat this review until the user explicitly approves the ticket plan.

Do not create tasks or mark ideas as processed before approval.

### 5. Publish the approved tickets

Inputs:

- The ticket plan approved in Step 4.
- The selected idea IDs.

Steps:

1. Create tickets in dependency order. Create every blocker first and use its returned task ID in the dependent tickets.

2. Create each approved ticket with every field populated:

```bash
kb task new "<ticket-title>" \
  -d "$(cat <<'EOF'
Context:
<Explain the relevant current state and background.>

What this ticket solves:
<Explain the specific problem this atomic ticket addresses.>

Desired outcome:
<Describe the behavior or state that must exist after completion.>

Original raw idea:
Idea ID: <idea-id>
<Copy the original idea text without rewriting it.>
EOF
)" \
  --priority "<urgent|high|medium|low>" \
  -s todo \
  -l "<relevant-label>" \
  --blocked-by "<blocker-task-id>" \
  --relevant-file "<absolute-file-path>" \
  --dod "<concrete, verifiable acceptance checkpoint>" \
  --constraint "<hard scope constraint>"
```

Use one or more specific labels that describe the ticket, such as `bug`, `ui`, `cli`, `api`, `permissions`, `migration`, or `refactor`.

Repeat `-l`, `--blocked-by`, `--relevant-file`, `--dod`, and `--constraint` when multiple values apply.

Omit `--blocked-by` when the ticket has no blockers. Repeat the original raw idea block when a ticket derives from multiple ideas.

The `-d` description must be in-depth and professional. It is the ticket's primary artifact and must let an implementer with no other context pick it up cold.

3. Verify every created ticket:

```bash
kb task get "<task-id>"
```

Confirm that the description, priority, status, labels, blockers, relevant files, definition of done, and constraints match the approved ticket plan.

4. If creation or verification fails, stop. Report the successful task IDs and the failed command. Do not recreate successful tasks or process any ideas.

5. After every ticket derived from an idea is created and verified, mark the idea as processed:

```bash
kb idea done "<idea-id>"
```

Run this command once for each fully processed idea.
