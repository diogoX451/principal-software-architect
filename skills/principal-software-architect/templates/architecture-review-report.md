# Architecture review: <system or change>

- **Date:** YYYY-MM-DD
- **Scope:**
- **Verdict:** ship | ship-with-guards | rework
- **Reviewer mode:** principal-software-architect
- **Language:** <conversation language; stable IDs and baseline field labels remain unchanged>
- **Multi-agent:** yes | no

## Executive summary

3–5 bullets. Lead with risk, not compliments.

## Architecture Baseline Matrix

One line per unit (required):

```text
BASELINE | <unit> | expected: … | observed: … | fit: align|partial|drift | patterns: […] | violations: […] | suggestion: …
```

| Unit | Fit | Patterns | Violations | Suggestion |
|------|-----|----------|------------|------------|
| | | | | |

## Code Quality Baselines

```text
CODEBASELINE | <unit> | responsibility: … | observed: … | fit: clean|mixed|drift | practices: [CC-…] | violations: [XC-…] | next: …
```

| Unit | Fit | Practices | Violations | Smallest safe improvement |
|------|-----|-----------|------------|---------------------------|
| | | | | |

## Algorithm Baselines

```text
ALGBASELINE | <unit> | problem: … | data: … | choice: … | complexity: <time; space> | preconditions: … | exactness: exact|approximate|probabilistic | fit: sound|conditional|drift | practices: [ALG-…] | violations: [XA-…] | next: …
```

| Unit | Problem/data | Choice | Complexity/exactness | Preconditions | Fit | IDs / next |
|------|--------------|--------|----------------------|---------------|-----|------------|
| | | | | | | |

## Routed Specialist Baselines

Include only applicable rows and paste the full baseline line defined by its owning reference.

| Domain | Baseline | Why material |
|--------|----------|--------------|
| Domain model | `DOMBASELINE | …` | |
| Data | `DATABASELINE | …` | |
| API contracts | `APIBASELINE | …` | |
| Quality | `QUALITYBASELINE | …` | |
| Reliability | `RELBASELINE | …` | |
| Security | `SECBASELINE | …` | |
| Evolution | `EVOBASELINE | …` | |
| Documentation | `DOCBASELINE | …` | |
| Engineering organization | `ENGBASELINE | …` | |

## Findings

| Sev | Area | Stable catalog ID(s) | Problem and consequence | Fix | Evidence / confidence |
|-----|------|----------------------|-------------------------|-----|-----------------------|
| critical | | X-… | | | file:line / high |
| high | | X-… | | | |

## Patterns found / missing

| Kind | IDs | Notes |
|------|-----|-------|
| Present | P-… | |
| Missing | | only if justified by growth |

## Invariants at risk

1.
2.

## Current architecture (as-is)

- Entrypoints:
- Circles present (Entities / Use Cases / Adapters / Frameworks):
- SoT:
- Dependency direction (inward?):
- Async paths:
- Trust boundaries:

## Target architecture (to-be) — only if rework/ship-with-guards

- Recommended shape:
- First strangler slice:
- Explicit non-goals:

## Ordered remediation

1. (critical first)
2.
3.

## Multi-agent validation

| Role | Result |
|------|--------|
| ARCH-PRIMARY | |
| ARCH-ADVERSARY | |
| ARCH-SYNTH | |

```text
VALIDATION | agents: […] | agreement: high|medium|low | unresolved: N | ready: yes|no
```

### Challenges

| Target | Decision | Reason |
|--------|----------|--------|
| | hold/downgrade/drop/upgrade | |

## Open questions

-

## Validation performed

- Formatter/linter:
- Type/static checks:
- Focused tests:
- Broader tests:
- Gaps:
