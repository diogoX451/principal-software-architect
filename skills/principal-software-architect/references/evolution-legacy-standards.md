# Evolution, refactoring, and legacy-system standards

Load for modernization, legacy code, migrations, refactors, architecture fitness functions, or changes that must preserve behavior. Sources: *Refactoring*, *Working Effectively with Legacy Code*, *A Philosophy of Software Design*, *Building Evolutionary Architectures*, Fowler's evolutionary/monolith articles, and *Release It!*. See `source-bibliography.md`.

## Change workflow

1. Define behavior/invariant to preserve and the business reason to change.
2. Find a seam: boundary where behavior can be observed or dependency substituted.
3. Add characterization/contract tests around risky behavior.
4. Make preparatory refactors separately from semantic change where practical.
5. Ship the smallest reversible vertical slice; run old/new paths only with an explicit reconciliation and retirement plan.
6. Measure the architectural quality with a fitness function and remove obsolete path/debt.

## Practice catalog

| ID | Practice | Evidence |
|---|---|---|
| EVO-SEAM | Change introduced through a controlled seam | Observable contract and substitution point |
| EVO-CHAR | Existing behavior characterized | Tests capture relevant behavior, including oddities |
| EVO-PREP | Structure prepared before behavior change | Small reviewable refactor with tests |
| EVO-SLICE | Migration is vertical and reversible | User value, rollback, bounded blast radius |
| EVO-COMPAT | Mixed versions are supported | Expand/migrate/contract, dual-read/write rules |
| EVO-RETIRE | Old path has owner and deletion condition | Consumers migrated, data reconciled, deadline |
| EVO-FIT | Architecture intent is executable | Dependency/quality/operability check in CI/telemetry |
| EVO-DEPTH | Abstraction hides meaningful complexity | Simple interface with owned responsibility |

## Violations

| ID | Violation | Consequence |
|---|---|---|
| XE-REWRITE | Big-bang rewrite replaces discovery | Long feedback gap and parity failure |
| XE-NO-ORACLE | Refactor lacks behavior oracle | Silent regression |
| XE-MIXED-DIFF | Structural and semantic changes inseparable | Review/rollback ambiguity |
| XE-DUAL-FOREVER | Parallel old/new paths have no retirement | Two architectures and SoTs |
| XE-CONTRACT-BANG | Breaking contract assumes atomic rollout | Mixed-version outage |
| XE-FLAG-DEBT | Flag has no owner/expiry/removal | Permanent branch complexity |
| XE-FITNESS-PROSE | Architecture rule exists only in docs | Unnoticed drift |
| XE-SHALLOW | Abstraction forwards complexity to every caller | High cognitive load and change amplification |
| XE-CLEANUP-SCOPE | Modernization expands beyond proof/value | Risk and delivery stall |

## Migration proof

- Characterize representative and boundary behavior.
- Reconcile old/new results or state during transition.
- Observe traffic/consumer migration and error rates.
- Define rollback until irreversible data/contract step.
- Remove old code, schema, flags, jobs and telemetry after exit criteria.

## Baseline

```text
EVOBASELINE | <change> | preserved: <behavior/invariant> | seam/oracle: <boundary/tests> | migration: <slice/compatibility> | rollback: <path> | retirement: <owner/criteria/date> | fitness: <check> | fit: safe|conditional|drift | practices: [EVO-…] | violations: [XE-…] | next: <smallest reversible step>
```
