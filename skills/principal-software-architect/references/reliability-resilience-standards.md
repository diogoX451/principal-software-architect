# Reliability, resilience, and operability standards

Load for production services, dependencies, SLOs, rollout, capacity, incidents, or failure handling. Sources: Google SRE books, *Building Secure and Reliable Systems*, *Release It!*, and Amazon Builders’ Library. See `source-bibliography.md`.

## Service contract

1. Define user journey and SLI before declaring an SLO.
2. Set target/window and error-budget policy tied to release decisions.
3. Map dependencies, time budgets, retry ownership, resource limits, and degradation.
4. Design deploy, rollback, capacity, observability, incident ownership, and recovery.
5. Exercise failure; do not infer resilience from redundancy diagrams.

## Practice catalog

| ID | Practice | Evidence |
|---|---|---|
| REL-SLI | User-centered indicator | Good/valid event definition and collection path |
| REL-SLO | Target/window/error policy | Measurable and connected to action |
| REL-BUDGET | Error budget governs risk | Release/feature/reliability trade-off rule |
| REL-TIMEOUT | End-to-end deadline is partitioned | Connect/read/request timeouts and cancellation |
| REL-RETRY | Retry is bounded, selective, idempotent | Backoff, jitter, budget, one retry layer |
| REL-OVERLOAD | Overload is controlled | Admission, queues, shedding, backpressure, fairness |
| REL-ISOLATE | Failure domains are isolated | Bulkheads/shards/tenant blast radius |
| REL-DEGRADE | Essential service survives dependency loss | Explicit fallback with correctness limits |
| REL-ROLL | Changes are progressively delivered | Staging/canary/flag/rollback and compatibility |
| REL-OBS | Signals answer impact, cause, saturation | Metrics/logs/traces linked by context |
| REL-INCIDENT | Incident lifecycle is owned | On-call, playbook, comms, postmortem/actions |
| REL-CAP | Capacity is forecast and tested | Demand, limits, headroom and scale lag |

## Violations

| ID | Violation | Consequence |
|---|---|---|
| XR-UPTIME | Component uptime substituted for user reliability | Green dashboard, broken journey |
| XR-SLO-NOACT | SLO has no decision policy | Decorative objective |
| XR-RETRY-STORM | Layered/unbounded synchronized retries | Failure amplification |
| XR-TIMEOUT-VOID | Remote wait has no bounded deadline/cancellation | Resource exhaustion |
| XR-HEALTH-FAKE | Health check ignores ability to serve | Bad instances receive traffic |
| XR-QUEUE-INFINITE | Queue hides overload without bound | Latency/memory collapse |
| XR-FALLBACK-LIE | Fallback violates correctness silently | Stale/unsafe user result |
| XR-CORRELATED | Replicas share same failure trigger | Redundancy collapses together |
| XR-BIGBANG | Irreversible full rollout | Large blast radius and slow recovery |
| XR-ALERT-NOACT | Alert has no urgent human action | Fatigue and missed incidents |
| XR-RPO-RTO-HOPE | Recovery target untested | Backup exists but restore fails |

## Remote-call minimum

- Propagate deadline/cancellation.
- Retry only transient failures, at one owned layer.
- Require idempotency token/semantic equivalence for side effects.
- Use capped exponential backoff with jitter and a retry budget.
- Bound concurrency/queue; shed load before collapse.
- Record attempt count, terminal cause, latency and dependency saturation.

## Baseline

```text
RELBASELINE | <journey/service> | SLI/SLO: <indicator; target/window> | dependencies: […] | timeout/retry: <policy> | overload/degrade: <policy> | rollout/recovery: <policy; RPO/RTO> | observe/own: <signals; owner> | fit: ready|conditional|drift | practices: [REL-…] | violations: [XR-…] | next: <smallest failure proof>
```
