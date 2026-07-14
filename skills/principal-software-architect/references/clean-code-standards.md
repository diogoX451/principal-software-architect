# Clean code standards and finding catalog

Load this reference for code review, implementation guidance, refactoring, or architecture reviews that descend into code-level quality. Read `clean-code-source.md` when source rationale or chapter mapping is needed.

## Contents

1. [Precedence and enforcement](#precedence-and-enforcement)
2. [Review workflow](#review-workflow)
3. [Practice catalog](#practice-catalog)
4. [Violation catalog](#violation-catalog)
5. [Severity and confidence](#severity-and-confidence)
6. [Output contract](#output-contract)
7. [Definition of done](#definition-of-done)

## Precedence and enforcement

Apply standards in this order:

1. Correctness, security, data integrity, and explicit user requirements.
2. Public contracts and architectural invariants.
3. Repository-owned instructions, formatter, linter, type checker, and test conventions.
4. Target-language idioms and ecosystem conventions.
5. This catalog's defaults.

Classify each rule before acting:

- **Invariant:** must hold; violation can block delivery.
- **Repository standard:** enforce when configured or documented.
- **Heuristic:** requires a concrete readability/change-risk consequence; never block on taste alone.

Do not make unrelated cleanup, public API changes, or broad refactors without scope authorization. Do not claim a rule is universal when language or repository evidence disagrees.

## Review workflow

1. Establish scope: changed behavior, touched units, callers, contracts, and tests.
2. Run repository-native checks or state why they could not run.
3. Map each unit to one responsibility, actor, and abstraction level.
4. Check invariants first, then local standards, then applicable heuristics.
5. Record only evidence-backed findings with consequence and minimal fix.
6. Separate behavior defects from maintainability debt and optional polish.
7. Re-run focused checks after changes; expand validation in proportion to blast radius.

## Practice catalog

Stable IDs make findings searchable. `CC-*` means an observed clean-code practice.

| ID | Practice | Evidence |
|---|---|---|
| CC-NAME | Intent-revealing, consistent domain vocabulary | Names explain role without decoding or misleading context |
| CC-FUNC | Focused function at one abstraction level | One coherent outcome; explicit inputs/side effects |
| CC-FLOW | Obvious control flow | Happy path visible; conditions and ordering communicate policy |
| CC-COMMENT | Durable rationale/contract comment | Explains why, constraint, or non-obvious contract and is current |
| CC-FORMAT | Automated, repository-consistent formatting | Formatter/linter passes; related code is predictably organized |
| CC-DATA | Intentional object/data boundary | Encapsulation or DTO exposure matches the role |
| CC-ERROR | Explicit contextual error contract | No swallowed error; boundary translation and cleanup are clear |
| CC-BOUNDARY | Owned integration boundary | Volatile/foreign semantics isolated behind a useful local contract |
| CC-TEST | Readable deterministic behavioral tests | Failure explains broken behavior; test is isolated and repeatable |
| CC-CLASS | Cohesive unit with a narrow public surface | One actor/reason to change; internals hidden |
| CC-WIRE | Construction separated from use | Concrete dependencies wired at an outer composition root |
| CC-SIMPLE | Tests pass, intent visible, duplication low, no needless elements | Emergent design rules hold without ceremony |
| CC-CONCUR | Explicit concurrency policy | Shared state, lifecycle, cancellation, and timeouts are controlled |
| CC-REFINE | Small behavior-preserving refinement | Focused diff with regression protection |

## Violation catalog

`XC-*` denotes a clean-code violation. Use an architecture `X-*` ID as well when a finding crosses a boundary.

| ID | Smell | Report only when |
|---|---|---|
| XC-NAME-MISLEAD | Misleading or inconsistent name | A reader can reasonably infer the wrong behavior/domain meaning |
| XC-NAME-NOISE | Encoding, noise word, or unexplained abbreviation | It adds decoding cost or hides distinctions |
| XC-FUNC-MIX | Mixed responsibilities/abstraction levels | Independent change axes or policy/detail interleaving are evident |
| XC-ARG-FLAG | Boolean/selector argument controls distinct operations | It hides multiple responsibilities; an enum as domain data is not automatically a violation |
| XC-SIDE-HIDDEN | Hidden mutation, I/O, time, randomness, or output argument | Call-site contract does not reveal a consequential side effect |
| XC-CMD-QUERY | Command and query semantics mixed | A query unexpectedly changes externally meaningful state |
| XC-COND-DUP | Repeated conditional/type dispatch | The same growing policy is duplicated across sites |
| XC-COMMENT-STALE | Comment contradicts or can drift from code | Current behavior disproves or bypasses it |
| XC-COMMENT-NOISE | Redundant, decorative, journal, or commented-out code | It obscures live intent; source control already preserves history |
| XC-FORMAT-DRIFT | Repository formatting/organization contract broken | Automated or documented convention provides evidence |
| XC-HYBRID-DATA | Type exposes internals and mixes unrelated behavior | It defeats both encapsulation and simple data use |
| XC-TRAIN-WRECK | Deep collaborator navigation | It leaks structure and creates transitive coupling, not merely fluent syntax |
| XC-ERROR-SWALLOW | Failure ignored, logged-and-lost, or replaced without context | Caller cannot react correctly or diagnosis is materially harmed |
| XC-NULL-PROTOCOL | Ambiguous null/sentinel control protocol | Valid absence, failure, and missing initialization become indistinguishable |
| XC-BOUNDARY-LEAK | Foreign API/type/exception leaks into policy | It couples callers to external semantics or volatility |
| XC-WRAPPER-NOISE | Pass-through abstraction owns no policy | Indirection adds change sites without isolation or translation |
| XC-TEST-FRAGILE | Test depends on timing, order, GUI, or incidental structure | Equivalent behavior can fail nondeterministically or after safe refactor |
| XC-TEST-OPAQUE | Test intent/failure is hard to understand | Setup/assertion noise hides the behavioral concept |
| XC-TEST-PRODLOGIC | Test duplicates production algorithm | Same defect can make implementation and test agree |
| XC-GOD-UNIT | Class/module coordinates unrelated actors/invariants | Multiple independent reasons to change are demonstrated |
| XC-SURFACE-WIDE | Public API exposes unnecessary internals | Callers can depend on details that should remain replaceable |
| XC-CONSTRUCT-IN-USE | Runtime policy constructs volatile concretes | Configuration and use cannot vary independently |
| XC-DUP-KNOWLEDGE | Same policy/knowledge encoded in multiple places | A rule change requires coordinated edits, not just similar syntax |
| XC-DEAD | Unreachable, unused, obsolete, or speculative code | Repository evidence shows no active contract; beware reflection/plugins |
| XC-TEMPORAL | Required call order is hidden | Correctness depends on an undocumented state sequence |
| XC-CONCUR-SHARED | Uncontrolled shared mutable state | A race, deadlock, visibility, shutdown, or retry risk is plausible and evidenced |
| XC-CONCUR-FLAKY | Concurrency confidence rests on nondeterministic tests | No stress/timeout/control strategy exists for material concurrency risk |
| XC-OVERDESIGN | Abstraction/pattern has no current responsibility | It adds indirection for hypothetical reuse or change |
| XC-SCOPE-CREEP | Cleanup exceeds the requested behavior | Diff risk/review burden grows without protecting the requested invariant |

## Severity and confidence

Severity is consequence, not ugliness:

| Severity | Meaning |
|---|---|
| critical | Can corrupt/lose data, violate isolation/safety, or make a critical failure silent |
| high | Likely correctness/operability failure or a policy change requires risky coordinated edits |
| medium | Demonstrated maintenance/test fragility likely to compound in the current horizon |
| low | Local clarity issue with a small but concrete cost |

Confidence:

- **high:** directly demonstrated by code, failing check, contract, or reproducible behavior.
- **medium:** strong structural evidence, but runtime/caller context is incomplete.
- **low:** plausible heuristic; move to a question or optional suggestion, not a blocking finding.

Never inflate severity because a method is long, has multiple arguments, contains a comment, or lacks a design pattern. State the consequence.

## Output contract

For each analyzed unit, append code-quality evidence to the architecture baseline when architecture is in scope:

```text
CODEBASELINE | <unit> | responsibility: <one actor/outcome> | observed: <evidence> | fit: clean|mixed|drift | practices: [CC-…] | violations: [XC-…] | next: <smallest safe improvement>
```

For focused code reviews, use findings first and omit empty sections:

```text
<path:line>: <severity>: [XC-ID] <problem and consequence>. <smallest fix>. confidence: high|medium
```

Rules:

- Use `clean` only when relevant repository checks pass and no material violation is found.
- Do not emit one finding per symptom when a single root-cause finding explains them.
- Do not praise-pad. List confirmed practices only when the user requested a standards audit or baseline.
- Keep IDs stable; localize explanatory prose to the conversation language.

## Definition of done

- Requested behavior and public contracts remain correct.
- Relevant formatter, linter, type checker, unit/integration tests pass, or limitations are explicit.
- Names and control flow reveal intent at the repository's normal level.
- Errors, cleanup, and side effects are explicit and tested in proportion to risk.
- No new duplication of policy, dead code, speculative abstraction, or boundary leakage is introduced.
- The diff remains scoped; any broader debt is reported separately.
