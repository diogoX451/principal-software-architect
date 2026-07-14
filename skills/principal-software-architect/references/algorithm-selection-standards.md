# Algorithm selection and review standards

Load for algorithm choice, complexity review, data-structure selection, performance-sensitive design, graph/optimization/search problems, probabilistic structures, or basic ML decisions. Use `algorithms-source.md` for chapter rationale.

## Contents

1. [Precedence](#precedence)
2. [Decision workflow](#decision-workflow)
3. [Problem-to-technique map](#problem-to-technique-map)
4. [Practice catalog](#practice-catalog)
5. [Violation catalog](#violation-catalog)
6. [Complexity contract](#complexity-contract)
7. [Validation contract](#validation-contract)
8. [Output contract](#output-contract)

## Precedence

Decide in this order:

1. Correctness, safety, security, exactness/error contract, and termination.
2. Public/architecture contracts and authoritative data semantics.
3. Input/workload facts and resource budgets.
4. Standard-library, database, or platform primitive guarantees.
5. Asymptotic and measured performance.
6. Introductory book defaults and implementation elegance.

Do not replace a working standard primitive with a custom textbook implementation unless the contract, evidence, or learning goal requires it.

## Decision workflow

1. **Name the problem:** lookup, ordering, traversal, shortest path, optimization, approximation, classification, aggregation, or similarity.
2. **Define correctness:** exact vs approximate/probabilistic; tie behavior; stability; determinism; failure for invalid input.
3. **Characterize data:** `n`, graph `V/E`, ordering, density, duplicates, weight signs, update/read ratio, dimensionality, distribution, and adversarial control.
4. **Set budgets:** latency percentile, throughput, memory, preprocessing, storage, network/I/O, and implementation/operational complexity.
5. **List candidates:** include the existing/platform primitive and at least one simpler alternative when the choice is consequential.
6. **Compare guarantees:** best/expected/amortized/worst time, auxiliary space, preconditions, output quality, and degradation mode.
7. **Prove/validate:** invariants, boundaries, properties, oracle comparison, representative benchmark, and observability.
8. **Record revisit trigger:** concrete input size, latency, collision rate, error rate, graph property, or model metric.

## Problem-to-technique map

Starting candidates once the problem contract is named. Verify preconditions (`ALG-PRECOND`) and prefer the platform primitive (`ALG-STDLIB`) before implementing anything custom.

| Problem shape | Default candidates | Precondition / cost note |
|---|---|---|
| Membership / exact lookup | Hash set/map; B-tree index | Hash/equality consistency; O(1) expected vs O(log n) ordered |
| Ordered iteration / range query | Sorted structure / B-tree + binary search | Maintained ordering; O(log n + k) |
| Top-k / streaming extremes | Bounded heap of size k | O(n log k); full sort only when all ranks needed |
| Prefix / lexicographic search | Trie, or sorted array + binary search | Memory overhead vs simplicity |
| Substring search | Stdlib find; KMP/Boyer-Moore for repeated scans | Stdlib is usually already optimized |
| Shortest path, unweighted | BFS | O(V+E); edge count = hop count |
| Shortest path, non-negative weights | Dijkstra + binary heap | No negative edges; O((V+E) log V) |
| Shortest path, negative edges | Bellman-Ford | O(V·E); detects negative cycles |
| Dependency ordering | Topological sort (Kahn/DFS) | Requires DAG; cycle is a modeling error |
| Connectivity / grouping | Union-find; BFS/DFS components | Near-constant amortized per op (union-find) |
| Minimum spanning / clustering skeleton | Kruskal or Prim | Comparable edge weights |
| Interval scheduling / selection | Greedy by earliest end | Greedy-choice property must hold (`XA-GREEDY-OPTIMAL`) |
| Capacity allocation / subset value | DP (knapsack family) | Pseudo-polynomial in capacity; state size budget |
| Sequence similarity / edit distance | DP (LCS / Levenshtein) | O(n·m); row compression for space |
| Nearest neighbor / similarity | Exact KNN small n; ANN index (e.g. HNSW) at scale | Metric validity and feature scaling (`ALG-ML`) |
| Approximate membership at scale | Bloom filter | False positives only; sized error budget (`ALG-EXACT`) |
| Distinct count at scale | HyperLogLog | Probabilistic (~2% typical error); never authoritative |
| Frequent items / heavy hitters | Count-min sketch | Overestimation bound accepted |
| Keyed partitioning / rebalancing | Consistent hashing | Bounded key movement on topology change |
| Side-effect deduplication | Idempotency key + unique constraint | SoT-backed, not memory-only (links `XD-RETRY-DUP`) |

## Practice catalog

`ALG-*` identifies sound algorithm-selection evidence.

| ID | Practice | Evidence |
|---|---|---|
| ALG-PROBLEM | Problem shape is explicit | Input, output, operation mix, and semantic goal are named |
| ALG-PRECOND | Preconditions are enforced | Sortedness, weight sign, hash/equality, graph/model assumptions checked or owned |
| ALG-CORRECT | Correctness argument is stated | Invariant, termination, recurrence, or algorithm guarantee matches contract |
| ALG-COMPLEX | Complexity contract is complete | Relevant time/space cases plus preprocessing/output costs are stated |
| ALG-STRUCT | Data structure matches operations | Access/update/order/memory trade-offs follow measured workload |
| ALG-STDLIB | Vetted primitive is reused | Library/database/platform guarantee satisfies the contract |
| ALG-EXACT | Exactness/approximation is explicit | Error bound, false-positive policy, or heuristic quality is accepted |
| ALG-GRAPH | Graph semantics are explicit | Directedness, weights, cycles, connectivity, representation, and path meaning |
| ALG-DP | DP state and recurrence are valid | State, base cases, transitions, order, reconstruction, and space are defined |
| ALG-HASH | Hash behavior is controlled | Equality, load, capacity, collisions, key mutability, and adversarial risk considered |
| ALG-ML | Data/metric assumptions are validated | Feature scaling, leakage, evaluation split, metric, latency, and drift considered |
| ALG-MEASURE | Benchmark represents production | Warm-up, distribution, scale, percentile, environment, and baseline recorded |
| ALG-OBSERVE | Assumptions are observable | Revisit threshold has metrics or logs |

## Violation catalog

`XA-*` identifies algorithmic selection or implementation drift.

| ID | Violation | Report when |
|---|---|---|
| XA-PROBLEM-MISMATCH | Algorithm solves a different problem | Example: BFS used for weighted cost or substring recurrence used for subsequence |
| XA-PRECOND | Required precondition absent/false | Unsorted binary search, negative-weight Dijkstra, inconsistent hash/equality |
| XA-COMPLEX-CLAIM | Complexity claim is incomplete or false | Case, representation, preprocessing, output, or memory materially changes it |
| XA-EXPECTED-AS-GUARANTEE | Expected/amortized cost presented as worst-case guarantee | Tail/adversarial behavior matters to the contract |
| XA-PREMATURE | Optimization lacks workload evidence | Simpler correct path meets known budgets and complexity is added speculatively |
| XA-CUSTOM-PRIMITIVE | Hand-rolled primitive replaces vetted implementation | No semantic/performance need justifies correctness/security risk |
| XA-STRUCT-MISMATCH | Data structure conflicts with dominant operation | Demonstrated access/update/memory costs violate the workload budget |
| XA-RECURSE-UNBOUND | Recursion depth or progress is uncontrolled | Input can exhaust stack or base/progress condition is incomplete |
| XA-SORT-WRONG | Sort properties do not meet contract | Stability, comparator, worst case, memory, or external-data needs are violated |
| XA-HASH-DEGRADE | Hash assumptions are uncontrolled | Load, collision, mutable keys, memory, or adversarial input can break budget/correctness |
| XA-CACHE-SEMANTIC | Hash/cache treated as authoritative truth | Freshness, invalidation, eviction, concurrency, or SoT relationship is missing |
| XA-GRAPH-VISIT | Traversal lacks correct visited/relaxation policy | Cycles, repeated work, or incorrect paths result |
| XA-DIJKSTRA-NEG | Dijkstra accepts negative weights | Correctness is invalid even if examples pass |
| XA-GREEDY-OPTIMAL | Greedy/heuristic result claimed optimal without proof | Problem lacks demonstrated greedy-choice property |
| XA-APPROX-HIDDEN | Approximate/probabilistic output presented as exact | False positives/error bounds can affect user-visible truth |
| XA-DP-STATE | DP state/recurrence is insufficient or explosive | It loses required history, has invalid dependencies, or exceeds budget |
| XA-KNN-DATA | KNN distance/data pipeline is invalid | Unscaled features, leakage, poor metric, high dimension, or prediction cost undermines result |
| XA-BENCH-BIAS | Benchmark cannot support the decision | Toy/unrepresentative input, average-only result, no baseline, or environment noise |
| XA-NO-FALLBACK | Degradation/failure has no bounded response | Time/memory/error budget can be exceeded without timeout, fallback, or rejection |
| XA-CRYPTO-HOMEMADE | Introductory crypto primitive used as a protocol | Custom password/key/security construction replaces vetted libraries/protocols |

## Complexity contract

For a material algorithmic path, record:

| Field | Required content |
|---|---|
| Input variables | Meaning of `n`, `V`, `E`, dimensions, capacity, output size |
| Time | Relevant worst, expected/amortized, and tail case; state which applies |
| Space | Auxiliary and retained/index/cache memory |
| Preconditions | Ordering, sign, uniqueness, consistency, distribution, mutability |
| Exactness | Exact, approximation ratio, probability/error bound, ML metric |
| Degradation | Pathological input and observed failure mode |
| Alternative | Existing primitive or simpler candidate rejected with reason |

Do not reduce I/O-, network-, database-, GPU-, or distributed algorithms to CPU Big O alone.

## Validation contract

- Use example tests for readability and boundary/property tests for general correctness.
- Compare optimized implementations against a simple oracle on generated small inputs when feasible.
- Test empty, singleton, duplicate, already ordered, reverse ordered, disconnected, cyclic, unreachable, overflow, invalid-weight, and capacity boundaries as applicable.
- Test approximate/probabilistic structures statistically against their declared error contract.
- Benchmark after correctness, using representative distributions and percentiles; include memory and preprocessing.
- For concurrency/distribution, include cancellation, retry, duplication, partition skew, and partial failure.
- For cryptography or ML, require specialist validation before high-stakes use.

## Output contract

For each material algorithmic path, emit:

```text
ALGBASELINE | <unit> | problem: <shape> | data: <scale/properties> | choice: <algorithm + structure> | complexity: <time; space> | preconditions: <...> | exactness: exact|approximate|probabilistic | fit: sound|conditional|drift | practices: [ALG-…] | violations: [XA-…] | next: <smallest verification/improvement>
```

Finding format:

```text
<path:line>: <severity>: [XA-ID] <broken assumption and consequence>. <smallest fix or validation>. confidence: high|medium
```

Use severity by consequence: critical for security/data/safety corruption; high for incorrect results or realistic resource exhaustion; medium for evidenced scalability/maintainability debt; low for a local documented risk. A heuristic without workload evidence becomes an open question, not a defect.
