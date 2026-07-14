# Architecture communication and decision records

Load when producing/reviewing diagrams, architecture documentation, ADRs, context/runtime/deployment views, or system glossaries. Sources: C4 Model, arc42, SEI quality scenarios, and Nygard/Fowler ADR guidance. See `source-bibliography.md`.

## Minimum communication set

Choose only views that answer a decision/review question:

- **Context:** people, system, external systems, trust/ownership boundaries.
- **Container:** deployable/runtime units, stores, responsibilities, protocols.
- **Component:** only when it clarifies an internal boundary under discussion.
- **Dynamic:** important success/failure sequence, concurrency or async flow.
- **Deployment:** nodes/zones/regions, routing, scaling and failure domains.
- **Data:** authority, flow, retention, classification, replication.

Every relationship needs direction and meaning. Every important unit needs responsibility/owner. Include failure paths when operability is material.

## Practice catalog

| ID | Practice | Evidence |
|---|---|---|
| DOC-AUDIENCE | Artifact has audience/question | Scope and purpose stated |
| DOC-LEVEL | One abstraction level per view | C4 level or equivalent is clear |
| DOC-REL | Relationships are labeled | Direction, protocol/data and purpose |
| DOC-RUNTIME | Critical scenarios show runtime behavior | Success plus relevant failure/async path |
| DOC-DEPLOY | Runtime maps to infrastructure/failure domains | Replicas, zones, stores, ingress/egress |
| DOC-TRACE | Documentation links to evidence | Code, contract, dashboard, ADR, owner |
| DOC-GLOSS | Domain/system terms are consistent | Ubiquitous glossary with owners |
| DOC-ADR | One sticky decision per concise record | Context, options, decision, consequences, revisit |
| DOC-SUPERSEDE | Changed decision is linked, not rewritten | Immutable history and superseding ADR |

## Violations

| ID | Violation | Consequence |
|---|---|---|
| XDOC-MIXED | Context, deployment and code mixed in one picture | Ambiguous audience and semantics |
| XDOC-BOXES | Unlabeled boxes/arrows | No responsibility or contract story |
| XDOC-HAPPY | Only success path shown | Failure/partial behavior hidden |
| XDOC-VENDOR | Product architecture described only by products | Domain/ownership disappears |
| XDOC-STALE | Artifact lacks owner/evidence/update trigger | Misleading architecture |
| XDOC-ADR-AFTER | ADR retrofits justification after decision | No real alternatives/trade-off record |
| XDOC-ADR-NOVEL | ADR contains implementation manual/history dump | Decision becomes undiscoverable |
| XDOC-DECISION-MUTATE | Old ADR edited to erase history | Lost rationale and chronology |

## ADR minimum

- Title as decision, status/date/deciders.
- Context, drivers, constraints, evidence and unknowns.
- Considered options with concrete trade-offs and reverse cost.
- One decision and consequences (positive/negative).
- Validation/rollout/rollback and revisit triggers.
- Links to superseded/superseding decisions.

## Baseline

```text
DOCBASELINE | <artifact> | audience/question: <...> | views/level: <...> | ownership/contracts: <evidence> | runtime/failure: <coverage> | currency: <owner/trigger> | fit: clear|conditional|drift | practices: [DOC-…] | violations: [XDOC-…] | next: <smallest clarification>
```
