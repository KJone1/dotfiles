---
description: Interview-driven specification writing for features, systems, or changes
argument-hint: feature_description
---

# /spec

<workflow>
- Read user's spec request (feature/system/change)
- Use AskUserQuestion until complete understanding
- Write SPEC.md with comprehensive details
</workflow>

<execution-notes>
- Read codebase patterns before architectural questions
- Reference specific files/components in implementation questions
- Synthesize understanding after each answer round
- Write SPEC.md when user indicates completion
</execution-notes>

<interview-strategy>
- NEVER ask obvious questions answerable from request
- Probe assumptions, edge cases, failure modes, non-functional requirements
- Challenge design to surface tradeoffs and present options
- Ask scenarios: "What happens when...", "Other cases?"
- Surface assumptions: "X mentioned, means Y?"
- Follow up when answers are unclear or need further touch ups
</interview-strategy>

<completion-criteria>
- Critical decisions documented
- Edge cases identified/addressed
- Tradeoffs explicit
- Metrics defined
- No ambiguities
</completion-criteria>

## Question Categories

<technical-implementation>
- Architecture: monolith vs microservices, sync vs async, stateful vs stateless
- Data flow: write/read path, consistency, caching
- Dependencies: services, libraries, versions
- Performance: latency, throughput, bottlenecks
- Scaling: horizontal vs vertical, sharding, load distribution
- Error handling: retry, circuit breakers, fallback
- Monitoring: metrics, thresholds, debug visibility
</technical-implementation>

<data-state>
- Schema: required/optional, validation, defaults
- Lifecycle: creation, updates, deletion, archival, retention
- Relationships: foreign keys, cascading deletes, integrity
- Migration: transformation, backwards compatibility
- Consistency: strong vs eventual, conflict resolution, boundaries
</data-state>

<api-interface>
- Endpoints: methods, URL structure, versioning
- Request/Response: format, required/optional, examples
- Auth: method, token type, refresh, session
- Rate limiting: limits, headers, throttling, resets
- Errors: codes, format, structure, handling
</api-interface>

<security-privacy>
- Auth: who, method, storage
- Authz: permission model, roles, ownership
- Validation: sanitization, type checking, limits, patterns
- Protection: encryption (rest/transit), PII, retention
- Audit: logging, compliance, lineage
</security-privacy>

<deployment-operations>
- Rollout: flags, canary, blue-green, percentage
- Rollback: triggers, automated/manual, consistency
- Monitoring: dashboards, alerts, SLOs, budgets
- Docs: runbooks, API, architecture, troubleshooting
- Compatibility: versioning, deprecation, migration
</deployment-operations>
