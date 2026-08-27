---
name: create-todo
description: Break a task into a structured micro-task plan in a markdown file. Use when the user wants to plan work, track progress, or decompose a complex task.
argument-hint: task description or goal
user-invocable: true
---

# Todo List Builder

The output file is the **single source of truth** for this task. It is primarily consumed by **LLM coding agents** across multiple sessions - any agent reading it must be able to understand the **full context**, **current state**, **what has been done**, and **what remains**, with **no prior knowledge** of the task.

**Do NOT start writing** until you understand the full scope. If the task is ambiguous, ask **one clarifying question**.

Before writing the file, **gather context**: list relevant existing resources, read key config files, run discovery commands, map current state and dependencies. Use the findings to populate the **Current Setup** section.

Rules:

* Each phase is a coherent unit of work (research, setup, implementation, validation, writeup)
* Phases are ordered by dependency: you cannot implement before you understand
* Each phase contains `- [ ]` checkboxes
* Break each task into micro-tasks - a single shell command or a single file read/write, something you can point at and say "done" with no ambiguity (clear pass/fail)
  * Good: `- [ ] enable API: gcloud services enable certificatemanager.googleapis.com --project=my-project`
  * Bad: `- [ ] Research DNS stuff`
* Every additive task (create, run, add) must be followed immediately by a validation task confirming it succeeded
  * Good:
    ```
    - [ ] enable API: gcloud services enable certificatemanager.googleapis.com --project=my-project
    - [ ] validate enabled: gcloud services list --project=my-project | grep certificatemanager
    ```
  * Bad (no validation after):
    ```
    - [ ] enable API: gcloud services enable certificatemanager.googleapis.com --project=my-project
    ```
* If the user mentions something is already done, mark it `- [x]` in the output
* No filler text, no "this phase will...", no meta-commentary inside the file
* Micro-task lines start with a verb: run, read, create, verify, add, remove, confirm, update
* Write the command directly in the task line, not as a description (e.g. `- [ ] gcloud ...` not `- [ ] run the gcloud command`)
* For file modifications, include `from` / `to` blocks inline:
  ```
  - [ ] update /etc/nginx/nginx.conf:
    from: `worker_processes 1;`
    to:   `worker_processes auto;`
  ```
* For file creation, one task per file with an explicit source if mirroring:
  ```
  - [ ] copy: `cp path/to/source/main.tf path/to/new/main.tf`
  ```
  Or with inline content for small/known files:
  ````
  - [ ] create path/to/new/main.tf:
    ```hcl
    resource "google_certificate" "example" {
      name = "example"
    }
    ```
  ````

Write the file to `../md/<task-slug>.md` relative to the current working directory, unless the user specifies a path.

The file must follow this exact structure:

```markdown
# <Title>

> **Agent Execution Rules:**
> 1. Never skip a task - always start from the first unchecked `- [ ]` item and work sequentially.
> 2. After completing each task, immediately mark it `- [x]` before moving to the next.
> 3. Work one phase at a time - complete and check off all tasks in a phase before starting the next.

**Ticket:** [<ID>](<jira-url>) (omit if no ticket)

## Goal

<One paragraph. What are we validating or building, and why does it matter.>

## Current Setup

<Bullet list of actual findings from context gathering: existing resources, configs, conventions.>

## Open Questions

- [ ] <unknown to resolve before implementation>

## Notes / Findings

<Empty at creation. Agents append findings, decisions, and discovered state here as work progresses.>

---

## Phase N - <Name>

- [ ] <action task>
- [ ] <validate action task succeeded>
...

---
```
