---
name: prompt-ab-test
description: A/B test a change to a prompt, skill or rule by replaying a real situation with the old and the new version.
disable-model-invocation: true
---

# Prompt A/B test

1. Rebuild the situation as close to the original as possible: the same inputs, files, messages and prior turns. Replace tools that act on the world (sending, posting, buying, deleting, writing to real accounts) with mocks or safe read-only equivalents.
2. Reproduce the original failure with A on every model you will test. If A doesn't fail on a model, testing B there proves nothing: drop that model, or rebuild the situation more faithfully.
3. Test B from the cheapest model of a family up to the most expensive (the user will usually set the upper boundary of model intelligence themselves. The reasoning is usually medium unless specified otherwise). Move a variant up to the next model only once it works on the cheaper one.
4. Run A (current version) and B (changed version) in separate fresh subagents, on the same model and effort as in production (or lower if user specified so). If results vary, do several runs of each. Be careful if the run is too token hungry -- keep the user up-to-date if we are consuming way too many tokens
5. Report what differed, how many runs of each, and the verdict.

Very important:
- **Don't overfit.** The change must stay a general rule. A B that wins only on this one case loses. When you can, also replay one or two unrelated situations to check that nothing else broke.
- **Don't give the test away.** The subagents must not learn that they're being tested, what is being compared, or what the "correct" response would be. Give each one the situation exactly as the real agent saw it: no hints, no mention of the original failure, no expected output (unless those are the same as in the original case and existed there too).
  Isolate each run so anything the subagent can discover through its tools or surroundings reveals no more about the test or its answer than the original situation did.
