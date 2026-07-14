# Clean Architecture patterns (analysis reference)

Derived from Robert C. Martin, *Clean Architecture*, via the repo PDF summary
`Arquitetura Limpa PDF (Cópia limitada).pdf` and the chapter digest in
`clean-architecture-source.md` (principles only — actionable for code review).

**IDs** (`P-*`, `X-*`) and the `BASELINE | …` machine line stay English for catalog
stability. **Prose** around findings, suggestions, and review narrative follows the
**conversation language** (see SKILL.md).

Load this when analyzing codebases, detecting pattern drift, or writing the
**Architecture Baseline Line** for each module under review.

---

## 1. Core thesis

| Principle | Review implication |
|-----------|-------------------|
| Design and architecture are a continuum | Judge structure *and* detail; do not only draw boxes |
| Goal = minimize human effort over time | Flag rising change-cost, merge conflict magnets, untestable cores |
| Behavior **and** structure are both product values | Perfect-but-unchangeable code is obsolete; imperfect-but-soft is better |
| "The only way to go fast is to go well" | Challenge urgency that permanently damages structure |
| Paradigms subtract capabilities (discipline) | Prefer clear constraints over "more power" |

---

## 2. SOLID (class / module level)

### SRP — Single Responsibility Principle

- **Meaning:** A module has **one reason to change** = serves **one actor** (stakeholder group), not "one function only".
- **Smell:** Class/file mixes CFO/COO/CTO concerns (e.g. payroll calc + hours report + DB persist on one type).
- **Smell:** Accidental shared helpers couple unrelated actors → cascading breaks.
- **Smell:** Frequent merge conflicts on the same type from unrelated teams.
- **Fix direction:** Split by actor; share plain data (`EmployeeData`); Facade if needed; keep domain rules free of I/O.

### OCP — Open–Closed Principle

- **Meaning:** Open for extension, closed for modification.
- **Smell:** Small requirement change rewrites protected core (interactors / domain).
- **Smell:** `switch`/`if` trees on type that grow for every new variant (prefer polymorphism / plugins).
- **Fix direction:** Protect high-level policy; point dependencies inward; extend with new code at the edges.

### LSP — Liskov Substitution Principle

- **Meaning:** Subtypes (or alternate implementations of a contract) must be replaceable without breaking clients.
- **Smell:** Square/Rectangle style hierarchy; subtype strengthens preconditions or weakens postconditions.
- **Smell:** API variants that need special-case branches (`dest` vs `destination`) in every client.
- **Fix direction:** Consistent contracts; config/adapters for wire-format variance; avoid "almost" subtypes.

### ISP — Interface Segregation Principle

- **Meaning:** Clients must not depend on methods/modules they do not use.
- **Smell:** Fat interfaces; one `Ops` class forces recompiles/redeploys for unused ops.
- **Smell:** App depends on a framework that pulls unused heavy deps (baggage).
- **Fix direction:** Role interfaces per client; slim public surfaces; optional modules.

### DIP — Dependency Inversion Principle

- **Meaning:** Source dependencies point toward **abstractions** (stable policy), not volatile concretes.
- **Smell:** Domain/use-case imports ORM entities, HTTP frameworks, vendor SDKs.
- **Smell:** Widespread `new ConcreteService()` in policy code (factories/main should wire).
- **Exceptions:** Extremely stable concretes (e.g. language `String`) are OK.
- **Fix direction:** Ports in inner circles; adapters outer; Abstract Factory / composition root (`main`) owns concrete wiring.

---

## 3. Component cohesion (package / deployable unit)

| Principle | Rule | Violation signal |
|-----------|------|------------------|
| **REP** Reuse/Release Equivalence | Reuse grain = release grain; versioned, cohesive purpose | Random grab-bag packages released together |
| **CCP** Common Closure | Classes that change for the same reason live together | One change fans out across many packages |
| **CRP** Common Reuse | Do not force clients to depend on what they do not use | Fat packages / "utils" that drag unused code |

**Tension:** REP+CCP enlarge components; CRP shrinks them. Balance by maturity and actual change rates — not ideology.

---

## 4. Component coupling

| Principle | Rule | Violation signal |
|-----------|------|------------------|
| **ADP** Acyclic Dependencies | Dependency graph is a DAG | Circular imports; "morning after" syndrome |
| **SDP** Stable Dependencies | Depend in the direction of stability | Volatile policy depends on volatile UI/DB drivers |
| **SAP** Stable Abstractions | Stability correlates with abstractness | Stable concrete cores (Zone of Pain); abstract unused shells (Zone of Uselessness) |

**Metrics (optional evidence):**

- Fan-in / Fan-out
- Instability `I = Fan-out / (Fan-in + Fan-out)` (0 ≈ stable, 1 ≈ unstable)
- Prefer high-level policy near Main Sequence (stable + abstract enough)

**Cycle breakers:** DIP (depend on abstractions); extract shared component; invert ownership.

---

## 5. Clean Architecture circles (Dependency Rule)

```text
┌─────────────────────────────────────────────┐
│  Frameworks & Drivers (DB, UI, devices…)    │  outermost
│  ┌───────────────────────────────────────┐  │
│  │  Interface Adapters                   │  │
│  │  (Controllers, Presenters, Gateways)  │  │
│  │  ┌─────────────────────────────────┐  │  │
│  │  │  Application Business Rules     │  │  │
│  │  │  (Use Cases / Interactors)      │  │  │
│  │  │  ┌───────────────────────────┐  │  │  │
│  │  │  │  Enterprise Business Rules│  │  │  │
│  │  │  │  (Entities)               │  │  │  │
│  │  │  └───────────────────────────┘  │  │  │
│  │  └─────────────────────────────────┘  │  │
│  └───────────────────────────────────────┘  │
└─────────────────────────────────────────────┘
```

### Dependency Rule (non-negotiable baseline)

**Source-code dependencies point only inward** (toward higher-level policy).
Nothing in an inner circle knows names, types, or frameworks of an outer circle.

| Circle | Owns | Must not own |
|--------|------|--------------|
| **Entities** | Critical business rules + critical business data; enterprise-wide | UI, DB schema, web, frameworks |
| **Use Cases** | Application-specific rules; orchestration of entities; request/response models | Framework types; entity leakage into DTOs that couple to HTTP/ORM |
| **Interface Adapters** | Controllers, presenters, gateways, mappers; format translation | Core business decisions |
| **Frameworks & Drivers** | DB engines, web, UI toolkits, devices | Business policy |

### Data flow (typical web)

UI → Controller → Use Case → Entity → (back) Presenter → View Model → View  
Always with **Dependency Rule** respected (outer depends on inner ports).

### Humble Object

At every boundary, split **hard-to-test** (humble: View, raw SQL driver, socket) from **testable** (Presenter, Use Case, pure mappers).

---

## 6. Business rules taxonomy

| Kind | Definition | Code signal |
|------|------------|-------------|
| **Critical Business Rules** | Make or save money even without a computer | Pure domain methods; invariants |
| **Critical Business Data** | Data those rules need | Entity state without ORM annotations as truth |
| **Application rules (Use Cases)** | How *this system* automates the process | Interactors; validation gates before entity ops |
| **Request/Response models** | Boundary data structures | Independent of Entities and web frameworks |

**Smell:** Request DTO is an ORM entity or HTTP model reused as domain.

---

## 7. Screaming architecture

- Top-level structure should scream **domain use cases** (health, billing, inventory), not Rails/Spring/Next.
- Frameworks are tools, not the architecture.
- Defer framework/DB/web choices until forced; keep options open.
- Web / DB / UI / frameworks are **delivery or storage details**, not the system shape.
- Microservices are **not** architecture by themselves; architecture = policy boundaries + Dependency Rule *inside* and *across* services.

---

## 8. Boundaries

| Concept | Guidance |
|---------|----------|
| Full boundary | Polymorphic ports both sides; independent deploy; higher cost |
| Partial boundary | Prepare separation (packages/interfaces) but same deploy unit; YAGNI-aware placeholder |
| Main / composition root | Outer, dirty plugin: wires concretes, configs, envs; hands control to policy |
| Test boundary | Tests are outermost; depend inward only; prefer test API over UI coupling; avoid fragile structural coupling |
| Partial degradation risk | Boundaries blur over time (e.g. FitNesse web vs app) — re-assert periodically |

---

## 9. Pattern catalog (name what you see)

Use these **English** pattern IDs in findings:

### Healthy patterns

| ID | Name | Expectation |
|----|------|-------------|
| P-ENT | Entity / Domain model | Pure rules; no framework imports |
| P-UC | Use Case / Interactor | App policy; ports for I/O |
| P-PORT | Port (interface inward) | Defined by use case/domain |
| P-ADP | Adapter (outer) | Implements port; talks to DB/HTTP/UI |
| P-CTRL | Controller | Thin: map input → use case DTO |
| P-PRES | Presenter | Formats output to ViewModel |
| P-GW | Gateway | DB/service interface at adapter edge |
| P-DTO | Boundary DTO | Request/Response independent of entity/ORM |
| P-CR | Composition Root / Main | Wiring only; no business rules |
| P-HO | Humble Object split | Testable policy vs humble I/O |
| P-HAL | Hardware/driver abstraction | Embedded: software free of hardware details |

### Out-of-pattern (anti-patterns)

| ID | Name | Detection |
|----|------|-----------|
| X-DEP-OUT | Dependency points outward | Domain imports ORM/web/SDK |
| X-GOD | God module / multi-actor type | Many reasons to change |
| X-FRAME-SCREAM | Framework-screaming layout | Top folders = Spring/Rails/Next only |
| X-ENTITY-DTO | Entity leaked across boundary | ORM entity as API/event payload |
| X-FAT-IF | Fat interface / bag package | Clients forced to unused deps |
| X-CYCLE | Cyclic dependency | A→B→A packages/services |
| X-STABLE-ON-VOLATILE | Unstable dependency direction | Core depends on UI/driver |
| X-SVC-AS-ARCH | "Services = architecture" fallacy | Split deployables without policy boundaries |
| X-SHARED-RECORD | Shared mutable record coupling | Microservices coupled via shared DB schema |
| X-LOGIC-IN-UI | Business rules in UI/controller | Fat controllers; no use case |
| X-LOGIC-IN-DB | Business rules only in SQL/triggers | Unreusable, untestable policy |
| X-TEST-FRAGILE | Fragile tests | Coupled to GUI/structure; no test API |
| X-CONCRETE-NEW | Concrete new in policy | `new PostgresRepo()` inside use case |
| X-VENDOR-DOMAIN | Vendor-named domain | `StripeInvoice` as core type |
| X-PATTERN-ZOO | Pattern zoo | Many GoF names without real variation axis |
| X-SINGLETON-SOT | Singleton as SoT | Global mutable process state for business data |
| X-GOD-FACADE | God façade | One façade owns many actors/invariants |
| X-INHERIT-REUSE | Inheritance for reuse only | Deep hierarchy instead of composition (GoF) |
| X-OBSERVER-BUS | Hidden mega-observer | Implicit global bus; ordering/failure opaque |

### GoF design patterns (`G-*`)

Full catalog, intents, consequences, and Clean Architecture placement live in
`design-patterns-source.md` (source PDF: Gamma, Helm, Johnson, Vlissides).

Use `G-*` IDs **alongside** `P-*` when object-structure patterns are the story:

| Family | Example IDs |
|--------|-------------|
| Creational | `G-AF` Abstract Factory, `G-BU` Builder, `G-FM` Factory Method, `G-PR` Prototype, `G-SI` Singleton |
| Structural | `G-AD` Adapter, `G-BR` Bridge, `G-CO` Composite, `G-DE` Decorator, `G-FA` Façade, `G-FL` Flyweight, `G-PX` Proxy |
| Behavioral | `G-CR` Chain, `G-CM` Command, `G-IN` Interpreter, `G-IT` Iterator, `G-MD` Mediator, `G-MM` Memento, `G-OB` Observer, `G-ST` State, `G-SY` Strategy, `G-TM` Template Method, `G-VI` Visitor |

Typical dual tags: port/adapter edge → `P-ADP` + `G-AD`; interchangeable domain algorithm → `P-ENT`/`P-UC` + `G-SY`; composition root wiring → `P-CR` + `G-AF`.

### Production-ready microservices (`MS-*` / `X-MS-*`)

Full standards, Appendix A checklist, and evaluation questions live in
`microservices-source.md` (source PDF: Susan J. Fowler, *Production-Ready Microservices*).

Use when reviewing **deployed or proposed services** and platform layers — **after**
policy boundaries / SoT are sound (`X-SVC-AS-ARCH` still applies).

| Family | Example IDs |
|--------|-------------|
| Capabilities | `MS-STABLE`, `MS-RELIABLE`, `MS-SCALE`, `MS-PERF`, `MS-FAULT`, `MS-CHAOS`, `MS-MON`, `MS-DOC`, `MS-PIPE`, `MS-HEALTH`, `MS-DEPCACHE`, `MS-ONCALL` |
| Gaps | `X-MS-NO-PIPE`, `X-MS-BIGBANG`, `X-MS-UNKNOWN-DEP`, `X-MS-NO-FALLBACK`, `X-MS-FAKE-HEALTH`, `X-MS-NO-CB`, `X-MS-SPOF`, `X-MS-NO-SCALE-MODEL`, `X-MS-SHARED-DB`, `X-MS-NO-CAPACITY`, `X-MS-NO-LOADTEST`, `X-MS-NO-METRICS`, `X-MS-NOISE-ALERT`, `X-MS-NO-ONCALL`, `X-MS-DOC-ROT`, `X-MS-NO-AUDIT`, `X-MS-PREMATURE-SPLIT`, `X-MS-SPRAWL` |

Typical dual tags: service with good pipeline but wrong domain boundary → `MS-PIPE` + `X-DEP-OUT`; shared DB mesh → `X-MS-SHARED-DB` + `X-SHARED-RECORD`.

Optional rollup:

```text
PRODREADY | <service> | stable+reliable: pass|partial|fail | scale+perf: … | fault+disaster: … | monitored: … | documented: … | blockers: [X-MS-…]
```

---

## 10. Architecture Baseline Line (required per analyzed unit)

For **every** module/package/service/file cluster analyzed, emit exactly one baseline line:

```text
BASELINE | <unit> | expected: <Clean Architecture placement + key rules> | observed: <what code does> | fit: align|partial|drift | patterns: [P-…, G-…, MS-…] | violations: [X-…, X-MS-…] | suggestion: <one concrete next step>
```

### Examples

```text
BASELINE | billing/domain | expected: Entities + pure money rules; no framework | observed: domain imports TypeORM entities | fit: drift | patterns: [P-ENT] | violations: [X-DEP-OUT, X-ENTITY-DTO] | suggestion: Introduce plain BillingAccount entity; map ORM only in adapters/gateway
```

```text
BASELINE | api/orders/controller | expected: Thin controller → Use Case DTO | observed: pricing + inventory + SQL in handler | fit: drift | patterns: [P-CTRL] | violations: [X-LOGIC-IN-UI, X-GOD] | suggestion: Extract PlaceOrder use case; inject ports for inventory and payment
```

```text
BASELINE | app/main | expected: Composition root wires adapters | observed: main only DI setup | fit: align | patterns: [P-CR, P-ADP] | violations: [] | suggestion: Keep business rules out of main; document plugin variants (test/prod)
```

---

## 11. Severity mapping for Clean Architecture violations

| Severity | When |
|----------|------|
| critical | Dependency Rule break that can corrupt SoT, couple tenants, or lock business to a vendor with no escape |
| high | Business rules trapped in UI/DB; cycles blocking independent change; untestable core |
| medium | Partial boundaries eroding; fat packages; OCP violated for next known change |
| low | Naming/layout noise that does not yet block change |

---

## 12. Suggestion quality bar

Suggestions must be:

1. **Layer-correct** — lowest correct circle to change
2. **Evidence-linked** — file/path or symbol
3. **Reversible** — prefer partial boundary / dual-run when cost is high
4. **Actor-aware** — SRP by stakeholder, not by verb
5. **Conversation-aligned** — explain findings and suggestions in the user's conversation language; keep `P-*` / `X-*` IDs and the `BASELINE | …` skeleton stable

Never suggest "rewrite everything in Clean Architecture." Prefer **strangler** slices: one use case, one port, one adapter.

**Deeper source map:** `clean-architecture-source.md` (PDF chapter map + Dependency Rule, Humble Object, details, packaging).
