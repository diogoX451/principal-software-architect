# Quality attributes and architecture evaluation

Load for architecture options, ATAM-style reviews, non-functional requirements, or disputed claims such as “scalable,” “secure,” “maintainable,” and “highly available.” Sources: *Software Architecture in Practice*, SEI ATAM/QAW, and arc42 quality model. See `source-bibliography.md`.

## Quality scenario contract

Turn each important quality claim into:

```text
QUALITY | <attribute> | source: <actor/system> | stimulus: <event> | environment: <normal/degraded/etc> | artifact: <affected part> | response: <behavior> | measure: <number/threshold> | priority: high|medium|low
```

Examples of measures: p99 latency, recovery time, lost operations, deployment frequency, time to add a variant, maximum affected tenants, audit completeness, accessibility task success.

## Evaluation workflow

1. Elicit business drivers, stakeholders, constraints, and top 3–5 quality goals.
2. Build and prioritize concrete quality scenarios.
3. Map architectural approaches/tactics to each scenario.
4. Identify risks, non-risks, sensitivity points, and trade-off points.
5. Compare at least two options; state evidence, unknowns, and validation experiment.
6. Record sticky decisions and attach revisit triggers/fitness functions.

## Practice catalog

| ID | Practice | Evidence |
|---|---|---|
| QA-SCENARIO | Quality expressed as measurable scenario | Complete source/stimulus/environment/response/measure |
| QA-PRIORITY | Stakeholders rank competing qualities | Explicit utility/priority, not “everything critical” |
| QA-TACTIC | Decision maps to a quality tactic | Mechanism and expected effect explained |
| QA-RISK | Risks and non-risks are separated | Evidence and uncertainty visible |
| QA-SENS | Sensitivity point identified | Parameter/decision strongly affects a quality |
| QA-TRADE | Trade-off point identified | Decision improves one quality while harming another |
| QA-FITNESS | Quality is continuously checked | Test/metric/policy with threshold and owner |

## Violations

| ID | Violation | Consequence |
|---|---|---|
| XQ-ADJECTIVE | Quality stated only as adjective | Cannot design, test, or arbitrate it |
| XQ-ALL-P1 | Every quality is highest priority | Trade-offs remain hidden |
| XQ-TACTIC-CARGO | Pattern chosen without scenario | Architecture by fashion |
| XQ-METRIC-PROXY | Easy proxy replaces user/business outcome | Local optimization with false confidence |
| XQ-NO-ENV | Degraded/peak/failure environment omitted | Happy-path architecture only |
| XQ-TRADE-HIDDEN | Cost to another quality is omitted | Decision appears universally good |
| XQ-FITNESS-THEATER | Check exists without threshold/owner/action | Drift is observed but not controlled |

## Evaluation output

```text
QUALITYBASELINE | <scope> | drivers: […] | scenarios: […] | sensitivities: […] | tradeoffs: […] | risks: […] | evidence: <tests/metrics/experiment> | fit: sound|conditional|drift | practices: [QA-…] | violations: [XQ-…] | next: <smallest de-risking experiment>
```

Use a lightweight pass for ordinary changes. Reserve a full stakeholder ATAM workshop for high-cost, cross-organization, safety/security-critical, or difficult-to-reverse decisions.
