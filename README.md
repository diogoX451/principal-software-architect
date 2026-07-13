# principal-software-architect

[![License](https://img.shields.io/badge/License-Apache_2.0-blue.svg)](LICENSE)

**Agent Skill** for principal-level software architecture — system design,
trade-offs, ADRs, growth strategy, and architecture reviews.

Compatible with the [Agent Skills](https://code.claude.com/docs/en/skills) open
format used by **Claude Code**, **Grok**, and similar harnesses.

## What it does

When activated, the agent behaves as a **Principal Software Architect**:

- Frames constraints and invariants before proposing structure
- Compares options with reverse-cost and fit to the existing product path
- Produces ADRs for sticky decisions
- Reviews architectures with severity-ranked findings
- Prefers lowest-layer expansion over inventing parallel frameworks

## Install

### One-liner (clone + install)

```bash
git clone https://github.com/diogoX451/principal-software-architect.git
cd principal-software-architect
./scripts/install.sh
```

Installs into:

| Harness | Path |
|---------|------|
| Claude Code | `~/.claude/skills/principal-software-architect/` |
| Grok | `~/.grok/skills/principal-software-architect/` |
| Codex (opt-in) | `INSTALL_CODEX=1 ./scripts/install.sh` |

### Manual

Copy the skill folder:

```bash
cp -R skills/principal-software-architect ~/.claude/skills/
cp -R skills/principal-software-architect ~/.grok/skills/
```

### Project-local (team share)

```bash
mkdir -p .claude/skills .grok/skills
cp -R skills/principal-software-architect .claude/skills/
cp -R skills/principal-software-architect .grok/skills/
```

## Usage

- Slash: `/principal-software-architect`
- Natural language: *"architecture review of the billing path"*, *"should we split this service?"*, *"write an ADR for the bus abstraction"*

## Layout (Agent Skills standard)

```text
principal-software-architect/
├── README.md
├── LICENSE
├── scripts/install.sh
├── agents/                         # Claude Code agent definition (optional)
│   └── principal-software-architect.md
└── skills/
    └── principal-software-architect/
        ├── SKILL.md                # required — instructions + triggers
        ├── references/             # load on demand
        │   ├── decision-framework.md
        │   └── architecture-review-checklist.md
        └── templates/
            ├── architecture-decision-record.md
            └── architecture-review-report.md
```

## Design of this skill pack

| Principle | Application |
|-----------|-------------|
| Progressive disclosure | SKILL.md is lean; references load only when needed |
| Trigger-rich description | Frontmatter lists when to auto-invoke |
| Multi-harness | Same `SKILL.md` for Claude/Grok; agent file is additive |
| No SaaS lock-in | Pure markdown + install script |

## Versioning

Tags follow `vMAJOR.MINOR.PATCH`. Skill `metadata.version` in `SKILL.md` matches
the latest tag.

## Contributing

See [CONTRIBUTING.md](CONTRIBUTING.md). Keep the skill actionable (agent
instructions), not a textbook.

## License

Apache-2.0 — © Diogo Almeida
