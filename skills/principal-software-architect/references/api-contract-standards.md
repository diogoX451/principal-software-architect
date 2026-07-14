# API and contract standards

Load for public/internal API design, event contracts, versioning, breaking changes, pagination, error formats, webhooks, or deprecation. Sources: Zalando RESTful API Guidelines, Google AIP, RFC 9457, OpenAPI/AsyncAPI, and Hyrum's Law. See `source-bibliography.md`.

## Contract workflow

1. Name consumers and the compatibility promise per audience (internal, partner, public) with a change SLA.
2. Design operations from domain intent (links `DOM-LANG`), not storage shape.
3. Make a machine-readable schema (OpenAPI/proto/AsyncAPI) the contract SoT, checked in and CI-validated.
4. Define error, pagination, idempotency, concurrency, and partial-failure semantics before first consumer.
5. Set versioning and deprecation lifecycle up front; assume Hyrum's Law — every observable behavior will acquire dependents.
6. Verify with contract tests on both sides; measure deprecated usage before removal.

## Practice catalog

| ID | Practice | Evidence |
|---|---|---|
| API-CONSUMER | Compatibility promise per audience | Consumers, tier, and change SLA documented |
| API-SCHEMA | Machine-readable schema is the SoT | Checked in, CI-validated, drift-checked against behavior |
| API-SEMANTIC | Operations express domain intent | Resources/verbs match ubiquitous language, not tables |
| API-ERROR | Errors are structured and actionable | Stable error contract (RFC 9457 or equivalent); no internals leak |
| API-IDEMP | Unsafe operations are retry-safe | Idempotency key/semantics for side effects (links `REL-RETRY`) |
| API-PAGE | Collections are bounded | Pagination, limits, and stable sort documented |
| API-CONCUR | Concurrent updates are arbitrated | ETag/If-Match or version field with conflict semantics |
| API-COMPAT | Changes are compatible by default | Additive rules; expand/contract for breaks (links `EVO-COMPAT`) |
| API-DEPREC | Deprecation is a managed lifecycle | Timeline, usage telemetry, consumer migration owner |
| API-TEST | Both sides verify the contract | Provider/consumer contract tests in CI |

## Violations

| ID | Violation | Consequence |
|---|---|---|
| XAPI-STORAGE-LEAK | DB/ORM shape serialized as the contract | Consumers couple to internals (links `X-ENTITY-DTO`) |
| XAPI-BREAK-SILENT | Observable behavior changed without version/deprecation | Hyrum-style consumer outage |
| XAPI-ERROR-OPAQUE | Errors are prose strings, bare 500s, or stack traces | Consumers parse text; operators debug blind |
| XAPI-UNBOUNDED | Collection/response has no size bound | Latency/memory blowup on either side |
| XAPI-RETRY-UNSAFE | Retriable operation duplicates its side effect | Double charge/create (links `XD-RETRY-DUP`) |
| XAPI-VERSION-FOREVER | Versions accumulate without retirement | N implementations maintained forever (links `XE-DUAL-FOREVER`) |
| XAPI-SCHEMA-DRIFT | Published schema/docs diverge from behavior | Integration by trial and error |
| XAPI-CHATTY | One consumer intent requires N sequential calls | Latency and partial-failure amplification |
| XAPI-TENANT-IMPLICIT | Tenant/authz scope implicit in the contract | Cross-tenant access risk (links `XS-TENANT-LEAK`) |

## Baseline

```text
APIBASELINE | <api/contract> | consumers: <audience/tier> | schema-SoT: <where/CI> | semantics: <domain fit> | errors/idempotency/pagination/concurrency: <contracts> | compat/deprecation: <policy> | fit: stable|conditional|drift | practices: [API-…] | violations: [XAPI-…] | next: <smallest compatibility improvement>
```

Emit `APIBASELINE` when a contract with more than one consumer, a versioning decision, or a breaking change is under review. Omit for private in-process interfaces.
