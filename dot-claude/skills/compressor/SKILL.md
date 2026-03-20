---
name: compressor
description: Guide for high-signal token compression for files and text. This skill should be used when users want to reduce the token count of a file or text while preserving 100% of its functional meaning and core directives.
disable-model-invocation: true
---

# Compress

<workflow>
1. User provides text via `@` file reference or by pasting it
2. Extract core directives, instructions, constraints, examples, behaviors, technical terms, commands
3. Analyze and categorize text: Critical (PRESERVE), Clarifying (CONDENSE), Redundant/Filler (ELIMINATE)
4. Apply the Core Principles
5. Report: Original [X] tokens → Compressed [Y] tokens ([Z]% reduction)
</workflow>

<core-principles>
1. ELIMINATE (Delete entirely → common words, short sentences, natural language):

- Filler: very, really, just, simply, basically, actually, essentially
- Redundant phrases: "in order to"→"to", "due to the fact that"→"because", "at this point in time"→"now"
- Repetitive examples
- Politeness, hedging, motivational text, meta-commentary
- Verbose preambles: "for example", "that is", "and so on"
- Obvious implications, general advice, explanatory asides
- Extra formatting: excessive line breaks, spaces, decorative chars, emojis
- Verbose transitions: "For example, you could"→[show directly]
- Obvious connectors: "This means that", "It is important that"→[state directly]

2. CONDENSE (Transform to terse form):

- Verbose sentences→terse imperatives: "You should always"→"Always"
- Paragraphs→bullets (long paragraphs→multiple bullets grouped by logical category)
- Bullets when order irrelevant, numbers when sequence matters
- Wordy conditionals→concise logic: "In cases where"→"When"
- Multiple examples→one representative: "Make sure to"→"Must"
- Long phrases→short phrases→single words
- Cause/effect, conditions, mappings→arrows: "If empty then all"→"Empty → all"
- Clarity beats brevity: "use" not "utilize"
- NEVER use symbols for common words: no "&", "w/", "b/c"
- NEVER remove spaces or create unnatural combinations

3. PRESERVE (Keep exact):

- Unique instructions, specific constraints, critical examples, non-obvious behaviors
- Exact technical terms, commands, paths, numbers, limits, edge cases
- Distinctions: "must" vs "should", "always" vs "prefer"
- Markdown headers
- Natural readability

4. SEMANTIC TEST: "Does this change behavior?"

- Yes → keep
- No → remove
- Creates brittleness (hardcoded if-else logic) → remove
- Too vague (assumes shared context) → add specificity
- Right altitude: avoid brittle if-else logic and vague assumptions; use clear heuristics
- Test strength: "should" → "must" (Bad: recommendation→requirement)
- Test nuance: "works for A, sometimes B" → "works for A and B" (Bad: nuance lost)
- Test specificity: "delete 'temp.csv'" → "delete temp file" (Bad: specificity lost)
</core-principles>
