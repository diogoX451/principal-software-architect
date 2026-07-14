# principal-software-architect

[![License](https://img.shields.io/badge/License-Apache_2.0-blue.svg)](LICENSE)
[![skills.sh](https://skills.sh/b/diogoX451/principal-software-architect)](https://skills.sh/diogoX451/principal-software-architect/principal-software-architect)

**Agent Skill** for principal-level software architecture — system design,
trade-offs, ADRs, growth strategy, and architecture reviews.

Compatible with the [Agent Skills](https://agentskills.io) open format and the
[skills.sh](https://skills.sh) ecosystem — works with **Claude Code**, **Codex**,
**Cursor**, **OpenCode**, **Grok**, and many other agents.

## What it does

When activated, the agent behaves as a **Principal Software Architect**:

- Frames constraints and invariants before proposing structure
- Compares options with reverse-cost and fit to the existing product path
- Produces ADRs for sticky decisions
- Reviews architectures with severity-ranked findings
- Prefers lowest-layer expansion over inventing parallel frameworks
- **Detects patterns** and **out-of-pattern** code (Clean Architecture `P-*` / `X-*`, GoF `G-*`, microservices `MS-*` / `X-MS-*`)
- Emits an **Architecture Baseline Line** for every analyzed unit
- Supports **multi-agent validation** (PRIMARY → ADVERSARY → SYNTH) before final verdict
- Grounds Clean Architecture in the Martin source digest (`clean-architecture-source.md`, from the repo PDF)
- Grounds object design in the GoF digest (`design-patterns-source.md`, from the Gamma et al. PDF)
- Grounds multi-service **production readiness** in the Fowler digest (`microservices-source.md`)
- Distills all chapters of *Clean Code* into contextual `CC-*` / `XC-*` standards backed by evidence and repository tooling
- Emits a **Code Baseline Line** for every implementation unit inspected
- Converts the 11 chapters of *Entendendo Algoritmos* into `ALG-*` / `XA-*` rules for correctness, complexity, exactness, data structures, and benchmarking
- Emits an **Algorithm Baseline Line** for every material algorithmic path
- Routes distributed data, quality attributes, reliability, security, legacy evolution, architecture communication, and team ownership through focused standards
- Emits only applicable specialist baselines—no empty compliance theater
- **Always answers in the conversation language**; stable catalog IDs and baseline skeletons remain machine-readable

## Install

### Recommended — [skills.sh](https://skills.sh) CLI

```bash
npx skills add diogoX451/principal-software-architect
```

Global install (user-level, all projects):

```bash
npx skills add diogoX451/principal-software-architect -g -y
```

List without installing:

```bash
npx skills add diogoX451/principal-software-architect --list
```

Directory page:
[skills.sh/diogoX451/principal-software-architect/principal-software-architect](https://skills.sh/diogoX451/principal-software-architect/principal-software-architect)

> **Note:** PromptScript does not support global skill installs. Use the
> project-scoped command (no `-g`) inside the target repo.

### Alternative — clone + install script

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

### Project-local (team share, no CLI)

```bash
mkdir -p .claude/skills .grok/skills
cp -R skills/principal-software-architect .claude/skills/
cp -R skills/principal-software-architect .grok/skills/
```

## Usage

- Slash: `/principal-software-architect`
- Natural language: *"architecture review of the billing path"*, *"should we split this service?"*, *"write an ADR for the bus abstraction"*, *"audit this module against Clean Architecture"*, *"multi-agent validate this design"*

### Architecture Baseline Line

For each analyzed unit the agent emits (skeleton English; free-text fields and surrounding explanation follow the conversation language):

```text
BASELINE | <unit> | expected: … | observed: … | fit: align|partial|drift | patterns: [P-…] | violations: [X-…] | suggestion: …
```

### Multi-agent validation

```text
VALIDATION | agents: [ARCH-PRIMARY, ARCH-ADVERSARY, ARCH-SYNTH] | agreement: high|medium|low | unresolved: N | ready: yes|no
```

### Code Baseline Line

```text
CODEBASELINE | <unit> | responsibility: … | observed: … | fit: clean|mixed|drift | practices: [CC-…] | violations: [XC-…] | next: …
```

### Algorithm Baseline Line

```text
ALGBASELINE | <unit> | problem: … | data: … | choice: … | complexity: <time; space> | preconditions: … | exactness: exact|approximate|probabilistic | fit: sound|conditional|drift | practices: [ALG-…] | violations: [XA-…] | next: …
```

### Specialist baselines

Loaded only when material:

| Concern | IDs | Baseline |
|---|---|---|
| Domain modeling / DDD | `DOM-*` / `XDOM-*` | `DOMBASELINE` |
| Distributed data | `DATA-*` / `XD-*` | `DATABASELINE` |
| API contracts | `API-*` / `XAPI-*` | `APIBASELINE` |
| Quality attributes / ATAM | `QA-*` / `XQ-*` | `QUALITYBASELINE` |
| Reliability / SRE | `REL-*` / `XR-*` | `RELBASELINE` |
| Secure architecture | `SEC-*` / `XS-*` | `SECBASELINE` |
| Evolution / legacy | `EVO-*` / `XE-*` | `EVOBASELINE` |
| C4, arc42 and ADRs | `DOC-*` / `XDOC-*` | `DOCBASELINE` |
| Ownership and delivery | `ENG-*` / `XENG-*` | `ENGBASELINE` |

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
        ├── agents/openai.yaml      # Codex UI metadata
        ├── references/             # load on demand
        │   ├── clean-architecture-source.md   # Martin PDF digest
        │   ├── design-patterns-source.md      # GoF PDF digest (G-*)
        │   ├── microservices-source.md        # Fowler production-ready (MS-*)
        │   ├── clean-architecture-patterns.md
        │   ├── clean-code-source.md           # full-book decision digest
        │   ├── clean-code-standards.md        # executable CC-*/XC-* catalog
        │   ├── algorithms-source.md           # Bhargava 11-chapter digest
        │   ├── algorithm-selection-standards.md # ALG-*/XA-* decision catalog
        │   ├── domain-modeling-standards.md
        │   ├── api-contract-standards.md
        │   ├── distributed-data-standards.md
        │   ├── quality-attribute-evaluation.md
        │   ├── reliability-resilience-standards.md
        │   ├── secure-architecture-standards.md
        │   ├── evolution-legacy-standards.md
        │   ├── architecture-communication-standards.md
        │   ├── engineering-organization-standards.md
        │   ├── source-bibliography.md          # canonical links + maintenance
        │   ├── multi-agent-validation.md
        │   ├── decision-framework.md
        │   └── architecture-review-checklist.md
        └── templates/
            ├── architecture-decision-record.md
            ├── architecture-review-report.md
            └── architecture-baseline-matrix.md
```

## Design of this skill pack

| Principle | Application |
|-----------|-------------|
| Progressive disclosure | SKILL.md is lean; Clean Architecture detail lives in references |
| Trigger-rich description | Frontmatter lists when to auto-invoke |
| Multi-harness | Same `SKILL.md` for Claude/Grok; agent file is additive |
| Conversation language | User-facing prose matches the chat; P-*/G-*/MS-*/X-*/CC-* + BASELINE skeletons stay stable |
| Clean Architecture source | PDF digest in `clean-architecture-source.md` |
| GoF design patterns | Full book digest in `design-patterns-source.md` (`G-*`) |
| Production-ready microservices | Fowler digest in `microservices-source.md` (`MS-*` / `X-MS-*`) |
| Clean Code source | 398-page PDF distilled into chapter guidance and context-aware standards |
| Algorithms source | 322-page image PDF distilled into selection, complexity, exactness, and validation rules |
| Canonical online sources | DDIA, DDD Reference, SEI/ATAM, Google SRE, AWS Builders’ Library, NIST, OWASP, Zalando/AIP, C4, arc42, Fowler, DORA and primary papers |
| Concern routing | Specialist references load only when their risk/decision is material |
| Multi-agent ready | PRIMARY / ADVERSARY / SYNTH protocol for cross-checks |
| No SaaS lock-in | Pure markdown + install script / `npx skills add` |

## Versioning

Tags follow `vMAJOR.MINOR.PATCH`. Release history lives in Git tags; `SKILL.md`
keeps only the portable `name` and `description` frontmatter fields.

## Contributing

See [CONTRIBUTING.md](CONTRIBUTING.md). Keep the skill actionable (agent
instructions), not a textbook.

## License

Apache-2.0 — © Diogo Almeida
