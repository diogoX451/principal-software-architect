# Architecture review checklist

Use for PRs, modules, or whole systems. Skip sections that do not apply; do not invent issues to fill the list.
Findings and baseline prose follow the conversation language. Stable IDs and field skeletons remain language-agnostic. Architecture catalog: `clean-architecture-patterns.md`.
For code-level review, also load `clean-code-standards.md`.

## A. Boundaries & ownership

- [ ] Each module/service has a clear owner of **one** primary invariant (SRP by actor)
- [ ] No circular dependencies between bounded contexts (ADP)
- [ ] Public API surface is intentional (not "export everything") (ISP / CRP)
- [ ] Domain language is not vendor-named (`X-VENDOR-DOMAIN`)
- [ ] Source dependencies point **inward** (Dependency Rule)

## B. Clean Architecture placement

- [ ] Entities hold critical business rules without framework imports (`P-ENT`)
- [ ] Use cases / interactors own application policy (`P-UC`)
- [ ] Controllers/presenters/gateways are adapters only (`P-CTRL`, `P-PRES`, `P-GW`)
- [ ] Request/Response DTOs are not ORM entities (`P-DTO` / `X-ENTITY-DTO`)
- [ ] Composition root / main wires concretes; policy does not `new` drivers (`P-CR` / `X-CONCRETE-NEW`)
- [ ] Top-level layout screams use cases, not frameworks (`X-FRAME-SCREAM`)

## C. Data & source of truth

- [ ] User-visible state has a single SoT
- [ ] Async paths cannot lose SoT (ack only after durable write, or explicit compensation)
- [ ] Multi-tenant keys are consistent (slug vs UUID resolved at the edge)
- [ ] Migrations/backfills are safe (expand → migrate → contract)
- [ ] DB is treated as a detail (policy not shaped as tables-first)

## D. Control flow

- [ ] Sync path is bounded (timeouts independent per step)
- [ ] Async path has idempotency / dedupe story
- [ ] Partial failure modes are named (not "hope")
- [ ] No head-of-line blocking on lifecycle/reconnect paths for multi-subject workers

## E. Extensibility (OCP / partial boundaries)

- [ ] New capability lands on the **lowest** correct layer
- [ ] Drivers/adapters are swappable without renaming product concepts (DIP / LSP)
- [ ] Feature flags / dual-read exist for breaking contract changes
- [ ] No second framework introduced for a one-off feature
- [ ] Extension prefers new code over core rewrites (OCP)

## F. Operability

- [ ] Health/ready semantics match real dependencies
- [ ] Metrics/logs can answer "is it broken?" without SSH folklore
- [ ] Deploy/rollback path is documented or obvious
- [ ] Cost drivers (LLM tokens, egress, storage) are metered if billed

## G. Security & trust

- [ ] Trust boundaries enforced in code (not only docs)
- [ ] Secrets never in events/logs
- [ ] AuthZ is tenant-scoped by default
- [ ] Dangerous operations are explicit and reversible where possible

## H. Test boundary

- [ ] Policy (entities/use cases) testable without UI/DB frameworks (`P-HO`)
- [ ] Tests are not structurally fragile (`X-TEST-FRAGILE`)
- [ ] Test superpowers not shipped to production

## I. Services / production-ready microservices (if applicable)

Catalog: `microservices-source.md` (`MS-*` / `X-MS-*`, Fowler). Four ecosystem layers: hardware → communication → app platform → services.

- [ ] Deployable split maps to policy boundaries — not "services for fashion" (`X-SVC-AS-ARCH` / `X-MS-PREMATURE-SPLIT`)
- [ ] No shared-record coupling as the real architecture (`X-SHARED-RECORD` / `X-MS-SHARED-DB`)
- [ ] Cross-cutting features do not require coordinated rewrites of every service
- [ ] Deploy pipeline has staging + canary/pre-release + controlled prod (`MS-PIPE`; not `X-MS-NO-PIPE` / `X-MS-BIGBANG`)
- [ ] Clients and dependencies known; fallbacks/defensive cache where needed (`MS-DEPCACHE`)
- [ ] Accurate health checks + circuit breaking / discovery hygiene (`MS-HEALTH`)
- [ ] Growth scale (qualitative + quantitative) known; capacity planning exists (`MS-SCALE`)
- [ ] No SPOF on critical path; resilience/load testing proportional to blast radius (`MS-FAULT` / `MS-CHAOS`)
- [ ] Key metrics, dashboards, **actionable** alerts, on-call (`MS-MON` / `MS-ONCALL`)
- [ ] Service docs (description, diagram, contacts, flows/deps, runbook, FAQ) + audits (`MS-DOC`)

## J. GoF design patterns (when object structure matters)

Catalog: `design-patterns-source.md` (`G-*`). Principles: interface not implementation; composition over inheritance; encapsulate variation.

- [ ] Axes of variation are isolated (Strategy/State/Factory) instead of growing `switch` trees
- [ ] Adapters/proxies sit at the edge — not as domain types (`G-AD` / `G-PX` + Dependency Rule)
- [ ] No Singleton as business SoT (`X-SINGLETON-SOT`)
- [ ] No pattern zoo without forces (`X-PATTERN-ZOO`); no god Façade/Mediator (`X-GOD-FACADE` / `X-GOD`)
- [ ] Creational binding happens at composition root, not inside use cases (`G-AF`/`G-FM` + `P-CR`)

## K. Baseline & multi-agent

- [ ] Every analyzed unit has a `BASELINE | …` line (explain in conversation language)
- [ ] Pattern inventory lists `P-*`, `G-*`, `MS-*` (when relevant), and `X-*` / `X-MS-*` with evidence
- [ ] Multi-service reviews include `PRODREADY | …` rollup when useful
- [ ] Adversary pass challenged align/drift claims
- [ ] `VALIDATION | …` attestation present when multi-agent ran

## L. Clean code in boundary implementations

- [ ] Names communicate domain intent and use one term per concept (`CC-NAME` / `XC-NAME-MISLEAD`)
- [ ] Functions keep policy and detail at coherent abstraction levels (`CC-FUNC` / `XC-FUNC-MIX`)
- [ ] Side effects, error contracts, cleanup, time, and randomness are explicit (`CC-ERROR` / `XC-SIDE-HIDDEN`)
- [ ] Comments preserve rationale or contracts; stale/noise/commented-out code is absent (`XC-COMMENT-*`)
- [ ] Objects, DTOs, and foreign types respect their architectural boundaries (`CC-DATA`, `CC-BOUNDARY`)
- [ ] Tests are behavioral, deterministic, readable, and do not copy the implementation (`CC-TEST` / `XC-TEST-*`)
- [ ] Construction stays outside runtime policy (`CC-WIRE` / `XC-CONSTRUCT-IN-USE`)
- [ ] No speculative wrapper/pattern or cleanup outside scope (`XC-WRAPPER-NOISE`, `XC-OVERDESIGN`, `XC-SCOPE-CREEP`)
- [ ] Every code unit inspected has a `CODEBASELINE | …` line
- [ ] Repository-native formatter, linter, type checker, and relevant tests ran, or gaps are explicit

## M. Algorithms and data structures (when material)

Catalog: `algorithm-selection-standards.md` (`ALG-*`, `XA-*`).

- [ ] Problem shape, semantic result, input scale/distribution, and operation mix are explicit (`ALG-PROBLEM`)
- [ ] Preconditions are true/enforced: ordering, weight signs, graph semantics, hash/equality, feature scaling (`ALG-PRECOND`)
- [ ] Time and auxiliary/retained space distinguish worst, expected/amortized, preprocessing, and output costs (`ALG-COMPLEX`)
- [ ] Exact, approximate, probabilistic, or heuristic behavior is visible in the contract (`ALG-EXACT`)
- [ ] Standard-library/database/platform primitive was considered before custom implementation (`ALG-STDLIB`)
- [ ] Data structure matches access/update/order/memory workload (`ALG-STRUCT`)
- [ ] Correctness has boundary/property tests and a simple oracle where feasible (`ALG-CORRECT`)
- [ ] Benchmark uses representative scale/distribution, percentiles, memory, and a baseline (`ALG-MEASURE`)
- [ ] Production assumptions and revisit thresholds are observable (`ALG-OBSERVE`)
- [ ] Every material algorithmic path has an `ALGBASELINE | …` line

## N. Routed specialist checks (only when material)

- [ ] Domain boundaries: subdomain class, context map, aggregate invariants, language (`DOM-*` / `XDOM-*`; `DOMBASELINE`)
- [ ] Distributed state: authority, consistency, transaction, replication, delivery, recovery (`DATA-*` / `XD-*`; `DATABASELINE`)
- [ ] Contracts: schema SoT, compatibility, errors/idempotency/pagination, deprecation lifecycle (`API-*` / `XAPI-*`; `APIBASELINE`)
- [ ] Quality claims: prioritized measurable scenarios, sensitivities and trade-offs (`QA-*` / `XQ-*`; `QUALITYBASELINE`)
- [ ] Reliability: user SLI/SLO, deadlines/retries, overload, rollout and recovery (`REL-*` / `XR-*`; `RELBASELINE`)
- [ ] Security: assets, trust boundaries, identity/authz, data/secrets, detection/recovery (`SEC-*` / `XS-*`; `SECBASELINE`)
- [ ] Evolution: behavior oracle, seam, compatibility, rollback, retirement, fitness (`EVO-*` / `XE-*`; `EVOBASELINE`)
- [ ] Communication: audience, abstraction level, labeled relationships, currency/owner (`DOC-*` / `XDOC-*`; `DOCBASELINE`)
- [ ] Organization: owner, consumers, coordination, cognitive load and operational feedback (`ENG-*` / `XENG-*`; `ENGBASELINE`)
- [ ] Only applicable baselines are emitted; omitted domains are not marked “pass” without analysis

## Severity guide

| Severity | Meaning |
|----------|---------|
| critical | Can corrupt data, cross tenants, lose money/safety, or hard-lock core policy to a vendor/detail |
| high | Will fail under realistic load, blocks growth, or traps business rules in UI/DB |
| medium | Friction, debt that compounds this quarter, eroding partial boundaries |
| low | Local clarity / maintainability with a concrete cost but no immediate growth block |

Do not assign severity from line count, argument count, comments, pattern absence, Big O label, architecture adjective, or checklist absence alone. State the correctness, change-cost, resource, security, user, or operability consequence.
