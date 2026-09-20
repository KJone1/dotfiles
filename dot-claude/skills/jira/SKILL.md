---
name: jira
description: Solve Jira tickets
argument-hint: ticket
user-invocable: true
disable-model-invocation: true
---

The user wants to solve a Jira ticket. Analyze the requirements and implement the solution.

<fetch-ticket phase="1">

Fetch the ticket: `acli jira workitem view <KEY> --json --fields "*all"`

Extract from the JSON:

* Key/ID
* Title (summary)
* Description
* Labels
* Type (issuetype)
* Priority
* Status
* Custom fields: Team, Tags, Story Points

</fetch-ticket>

<analyze phase="2">

* Identify: Affected repositories, services, files, and dependencies
* Understand: Architecture, configuration, and current behavior
* Review: Existing patterns, naming conventions, and style
* No new tools or dependencies unless strictly necessary

</analyze>

<attack-plan phase="3">

* Root Cause and Scope: Define the exact problem and boundary of change
* Technical Solution: Specific files, modules, and logic to modify
* Impact Analysis: Callers, consumers, configurations, and blast radius
* Security: Least privilege, secret management, and boundary validation

</attack-plan>

<implementation phase="4">

Validate:

* Check existing state and target files before editing

Implement:

* Minimal, clean changes strictly satisfying ticket requirements
* Follow existing codebase patterns and architecture
* Keep solutions simple, robust, and DRY

Refine:

* Remove debug residue and commented code
* Ensure changes are self-contained and minimal

</implementation>
