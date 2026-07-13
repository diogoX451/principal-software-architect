# Architecture review checklist

Use for PRs, modules, or whole systems. Skip sections that do not apply; do not invent issues to fill the list.

## A. Boundaries & ownership

- [ ] Each module/service has a clear owner of **one** primary invariant
- [ ] No circular dependencies between bounded contexts
- [ ] Public API surface is intentional (not "export everything")
- [ ] Domain language is not vendor-named

## B. Data & source of truth

- [ ] User-visible state has a single SoT
- [ ] Async paths cannot lose SoT (ack only after durable write, or explicit compensation)
- [ ] Multi-tenant keys are consistent (slug vs UUID resolved at the edge)
- [ ] Migrations/backfills are safe (expand → migrate → contract)

## C. Control flow

- [ ] Sync path is bounded (timeouts independent per step)
- [ ] Async path has idempotency / dedupe story
- [ ] Partial failure modes are named (not "hope")
- [ ] No head-of-line blocking on lifecycle/reconnect paths for multi-subject workers

## D. Extensibility

- [ ] New capability lands on the **lowest** correct layer
- [ ] Drivers/adapters are swappable without renaming product concepts
- [ ] Feature flags / dual-read exist for breaking contract changes
- [ ] No second framework introduced for a one-off feature

## E. Operability

- [ ] Health/ready semantics match real dependencies
- [ ] Metrics/logs can answer "is it broken?" without SSH folklore
- [ ] Deploy/rollback path is documented or obvious
- [ ] Cost drivers (LLM tokens, egress, storage) are metered if billed

## F. Security & trust

- [ ] Trust boundaries enforced in code (not only docs)
- [ ] Secrets never in events/logs
- [ ] AuthZ is tenant-scoped by default
- [ ] Dangerous operations are explicit and reversible where possible

## Severity guide

| Severity | Meaning |
|----------|---------|
| critical | Can corrupt data, cross tenants, or lose money/safety |
| high | Will fail under realistic load or blocks growth |
| medium | Friction, debt that compounds this quarter |
| low | Clarity / maintainability |
