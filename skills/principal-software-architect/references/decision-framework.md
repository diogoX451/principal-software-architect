# Decision framework (Principal Architect)

Use when more than one option is plausible and the cost of being wrong is high.

## 1. Name the decision

One sentence: **We are choosing ___ so that ___.**

If you cannot fill both blanks, you are not ready to decide — gather constraints.

## 2. Hard constraints vs soft preferences

| Hard (must) | Soft (prefer) |
|-------------|----------------|
| Correctness / safety / compliance | Team familiarity |
| Data ownership / tenancy isolation | "Nice" latency margins |
| User-visible SoT | Fashionable stack |
| Operability (deploy, observe, rollback) | Perfect purity |

Never trade a hard constraint for a soft preference without saying so out loud.

## 3. Time horizon

| Horizon | Bias |
|---------|------|
| < 2 weeks | Ship the reversible path |
| 1–2 quarters | Invest in clear boundaries + tests |
| Multi-year platform | SoT, contracts, and extension layers matter more than speed |

Principal default: **optimize for the next 2 quarters**, leave a door open for year 2.

## 4. Cost of reverse

Ask: *If we pick A and are wrong in 90 days, what do we rewrite?*

- **Low** — config/flag/adapter swap
- **Medium** — one service boundary or schema migration
- **High** — cross-tenant data model, public API, event envelope

Prefer low reverse-cost when evidence is weak.

## 5. Fit to existing architecture

Score each option:

1. Extends product path? (+2)
2. Reuses existing SoT? (+2)
3. Adds a second parallel architecture? (−3)
4. Introduces a new operational dependency? (−1 unless justified)
5. Improves an explicit measured pain? (+2)

Highest score wins unless a hard constraint vetoes it.

## 6. Decision quality bar

A good decision states:

- Chosen option
- Rejected options (with one-line why)
- What would change your mind (metric or event)
- First slice to de-risk

If any of those four is missing, the decision is incomplete.
