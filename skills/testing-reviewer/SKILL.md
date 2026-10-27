---
name: testing-reviewer
description: Use when reviewing tests or a test suite (a PR diff or a whole codebase) for anti-patterns that make tests slow or let bugs through.
disable-model-invocation: true
user-invocable: true
---

# Testing reviewer

The standard is the `testing` skill, follow that plus the list below. Tests exist to freeze the public behavior we like. Judge each test by two costs: the bugs it lets through and the time it takes. The anti-patterns below are where agent-written tests usually fail, not a checklist.

## Common anti-patterns

- Testing internals instead of the public interface.
- Tests that share state, depend on order, or can't run in parallel.
- Silent skips, and red tests waved off as "already failing before my change". A red suite blocks new work.
- Mocking what we own (database, our own services and functions).
- Tests of the wrong size or layer. Splitting unrelated invariants helps; a long user workflow is fine as one test.
- Weak assertions that a plausible wrong implementation would pass. Mutation testing on the diff is good evidence.
- Dead test code.
- Testing the code we don't own (with rare and well-understood exceptions).
- User-visible behaviors with no test.
