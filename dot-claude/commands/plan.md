# /plan - Comprehensive Planning Command

## Usage

- `/plan <task description>` - Create an in-depth plan for the specified task

## Overview

The plan command is a pure planning phase where Claude analyzes the task from multiple angles, considers edge cases, identifies risks, and creates a comprehensive execution strategy WITHOUT making any actual changes to the codebase.

## Planning Process

### 1. Explore Phase

**Understand the codebase and requirements before making any changes:**

- **Read and analyze**: Use Read, Grep, and Glob tools to understand existing code structure
- **Search comprehensively**: Look for related functionality, patterns, and conventions
- **Identify dependencies**: Find files, functions, and components that might be affected
- **Understand context**: Review documentation, comments, and existing implementations
- **Ask clarifying questions**: If requirements are unclear, ask the user for clarification

**Example exploration activities:**
```bash
# Search for existing implementations
grep -r "similar_functionality" .
# Find related files
find . -name "*related*" -type f
# Understand project structure
ls -la && cat README.md
```

**Task Analysis:**
- Parse and analyze the complete task description
- Identify primary and secondary objectives
- Understand user intent and desired outcomes
- Clarify ambiguous requirements through questions if needed

### 2. Multi-Angle Assessment

**Technical Considerations:**
- Evaluate multiple implementation approaches
- Consider performance implications
- Assess security requirements and vulnerabilities
- Analyze backwards compatibility constraints
- Review scalability and maintainability factors

**Risk Analysis:**
- Identify potential breaking changes
- Consider edge cases and error scenarios
- Evaluate testing complexity and requirements
- Assess rollback and recovery strategies
- Consider dependency conflicts and version issues

**Best Practices Evaluation:**
- Review industry standards and conventions
- Consider code quality and maintainability
- Evaluate documentation and testing needs
- Assess user experience implications
- Consider accessibility and internationalization

### 3. Comprehensive Planning

**Step Breakdown:**
- Divide complex tasks into atomic, manageable steps
- Establish clear dependencies between steps
- Define success criteria for each step
- Estimate effort and complexity for each component
- Identify parallel vs sequential execution opportunities

**Testing Strategy:**
- Plan unit tests for new functionality
- Design integration test scenarios
- Consider end-to-end testing requirements
- Plan manual testing and validation steps
- Define rollback testing procedures

**Documentation Plan:**
- Identify documentation updates needed
- Plan code comments and inline documentation
- Consider API documentation changes
- Plan user-facing documentation updates
- Define migration guides if needed

### 4. Implementation Strategy

**Execution Order:**
- Prioritize steps by risk and dependency
- Identify critical path components
- Plan incremental delivery milestones
- Define validation checkpoints
- Establish feedback loops and review points

**Resource Planning:**
- Identify required tools and libraries
- Plan development environment setup
- Consider team coordination needs
- Plan code review and approval processes
- Define deployment and release strategy

### 5. Plan Output

**Create Temporary Plan File:**
- Generate detailed `plan.md` file in project root
- Include step-by-step execution instructions
- Document all considerations and decisions
- Provide reference links and resources
- Include troubleshooting and fallback options

**Plan Structure:**
```markdown
# Plan: [Task Description]

## Executive Summary
- Brief overview of the task and approach

## Technical Analysis
- Architecture decisions and rationale
- Technology choices and alternatives
- Performance and security considerations

## Implementation Steps
1. Step 1: [Description]
   - Rationale: [Why this step]
   - Dependencies: [What must be done first]
   - Success criteria: [How to verify completion]
   - Risks: [Potential issues]

## Testing Strategy
- Unit testing approach
- Integration testing plan
- Manual testing scenarios

## Documentation Updates
- Code documentation changes
- User documentation updates
- API documentation changes

## Risk Mitigation
- Identified risks and mitigation strategies
- Rollback procedures
- Alternative approaches

## Timeline and Milestones
- Estimated effort for each phase
- Key validation checkpoints
- Delivery milestones
```

### 6. Plan Validation

**Review and Refinement:**
- Validate plan completeness and accuracy
- Check for missing dependencies or steps
- Verify risk mitigation strategies
- Confirm testing coverage adequacy
- Ensure documentation completeness

**Stakeholder Review:**
- Present plan to user for feedback and approval
- Address questions and concerns
- Refine plan based on feedback
- Confirm understanding and expectations
- Get explicit approval before proceeding

### 7. Cleanup Process

**Plan File Management:**
- Store plan in temporary location for execution reference
- Version control plan file if changes are made
- Archive completed plans for future reference
- Clean up temporary files after task completion
- Maintain plan history for similar future tasks

## Planning Best Practices

**Thoroughness:**
- Better to over-plan than under-plan
- Consider second and third-order effects
- Plan for failure scenarios and edge cases
- Include multiple implementation alternatives
- Document assumptions and constraints

**Clarity:**
- Use clear, actionable language
- Define technical terms and concepts
- Provide context and rationale for decisions
- Include examples and references
- Make steps specific and measurable

**Flexibility:**
- Build in adaptation points and decision gates
- Allow for discovery and learning during execution
- Plan for requirement changes and pivots
- Include alternative approaches and fallbacks
- Design for iterative refinement

**Collaboration:**
- Involve stakeholders in plan review
- Seek expert input on complex technical decisions
- Plan for team coordination and communication
- Include knowledge transfer and documentation
- Design for code review and quality assurance

## Integration with Workflow

The plan command integrates with the overall Claude Code workflow:

1. **Explore Phase**: Gather context and understand requirements
2. **Plan Phase**: Use `/plan` command to create comprehensive plan
3. **Code Phase**: Execute plan systematically using TodoWrite
4. **Commit Phase**: Commit changes following established practices

The plan command ensures thorough preparation before any code changes, reducing errors and improving quality.