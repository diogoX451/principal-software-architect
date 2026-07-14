# Production-Ready Microservices — source reference

**Primary source (repo):** `Microsserviços prontos para a produção (Susan J. Fowler, traduzido por Claudio Adas) (z-lib.org).pdf`  
**Author:** Susan J. Fowler  
**Edition:** Portuguese (Novatec) of *Production-Ready Microservices* (O'Reilly, 2017)  
**Use in this skill:** Load for multi-service design, production readiness audits, platform/ecosystem reviews, SRE-adjacent architecture gates, and “should we split this service?” decisions. Pair with `clean-architecture-source.md` (policy boundaries), `design-patterns-source.md` (object structure), and `clean-architecture-patterns.md` (`P-*` / `X-*`).

> **Quality note:** Full book (production standards from Uber-scale practice). Digest is **actionable standards + evaluation questions**, not a rewrite of the narrative. **Services ≠ architecture** — Fowler’s standards assume a service already exists; Clean Architecture still owns *whether* and *where* policy boundaries live.

---

## 1. Core thesis

| Claim | Review implication |
|-------|-------------------|
| **Production-ready** = trust to serve production traffic | Do not ship “works on my laptop” services without availability standards |
| Availability is an **emergent property** of eight standards applied together | One dashboard or one health check is not enough |
| Microservices increase **velocity and instability** | Most outages trace to bad deploys / undetected code errors |
| Standardization without principles is meaningless | Checklists must map to measurable requirements |
| Four-layer **ecosystem** (hardware → communication → app platform → services) | Review the service *and* the layers under it |
| Reverse Conway, tech sprawl, resource competition | Org design is part of the architecture review |

**Definition (book):** a production-ready application/service is one we can **trust** to behave reasonably, perform reliably, do its job with quality, and little downtime.

---

## 2. Four-layer microservice ecosystem (ch. 1)

| Layer | Contains | Architect watch |
|-------|----------|-----------------|
| **1 Hardware** | Servers, OS, isolation/resource abstraction, host config, host metrics/logs | No capacity plan / shared noisy neighbors |
| **2 Communication** | Network, DNS, RPC, endpoints, messaging, discovery, registry, load balancing | Unreliable health, no circuit breakers, wrong routing |
| **3 Application platform** | Self-serve tools, dev env, test/pack/version/release, deploy pipeline, service-level log/metrics | Missing staging/canary; manual release |
| **4 Microservices** | Services + service-specific config | Policy boundaries, deps, clients, SLAs |

**Organizational failure modes (book):** Reverse Conway’s Law, technical dispersion/sprawl, competition for resources, other social failure modes.

---

## 3. Eight production-availability standards (ch. 2)

Together they drive **availability**. IDs: **`MS-*`** (healthy capability present) and **`X-MS-*`** (gap).

| ID | Standard | One-line meaning |
|----|----------|------------------|
| **MS-STABLE** | Stability | Change (dev, deploy, tech introduce, decommission) without ecosystem thrash |
| **MS-RELIABLE** | Reliability | Clients, deps, and ecosystem can trust the service (incl. defensive cache, careful failures) |
| **MS-SCALE** | Scalability | Handle growth (qualitative + quantitative); deps and clients scale with it |
| **MS-PERF** | Performance | Efficient task/request handling under load |
| **MS-FAULT** | Fault tolerance | No SPOF; failure modes identified; automated detection/repair |
| **MS-CHAOS** | Disaster readiness | Resilience testing (load/chaos); incident procedures |
| **MS-MON** | Monitoring | Key metrics, logs, dashboards, actionable alerts, on-call |
| **MS-DOC** | Documentation | Complete, updated docs + org understanding + audits |

Book sometimes lists **eight** names (stability, reliability, scalability, fault tolerance, disaster readiness, performance, monitoring, documentation) — same substance as the five checklist groups in Appendix A (stable+reliable, scalable+perf, fault+disaster, monitored, documented).

---

## 4. Stability & reliability (ch. 3)

### Stability requirements

- Stable **development cycle**
- Stable **deployment process**
- Stable **introduction / deprecation / decommission** procedures

### Reliability requirements

- Reliable deployment (tests + staging + canary success)
- Plan/mitigate/protect against **dependency** failures
- Reliable **routing and discovery**

### Deployment pipeline (canonical)

```text
dev cycle (lint/unit/integration/e2e + review)
  → staging (prod-like)
  → pre-release / canary (~2–5% production)
  → production (prefer gradual, not big-bang)
```

Emergency skip of staging/canary must be **explicit procedure**, not habit.

### Dependencies

- Know **clients** and **dependencies**
- For fragile deps: backups, alternatives, fallbacks, **defensive cache** (e.g. LRU of downstream data)

### Routing & discovery

- Health checks **accurate** (not blind `200 OK` forever)
- Prefer health on a **separate channel** from main traffic
- **Circuit breakers** for unhealthy instances/services and error spikes
- Unhealthy instances must not receive production traffic

### Deprecation / decommission

- Warn clients; migration path; monitor old endpoints before kill
- Often a **social** problem — treat as first-class process

### Evaluation questions (sample)

| Area | Ask |
|------|-----|
| Dev cycle | Central repo? Prod-like dev env? Lint/unit/integration/e2e? Code review? Automated build/release? |
| Pipeline | Staging? Canary long enough? Random prod sample? Same ports as prod? Gradual prod rollouts? Emergency skip procedure? |
| Deps | Listed? Clients known? Fallbacks/cache? |
| Discovery | Reliable health? Separate health channel? Circuit breakers? |
| Sunset | Decommission procedures for service and API endpoints? |

---

## 5. Scalability & performance (ch. 4)

| Theme | Requirement |
|-------|-------------|
| Growth scale | Know **qualitative** (business driver: orders, page views…) and **quantitative** (RPS, etc.) |
| Resources | Efficient use; know CPU/RAM/etc. per instance; bottlenecks; vertical vs horizontal |
| Capacity | Scheduled + preferably **automated** capacity planning |
| Deps scale | Dependencies and their owners prepared for your growth |
| Traffic | Understand patterns; schedule changes off peaks; handle spikes; cross-DC reroute if needed |
| Task handling | Language/runtime limits known; efficient request/task processing under growth |
| Data | Scalable storage; dedicated vs shared DB intentional; R/W profile known; test data strategy |

**Smell:** “We’ll scale later” with unknown growth scale, shared DB as hidden architecture, or deps unaware of upcoming load.

---

## 6. Fault tolerance & disaster readiness (ch. 5)

| Theme | Requirement |
|-------|-------------|
| SPOF | No single points of failure |
| Failure catalog | Common ecosystem, hardware, communication/platform, dependency, internal service scenarios |
| Resilience tests | Code tests + **load** tests + **chaos** tests |
| Detect/repair | Automated detection and repair where possible |
| Incidents | Proper categorization; **five stages** of incident response; team + org procedures |

---

## 7. Monitoring (ch. 6)

| Theme | Requirement |
|-------|-------------|
| Key metrics | Identified at **server**, **infra**, and **microservice** levels; all monitored |
| Logging | Important requests; reconstruct past state; scalable/cost-aware |
| Dashboards | Easy to interpret; all key metrics; health visible at a glance |
| Alerts | On key metrics; warning thresholds **before** outage; **actionable** with runbook steps |
| On-call | Dedicated rotation; ≥2 engineers; org-standardized on-call procedures |

**Actionable alert (glossary):** fired alert includes step-by-step triage, mitigation, resolution for the on-call.

---

## 8. Documentation & understanding (ch. 7)

### Documentation contents (minimum set)

1. Description  
2. Architecture diagram  
3. Contact / on-call info  
4. Important links  
5. Onboarding & development guide  
6. Request flows, endpoints, dependencies  
7. On-call runbook  
8. FAQ  

Docs live in a **central, searchable** place and update with significant changes.

### Understanding (org)

- Devs can answer production-readiness questions about their service  
- Shared production-availability standards  
- RFC for new services  
- Periodic architecture reviews + **production-availability audits**  
- Strategic plans to reach production-ready  
- Standards guide OKRs; automation of checks where possible  

---

## 9. Appendix A — production-availability checklist (condensed)

Use as audit gate. Emit `MS-*` when met, `X-MS-*` when not.

### Stable & reliable when

- Standardized development cycle  
- Thorough lint, unit, integration, e2e tests  
- Fully automated test/package/version/release  
- Standardized deploy pipeline: staging → pre-release → production  
- Clients known  
- Dependencies known with backups/alternatives/fallbacks/cache  
- Stable, reliable routing and discovery  

### Scalable & high-performance when

- Qualitative + quantitative growth scales known  
- Efficient hardware use; bottlenecks/requirements identified  
- Capacity planning automated/scheduled  
- Dependencies scale with the service; service scales with clients  
- Traffic patterns understood; traffic redirectable on failure  
- Language/runtime allows scale/perf; efficient task handling  
- Scalable high-performance data handling/storage  

### Fault-tolerant & disaster-ready when

- No SPOF  
- Failure/disaster scenarios identified  
- Resilience tested (code, load, chaos)  
- Failure detection and repair automated  
- Standardized incident/outage procedures (team + org)  

### Adequately monitored when

- Key metrics at server, infra, and service levels  
- Adequate logging of past states  
- Interpretable dashboards with all key metrics  
- Actionable alerts with threshold signals  
- Dedicated on-call; clear standardized incident procedures  

### Documented & understood when

- Comprehensive, regularly updated documentation (full content set above)  
- Understood at developer, team, and org levels  
- Follows production-availability standards  
- Architecture reviewed/audited frequently  

---

## 10. Catalog IDs for findings

### Healthy capabilities (`MS-*`)

| ID | Meaning |
|----|---------|
| MS-STABLE | Stable change/dev/deploy/decommission practices |
| MS-RELIABLE | Trustworthy to clients/deps (incl. failure mitigation) |
| MS-SCALE | Growth scale known; capacity/deps/traffic ready |
| MS-PERF | Efficient handling under load |
| MS-FAULT | No SPOF; failure modes handled |
| MS-CHAOS | Load/chaos resilience testing + incident process |
| MS-MON | Metrics, logs, dashboards, alerts, on-call |
| MS-DOC | Complete docs + org understanding + audits |
| MS-PIPE | Staging + canary + gradual prod pipeline |
| MS-DEPCACHE | Defensive caching / fallbacks for deps |
| MS-HEALTH | Accurate health + circuit breakers + discovery |
| MS-ONCALL | Dedicated on-call with runbooks |

### Gaps / anti-patterns (`X-MS-*`)

| ID | Name | Detection |
|----|------|-----------|
| X-MS-NO-PIPE | No/unsafe deploy pipeline | Prod push without staging/canary |
| X-MS-BIGBANG | Big-bang production deploy | All instances at once, no gradual |
| X-MS-UNKNOWN-DEP | Unknown deps/clients | No inventory; surprise coupling |
| X-MS-NO-FALLBACK | No dependency mitigation | Cascade on downstream outage |
| X-MS-FAKE-HEALTH | Fake/naïve health | Always-200 `/health`; health shares congested path |
| X-MS-NO-CB | No circuit breaking | Unhealthy instances keep traffic |
| X-MS-SPOF | Single point of failure | One instance/region/db primary without plan |
| X-MS-NO-SCALE-MODEL | Unknown growth scale | Cannot state qualitative/quantitative scale |
| X-MS-SHARED-DB | Shared DB as architecture | Multi-service mutual schema coupling (also `X-SHARED-RECORD`) |
| X-MS-NO-CAPACITY | No capacity planning | Reactive only; surprise resource exhaustion |
| X-MS-NO-LOADTEST | No load/chaos testing | First load test is production |
| X-MS-NO-METRICS | Missing key metrics | Cannot see health on dashboard |
| X-MS-NOISE-ALERT | Non-actionable alerts | Pages without runbook; cry-wolf |
| X-MS-NO-ONCALL | No on-call ownership | Orphans after hours |
| X-MS-DOC-ROT | Missing/stale docs | No diagram/deps/runbook/FAQ |
| X-MS-NO-AUDIT | No readiness audit | Never reviewed against standards |
| X-MS-PREMATURE-SPLIT | Split without boundary | Fashion microservices (also `X-SVC-AS-ARCH`) |
| X-MS-SPRAWL | Tech/org sprawl | Reverse Conway; ungoverned stack diversity blocking operability |

Severity: follow `clean-architecture-patterns.md` guide. Prefer **critical** for SPOF + no fallback on money path, **high** for missing canary/health/circuit on high-traffic services, **medium** for doc/audit gaps, etc.

---

## 11. Mapping to Clean Architecture & GoF

| Fowler concern | CA / skill link |
|----------------|-----------------|
| Service boundary | Must still honor **Dependency Rule** *inside* the service (`P-ENT`/`P-UC`/`P-ADP`) |
| “Services = architecture” | Explicit anti-pattern (`X-SVC-AS-ARCH` / `X-MS-PREMATURE-SPLIT`) |
| Defensive cache / fallbacks | Protect SoT and SLAs; do not invent second SoT without saying so |
| Adapter to other services | Outer circle + ports (`G-AD`, `P-PORT`) |
| Circuit breaker / proxy to unhealthy | Often edge Proxy/Decorator (`G-PX`/`G-DE`) |
| Composition of platform tools | Platform layer ≠ product vocabulary |
| Shared DB | `X-SHARED-RECORD` / `X-MS-SHARED-DB` |

**Rule:** A service can be “production-ready” operationally and still **wrongly carved**. Always check policy ownership + SoT first, then Fowler gates.

---

## 12. BASELINE free-text (microservice units)

```text
BASELINE | <service> | expected: production-ready MS standards + CA placement | observed: … | fit: align|partial|drift | patterns: [MS-…, P-…] | violations: [X-MS-…, X-…] | suggestion: …
```

Examples:

```text
BASELINE | payments-api | expected: MS-PIPE + MS-HEALTH + no SPOF; domain free of Stripe types | observed: direct prod deploy; Stripe types in domain | fit: drift | patterns: [MS-MON] | violations: [X-MS-NO-PIPE, X-DEP-OUT] | suggestion: Add staging+canary; extract PaymentPort adapter
```

```text
BASELINE | inventory | expected: known growth scale; dep fallbacks | observed: RPS model documented; Redis defensive cache on catalog dep | fit: align | patterns: [MS-SCALE, MS-DEPCACHE, MS-PIPE] | violations: [] | suggestion: Schedule chaos test quarterly
```

Optional service-level summary line (conversation language around it):

```text
PRODREADY | <service> | stable+reliable: pass|partial|fail | scale+perf: … | fault+disaster: … | monitored: … | documented: … | blockers: [X-MS-…]
```

---

## 13. Options table extension

When the decision involves services/platform:

| Field | Content |
|-------|---------|
| Shape | Services + platform layers + data/control flow |
| Production-ready | Which `MS-*` already hold; which `X-MS-*` block ship |
| GoF mechanism | if relevant |
| Dependency Rule | Holds / Partial / Breaks |
| Reverse cost | … |

Do not recommend a new microservice without: (1) independent failure boundary, (2) SoT ownership, (3) path to MS-PIPE + MS-MON at minimum for production traffic.

---

## 14. How the skill uses this source

1. **Decide carve-up** with CA/SoT first; refuse fashion splits.  
2. **Audit** existing or proposed services with Appendix A groups → `MS-*` / `X-MS-*`.  
3. **Prioritize** pipeline, health/discovery, deps fallbacks, monitoring before polish docs.  
4. **Cite** as: *Production-Ready Microservices (Fowler) via repo PDF* when standards drive the call.  
5. **Language:** explain in conversation language; keep `MS-*` / `X-MS-*` IDs stable.

---

## 15. Chapter map (lookup)

| Ch | Topic |
|----|--------|
| 1 | Monolith → microservices; architecture; 4-layer ecosystem; org challenges |
| 2 | Production availability; eight standards; implementing standardization |
| 3 | Stability & reliability; dev cycle; deploy pipeline; deps; discovery; decommission |
| 4 | Scalability & performance; growth scales; resources; capacity; traffic; data |
| 5 | Fault tolerance & disasters; SPOF; scenarios; load/chaos; incidents |
| 6 | Monitoring; metrics; logging; dashboards; alerts; on-call |
| 7 | Documentation & understanding; reviews; audits; automation |
| App A | Production-availability checklist |
| App B | Full “evaluate your microservice” question bank |
| Glossary | Platform terms (defensive cache, canary, actionable alert, …) |

---

## 16. What not to do with the PDF

- Do not treat “production-ready checklist” as permission to explode a modular monolith  
- Do not skip CA Dependency Rule because ops metrics are green  
- Do not require Uber-scale chaos tooling on a two-person prototype — scale standards to blast radius, still name gaps  
- Do not copy entire question banks into every reply; sample the relevant sections
