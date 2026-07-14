# Clean Architecture — source reference

**Primary source (repo):** `Arquitetura Limpa PDF (Cópia limitada).pdf`  
**Author:** Robert C. Martin ("Uncle Bob")  
**Form:** Portuguese Bookey-style summary of *Clean Architecture: A Craftsman's Guide to Software Structure and Design*  
**Use in this skill:** Load when justifying Dependency Rule, SOLID, boundaries, screaming architecture, "details" (DB/Web/frameworks), or package organization. Pair with `clean-architecture-patterns.md` for `P-*` / `X-*` IDs.

> **Quality note:** The PDF is a *summary*, not the full book. Some TOC lines are broken translations. Prefer principles below over marketing fluff or "life lessons" sections in the PDF. When in doubt, code evidence wins over the summary.

---

## Core thesis (ch. 1–2)

| Claim | Review implication |
|-------|--------------------|
| Design and architecture are a **continuum** (house plan ↔ switch placement) | Judge structure *and* detail; boxes alone are incomplete |
| Goal = **minimize human effort** over the life of the system | Flag rising change-cost, productivity collapse with more headcount |
| Two values: **behavior** + **structure** | Behavior-only is incomplete; perfect-but-unchangeable is obsolete |
| Structure often outranks pure features long-term | Soft, imperfect code that can change beats frozen "correct" code |
| Eisenhower: architecture is **important, often not urgent** | Challenge urgency that permanently damages structure |
| "The only way to go fast is to go well" | Refuse "fix later" as permanent strategy |
| Do not rewrite "from zero" as default | Prefer continuous principle application + strangler |

---

## Paradigms subtract (ch. 3–6)

Each paradigm **removes** capabilities to create discipline:

| Paradigm | Discipline | Arch takeaway |
|----------|------------|---------------|
| Structured | No unrestricted goto; sequence / selection / iteration | Decompose into falsifiable units; testability |
| OO | Safe polymorphism → **dependency inversion** | High-level policy defines ports; low-level plugins implement |
| Functional | Immutability; segregate mutable parts | Event sourcing / append-only as mutability strategy |

**Review signal:** Prefer clear constraints over "more power."

---

## SOLID (ch. 7–11) — class / module

| ID | Principle | One-line meaning | Smell |
|----|-----------|------------------|-------|
| SRP | Single Responsibility | One **reason to change** = one **actor** | Multi-stakeholder class; merge conflicts from unrelated teams |
| OCP | Open–Closed | Extend without rewriting protected policy | Core rewrites for peripheral features; type switches that grow forever |
| LSP | Liskov Substitution | Implementations must honor the contract | Special-case branches per "almost" subtype; wire-format variance in clients |
| ISP | Interface Segregation | Clients must not depend on unused surface | Fat ops interfaces; forced unused deps |
| DIP | Dependency Inversion | Depend on **stable abstractions**, not volatile concretes | Domain → ORM/HTTP/SDK; `new Concrete()` in policy |

**Composition root:** Concretes are wired in **Main** (outer dirty plugin), not inside use cases.

---

## Components (ch. 12–14)

### Cohesion

| Principle | Rule |
|-----------|------|
| **REP** Reuse/Release Equivalence | Reuse grain = release grain |
| **CCP** Common Closure | Same reason to change → same component |
| **CRP** Common Reuse | Do not force clients to drag unused code |

REP+CCP enlarge; CRP shrinks — balance by **real change rates**.

### Coupling

| Principle | Rule |
|-----------|------|
| **ADP** Acyclic Dependencies | Graph is a DAG |
| **SDP** Stable Dependencies | Depend toward stability |
| **SAP** Stable Abstractions | Stability ↔ abstractness (Main Sequence) |

Optional metrics: Fan-in/out; Instability `I = Fan-out / (Fan-in + Fan-out)`.

---

## Architecture goals (ch. 15–16)

A good architecture:

1. Makes **use cases visible** (screaming)
2. Keeps **options open** (defer DB/framework/UI)
3. Supports independent **development** (Conway-aware slices)
4. Supports easy **deployment**
5. Supports required **operation** (throughput models without rewrite)
6. Allows oscillation mono ↔ distributed when needed

**Duplication warning:** Do not unify "similar" components if they will diverge by actor/reason.

---

## Boundaries (ch. 17–18, 24–25)

| Boundary strength | Form | Cost / note |
|-------------------|------|-------------|
| Softest | Monolith internal modules + polymorphism | Fast calls; still need Dependency Rule |
| Medium | Deployable libraries (jar/dll) | Independent deploy unit |
| Stronger | Local processes | Serialization cost |
| Strongest | Network services | Latency; **not** architecture by itself |

**Partial boundaries (ch. 24):** Prepare ports/packages, same deploy unit — YAGNI-aware placeholder. Re-assert before they erode (FitNesse-style degradation risk).

**Policy & level (ch. 19):** Group by **rate/reason of change**; lower levels plugin into higher; DIP + stable abstractions.

---

## Business rules (ch. 20)

| Kind | Definition | Placement |
|------|------------|-----------|
| Critical business rules | Make/save money even without a computer | Entities |
| Critical business data | Data those rules need | Entities (not ORM as truth) |
| Application rules | How *this* system automates the process | Use Cases / Interactors |
| Request/Response models | Boundary data | Independent of Entity **and** web/ORM |

---

## Screaming architecture (ch. 21)

Top-level structure screams **domain use cases** (billing, clinical, cart), not Spring/Rails/Next.  
Frameworks are tools, not the architecture.

---

## Clean Architecture circles (ch. 22) — Dependency Rule

```text
Frameworks & Drivers          (outermost — mechanisms)
  Interface Adapters          Controllers, Presenters, Gateways
    Application Business Rules   Use Cases / Interactors
      Enterprise Business Rules  Entities (innermost — policy)
```

**Dependency Rule (non-negotiable):** source dependencies point **inward** only.  
Inner circles never know outer names, types, or frameworks.

**Typical web flow:**  
UI → Controller → Use Case → Entity → (back) Presenter → View Model → View  
Always with inward source dependencies (ports owned by inner circles).

Goals: independent of frameworks / UI / DB; highly testable; defer tech decisions; extend without rewriting stable policy.

---

## Humble Object (ch. 23)

At every boundary, split:

| Hard to test (humble) | Testable |
|-----------------------|----------|
| View / GUI | Presenter + ViewModel |
| Raw SQL / driver | Gateway interface + pure mappers |
| Socket / vendor SDK | Service listener / adapter |
| ORM | Data mapper at edge only |

---

## Main component (ch. 26)

**Main** is the outermost dirty plugin: configs, env, concrete wiring, then hands control to policy.  
No business rules in Main.

---

## Services are not architecture (ch. 27)

- Microservices ≠ architecture by themselves  
- Architecture = **policy boundaries** + Dependency Rule *inside* and *across* services  
- Shared DB records between services = coupling smell (`X-SHARED-RECORD`)

---

## Test boundary (ch. 28)

Tests sit in the **outermost** circle: depend inward only; nothing production depends on tests.  
Prefer a **test API**; avoid fragile GUI/structure coupling (`X-TEST-FRAGILE`).

---

## Details (ch. 29–32)

| Topic | Rule |
|-------|------|
| Embedded (ch. 29) | Software free of hardware details via HAL-style ports |
| Database (ch. 30) | DB is a detail; data model ≠ table shape as architecture |
| Web (ch. 31) | Web is a delivery mechanism, not the system |
| Frameworks (ch. 32) | Asymmetric marriage — keep frameworks at the edge via adapters; never derive domain from framework base classes |

---

## Package organization (ch. 34 — Simon Brown "Missing Chapter")

Progression (prefer domain-aligned over pure technical layers):

1. **Package by layer** — web / business / persistence (starts simple; hides domain at scale)
2. **Package by feature** — vertical domain slices
3. **Ports & adapters / hexagonal** — domain inside; tech outside; deps inward
4. **Package by component** — related policy + its persistence boundary together (step toward services)

Enforce encapsulation (compiler / package visibility). Public-everything → big ball of mud.

---

## Chapter map (PDF TOC — for lookup)

| Ch | Topic |
|----|--------|
| 1 | What is design & architecture |
| 2 | A tale of two values (behavior + structure) |
| 3–6 | Paradigms: overview, structured, OO, functional |
| 7–11 | SOLID |
| 12–14 | Components, cohesion, coupling |
| 15–16 | What is architecture; independence |
| 17–18 | Boundaries: drawing lines; anatomy |
| 19–20 | Policy & level; business rules |
| 21–22 | Screaming architecture; Clean Architecture |
| 23–25 | Presenters & Humble Object; partial boundaries; layers |
| 26–28 | Main; services; test boundary |
| 29–32 | Embedded; DB/Web/frameworks as details |
| 33 | Case study (video sales) |
| 34 | Missing chapter (packaging strategies) |
| 35 | Architecture archaeology (appendix) |

---

## How the skill uses this source

1. **Map** code to circles + package style (ch. 22, 34).  
2. **Emit** `BASELINE` lines via catalog in `clean-architecture-patterns.md`.  
3. **Challenge** with book-backed anti-patterns: Dependency Rule breaks, framework-screaming, services-as-architecture, logic in UI/DB, entity leakage, fragile tests.  
4. **Suggest** strangler slices and partial boundaries — never "rewrite everything Clean Architecture."  
5. **Cite** as: *Clean Architecture (Martin) via repo PDF summary* when principles drive a recommendation.

---

## What to ignore in the PDF

- Bookey ads, QR codes, "test free" banners  
- Generic self-help "critical thinking" paragraphs that do not change technical decisions  
- Broken auto-translated TOC lines (use the chapter map above)
