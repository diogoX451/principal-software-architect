# Distributed data and systems standards

Load for databases, replication, partitions, transactions, event streams, consensus, caches, indexes, distributed jobs, or cross-service state. Sources: DDIA (Kleppmann/Riccomini), Dynamo, Spanner, MapReduce, Raft, Dapper, *The Tail at Scale*, and CAP literature. See `source-bibliography.md`.

## Decision workflow

1. Name authoritative state, derived state, owners, and invariants.
2. State the consistency contract per operation: linearizable, serializable, snapshot, causal, read-your-writes, monotonic, or eventual.
3. Map write/read paths, replication, partition key, ordering scope, and failure acknowledgement.
4. Define transaction boundary and what happens under retry, duplicate, reordering, lag, failover, and partition.
5. Set recovery objectives, retention, backfill, schema evolution, and observability.
6. Prefer a system whose native guarantees satisfy the contract; do not emulate stronger semantics casually in application code.

## Practice catalog

| ID | Practice | Evidence |
|---|---|---|
| DATA-SOT | One authoritative owner per invariant | Writes and conflict authority are explicit |
| DATA-CONS | Consistency is operation-specific | Named model plus user-visible consequence |
| DATA-TXN | Transaction boundary protects an invariant | Isolation and retry semantics documented/tested |
| DATA-REPL | Replication contract is explicit | Quorum, lag, failover, read routing, durability |
| DATA-PART | Partitioning follows access/load facts | Key distribution, hotspots, rebalancing considered |
| DATA-EVENT | Event semantics are explicit | Ordering scope, dedupe, replay, schema, retention |
| DATA-DERIVE | Derived views are rebuildable | Provenance, checkpoint, backfill and drift detection |
| DATA-RECOVER | Recovery is designed and exercised | RPO/RTO, backup restore, corruption response |
| DATA-TRACE | Cross-node causality is observable | Correlation/trace context and sampling contract |
| DATA-CONSENSUS | Consensus delegated or fully specified | Safety, liveness, membership and client retry semantics |

## Violation catalog

| ID | Violation | Consequence |
|---|---|---|
| XD-DUAL-SOT | Multiple writers claim authority | Conflicts or silent last-write-wins loss |
| XD-CONS-FOG | “Eventually consistent” without bounded UX semantics | Stale/contradictory user-visible behavior |
| XD-ACK-EARLY | Success acknowledged before durable invariant | Accepted writes can disappear |
| XD-ISO-GAP | Isolation weaker than invariant assumes | Write skew, lost update or dirty decision |
| XD-RETRY-DUP | Retry can repeat a side effect | Double charge/create/process |
| XD-ORDER-GLOBAL | Global ordering assumed without guarantee | Invalid state-machine transitions |
| XD-HOT-PART | Partition key concentrates load | Tail latency, throttling, outage |
| XD-SCHEMA-BANG | Producer/consumer schema changes atomically assumed | Mixed-version failure |
| XD-REPL-MAGIC | Replica count treated as availability proof | Correlated failure or unusable quorum |
| XD-CACHE-SOT | Cache becomes undocumented authority | Freshness and invalidation corruption |
| XD-CAP-SLOGAN | “Pick two” replaces partition scenario analysis | Wrong availability/consistency decision |
| XD-CONSENSUS-HOME | Custom consensus used without proof/tooling need | Safety or liveness failure |

## Required scenarios

- Node/process crash before and after durable write.
- Timeout after side effect but before response.
- Duplicate, delayed, reordered, and poison messages.
- Network partition, clock skew, leader failover, replica lag.
- Hot key/partition, rebalancing, capacity exhaustion.
- Mixed schema/application versions and replay of old events.
- Backup restoration, regional loss, corruption detection.

## Baseline

```text
DATABASELINE | <flow/store> | authority: <SoT/derived> | consistency: <model> | transaction: <boundary/isolation> | replication/partition: <shape> | delivery/order: <guarantees> | recovery: <RPO/RTO> | fit: sound|conditional|drift | practices: [DATA-…] | violations: [XD-…] | next: <smallest proof/improvement>
```

Do not emit `DATABASELINE` for a purely local ephemeral collection. Emit it whenever persistence, replication, asynchronous state, or cross-service ownership affects correctness.
