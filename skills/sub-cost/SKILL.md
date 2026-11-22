---
name: sub-cost
disable-model-invocation: true
description: Work out what share of my AI subscriptions a job, thread or workload uses, by Adam Holter's Priors method.
---

Tell me what percentage of each subscription plan the workload uses per 30 days. Rates change weekly: look up every number fresh and link its source.

Method: Priors' ratio for a model on a plan is fee ÷ API value of its monthly allowance, so share of plan = workload's API-price cost × ratio ÷ fee.

- Ratios: https://mypriors.com/api/plan-prices. Method and caveats: https://github.com/adamholter/priors/blob/main/docs/data.md ("Subscription cost"). Changes: https://x.com/AdamHoltererer
- List prices: each lab's API pricing page.
- My plans: `~/.claude.json` for Claude, Codex session logs for ChatGPT. If the tier is unclear, report every possible tier.
- My usage: `~/.t3/userdata/statev2.sqlite`, including delegates.
