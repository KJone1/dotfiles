# /plan - Comprehensive Planning Command

## Usage

- `/plan <task description>` - Create an in-depth plan for the specified task.

## Overview

The `/plan` command is a mandatory preliminary phase. YOU MUST analyze the task from multiple angles, assess edge cases, identify risks, and create a comprehensive execution strategy BEFORE making any changes to the codebase. This is a pure planning and analysis phase.

# Planning Process

### 1. YOU MUST Execute the Explore Phase

**IMPORTANT**: Before writing any code, YOU MUST understand the codebase and requirements.

- **Analyze Code**: Use Read, Grep, and Glob tools to understand the existing code structure, patterns, and conventions. The goal is to build a complete mental model of the relevant code. While a broad-to-narrow approach is often effective (e.g., `glob` -> `search_file_content` -> `read_file`), you should use the tools flexibly. For instance, reading a central configuration file first might provide the necessary context to perform a more targeted search.
- **Search Comprehensively**: Identify all related functionality that will be reused or affected by your changes.
- **Identify Dependencies**: Find all files, functions, and components that are connected to the task.
- **Analyze Tooling**: Identify the project's tooling for building, testing, and linting by inspecting files like `package.json`, `justfile`, `Makefile`, etc.
- **Understand Context**: Review all relevant documentation, comments, and existing implementations to build a complete picture.
- **Clarify Ambiguities**: If requirements are unclear, YOU MUST ask clarifying questions before proceeding.
- **Synthesize Key Information**: After gathering information, create a mental summary or temporary note of the most critical information (e.g., key functions, relevant files) to prime the planning process.

**Task Analysis:**

- **Parse Task**: Deconstruct the complete task description to identify primary and secondary objectives.
- **Determine Intent**: Understand the user's desired outcome.

### 2. YOU MUST Conduct a Multi-Angle Assessment

**Technical Considerations:**

- **Evaluate Approaches**: Analyze multiple implementation strategies and document the pros and cons of each.
- **Assess Performance**: Assess the performance implications of your proposed solution.
- **Analyze Security**: Identify potential security vulnerabilities and plan mitigations.
- **Ensure Compatibility**: Analyze backwards compatibility constraints.

**Risk Analysis:**

- **Identify Breaking Changes**: Pinpoint any potential breaking changes your implementation might cause.
- **Identify Edge Cases**: Identify and plan for all edge cases and error scenarios.
- **Evaluate Testing Complexity**: Assess the testing requirements and complexity.

**Best Practices Evaluation:**

- **Adhere to Standards**: YOU MUST review and follow all industry and project-specific conventions.
- **Ensure Quality**: The plan MUST ensure code quality, maintainability, and readability.
- **Assess UX**: Evaluate user experience implications for any UI/UX changes.

### 3. YOU MUST Create a Comprehensive Plan

**Step Breakdown:**

- **Create Atomic Steps**: Divide complex tasks into small, manageable, and atomic steps. An atomic step is a self-contained unit of work that results in a single, verifiable change. It should leave the codebase in a stable state and, crucially, be easily reversible.
- **Establish Dependencies**: Clearly define the dependencies between each step.
- **Define Success Criteria**: For each step, define what success looks like.

**Testing Strategy:**

- **Plan Unit Tests**: Design unit tests for all new functionality.
- **Plan Integration Tests**: Design scenarios for integration testing.
- **Plan Manual Validation**: Define the steps for manual testing and validation.

**Documentation Plan:**

- **Identify Updates**: Determine which documentation files MUST be updated.
- **Plan Comments**: Plan for clear and concise code comments where necessary.

### 4. YOU MUST Define the Implementation Strategy

**Execution Order:**

- **Prioritize Steps**: Order the steps by risk and dependency, tackling the highest-risk items first.
- **Identify Critical Path**: Determine the critical path for the implementation.
- **Define Checkpoints**: Establish validation checkpoints to review progress.

### 5. YOU MUST Generate a Plan Output File

**Create `plan.md`:**

- **Generate File**: Create a detailed `plan.md` file in the project root.
- **Document Instructions**: Include step-by-step execution instructions.
- **Record Decisions**: Document all technical decisions, considerations, and trade-offs.

**Plan Structure:**

```markdown
# Plan: [Task Description]

## Executive Summary
- Brief overview of the task and the chosen approach.

## Definition of Done
- A clear, concise list of criteria that MUST be met for the task to be considered complete.

## Non-Goals
- A list of items that are explicitly out of scope for this task to prevent scope creep.

## Assumptions
- A list of any assumptions made about the codebase, environment, or requirements.

## Environment Considerations
- A list of any differences in configuration, API keys, or behavior the implementation must account for across different environments (development, staging, production).

## Technical Analysis
- Architecture decisions and rationale.
- Technology choices.
- Performance, security, and compatibility considerations.
- (Optional) ASCII diagrams or Mermaid syntax for complex architectural changes.

## Alternative Approaches Considered
- A brief description of other viable approaches and why they were not chosen.

## Implementation Steps
1.  **Step 1**: [Description]
    -   **Rationale**: [Why this step is necessary]
    -   **Dependencies**: [What must be done first]
    -   **Success Criteria**: [How to verify completion]
    -   **Verification**: [The *exact* command(s) to run to prove the step was successful (e.g., 'pytest tests/test_feature.py')]
    -   **Risks**: [Potential issues with this step]
    -   **Effort**: [e.g., S, M, L]

## Major Checkpoints
- A high-level list of milestones where progress can be re-validated.

## Testing Strategy
- Unit testing approach.
- Integration testing plan.
- Manual testing scenarios.

## Documentation Updates
- List of documents to be updated.
- Plan for code comments.

## Resources & Links
- A list of relevant URLs or file paths for future reference.

## Identified Risks
- A list of potential problems or obstacles.

## Mitigation Strategy
- A corresponding list of actions to prevent or handle the identified risks.

## Estimated Timeline
- A high-level, optional timeline (e.g., "Phase 1: 2-3 hours").
```

### 6. YOU MUST Validate the Plan

**Self-Correction Checklist:**

Before presenting the plan, YOU MUST answer the following questions:
- Have I read all files relevant to the changes?
- Does the plan account for the project's existing patterns, conventions, and frameworks?
- Have I identified the riskiest part of the plan and prioritized it accordingly?
- Does each implementation step have a clearly defined and tested rollback procedure?
- Is the testing strategy sufficient to prevent regressions?
- Does the plan address the user's request completely?

**Stakeholder Review:**

- **Present Plan**: YOU MUST present the plan to the user for feedback and approval.
- **Address Concerns**: YOU MUST answer any questions and address all concerns.
- **Get Approval**: YOU MUST get explicit approval from the user before proceeding with implementation.

### 7. Cleanup Process

**Plan File Management:**

- **Store Plan**: Keep the `plan.md` file in a temporary location for reference during execution.
- **Clean Up**: After the task has been fully implemented and all related code has been committed, YOU MUST delete the temporary `plan.md` file.

## IMPORTANT: Planning Best Practices

- **Thoroughness**: YOU MUST plan for all scenarios and analyze all potential second and third-order effects of your changes.
- **Clarity**: The plan MUST use clear, direct, and actionable language. All technical terms MUST be defined.
- **Flexibility**: The plan MUST be adaptable. If new information requires a significant deviation from the approved plan, YOU MUST halt execution, update the `plan.md` file, and re-submit it for user approval before proceeding. A significant deviation includes, but is not limited to: changing a core library, altering a public API, choosing a different implementation strategy, introducing a new major dependency, or changing the database schema.
- **Collaboration**: YOU MUST involve stakeholders in the review process to ensure alignment.

## Integration with Workflow

The planning process is the foundation of the entire workflow:

1.  **Explore Phase**: Gather context.
2.  **Plan Phase**: Use `/plan` to create the comprehensive plan.
3.  **Code Phase**: Execute the plan systematically.
4.  **Commit Phase**: Commit changes following the `/commit` guidelines.