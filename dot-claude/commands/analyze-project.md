---
description: Analyze IaC patterns, deployment configs, operational conventions via gemini CLI
---

# /analyze-project

## Principles

1. DELEGATE: Construct gemini prompt; gemini does analysis
2. FOCUS: Infrastructure/operational conventions
   - IaC structure, module dependencies (Terraform)
   - Deployment configs, value management (Helm)
   - Environment definitions, promotion paths
   - CI/CD integration points
   - Skip application logic
3. ACTIONABILITY: Architectural patterns/code structure over statistics. Goal: practical understanding for quick onboarding/contribution

   Request patterns/structure/relationships, not counts:
   - ❌ "Count modules", "List all variables", "How many resources"
   - ✅ "Identify module dependency patterns", "Describe layering approach", "Explain environment structure"

   Request practical insights:
   - ❌ "Generate statistics", "Create graph"
   - ✅ "What new developer needs to know", "How to structure new module", "Common patterns"

4. CONVENTIONS: Identify project-specific coding conventions (naming, writing guidelines) for consistent contributions

## Workflow

1. Determine Mode:
   - User Focus: User provides question (e.g., `/analyze-project how are environments structured?`)
   - General: Standalone invocation (e.g., `/analyze-project`)

2. Detect IaC: Search `*.tf`, `Chart.yaml`
   - Both → analyze both separately
   - Neither → general codebase analysis

3. Prompt Construction Guidelines:

   Build gemini prompt based on detected IaC type and mode:

   Terraform:
   - User Focus: User's question + examine:
     - Provider/backend architecture
     - Module dependency relationships
     - Variable/output patterns
     - Component interaction
   - General: Analyze:
     - Root module organization/layering
     - Provider configuration strategy
     - Module dependency patterns/interfaces
     - State management

   Helm:
   - User Focus: User's question + examine:
     - values.yaml organization
     - Subchart dependencies
     - Template helper patterns
     - Component interaction
   - General: Analyze:
     - Chart purpose/architecture
     - Default values organization/override patterns
     - Subchart integration
     - Hook/annotation usage

   Generic (no IaC):
   - User Focus: User's question + analyze relevant structure/patterns
   - General: Analyze:
     - Project organization/architecture
     - Key dependencies/frameworks
     - Common patterns/conventions
     - Configuration management

   All Prompts:
   - Start with `@/` for full codebase context
   - Emphasize architectural patterns over statistics
   - Request practical onboarding insights
   - Request concise response

4. Construct and Execute:
   - Build prompt using step 3 guidelines
   - Format: `gemini -p "..."`
   - Execute

5. Process Output:
   - Read full analysis
   - Synthesize into 3-5 key bullets
   - Keep full output in context for follow-ups

## Iteration

Auto-iterate if output unclear/incomplete:
- < 100 chars
- Error messages
- Missing sections (asked 4, got 1)
- Vague/generic

Refine prompt, rerun gemini

Example: `gemini -p "@/ How does 'production' differ from 'staging' in Helm values? Validate files."`
