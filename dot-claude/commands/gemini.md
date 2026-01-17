---
description: Claude & gemini iterate to find optimal, verified solutions
argument-hint: question
---

# /gemini

## Principles

1. DELEGATE: Offload to gemini
2. SCAN-FIRST: Quick scope
3. CONVERSE: Iterate
4. STRUCTURED: Prompts with @/
5. VALIDATE: Checkpoints
6. CROSS-VERIFY: Gemini validates
7. ITERATE: Both confirm
8. SYNTHESIZE: Verified response

## Workflow

**KEY**: Claude asks itself questions, documents, THEN asks gemini same via `gemini -p` → compare → independent evaluations.

### 0. Triage

Assess complexity:
- Simple (known location, single answer): Fast path → Steps 1,2,6,11 only
  - Examples: "where is X defined?", "what does function Y do?"
- Complex (architectural, multiple components, needs quality eval): Full workflow → all steps
  - Examples: "how does auth work?", "explain feature Z", "best way to implement X?"

### 1. Parse Input

Question (argument, required) or prompt user

### 2. Claude Scan

Understand scope/intent via grep, glob, fast (no deep reads)

### 3. Construct Gemini Prompt

Scope decision:
- Use `@/` (full codebase): complex questions, architectural, multiple components
- Use targeted context: simple questions, known files/directories

Structure:
- Start: `@/` or `@specific/path`
- Include: user question
- Instructions by type:
  - Code/Architecture: patterns, relationships, dependencies
  - Bug: trace flow, root causes
  - Feature: how works, key files, integration
  - General: context, insights
- Request: concise, actionable
- Emphasize: patterns over statistics
- Format: `gemini -p "..."`

### 4. Conversation

**Round 1**: Run gemini, capture

**Rounds 2-N**: Analyze → identify unclear/vague/missing → follow-up (reference context, specific questions, challenge) → run gemini

**Stop** (any): comprehensive understanding, all answered, no gaps, repetitive, error

**Guidelines**: 1-3 focused questions/round, build progressively, stay focused

### 5. Self-Validation (Checkpoint 1)

**Purpose**: Verify gemini's claims against actual code

- File verification: check ALL paths, read key files
- Pattern confirmation: grep, verify matches
- Cross-reference: compare scan, find discrepancies
- Code reading: verify claims
- Accuracy: verify EVERY claim
- Gap identification: list ALL missing/unclear
- Confidence: rate each

If confidence < high: ask gemini before proceeding

### 6. Draft Synthesis

Merge conversation, add verified findings, include file:line, note unverified, identify uncertainties

**Critical**: draft only, not for user

### 7. Self-Review (Checkpoint 2)

**Purpose**: Review synthesis quality before gemini cross-verification

Check:
- Completeness: fully answers question?
- Accuracy: all verifiable and correct?
- Consistency: no contradictions?
- Gaps: anything missing/unclear?
- Evidence: every claim backed?

If issues: note for cross-verification

### 8. Cross-Verification (Checkpoint 3)

**Purpose**: Gemini validates synthesis for accuracy and completeness

```bash
gemini -p "@/ Synthesized answer to '[question]':
[Draft]
Review: 1) Factual accuracy? 2) Missing? 3) Misunderstandings? 4) Insights?
Be specific about corrections."
```

Analyze: corrections → update, additions → incorporate, confirmations → confidence, disagreements → investigate

### 9. Quality Assessment (Checkpoint 4)

**Purpose**: Find optimal solution, not just correct one

Step 1: Accuracy

If gemini found issues: update, re-verify, if significant → present revised

Step 2: Quality

**A: Claude ITSELF**

Questions: BEST? More maintainable? Easier? More robust? More elegant? Better alternatives? Trade-offs? Do differently?

Document before asking gemini.

**B: Claude asks GEMINI**

```bash
gemini -p "@/ Regarding [solution] for '[question]':
Current: [summary]
CRITICAL EVALUATION:
1. BEST or BETTER alternatives? Describe specifically
2. More maintainable? How?
3. Easier? What clarifies?
4. More robust? Missing?
5. More elegant? How?
6. Trade-offs? Pros/cons
7. Different? What/why
Brutally honest - OPTIMAL?"
```

**C: Compare**

Agreement/disagreement, missed alternatives, synthesize both

**Critical**: Independent - Claude first, then gemini

Step 3: Better Solutions

If better: document current as "Alt A", ask explore, verify codebase, analyze/compare, ask "which better, why?", iterate

If changes understanding: back to workflow Step 4 (Conversation), explain, re-validate, update, re-run quality

Step 4: Iteration

Continue if ANY: better exists → explore, improvement → investigate, unclear → clarify, disagreement → resolve, quality < good

Stop if: both agree best, no alternatives, trade-offs understood

Step 5: Rate

- Best: optimal, no improvements
- Good: solid, minor improvements not critical
- Needs Improvement: better alternatives exist

### 10. Final Validation (Checkpoint 5)

**Purpose**: Final gate before presenting to user - all quality criteria met

- ✓ Question fully answered
- ✓ High confidence all major claims
- ✓ Quality assessed (both agree)
- ✓ Alternatives explored/evaluated
- ✓ Trade-offs understood/documented
- ✓ Quality rated

**Only proceed if all pass**

### 11. Present Response

1. Direct Answer: findings, file:line, comprehensive
2. Quality: rate (Best/Good/Needs Improvement), why
3. Trade-offs: strengths (✓), limitations (✗), when optimal
4. Alternatives (if any): better approaches, improvements, why better/worse, recommendations
5. Confidence: verified via code + gemini, uncertainties, level (optional)
