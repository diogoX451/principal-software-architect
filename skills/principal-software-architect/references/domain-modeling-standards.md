# Domain modeling and strategic design standards

Load for boundary decisions, bounded contexts, service/module split, aggregates, domain events, ubiquitous language, context integration, or core-domain investment. Sources: Evans (*Domain-Driven Design*, DDD Reference), Vernon (*Implementing DDD*), Khononov (*Learning DDD*), and Fowler's bounded-context guidance. See `source-bibliography.md`.

## Decision workflow

1. Elicit the domain language from experts, tickets, and code; one term per concept **per context**.
2. Classify each subdomain: **core** (differentiator — invest and model deeply), **supporting** (necessary, not differentiating), **generic** (buy/adopt).
3. Draw bounded contexts around **model consistency**, not entity nouns or org charts; where a term changes meaning, a boundary exists.
4. Name each context relationship: partnership, shared kernel, customer–supplier, conformist, anti-corruption layer, open-host service/published language, or separate ways.
5. Design aggregates as invariant/transaction boundaries: state the invariant, keep the aggregate small, reference other aggregates by ID, one aggregate per transaction; coordinate across aggregates with domain events and eventual consistency.
6. Align module/service boundaries to contexts and contexts to team ownership (links `ENG-OWNER`); carve policy/SoT before any deployable split.

## Practice catalog

| ID | Practice | Evidence |
|---|---|---|
| DOM-LANG | Ubiquitous language per context | Terms align across conversation, code, and tests; glossary has owner |
| DOM-SUB | Subdomain classified with matching investment | Core/supporting/generic named with build/buy rationale |
| DOM-CTX | Bounded context bounds model consistency | Same term with different meanings is documented per context |
| DOM-MAP | Context relationship named and governed | Mapping pattern, contract, and owning teams explicit |
| DOM-AGG | Aggregate protects a real invariant | Invariant stated; ID references; single-transaction rule holds |
| DOM-EVENT | Domain events are domain facts | Past-tense fact in context language, versioned schema (links `DATA-EVENT`) |
| DOM-ACL | Foreign models translated at the boundary | Anti-corruption translation; upstream types do not leak inward |
| DOM-CORE | Core domain gets the depth | Modeling effort and best people follow classification, not fashion |

## Violations

| ID | Violation | Consequence |
|---|---|---|
| XDOM-SHARED-MODEL | One canonical model forced across contexts | Semantic conflicts, coupling, big-ball-of-mud integration |
| XDOM-NOUN-SPLIT | Services/modules split by entity nouns, not invariants | Chatty distributed monolith (links `X-MS-PREMATURE-SPLIT`) |
| XDOM-INVARIANT-ORPHAN | Business invariant has no owning model/aggregate | Rules duplicated in controllers/SQL/UI and silently divergent |
| XDOM-AGG-GOD | Aggregate spans unrelated invariants | Contention, giant transactions, hot rows |
| XDOM-AGG-CROSS-TXN | Cross-aggregate invariant assumed atomic without design | Deadlocks or false consistency under concurrency |
| XDOM-CRUD-CORE | Core differentiator modeled as generic CRUD | Competitive logic buried in integration/UI code |
| XDOM-LANG-DRIFT | Code vocabulary diverges from domain vocabulary | Permanent translation cost; requirements misread as bugs |
| XDOM-MAP-SILENT | Integration exists with no named relationship/ACL | Accidental conformist coupling; upstream model leaks inward |
| XDOM-EVENT-CRUD | "Domain events" are row-change notifications | Consumers couple to internal schema (links `XD-SCHEMA-BANG`) |
| XDOM-CTX-ORG | Context boundary mirrors a transient org chart | Reorg forces remodel; ownership churn |

## Boundary decision proof

- **Language test:** does the term mean the same thing on both sides? If not, split or translate.
- **Invariant test:** which transaction/aggregate protects each named invariant?
- **Change test:** how many contexts/teams does a typical product change touch?
- **Failure test:** can the contexts fail, deploy, and evolve independently (links `MS-*` gates)?

## Baseline

```text
DOMBASELINE | <context/aggregate/decision> | subdomain: core|supporting|generic | language: <glossary/term evidence> | invariants: […] | aggregates: <boundaries + txn rule> | relationships: <context-map patterns> | fit: aligned|conditional|drift | practices: [DOM-…] | violations: [XDOM-…] | next: <smallest boundary improvement>
```

Emit `DOMBASELINE` for boundary decisions, context/aggregate reviews, and service-split proposals. Omit for changes that live entirely inside one healthy context.
