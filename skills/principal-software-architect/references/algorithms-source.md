# Grokking Algorithms — source digest

**Primary source:** `Entendendo Algoritmos Um guia ilustrado para programadores e outros curiosos (Aditya Y. Bhargava).pdf` at the repository root  
**Book:** *Grokking Algorithms*, Aditya Y. Bhargava  
**Repository edition:** Portuguese, image-only PDF, 322 pages  
**Use:** Consult for algorithm vocabulary, problem-shape recognition, complexity trade-offs, and the source's 11-chapter map. Use `algorithm-selection-standards.md` for executable decision rules.

This digest preserves the book's teaching path while adding production interpretation. The book is introductory: validate its simplified cost models against the target workload, language runtime, data distribution, and correctness contract.

## Contents

1. [Core method](#core-method)
2. [Chapter map](#chapter-map)
3. [Decision table](#decision-table)
4. [Production interpretation](#production-interpretation)
5. [Limits](#limits)

## Core method

- Model the problem before choosing an algorithm: ordered search, lookup, ranking, graph traversal, optimization, classification, or approximation.
- Compare growth rates as input grows; do not optimize from a tiny example alone.
- Select a data structure together with the algorithm because access, insertion, deletion, memory, and ordering costs interact.
- State base cases, invariants, termination, and the assumptions that make the result correct.
- Prefer the simplest algorithm that satisfies measured scale and correctness constraints; revisit when input shape changes.

## Chapter map

### 1. Introduction to algorithms

- Binary search repeatedly halves an ordered search space: `O(log n)` comparisons, versus `O(n)` linear search.
- Binary search requires ordered/indexable data and correct interval boundaries.
- Big O describes growth, not elapsed seconds or an exact instruction count.
- Common classes introduced: `O(1)`, `O(log n)`, `O(n)`, `O(n log n)`, `O(n²)`, `O(n!)`.
- The book emphasizes worst-case reasoning; production analysis should state upper, expected/amortized, and relevant tail behavior separately.

### 2. Selection sort

- Arrays provide direct indexed access but costly middle insertion/deletion; linked lists invert several trade-offs.
- Selection sort repeatedly finds the smallest remaining item: `O(n²)` time.
- Its teaching value is the data-structure/cost connection. It is rarely the default general-purpose production sort.
- Account for cache locality, allocation overhead, built-in library guarantees, and actual operation mix—not asymptotics alone.

### 3. Recursion

- Every recursive algorithm needs a base case and progress toward it.
- The call stack stores suspended work; deep or branching recursion consumes memory and can overflow.
- Recursion can make recursive structure clear, but iteration or an explicit stack may be safer when depth is unbounded.
- Distinguish a recursive formulation from its complexity: recursion does not inherently make an algorithm faster.

### 4. Quicksort and divide-and-conquer

- Divide-and-conquer identifies a base case, decomposes the input, solves subproblems, and combines results.
- Quicksort partitions around a pivot; expected performance is commonly `O(n log n)`, worst case `O(n²)`.
- Pivot strategy, duplicate keys, recursion depth, stability needs, and memory model affect real suitability.
- Merge sort offers deterministic `O(n log n)` time with different space, stability, and locality trade-offs.
- Constant factors matter only after growth class and constraints are understood.

### 5. Hash tables

- Hash tables map keys to buckets and support lookup, insertion, deduplication, and caching.
- Expected `O(1)` operations depend on hash quality, collision strategy, capacity, and load factor; worst case can degrade.
- Equality and hashing must agree. Mutable keys, adversarial input, memory amplification, and iteration-order assumptions are risks.
- A cache additionally requires freshness, invalidation, capacity/eviction, and concurrency policy.

### 6. Breadth-first search

- Graphs model entities and relationships through vertices and edges.
- BFS uses a FIFO queue and finds minimum-edge paths in unweighted graphs.
- Mark visited vertices to avoid cycles/repeated work; complexity is `O(V + E)` with adjacency lists.
- Direction, reachability, disconnected components, path reconstruction, and graph representation are part of correctness.
- Weighted shortest paths require a different algorithm.

### 7. Dijkstra's algorithm

- Dijkstra repeatedly settles the lowest known tentative distance and relaxes outgoing edges.
- It requires non-negative edge weights. Negative edges invalidate its greedy correctness argument.
- Use a priority queue for scalable implementations; complexity depends on representation and queue operations.
- Detect overflow, unreachable targets, stale queue entries, and ambiguous tie behavior.
- For negative weights, consider Bellman–Ford or a domain-specific reformulation; for negative cycles, define failure semantics.

### 8. Greedy algorithms and NP-complete problems

- Greedy algorithms choose the best local option and can be optimal only when the problem has the required structure.
- For set cover, a greedy choice provides an approximation rather than an exact optimum.
- NP-complete problems such as traveling salesperson can make exact exhaustive search infeasible at scale.
- State whether the answer must be exact, bounded-approximate, heuristic, or best-effort, and expose the quality/time budget.
- Do not infer optimality from plausible local choices.

### 9. Dynamic programming

- Dynamic programming reuses overlapping subproblems with optimal substructure.
- Define state meaning, recurrence, base cases, traversal order, and reconstruction—not just a table.
- Knapsack illustrates discrete choices; fractional variants have different structure and may suit greedy methods.
- Longest common substring and longest common subsequence use different recurrences and answer different questions.
- Time and memory follow the state-space size; rolling arrays or sparse memoization may reduce memory when dependencies permit.

### 10. K-nearest neighbors

- KNN classifies or regresses from nearby labeled examples under a chosen distance metric.
- Feature selection, scaling/normalization, missing values, categorical encoding, `k`, weighting, and tie rules determine behavior.
- Evaluate on held-out data with domain-appropriate metrics; examples such as recommendations, OCR, spam, and forecasting require different loss/error analysis.
- High-dimensional distance can lose meaning; prediction cost and storage grow with the training set unless indexed/approximated.
- Treat KNN as a baseline, not proof that a production ML system is safe or accurate.

### 11. Next steps

- **Trees:** ordered search/index structures; balance and workload determine guarantees.
- **Inverted indexes:** map terms to documents for retrieval; tokenization, ranking, updates, and storage remain design concerns.
- **Fourier transform:** move between time/spatial and frequency representations for signals and compression.
- **Parallel algorithms:** speedup is bounded by sequential work, communication, synchronization, partition skew, and overhead.
- **MapReduce:** distribute map and reduce stages; useful for batch aggregation, not every low-latency workflow.
- **Bloom filters:** space-efficient probabilistic membership with false positives but no false negatives under standard operation; parameterize capacity/error rate.
- **HyperLogLog:** probabilistic cardinality estimate with explicit error/memory trade-off.
- **SHA:** cryptographic digest for integrity/identification; plain fast hashes are not password storage.
- **Locality-sensitive hashing:** approximate similarity search; it serves a different goal than cryptographic hashing.
- **Diffie–Hellman:** key agreement primitive requiring authenticated protocols and vetted libraries.
- **Linear programming:** optimize a linear objective under linear constraints; model validity and solver behavior matter.

## Decision table

| Problem shape | Candidate | Preconditions | Key risk |
|---|---|---|---|
| Find in ordered indexable data | Binary search | Total ordering; stable search range | Off-by-one, unsorted input |
| General in-memory sort | Standard-library sort | Comparator contract | Wrong stability/memory assumption |
| Repeated key lookup/dedup | Hash table/set | Stable hash/equality; memory budget | Collision/load/adversarial input |
| Unweighted shortest path | BFS | Unit/unweighted edges | Using it for weighted cost |
| Non-negative weighted shortest path | Dijkstra | No negative weights | Invalid result with negative edge |
| Exact overlapping-subproblem optimization | Dynamic programming | Valid state/recurrence | State explosion |
| Locally optimal construction | Greedy | Proven greedy-choice property, or approximation accepted | False optimality claim |
| Similarity classification/regression | KNN | Meaningful scaled distance; labeled examples | Dimensionality, leakage, latency |
| Approximate membership/cardinality | Bloom/HLL | Explicit error tolerance | Treating estimates as exact truth |

## Production interpretation

1. Define the semantic contract and acceptable error first.
2. Characterize input size, distribution, ordering, density, update/read ratio, and adversarial exposure.
3. State time and space complexity for relevant cases, including preprocessing and output costs.
4. Compare with standard-library/database/platform primitives before custom implementation.
5. Validate correctness with examples, boundary/property tests, and an oracle where possible.
6. Benchmark representative workloads only after asymptotic fit is sound.
7. Instrument production assumptions and identify a revisit threshold.

## Limits

- This is an introductory book, not a complete algorithms reference or proof text.
- Big O suppresses constants and machine effects; it also does not by itself describe latency distribution, I/O, memory locality, parallelism, or network cost.
- Examples use simplified data and Python-like code. Use idiomatic, vetted implementations in the target ecosystem.
- Cryptography and production ML require specialist standards beyond the chapter introductions.
- Never treat approximate/probabilistic output as exact, or expected complexity as a worst-case guarantee.
