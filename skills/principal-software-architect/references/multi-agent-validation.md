# Multi-agent validation protocol

Use when architecture analysis must be **cross-checked** by multiple agents
before a final verdict. All coordination artifacts are **English**.

---

## 1. Roles

| Role ID | Responsibility | Must not |
|---------|----------------|----------|
| **ARCH-PRIMARY** | Map as-is, emit BASELINE lines, pattern IDs, first findings | Implement large refactors mid-review |
| **ARCH-ADVERSARY** | Attack baselines: false positives, missed X-*, over-architecture | Rubber-stamp primary |
| **ARCH-BOUNDARY** | Focus Dependency Rule, ports/adapters, cycles, package graph | Style nits |
| **ARCH-DOMAIN** | Focus entities vs use cases vs DTO leakage, SRP by actor | Framework fashion |
| **ARCH-TEST** | Focus humble object, test API, fragile tests, testability of policy | Production feature design |
| **ARCH-SYNTH** | Merge agreements/disputes into one verdict + ordered suggestions | Invent new facts without evidence |

Minimum viable panel: **PRIMARY + ADVERSARY + SYNTH**.  
Preferred panel for large scopes: all roles.

---

## 2. Shared input contract (English)

Every agent receives the same brief:

```text
SCOPE: <paths / services / PR>
GOAL: pattern detection | drift audit | design decision | full review
CONSTRAINTS: <latency, team, timeline, compliance>
NON-GOALS: <…>
PRIOR ADRs: <links or none>
EVIDENCE RULE: file:line or symbol required for each finding
OUTPUT LANG: English (baselines, tables, findings)
```

---

## 3. Parallel pass (PRIMARY, ADVERSARY, specialists)

Each non-synth agent returns **only**:

1. **Baseline block** — one `BASELINE | …` line per unit (see clean-architecture-patterns.md §10)
2. **Findings** — severity-ranked, format:
   ```text
   path: severity: [X-ID or P-gap] problem. Fix.
   ```
3. **Confidence** — high | medium | low per finding
4. **Open questions** — unknowns that block certainty
5. **Disagreements with brief** — if scope was wrong

Agents must **not** rewrite each other mid-pass. Independent exploration.

---

## 4. Adversary checklist (mandatory)

ADVERSARY must explicitly try to:

- [ ] Falsify each `fit: drift` (is it actually an accepted local pattern?)
- [ ] Falsify each `fit: align` (hidden X-DEP-OUT / cycles?)
- [ ] Detect **framework-screaming** misread as domain layout
- [ ] Detect **over-prescription** (full boundary where partial is enough)
- [ ] Detect **missing actor split** (SRP false negatives)
- [ ] Mark findings that lack file/symbol evidence as **unverified**

Adversary output includes:

```text
CHALLENGE | <finding-id or baseline unit> | hold|downgrade|drop|upgrade | reason
```

---

## 5. Synthesis pass (SYNTH)

Merge rules:

| Situation | Action |
|-----------|--------|
| ≥2 agents agree with evidence | Keep |
| Conflict on severity | Prefer higher if safety/SoT risk; else medium + note dispute |
| Only one agent saw it, strong evidence | Keep, tag `single-observer` |
| Only one agent, weak evidence | Move to Open questions |
| Adversary says drop + primary weak evidence | Drop or re-investigate |
| Suggestion invents second architecture | Reject; force strangler / lowest layer |

Synth emits final English package:

1. Verdict: `ship | ship-with-guards | rework`
2. Architecture Baseline Matrix (all units)
3. Consensus findings (severity-ranked)
4. Disputed items (table)
5. Suggestions (ordered, reversible, layer-correct)
6. Multi-agent attestation block:

```text
VALIDATION | agents: [ARCH-PRIMARY, ARCH-ADVERSARY, …] | agreement: high|medium|low | unresolved: N | ready: yes|no
```

`ready: no` if critical disputes or missing evidence on critical paths.

---

## 6. Orchestration recipes (for harnesses)

### A. Single-session sequential (no subagents)

1. Run PRIMARY mentally → draft baselines  
2. Switch hat to ADVERSARY → challenge  
3. Switch hat to SYNTH → final report  

State role headers explicitly in the output so humans can audit.

### B. True multi-agent (subagents / parallel)

1. Spawn PRIMARY, ADVERSARY, optional BOUNDARY/DOMAIN/TEST with same brief  
2. Collect independent results  
3. Run SYNTH only after all complete  
4. Do not let implementer agents mutate code during validation  

### C. PR / CI style

1. PRIMARY on diff + affected packages  
2. ADVERSARY on full dependency direction of touched modules  
3. SYNTH gates merge recommendation  

---

## 7. Anti-collusion rules

- Specialists must not copy PRIMARY wording; re-derive from code
- SYNTH must list dropped findings (adversary wins)
- No praise padding; no severity inflation for show
- Pattern IDs from `clean-architecture-patterns.md` only (or mark `CUSTOM:…`)

---

## 8. Minimal dual-control example

```text
# PRIMARY
BASELINE | src/orders | expected: Use cases + ports | observed: SQL in service | fit: drift | patterns: [P-UC] | violations: [X-DEP-OUT] | suggestion: Extract OrderRepository port

# ADVERSARY
CHALLENGE | src/orders | hold | Confirmed: service imports pg client at line 41

# SYNTH
VALIDATION | agents: [ARCH-PRIMARY, ARCH-ADVERSARY] | agreement: high | unresolved: 0 | ready: yes
Verdict: ship-with-guards
```
