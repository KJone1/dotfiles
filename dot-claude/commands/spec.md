---
description: Interview-driven specification writing for features, systems, or changes
argument-hint: feature_description
---

# /spec

## Workflow

1. **Understand Request**: Read user's initial spec request (feature/system/change)
2. **Conduct Interview**: Use AskUserQuestion continuously until complete understanding
3. **Write Specification**: Create SPEC.md with comprehensive details

## Interview Strategy

**Depth Requirements:**
- NEVER ask obvious questions answerable from initial request
- Probe assumptions, edge cases, failure modes
- Challenge design choices to surface tradeoffs
- Ask 2-4 questions per round until complete

**Question Categories (prioritize by request type):**

Technical Implementation:
- Architecture: monolith vs microservices, sync vs async, stateful vs stateless
- Data flow: write path, read path, consistency model, caching strategy
- Dependencies: external services, libraries, version constraints
- Performance: latency requirements, throughput targets, bottlenecks
- Scaling: horizontal vs vertical, sharding strategy, load distribution
- Error handling: retry logic, circuit breakers, fallback behavior
- Monitoring: metrics to track, alerting thresholds, debug visibility

Data & State:
- Schema: required fields, optional fields, validation rules, defaults
- Lifecycle: creation, updates, deletion, archival, retention
- Relationships: foreign keys, cascading deletes, referential integrity
- Migration: existing data transformation, backwards compatibility
- Consistency: strong vs eventual, conflict resolution, transaction boundaries

UI/UX (when applicable):
- User journey: entry points, happy path, error states, exit points
- Interaction model: click, hover, keyboard nav, touch gestures
- Feedback: loading states, success confirmation, error messages, progress indication
- Accessibility: screen readers, keyboard-only, color contrast, ARIA labels
- Responsive: mobile breakpoints, tablet layout, desktop optimization
- Edge cases: empty states, loading states, error states, offline mode

API/Interface:
- Endpoints: HTTP methods, URL structure, versioning strategy
- Request/Response: payload format, required fields, optional fields, examples
- Authentication: method, token type, refresh strategy, session management
- Rate limiting: limits, headers, throttling behavior, quota resets
- Errors: status codes, error format, message structure, client handling

Security & Privacy:
- Authentication: who can access, auth method, credential storage
- Authorization: permission model, role hierarchy, resource ownership
- Input validation: sanitization, type checking, size limits, allowed patterns
- Data protection: encryption at rest, encryption in transit, PII handling, retention
- Audit: logging requirements, compliance needs, data lineage

Tradeoffs & Constraints:
- Time vs quality: MVP scope, nice-to-haves, future phases
- Complexity vs flexibility: configuration options, hardcoded values, extensibility
- Performance vs maintainability: optimization level, code clarity, premature optimization
- Cost vs capability: infrastructure spend, operational overhead, vendor lock-in
- Build vs buy: custom implementation, third-party service, open source library

Testing & Validation:
- Unit tests: coverage targets, critical paths, mocking strategy
- Integration tests: external dependencies, test data, environment setup
- E2E tests: user flows, regression coverage, flakiness tolerance
- Performance tests: load testing, stress testing, benchmark criteria
- Acceptance criteria: definition of done, success metrics, rollback conditions

Deployment & Operations:
- Rollout strategy: feature flags, canary deployment, blue-green, percentage rollout
- Rollback plan: triggers, automated vs manual, data consistency during rollback
- Monitoring: dashboards, alerts, SLOs, error budgets
- Documentation: runbooks, API docs, architecture diagrams, troubleshooting guides
- Backwards compatibility: API versioning, deprecation timeline, migration guide

**Interview Tactics:**
- Present options when multiple valid approaches exist
- Ask about specific scenarios: "What happens when..."
- Probe non-functional requirements: performance, security, scalability
- Surface implicit assumptions: "You mentioned X, does that mean Y?"
- Check completeness: "Are there other cases we should consider?"

**Completion Criteria:**
- All critical decisions documented
- Edge cases identified and addressed
- Tradeoffs explicitly stated
- Success metrics defined
- No major ambiguities remaining

## Specification Structure

Write to SPEC.md:

```markdown
# [Feature/System Name]

## Overview
[1-2 sentences: what and why]

## Goals
- [Primary objective]
- [Secondary objectives]

## Non-Goals
- [Explicit exclusions]

## Requirements

### Functional
- [Specific behaviors, inputs, outputs]

### Non-Functional
- Performance: [latency, throughput]
- Security: [auth, authz, data protection]
- Scalability: [growth expectations]
- Reliability: [uptime, error rates]

## Architecture

### Components
- [Component]: [Responsibility]

### Data Flow
[Request → Processing → Response with decision points]

### Data Model
[Schemas, relationships, constraints]

## API/Interface

### Endpoints (if applicable)
[Method, path, request/response, errors]

### UI Flow (if applicable)
[Screens, interactions, states]

## Edge Cases
- [Scenario]: [Behavior]

## Tradeoffs
- [Decision]: [Chosen approach] over [Alternative] because [Reasoning]

## Testing Strategy
- Unit: [Coverage]
- Integration: [Dependencies]
- E2E: [Critical flows]

## Deployment
- Rollout: [Strategy]
- Monitoring: [Metrics, alerts]
- Rollback: [Triggers, process]

## Success Metrics
- [Metric]: [Target]

## Open Questions
[Unresolved items requiring future decisions]
```

## Execution Notes

- Read existing codebase patterns before asking architectural questions
- Reference specific files/components when asking implementation questions
- Group related questions in single AskUserQuestion call (max 4)
- After each answer round, synthesize understanding before next questions
- When user indicates completion, write SPEC.md immediately
