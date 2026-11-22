# Agent skills

Installable skills maintained by [Stanislav Zmiev](https://github.com/zmievsa).

| Skill | Purpose |
| --- | --- |
| `sub-cost` | Work out what share of your AI subscriptions a job, thread or workload uses, by the Priors method. Manual invocation only. |
| `testing` | Test observable behavior with realistic boundaries and direct assertions. |
| `testing-reviewer` | Review tests for anti-patterns that slow them down or let bugs through. Manual invocation only. |
| `prompt-ab-test` | A/B test a change to a prompt, skill or rule by replaying a real situation with the old and the new version. Manual invocation only. |
| `prompting` | Write and edit instructions for other agents: how much to prescribe per model tier, and how to keep reusable prompts from overfitting. Manual invocation only in Codex. |
| `typings` | Apply strict modern Python typing rules. Originally authored by [GAO Hongnan](https://github.com/gao-hongnan); see its [attribution](skills/typings/ATTRIBUTION.md). |

## Install

List the available skills without installing them:

```bash
npx -y skills add zmievsa/skills --list
```

Using the Skills CLI:

```bash
npx -y skills add zmievsa/skills --skill testing testing-reviewer typings prompting prompt-ab-test sub-cost --agent codex --global --yes
```

Using GitHub CLI:

```bash
gh skill install zmievsa/skills testing --agent codex --scope user
gh skill install zmievsa/skills testing-reviewer --agent codex --scope user
gh skill install zmievsa/skills typings --agent codex --scope user
gh skill install zmievsa/skills prompting --agent codex --scope user
gh skill install zmievsa/skills prompt-ab-test --agent codex --scope user
gh skill install zmievsa/skills sub-cost --agent codex --scope user
```

To install a fixed release with GitHub CLI, add `--pin v0.1.0`.

## Validate

```bash
scripts/validate.sh
```

Each skill follows the [Agent Skills specification](https://agentskills.io/specification).

## License

MIT. Third-party provenance is recorded in [NOTICE.md](NOTICE.md).
