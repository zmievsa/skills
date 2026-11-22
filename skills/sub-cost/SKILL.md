---
name: sub-cost
disable-model-invocation: true
description: Work out what share of my AI subscriptions a job, thread or workload uses, by Adam Holter's Priors method.
---

Every report must give the workload's estimated percentage of each subscription's 30-day allowance. For plans with a weekly reset, also calculate the percentage of one week's allowance used by the same workload. Look up current rates and link the sources for each input.

For each model, calculate the 30-day percentage as `100 × workload API-price cost × Priors model-to-plan ratio ÷ plan fee`, with the fee and ratio on the same monthly basis. Sum the model percentages within each plan, including delegates once.

For the weekly percentage, divide each model's workload API-price cost by the API value of its weekly allowance, multiply by 100, and sum within the plan. Show the denominator and its source. When deriving a weekly allowance from a published monthly measurement, use the source's period convention (for example, divide a four-week total by four). If the exact tier is missing, use a documented plan multiplier when available and label the estimate. Keep enough significant digits for small jobs to show a meaningful percentage.

- Ratios: https://mypriors.com/api/plan-prices. Say when a row's ratio is borrowed from another model, preliminary or low-confidence. Method and caveats (full use of the allowance, resets): https://github.com/adamholter/priors/blob/main/docs/data.md ("Subscription cost"). Missing rows: [overrides](https://github.com/adamholter/priors/blob/main/scripts/scrape/sources/subscription-overrides.ts), [measurements](https://github.com/FeiZhuLulu/real-api-pricing). Changes: https://x.com/AdamHoltererer
- List prices: each lab's API pricing page. Input totals may already include cached tokens; don't count them twice.
- My plans: `~/.claude.json` for Claude, Codex session logs for ChatGPT. If the tier is unclear, report every possible tier.
- My usage: `~/.t3/userdata/statev2.sqlite`, including delegates. A live limit reading (e.g. Codex's weekly `used_percent`) goes beside the estimate, not into it.
