---
name: testing
description: Use when reproducing or fixing bugs, testing behavior, reviewing existing tests, or deciding whether to add or change regression coverage.
---

# Testing

Copyright (c) 2026 Stanislav Zmiev. Distributed under the MIT License.

## Public behaviors

We test for a single reason: to verify whether public behaviors are working as expected. Most rules we will write below are going to be in one way or another based on this law. Therefore, we add a new test if and only if we are changing/fixing a user-visible behavior that is uncovered by older tests -- both must be true for addition.

If we are changing/fixing a non-user-visible behavior (such as refactoring, changes to deployment, CICD, etc), we focus on running old regressions and testing things manually, as this doesn't require new automated tests.

If we are improving performance, we should use benchmarks that cover a specific behavior surface instead of tests.

### Add a test vs edit an existing test

If we are changing a user visible behavior, then we must follow this checklist:

- Fixing a bug:
  - If the bug supposed to be covered by our old tests, i.e. existing tests were already attempting to cover this behavior surface, then fix existing tests to cover it. The tests likely didn't cover it because an LLM wrote them and LLMs are eager to write useless tests that do not actually cover the behavior -- they are commonly too granular, or mock too much, or test in an entirely different context than how the user would interact with the application, or lack the assertions necessary to confirm no regressions, etc.
  - else: add a new test
- Adding a feature:
  - If an existing test needs just more assertions or a tiny bit more steps and the feature fits right inside its existing flow / set of checks, we should extend the existing test. But be careful with ballooning tests that lose their purpose and never allow an "if" statement within a granular test for testing different invariants -- it's a clear sign of a bad test
  - If the feature creates an entirely new behavior surface or a new invariant that doesn't fit neatly in existing tests, we should create a new test

## Classification

### Types of testing

There are two distinct processes we call testing:

- Manual testing: using the application interfaces yourself as close to how a user would use them, preferably in the exact same manner and context, using exact same tools and environment
- Regression testing (also: "covering" a behavior/interface with tests): writing automated tests that show whether some public behavior regressed

For any new feature or a bug fixed, you should always do a manual test and oftentimes a regression test -- whether to edit/create regression tests is decided by the [add vs edit section](#add-a-test-vs-edit-an-existing-test)

### Types of tests

There are many classifications of tests but we only reason in:

- E2E tests: truest "user-like" environments -- real frontend, real backend, realish payments (albeit in some sort of provider-made sandbox where we can't actually spend money), real clicks, production-like context -- everything should be as close to how a user would approach it as possible. We want to have at least one such test for every major "user flow" but edge cases and invariants are to be covered by granular tests unless the current project specifically prefers e2e-only approach
- Granular tests: once we established that the main flow works with e2e tests, we might sometimes need more granular tests for testing edge cases. Granular tests omit the surfaces that are irrelevant for the test -- be it a frontend, a backend, another service, an API provider, etc. For example, if I already tested that clicking buttons to submit the order works, I now want a dozen more tests that would check all possible invariants on both backend and frontend separately. However, granular tests still must not mock the database or internal interfaces: mocking and stubbing are reserved for external services that would be hard/costly to run on every test. Be careful: granular tests do not replace e2e tests for their behavior surface, they "supplement" e2e tests -- i.e. the main surface is covered by the e2e test, and then each possible invariant and edge case are covered by the granular test.
- Benchmarks: tests used to assess the performance/quality of some specific surface such as performance benchmarks or LLM evals running against agents/LLM calls. Unlike tests, benchmarks should not run as often -- they should run only when we are doing performance-specific work or fixing performance bugs or, if the project rules prefer so, on a daily/weekly basis as a regular job.

(this skill intentionally doesn't use terms such as "unit" and "integration" testing since they have been tainted with too many poisonous connotations over the years)

### Types of mocks

- When mocking external services, prefer solutions that allow to mock "at the edge". e.g. in python, using respx to mock a specific HTTP call in tests by its method and path is preferable to mocking the actual internal function that we use for making the HTTP call. This is because oftentimes those internal functions contain their own business logic that could break so if we are forced to mock -- it's best to mock as close to the edge as possible
- When needing to mock LLM calls, it's best to use mechanisms similar to pydantic-ai's `TestModel`
- When mocking a large count of different complex HTTP responses, it can be useful to use mechanisms like VCR-py

## Test structure and naming

Tests should match app structure and app structure often matches intended business structure so tests should also generally focus on being split in terms of business domains, features, and edge cases within those features. To put it another way, the test's location and name should focus around the public interface it is covering.

Name tests using the `what`, `when`, `expected` convention:

`test__{what}__{when}__{expected}` (feel free to change snake case to camel case if the current programming language prefers that in tests)

`what` is the public interface under test, `when` describes the conditions in which it is exercised, and `expected` states the observable result. Prefer concrete outcomes such as `should_return_404` or  `should_raise_router_generation_error` over generic suffixes such as `error`, `ok`, or numbered variants. A test name should let a reader understand a failure without first opening its implementation.

## Running tests

- Each test must be completely independent from other tests -- this means that ordering / parallelization / isolation when running tests should not affect the result at all. We should achieve this by using temporary per-test accounts/db entities/queue prefixes/etc and not using global "cleanup all data" type of fixtures in tests. However, whenever we could achieve greater speeds by reusing infra while keeping the tests "mostly" isolated (i.e. tests interfering with one another is impossible or close to impossible) -- we should do it if it speeds up running the tests
- We should generally run only the tests whose behavior surfaces we could've broken with our changes so that we can deliver fast (unless CI is configured otherwise)

## Assertion quality

Tests must rarely or never rely on asserting something that "should correlate" with correct behavior. They must assert the correct behavior/response itself. For example, testing that our bot tried to access a resource with the correct arguments/headers/config is not a good e2e test. Testing that it was actually physically let in is a good test. Correlation = meh, causation = good in tests.

Oftentimes we need to fuzzy match things in our assertions (i.e. if we don't care about a specific result but care that the result is of a certain structure) -- this is where libs like python's dirty-equals are useful.
