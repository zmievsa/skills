# Reusable prompts

Overfitting is the main risk, and it matters most. An edit tuned to the case that prompted it makes the prompt worse everywhere else. The rules below exist to prevent it.

- State the principle, not its instances. A list of cases reads as the full scope of the rule, and everything outside the list as out of scope. Replace the list with the property its items share.
- Add an example only when the principle is misread without it.
- Keep the current task's specifics out: its domain, its bugs, its names and its numbers. If an edit only makes sense for the case at hand, it belongs in that task, not in the reusable prompt.
- Prefer rewording or removing over adding. Check whether an existing sentence already covers the new rule or contradicts it.
- Say what to do. Replace a line about what to avoid with the action you want. E.g. "Don't write long replies" becomes "Reply in three sentences or fewer".
- Text the user wrote stays as written unless they ask to change it. E.g. asked to add one rule, add it and leave the other lines word for word, even ones you would phrase better.
- State each rule in one place and link to it from the others. E.g. a skill that needs a rule from another skill links to that skill instead of copying the rule.
- An agent takes every exit a prompt offers, so write only the exits you want and say what to try first.
- A skill's `description` says only when to load it, in two sentences at most. Start an auto-loaded skill's description with "Use when…" or "Use before…": agents load it more reliably when the message doesn't name its domain. For a manual-only skill, write it for the person invoking it.
- Judge an edit by its effect. You may ask the user whether to A/B test it (the `prompt-ab-test` skill); run a test only with their approval. When comparing, test the shorter, more abstract wording against the longer one, ideally on a task unlike the one that prompted the edit, and keep the abstract one unless it measurably loses.

Not every model failure should be solved by a prompt change. A ton of cases can be solved by structural changes, removing inconsistent prompt parts, better interfaces, tooling, or infra fixes. When defining guardrails/hooks, be careful with false positives -- most of the time in day-to-day workflows they are worse than false negatives.

## Poteto's pyramid

Where a fix goes, from strongest to weakest. Put each fix on the highest layer that can hold it: the higher the layer, the less it depends on an agent or a person remembering to apply it.

1. **Codebase and architecture.** Types, data structures and APIs make the mistake impossible to write
2. **Static analysis.** Linters, compiler checks and CI block the mistake: if the agent ignores it, the build fails.
3. **Rules and automated review** Guidance that an LLM review bot checks; some violations slip through.
4. **Skills.** Guidance loaded when relevant; the agent sometimes doesn't read it.
