# Engineering organization and sustainable delivery standards

Load when architecture decisions affect team ownership, cognitive load, delivery flow, API ecosystem, large-scale change, governance, or platform boundaries. Sources: *Software Engineering at Google*, *Accelerate*, *Team Topologies*, Brooks, Conway's law, Hyrum's Law, and DORA research. See `source-bibliography.md`.

## Principles

- Evaluate practices over time and organizational scale, not for one commit.
- Align ownership with cohesive business/system boundaries and operational responsibility.
- Treat coordination paths as architecture: cross-team synchronous work is a coupling cost.
- Use delivery metrics diagnostically; never turn them into individual quotas.
- Assume every observable API behavior may acquire consumers; evolve deliberately.
- Reduce cognitive load through clear platforms and boundaries, not handoffs or abstraction volume.

## Practice catalog

| ID | Practice | Evidence |
|---|---|---|
| ENG-OWNER | Boundary has one accountable team | Code, data, on-call and roadmap ownership align |
| ENG-API | Contract lifecycle is managed | Compatibility, deprecation, consumers, versioning |
| ENG-CHANGE | Large change has migration mechanism | Tooling, staged adoption, owner, completion signal |
| ENG-REVIEW | Review optimizes correctness/learning/flow | Timely evidence-based feedback |
| ENG-PLATFORM | Platform offers a paved road as product | Users, SLO, support, adoption and escape hatch |
| ENG-COGNITIVE | Team scope fits cognitive capacity | Few owned domains/dependencies and usable docs |
| ENG-FLOW | Delivery performance is measured systemically | Lead time, frequency, failure rate, recovery trends |
| ENG-LEARN | Incidents/defects change system/practice | Owned actions and verified recurrence reduction |

## Violations

| ID | Violation | Consequence |
|---|---|---|
| XENG-SHARED-ALL | Everyone owns a critical boundary | Nobody is accountable |
| XENG-TEAM-API | Internal org chart leaks as product API | Reorg causes contract churn |
| XENG-COORD | Routine change requires many teams/releases | Delivery bottleneck and integration risk |
| XENG-PLATFORM-MANDATE | Platform has no user/product feedback | Centralized bottleneck and shadow paths |
| XENG-METRIC-TARGET | Delivery metric becomes individual target | Gaming and local optimization |
| XENG-COMPAT-HOPE | Observable behavior changed without consumers | Hyrum-style ecosystem break |
| XENG-HANDOFF | Ownership stops at deployment | Operability feedback lost |
| XENG-BIGCHANGE | Repository-wide change lacks automation/staging | Long-lived divergence |
| XENG-HERO | Reliability depends on undocumented expert | Bus factor and slow incidents |

## Architecture implications

- Prefer stream-aligned ownership for end-to-end value; use platform/enabling teams to reduce load, not seize domain ownership.
- Count cross-team dependencies and coordinated deploys in option trade-offs.
- Keep APIs minimal because compatibility cost grows with consumers and time.
- Separate governance invariant from implementation choice; automate invariants with feedback.
- Interpret DORA-style metrics at service/team/system level and alongside quality/reliability context.

## Baseline

```text
ENGBASELINE | <boundary/change> | owner: <team> | consumers/dependencies: […] | coordination: <teams/releases> | cognitive-load: <evidence> | delivery/operations: <signals> | fit: aligned|conditional|drift | practices: [ENG-…] | violations: [XENG-…] | next: <smallest ownership/flow improvement>
```
