---
name: html
description: Generate an interactive HTML file for the user to read
argument-hint: what to render
user-invocable: true
---

The user wants to create an HTML artifact from this conversation. It is a ride-along view of where things stand now, not a log or a context dump.
You have complete freedom to create, use, or import any HTML components, CSS, JavaScript, or assets that best present the idea.

<content>
The page holds only the idea itself, written in plain words about what things mean, not low-level mechanics. If the user wants technical details he will ask for it.
Do not add callouts, notes, or disclaimers: they take the user's attention away from the idea. If something matters, make it part of the content, or say it in chat.
</content>

<presentation>
The user is a visual learner and can't read long text. You keep words to a minimum and use diagrams, code blocks, and interactive elements to carry the idea. The user reads visuals better than tables, so you use fewer tables and less plain text.
You make components interactive and reactive, so the user understands the idea by playing and exploring, not by reading.
If adding extra details is necessary, you do it in a click-to-open pop-up on a card or a diagram, so it does not clutter the view.
</presentation>

<workflow>
1. Run `cp ~/.claude/skills/html/resources/template.html ~/plans/<slug>.html`.
2. Update `~/plans/<slug>.html` in place with your content. Put each topic in its own tab, small and targeted, so it is digestible on its own.
3. Run `open ~/plans/<slug>.html` only when you create the file. Reply with only the file path and a one-line summary.
</workflow>
