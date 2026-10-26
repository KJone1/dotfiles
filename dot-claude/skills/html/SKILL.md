---
name: html
description: Generate an interactive HTML file for the user to read
argument-hint: what to render
user-invocable: true
---

The user wants to create an HTML artifact from this conversation. It is a ride-along view of where things stand now, not a log or a context dump.

The user is a visual learner and skips long text. HTML shows diagrams, code blocks, and custom reactive elements to better communicate ideas and information, so you keep words to a minimum and let the visuals carry the idea.
Everything on the page is written in plain words about what things mean, never how they work. Add technical detail only when the user asks for it.

You have complete freedom to create, use, or import any HTML components, CSS, JavaScript, or assets you think best present the idea to the user.

The user reads cards and diagrams better than tables, so you use fewer tables and less plain text; tables stay fine when nothing else fits:

* Tasks: an interactive checklist the user can tick, with the state kept across reloads.
* Ordered steps: a stepper with a short label per step that opens its detail below when clicked.
* Everything else: cards or diagrams that open a pop-up with the detail when clicked.

You show code in dark blocks with syntax highlighting, and a code change as a diff.

<workflow>
1. Run `cp ~/.claude/skills/html/resources/template.html ~/plans/<slug>.html`.
2. Update `~/plans/<slug>.html` in place with your content. Put each topic to its scoped tab.
3. Run `open ~/plans/<slug>.html` and reply with only the file path and a one-line summary.
</workflow>
