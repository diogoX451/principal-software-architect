# Clean Code — source digest

**Primary source:** `codigo-limpo-completo-pt_text.pdf` at the repository root  
**Book:** *Clean Code: A Handbook of Agile Software Craftsmanship*, Robert C. Martin  
**Edition in the repository:** Portuguese text extraction, 398 PDF pages  
**Use:** Consult when a review or implementation needs code-level maintainability criteria. Use `clean-code-standards.md` for the executable catalog.

This is a decision-oriented digest, not a replacement for the book. Preserve the author's intent while treating examples tied to Java or the period of publication as contextual. Repository conventions, language idioms, automated checks, and demonstrated behavior remain evidence.

## Contents

1. [Core thesis](#core-thesis)
2. [Chapter map and review implications](#chapter-map-and-review-implications)
3. [Cross-cutting rules](#cross-cutting-rules)
4. [How to apply the source](#how-to-apply-the-source)
5. [Limits and interpretation](#limits-and-interpretation)

## Core thesis

- Code is read and changed far more often than it is first written; optimize for comprehension and safe change.
- Working code can still impose a compounding maintenance cost. Passing tests are necessary, not sufficient.
- Cleanliness is continuous: make the touched area a little clearer without broad, unrelated rewrites.
- Quality comes from disciplined small decisions: names, boundaries, tests, error paths, formatting, and removal of duplication.
- There is no mechanical definition of clean code. Use judgment, evidence, and local context.

## Chapter map and review implications

### 1. Clean Code

- Treat readability, focused responsibility, tests, low duplication, and clear intent as design qualities.
- Reject the false trade-off that messy code is a sustainable way to move faster.
- Apply the Boy Scout rule within scope: improve the code touched, without hijacking the change.

### 2. Meaningful Names

- Reveal intent and distinctions; avoid encodings, noise words, misleading names, and arbitrary abbreviations.
- Use pronounceable, searchable vocabulary and one term per concept.
- Use domain language for policy and solution language for technical mechanisms.
- Prefer names that remove the need for explanatory comments.

### 3. Functions

- Keep a function focused at one level of abstraction and make its control flow read top-to-bottom.
- Prefer few arguments; avoid flag arguments and hidden output arguments.
- Separate commands from queries and make side effects explicit.
- Extract exception handling from the main happy-path policy when it obscures intent.
- Treat size as a signal, not a numeric gate: responsibility and readability decide.

### 4. Comments

- Prefer code that explains itself. Comments do not rescue poor names or structure.
- Keep only comments that add information the code cannot express well: intent, rationale, contract warning, legal notice, or actionable TODO.
- Delete stale, redundant, journal-style, decorative, closing-brace, and commented-out code.
- Validate every comment against current behavior; source control owns history.

### 5. Formatting

- Use consistent automated formatting and a predictable top-to-bottom narrative.
- Keep related concepts vertically close; separate distinct concepts visibly.
- Declare variables near use and keep dependent functions near each other when repository organization permits.
- Prefer team consistency over personal formatting taste.

### 6. Objects and Data Structures

- Objects hide data and expose behavior; data structures expose data and have little behavior. Choose intentionally.
- Avoid hybrid types that expose internals while also pretending to encapsulate behavior.
- Follow the Law of Demeter as a coupling diagnostic; do not create blind forwarding chains merely to satisfy it.
- Use DTOs as explicit boundary data, not as domain behavior containers.

### 7. Error Handling

- Use exceptions or the language's idiomatic error channel instead of mixing error codes into business flow.
- Add context at the boundary where an error becomes meaningful; do not swallow failures.
- Define error behavior around the caller's needs and wrap third-party exceptions at integration boundaries.
- Avoid `null`/`None` as an ambiguous control protocol when an option/result/empty collection or explicit exception communicates better.
- Keep cleanup deterministic and test failure paths.

### 8. Boundaries

- Isolate third-party APIs behind a small interface owned by the application when volatility or semantic mismatch warrants it.
- Use learning/characterization tests to understand external packages.
- Do not speculate about wrappers for every dependency; add a boundary for ownership, volatility, testability, or translation.
- Keep unknown future collaborators behind the smallest interface needed by the current use case.

### 9. Unit Tests

- Keep tests as clean as production code: readable, focused, deterministic, and easy to change.
- Prefer one behavioral concept per test and a clear build-operate-check narrative.
- Use FIRST as a review aid: fast, independent, repeatable, self-validating, timely.
- Preserve a single testing vocabulary; avoid assertion noise and production logic duplicated in tests.
- Do not confuse maximal assertion count rules with behavioral focus.

### 10. Classes

- Keep classes cohesive and focused on one actor/reason to change.
- Encapsulate internals and expose the smallest useful surface.
- Use SRP to identify change axes and DIP to isolate volatile details.
- Extract classes when cohesion evidence supports it; do not fragment code into ceremony.

### 11. Systems

- Separate construction/configuration from runtime use; keep concrete wiring at the composition root.
- Scale architecture incrementally, preserving options until evidence justifies commitment.
- Keep cross-cutting concerns modular and use standards only when they add demonstrable value.
- Make domain policy visible and reduce framework intrusion.

### 12. Emergence

Use the four design rules as an ordering heuristic:

1. Run all tests.
2. Reveal intent.
3. Remove duplication.
4. Minimize unnecessary elements.

Tests protect refactoring; the last three rules improve structure. Do not remove necessary clarity merely to reduce line or type count.

### 13. Concurrency

- Separate concurrency policy from business policy.
- Minimize shared mutable state and keep synchronized regions small.
- Understand library thread-safety, shutdown behavior, deadlock risks, and execution models.
- Test beyond the happy path with timeouts, repeated runs, load, and platform variation where risk warrants it.
- Never claim a concurrency defect is fixed because one run passed.

### 14. Successive Refinement

- Start with the simplest working path, then refine through small behavior-preserving steps.
- Keep tests passing during refactoring and separate semantic changes from structural cleanup when possible.
- Let abstractions emerge from concrete duplication and change pressure rather than guessing them up front.

### 15. JUnit Internals

- Demonstrates incremental cleanup: reduce duplication, improve names, separate concerns, and preserve behavior with tests.
- Review the direction and safety of refinement, not fidelity to the Java-specific end state.

### 16. Refactoring SerialDate

- Review public API, naming, responsibility, duplication, dead code, boundary conditions, and test coverage together.
- Fix high-risk behavior and contract issues before cosmetic cleanup.
- Record unresolved design decisions instead of hiding them in partial refactors.

### 17. Smells and Heuristics

The chapter consolidates contextual diagnostics across comments, environment, functions, general design, Java, names, and tests. Recurring themes:

- Delete obsolete or redundant information.
- Make the obvious behavior real, not surprising.
- Centralize knowledge and policy; remove duplication at its correct abstraction level.
- Keep configurable data at an appropriate boundary.
- Prefer polymorphism or data-driven dispatch when repeated conditional type logic is truly open-ended.
- Avoid hidden temporal coupling, arbitrary structure, transitive navigation, feature envy, selector arguments, dead code, and inconsistent vocabulary.
- Test boundaries, defects, and fast/slow behavior; keep the suite deterministic and understandable.

### Appendix A. Concurrency II

- Enumerate execution paths and shared-state failure modes before selecting synchronization.
- Favor designs that reduce shared data over increasingly clever locking.
- Instrument, stress, and isolate concurrency tests; distinguish production guarantees from test-only hooks.

## Cross-cutting rules

| Concern | Source-backed default | Context check |
|---|---|---|
| Readability | Optimize for the next reader | Generated code and proven hot paths may favor other constraints |
| Functions | One responsibility/abstraction level | Do not enforce an arbitrary line count |
| Arguments | Fewer, explicit inputs | Domain constructors and pure transformations may legitimately need several fields |
| Comments | Explain why/contract, not what | Public API documentation may be required by ecosystem |
| Errors | Explicit, contextual, never swallowed | Use the language's idiomatic error model |
| Boundaries | Wrap semantic mismatch or volatility | Avoid pass-through interfaces with no owned policy |
| Tests | Behavioral, deterministic, readable | Test pyramid shape depends on risk and system boundaries |
| Refactoring | Small, protected, in scope | Stop when risk exceeds evidence or authorization |

## How to apply the source

1. Read the changed behavior and tests before rating cleanliness.
2. Identify the actor, invariant, and abstraction level of the code.
3. Select only applicable checks from `clean-code-standards.md`.
4. Cite `file:line` or symbols and explain the maintenance or correctness consequence.
5. Prefer the smallest behavior-preserving improvement.
6. Verify with repository-native formatting, static analysis, and tests.
7. Report uncertain heuristics as suggestions, not defects.

## Limits and interpretation

- The book's examples are predominantly Java and reflect its publication era. Translate principles into the target language instead of copying syntax or Java-specific rules.
- Short functions, zero comments, exception use, and one-assert tests are not universal numeric laws.
- Clean code cannot override public contracts, measured performance requirements, security, accessibility, compliance, or repository conventions.
- A pattern is useful only when it reduces change cost or protects an invariant. Do not introduce indirection merely to make code resemble a diagram.
