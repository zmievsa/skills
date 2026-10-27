# Agent skills

Installable skills maintained by [Stanislav Zmiev](https://github.com/zmievsa).

| Skill | Purpose |
| --- | --- |
| `testing` | Test observable behavior with realistic boundaries and direct assertions. |
| `testing-reviewer` | Review tests for anti-patterns that slow them down or let bugs through. Manual invocation only. |
| `typings` | Apply strict modern Python typing rules. Originally authored by [GAO Hongnan](https://github.com/gao-hongnan); see its [attribution](skills/typings/ATTRIBUTION.md). |

## Install

List the available skills without installing them:

```bash
npx -y skills add zmievsa/skills --list
```

Using the Skills CLI:

```bash
npx -y skills add zmievsa/skills --skill testing testing-reviewer typings --agent codex --global --yes
```

Using GitHub CLI:

```bash
gh skill install zmievsa/skills testing --agent codex --scope user
gh skill install zmievsa/skills testing-reviewer --agent codex --scope user
gh skill install zmievsa/skills typings --agent codex --scope user
```

To install a fixed release with GitHub CLI, add `--pin v0.1.0`.

## Validate

```bash
scripts/validate.sh
```

Each skill follows the [Agent Skills specification](https://agentskills.io/specification).

## License

MIT. Third-party provenance is recorded in [NOTICE.md](NOTICE.md).
