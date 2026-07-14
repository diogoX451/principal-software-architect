# Design Patterns (GoF) — source reference

**Primary source (repo):** `Padrões de Projetos Soluções Reutilizáveis (Gamma, Erich  johnson, Ralph  Helm etc.).pdf`  
**Authors:** Erich Gamma, Richard Helm, Ralph Johnson, John Vlissides (*Gang of Four*)  
**Edition:** Portuguese translation (Bookman / Addison-Wesley) — *Design Patterns: Elements of Reusable Object-Oriented Software*  
**Use in this skill:** Load when naming object structure, choosing creational/structural/behavioral mechanisms, reviewing over-patterning, or mapping GoF roles onto Clean Architecture circles. Pair with `clean-architecture-patterns.md` (`P-*` / `X-*`) and `clean-architecture-source.md`.

> **Quality note:** This is the **full book** (not a flyer summary). Digest below is principles + catalog intents + architect decision rules. Prefer **intent + consequences** over copy-pasting class diagrams. Code evidence always wins.

---

## 1. What a design pattern is (ch. 1.1)

Four essential elements:

| Element | Meaning for review |
|---------|-------------------|
| **Name** | Shared vocabulary — document and findings use GoF names |
| **Problem** | When to apply; context and forces |
| **Solution** | Roles, relationships, collaborations (template, not paste code) |
| **Consequences** | Trade-offs (space/time, flexibility, coupling, complexity) |

A pattern is **not**: a linked list, a whole application architecture, or a framework.  
Patterns sit **below** architecture frameworks and **above** language idioms.

**Patterns vs frameworks (book):**

1. Patterns are more abstract (reimplemented each time).  
2. Patterns are smaller architectural elements (a framework embeds many patterns).  
3. Patterns are less domain-specialized than frameworks.

---

## 2. Core OO design principles (ch. 1.6)

These principles **underwrite** almost every GoF pattern and align with Clean Architecture / DIP:

| Principle | Rule | Review signal |
|-----------|------|---------------|
| **Program to an interface, not an implementation** | Clients depend on abstract types; concretes appear at creation boundary | Domain `new ConcreteX()` scattered in policy |
| **Prefer object composition to class inheritance** | Black-box reuse; runtime swap; keep hierarchies small | Deep inheritance for “reuse”; inheritance that violates encapsulation |
| **Encapsulate the concept that varies** | Isolate the axis of change behind a stable interface | Same `if/switch` growing for every new variant |
| **Delegation** | Composition that rivals inheritance for reuse | Window *has-a* Rectangle vs *is-a* Rectangle smell |

**Creational patterns** exist so the rest of the system can stay interface-oriented while *somewhere* (composition root / Main / factories) binds concretes.

---

## 3. Catalog organization

### Purpose × scope (Table 1.1)

| Scope \ Purpose | Creational | Structural | Behavioral |
|-----------------|------------|------------|------------|
| **Class** | Factory Method | Adapter (class) | Interpreter, Template Method |
| **Object** | Abstract Factory, Builder, Prototype, Singleton | Adapter (object), Bridge, Composite, Decorator, Façade, Flyweight, Proxy | Chain of Responsibility, Command, Iterator, Mediator, Memento, Observer, State, Strategy, Visitor |

- **Creational** — how objects are born (defer class knowledge).  
- **Structural** — how classes/objects compose.  
- **Behavioral** — how objects collaborate and share responsibility.  
- **Class scope** — static, inheritance-time. **Object scope** — dynamic, runtime.

### Common families (book relationships)

| Often together | Why |
|----------------|-----|
| Composite + Iterator / Visitor | Tree walk without exploding node APIs |
| Composite + Decorator | Structure similar; intent differs (part-whole vs add responsibility) |
| Abstract Factory ↔ Prototype | Alternatives for families of products |
| Observer + Mediator | Decouple publishers vs centralize interaction |
| Strategy + Context | Algorithm family behind stable host |
| Command + Memento | Undo stacks |
| Adapter + Façade | Interface reshape vs subsystem simplification (different intent) |
| Bridge vs Adapter | Bridge designed up-front to vary both sides; Adapter usually retrofit |

---

## 4. The 23 patterns — intent + architect notes

IDs: **`G-<code>`** for findings (`patterns: [G-AF, G-AD, …]`).  
Use with Clean Architecture IDs (`P-*` / `X-*`) when both apply.

### Creational

| ID | Pattern | Intent (book) | When (architecture) | Misuse / smell |
|----|---------|---------------|---------------------|----------------|
| **G-AF** | Abstract Factory | Interface for families of related products without concrete classes | Composition root / plugin variants (test/prod drivers); family consistency | Factory explosion; factory that *is* the domain |
| **G-BU** | Builder | Separate construction of complex object from representation | Multi-step assembly of aggregates/DTOs; same process → many representations | Builder for 2-field structs |
| **G-FM** | Factory Method | Interface to create; subclasses decide concrete class | Framework extension hooks; open for product subtypes | Parallel inheritance only for `new` |
| **G-PR** | Prototype | Create by cloning a prototypical instance | Runtime product catalogs; expensive setup | Clone of mutable graph without ownership rules |
| **G-SI** | Singleton | One instance + global access | Rare: true process-wide policy (logging config?) | Hidden global SoT; untestable; multi-tenant trap → prefer DI composition root |

### Structural

| ID | Pattern | Intent (book) | When (architecture) | Misuse / smell |
|----|---------|---------------|---------------------|----------------|
| **G-AD** | Adapter | Convert interface so incompatible classes collaborate | Clean Architecture **port/adapter edge**; vendor SDK wrap | Adapter in domain core; adapter that adds business rules |
| **G-BR** | Bridge | Decouple abstraction from implementation so both vary | Stable domain API over multiple runtimes/drivers | Premature bridge for one implementation |
| **G-CO** | Composite | Tree of part-whole; uniform client treatment | Document models, UI trees, rule trees | Treating graphs as trees; leaf/composite API pollution |
| **G-DE** | Decorator | Add responsibilities dynamically (alt. to subclassing) | Cross-cutting at edges (auth, metrics, retry) without domain inheritance | Decorator stack hiding core rules; order-sensitive chaos |
| **G-FA** | Façade | Unified higher-level interface to a subsystem | Application service boundary; simplify package for clients | God façade owning all invariants (`X-GOD`) |
| **G-FL** | Flyweight | Share fine-grained objects efficiently | Huge catalogs of immutable value-like objects | Flyweight for mutable identity entities |
| **G-PX** | Proxy | Surrogate controlling access to another object | Lazy load, remote, protection, virtual resource | Proxy that silently changes business semantics |

### Behavioral

| ID | Pattern | Intent (book) | When (architecture) | Misuse / smell |
|----|---------|---------------|---------------------|----------------|
| **G-CR** | Chain of Responsibility | Pass request along chain until one handles | Middleware, validation pipelines, UI event bubbling | Unclear who handles; silent drop |
| **G-CM** | Command | Encapsulate request as object (queue, log, undo) | Use-case invocation objects; job queues; undo | Anemic “command” that is just a DTO name |
| **G-IN** | Interpreter | Grammar + interpreter for a language | DSL rules, query filters | Interpreter for trivial configs better as data |
| **G-IT** | Iterator | Sequential access without exposing representation | Collections, domain aggregates traversal | Leaking internal structure via “iterator” |
| **G-MD** | Mediator | Encapsulate how a set of objects interact | UI dialog coordination; reduce N×N coupling | Mediator becomes god object |
| **G-MM** | Memento | Capture/restore internal state without breaking encapsulation | Undo, snapshots, draft restore | Memento exposes private fields as public DTO |
| **G-OB** | Observer | 1-to-many; notify dependents on change | Domain events (in-process); UI binding | Hidden global event bus; cascade storms; lost SoT |
| **G-ST** | State | Behavior changes with internal state (as if class changed) | Lifecycle machines (order, claim, ticket) | State machine with business rules only in transitions outside domain |
| **G-SY** | Strategy | Family of interchangeable algorithms | Pricing, scoring, auth methods behind port | Strategy for single algorithm “just in case” |
| **G-TM** | Template Method | Skeleton algorithm; subclasses fill steps | Framework hooks; fixed policy with variable steps | Template Method deep inheritance vs composition Strategy |
| **G-VI** | Visitor | New operation over structure without changing element classes | Export, analytics over stable domain graph | Visitor thrashing when structure changes often (prefer ops on types) |

---

## 5. How to select a pattern (ch. 1.7 — book process)

Use this order in reviews and design options:

1. **Name the force that varies** (creation, structure, collaboration).  
2. **Read intents** (section above / book §1.4) — shortlist by problem statement.  
3. **Check purpose × scope** table.  
4. **Compare related patterns** (same structure, different intent — e.g. Decorator vs Proxy).  
5. **List consequences** — what coupling/complexity you accept.  
6. **Place in Clean Architecture circles** (next section) — never let GoF hide Dependency Rule breaks.  
7. **Prefer fewer patterns** that densify meaning (Alexander quote in book closing) over a “pattern zoo”.

---

## 6. Mapping GoF → Clean Architecture circles

| Clean Architecture placement | Typical GoF |
|------------------------------|-------------|
| **Entities** | Strategy/State for pure domain algorithms; Composite for domain trees; rarely Singleton |
| **Use Cases** | Command (request as object), Template Method for fixed app flow, Mediator only if interaction is *application* policy |
| **Interface Adapters** | **Adapter**, Proxy, Decorator (IO cross-cuts), Façade (subsystem for outer), Iterator at API edge |
| **Frameworks & Drivers** | Concrete products of Abstract Factory / Factory Method / Builder / Prototype |
| **Composition Root / Main** | Abstract Factory wiring, Builder orchestration, **not** business rules |
| **Ports (interfaces inward)** | The *abstract* side of Strategy, Factory Method, Observer subjects, etc. |

**Rules of thumb:**

- **Adapter** at the edge ≈ `P-ADP` / `P-GW`. Adapter *inside* domain ≈ `X-DEP-OUT` risk.  
- **Strategy/State** in entities = good OCP; Strategy that imports SQL = wrong circle.  
- **Observer** for in-process domain reactions is fine; replacing SoT with fire-and-forget events = anti-pattern (skill `X-*` async/SoT rules).  
- **Singleton** global access fights testability and multi-tenancy — prefer inject-once at Main.  
- **Façade** must not become multi-actor god module (`X-GOD`).

---

## 7. Pattern & drift findings (GoF layer)

Extend analysis lists with GoF IDs:

```text
path-or-area: severity: [G-ID or X-ID] problem. Fix.
```

### Healthy pattern citations

```text
patterns: [G-AD, G-SY, P-PORT, P-UC]
```

### Extra GoF-oriented violations (use with `X-*` when structural)

| ID | Name | Detection |
|----|------|-----------|
| **X-PATTERN-ZOO** | Pattern zoo | Many GoF names, no problem force; ceremony without variation axis |
| **X-SINGLETON-SOT** | Singleton as SoT | Global mutable process state for business data |
| **X-GOD-FACADE** | God façade | One façade owns many actors/invariants |
| **X-INHERIT-REUSE** | Inheritance for reuse only | Deep hierarchy instead of composition (GoF principle break) |
| **X-CONCRETE-NEW** | (existing) | Policy `new`s concretes — creational pattern missing at root |
| **X-OBSERVER-BUS** | Hidden mega-observer | Implicit global bus; hard to reason ordering/failure |

Severity follows `clean-architecture-patterns.md` guide (critical when SoT/tenant/vendor lock; high when untestable core; etc.).

---

## 8. BASELINE free-text guidance

When a unit’s main story is GoF (not only CA circles), still emit:

```text
BASELINE | <unit> | expected: … | observed: … | fit: … | patterns: [G-…, P-…] | violations: […] | suggestion: …
```

Examples:

```text
BASELINE | billing/pricing | expected: Strategy port on entity/use case; no SQL | observed: switch on plan type in controller | fit: drift | patterns: [G-SY] | violations: [X-LOGIC-IN-UI] | suggestion: Extrair PricingStrategy; inject via composition root
```

```text
BASELINE | infra/stripe | expected: Adapter implementing PaymentPort | observed: Stripe SDK types in domain invoice | fit: drift | patterns: [G-AD] | violations: [X-DEP-OUT, X-VENDOR-DOMAIN] | suggestion: Map Stripe DTO only in adapter; domain PaymentResult plain
```

```text
BASELINE | app/main | expected: Abstract Factory / wiring only | observed: main wires factories | fit: align | patterns: [G-AF, P-CR] | violations: [] | suggestion: Keep use-case construction here; no domain rules
```

---

## 9. Decision options table extension

When recommending structure, add a **GoF mechanism** column when useful:

| Field | Content |
|-------|---------|
| Shape | Components + flow |
| GoF | Which `G-*` (or “none — plain modules”) |
| Pros / Cons | Include pattern **consequences** |
| Dependency Rule | Holds / Partial / Breaks |
| Cost to reverse | … |

Never force a pattern: **no pattern** is valid when variation is not real (YAGNI).

---

## 10. Anti-patterns to challenge (GoF-aware)

- Pattern for its own résumé value (pattern zoo)  
- Singleton as application database  
- Inheritance trees where Strategy/Decorator/composition would isolate change  
- Adapter that pulls vendor types inward past the port  
- Observer/event bus that drops user-visible SoT  
- Façade/Mediator that becomes the new god object  
- Visitor when the object structure changes more often than operations  
- Interpreter for configuration that should be data  
- Framework *is* the architecture (book: frameworks embed patterns; do not invert)

---

## 11. Chapter / book map (for lookup)

| Part | Content |
|------|---------|
| Prefácio / Cap. 1 | What is a pattern; MVC case; catalog intents; organization; how patterns solve design problems; frameworks; selection & usage |
| Cap. 2 | Case study (document editor) — Composite, Strategy, Decorator, … in context |
| Cap. 3 | Creational patterns (Abstract Factory … Singleton) |
| Cap. 4 | Structural (Adapter … Proxy) |
| Cap. 5 | Behavioral (Chain … Visitor) |
| Cap. 6 | What to expect from design patterns; history; closing (density of overlapping patterns) |
| Appendices | Glossary, guide to notation, foundation classes |

---

## 12. How the skill uses this source

1. **Detect** existing GoF roles in code (even if unnamed).  
2. **Name** them with `G-*` for shared vocabulary.  
3. **Place** them on Clean Architecture circles — reject patterns that break Dependency Rule.  
4. **Compare** pattern options in design decisions with consequences, not fashion.  
5. **Suggest** the smallest pattern (or none) that isolates the real axis of change.  
6. **Cite** as: *Design Patterns (Gamma et al.) via repo PDF* when GoF drives the recommendation.  
7. **Language:** explain in conversation language; keep `G-*` / `P-*` / `X-*` IDs stable.

---

## 13. What not to do with the PDF

- Do not dump full C++/Smalltalk sample code into reviews  
- Do not treat the MVC chapter as “the architecture” for every app  
- Do not require all 23 patterns in a codebase  
- Do not confuse **pattern density** (good) with **pattern count** (often bad)
