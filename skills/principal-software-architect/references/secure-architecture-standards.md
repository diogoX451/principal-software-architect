# Secure architecture standards

Load when trust, identity, authorization, secrets, sensitive data, external input, supply chain, tenancy, or abuse matters. Sources: NIST SSDF SP 800-218, OWASP ASVS/Cheat Sheets/Secure by Design, and *Building Secure and Reliable Systems*. See `source-bibliography.md`.

This is an architecture gate, not a substitute for specialist threat modeling, compliance, cryptography, or penetration testing.

## Workflow

1. Identify assets, actors, trust boundaries, entry/egress points, tenants, and privileged operations.
2. Enumerate misuse/abuse cases and plausible threat actors.
3. Map preventive, detective, responsive, and recovery controls.
4. Apply least privilege, secure defaults, complete mediation, defense in depth, and separation of duties.
5. Define verification, logging/audit, dependency provenance, secret rotation, incident and residual risk.

## Practice catalog

| ID | Practice | Evidence |
|---|---|---|
| SEC-MODEL | Threat model is scoped and current | Assets, boundaries, abuse, controls, owners |
| SEC-IDENT | Workload/user identity is explicit | AuthN mechanism, lifecycle, binding and assurance |
| SEC-AUTHZ | Authorization is server-side and object/tenant scoped | Deny-by-default policy tested at boundary |
| SEC-DATA | Data classified and minimized | Retention, encryption, deletion and access paths |
| SEC-SECRET | Secrets are managed | No source/log secret; rotation and revocation |
| SEC-INPUT | Untrusted input stays untrusted | Validation, canonicalization, safe sinks |
| SEC-AUDIT | Security events are tamper-resistant/useful | Actor, action, target, outcome, correlation |
| SEC-SUPPLY | Dependencies/builds have provenance | Pinning, review, SBOM/scanning, trusted release |
| SEC-RECOVER | Compromise recovery is designed | Revoke, rotate, isolate, restore, communicate |
| SEC-VERIFY | Controls are continuously verified | Tests/scans/review mapped to requirements |

## Violations

| ID | Violation | Consequence |
|---|---|---|
| XS-TRUST-HIDDEN | Boundary or privileged actor undocumented | Unreviewed attack path |
| XS-AUTHZ-CLIENT | Client/UI enforces authorization | Bypassable access control |
| XS-TENANT-LEAK | Tenant context optional/inconsistent | Cross-tenant disclosure or mutation |
| XS-DEFAULT-OPEN | Missing config grants access | Insecure deployment state |
| XS-SECRET-SPRAWL | Long-lived secret in code/config/log/event | Credential compromise and difficult rotation |
| XS-DATA-EXCESS | Sensitive data collected/retained without need | Expanded breach/regulatory impact |
| XS-LOG-SENSITIVE | Secret/PII written to telemetry | Secondary disclosure surface |
| XS-CRYPTO-CUSTOM | Custom crypto/protocol/password storage | Catastrophic security weakness |
| XS-SUPPLY-BLIND | Unpinned/unverified dependency/build path | Supply-chain compromise |
| XS-ALERT-BLIND | Control failure/abuse not observable | Long dwell time |
| XS-RISK-SILENT | Accepted residual risk has no owner/expiry | Permanent undocumented exposure |

## Baseline

```text
SECBASELINE | <scope> | assets: […] | trust-boundaries: […] | threats/abuse: […] | identity/authz: <model> | data/secrets: <controls> | detect/recover: <controls> | residual-risk: <owner/expiry> | fit: sound|conditional|drift | practices: [SEC-…] | violations: [XS-…] | next: <smallest risk reduction>
```

Critical findings require direct evidence and specialist escalation. Never invent exploitability from a naming smell alone.
