# Contributing

## Skill quality bar

1. **Trigger quality** — `description` must include clear when-to-use phrases.
2. **Actionable body** — steps the agent can execute, not essays.
3. **Progressive disclosure** — put deep material in `references/`, not in SKILL.md.
4. **No harness lock-in** — works with only `SKILL.md` present.
5. **Templates stay fillable** — no project-specific secrets or company names.

## Local test loop

1. Install: `./scripts/install.sh`
2. In Claude Code or Grok, run `/principal-software-architect`
3. Prompt: *"Review whether our messaging config should name the broker or the bus"*
4. Confirm the agent loads references only when needed and produces options + recommendation

## PR checklist

- [ ] `name` matches folder name `principal-software-architect`
- [ ] Frontmatter `description` updated if triggers change
- [ ] `metadata.version` bumped if behavior changes
- [ ] README install paths still accurate
