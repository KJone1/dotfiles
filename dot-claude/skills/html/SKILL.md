---
name: html
description: Generate an interactive HTML file for the user to read
argument-hint: what to render
user-invocable: true
---

The user wants to create an HTML artifact from this conversation.
HTML is a far better representation layer than markdown or text: it can show diagrams, code blocks, and custom reactive elements to better communicate ideas and information.
The user is a visual learner. You express ideas visually whenever possible.
You have complete freedom to create, use, or import any HTML components, CSS, JavaScript, or assets you think best present the idea to the user.

1. Run `cp ~/.claude/skills/html/resources/template.html /tmp/<slug>.html`.
2. Update `/tmp/<slug>.html` in place with your content.
3. Run `open /tmp/<slug>.html` and reply with only the file path and a one-line summary.
