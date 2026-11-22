---
name: prompting
description: Use before writing or editing instructions for another agent.
---

# Prompting

Rules below are defaults: when the user asks for specific wording, follow the user. If the user asks for a specific description/body using something like quotes -- use their words as-is with minimal modifications.

## Match detail to the target model

Intelligence: Fable 5.2 > Opus 5.5 > Neon 4 > Astra 6.2 >> Sol 6.2 > Sonnet 5.5 >> Haiku 5.5.

Use Fable and Astra only when the user names them. Otherwise Opus is the top Claude model and Sol the top GPT model.

NEVER use more than high effort on Fable/Opus/Astra
NEVER use max effort anywhere.

State the goal, the problem behind it, the context it can't discover or would struggle to, and what to return.

Tiers: smart = Fable, Opus, Neon, Astra; moderate = Sol, Sonnet; dumb = Haiku.

The target's tier sets how much to prescribe:

1. Smart: give the goal and what must hold when it's done; leave the method to it. Don't try to give it "initial ideas" or "likely causes", let it think on its own. 
2. Moderate: let it make decisions on the job if they don't affect the end goal. E.g. there are many cases where it gets blocked on the direct solution but may still try other options/approaches or simple fixes. It follows a stop condition to the letter, so for an obstacle you can foresee give it the next thing to try, and keep stops for what only the user can decide. It's still a very smart and capable model, not a state machine, so give it some freedom, but keep the significant decisions in your prompt.
3. Dumb: no decisions; give it a detailed decision tree, but still allow it options to recover on its own if something goes wrong.

Then adjust for where the target sits relative to you:

- Smarter than you: when asking it for advice, mention that it's allowed to think from first principles and outside your solution to reach better options. Give your conclusions as context it may overturn.
- Below you but smart: don't constrain its method. Still pass on what you've already worked out, your decision-making behind it, and the user's decisions, so it doesn't redo or reopen them.

If a target is not a dumb model and it needs something from you/user that it cannot get from anywhere or bypass in any way, just let it ping you to make the decision and to await whatever it needs instead of stopping entirely

Only for reusable prompts such as skills, scheduled jobs, prompt files, etc., but not for regular subagents: [reusable-prompts.md](reusable-prompts.md).
