# Canonical source registry

Use this file to locate source rationale and check whether a living standard has changed. Do not bulk-load every source for ordinary tasks. Prefer primary/official sources, record retrieval date when updating a digest, and paraphrase rather than copy.

## Data and distributed systems

- Martin Kleppmann and Chris Riccomini, *Designing Data-Intensive Applications*, 2nd ed. (2026): <https://martin.kleppmann.com/>
- Ongaro and Ousterhout, *In Search of an Understandable Consensus Algorithm*: <https://www.usenix.org/conference/atc14/technical-sessions/presentation/ongaro>
- DeCandia et al., *Dynamo*: <https://www.allthingsdistributed.com/files/amazon-dynamo-sosp2007.pdf>
- Corbett et al., *Spanner*: <https://research.google/pubs/spanner-googles-globally-distributed-database/>
- Dean and Ghemawat, *MapReduce*: <https://research.google/pubs/mapreduce-simplified-data-processing-on-large-clusters/>
- Sigelman et al., *Dapper*: <https://research.google/pubs/dapper-a-large-scale-distributed-systems-tracing-infrastructure/>
- Dean and Barroso, *The Tail at Scale*: <https://research.google/pubs/the-tail-at-scale/>
- Gilbert and Lynch, CAP conjecture proof: <https://groups.csail.mit.edu/tds/papers/Gilbert/Brewer2.pdf>

## Architecture quality and communication

- Bass, Clements, Kazman, *Software Architecture in Practice*, 4th ed.
- SEI ATAM collection: <https://www.sei.cmu.edu/library/architecture-tradeoff-analysis-method-collection/>
- SEI Quality Attribute Workshops: <https://insights.sei.cmu.edu/library/quality-attribute-workshop-collection/>
- arc42 template and quality model: <https://arc42.org/overview>, <https://quality.arc42.org/>
- Simon Brown, C4 Model: <https://c4model.com/>
- Fowler/Nygard ADR guidance: <https://martinfowler.com/bliki/ArchitectureDecisionRecord.html>
- Parnas, *On the Criteria To Be Used in Decomposing Systems into Modules*: <https://prl.khoury.northeastern.edu/img/p-tr-1971.pdf>
- Moseley and Marks, *Out of the Tar Pit*: <https://curtclifton.net/papers/MoseleyMarks06a.pdf>

## Domain modeling and API contracts

- Eric Evans, *Domain-Driven Design*; DDD Reference (free): <https://www.domainlanguage.com/ddd/reference/>
- Vaughn Vernon, *Implementing Domain-Driven Design*.
- Vlad Khononov, *Learning Domain-Driven Design*.
- Martin Fowler, *BoundedContext*: <https://martinfowler.com/bliki/BoundedContext.html>
- Zalando RESTful API Guidelines: <https://opensource.zalando.com/restful-api-guidelines/>
- Google API Improvement Proposals: <https://google.aip.dev/>
- RFC 9457, *Problem Details for HTTP APIs*: <https://www.rfc-editor.org/rfc/rfc9457>
- OpenAPI Specification: <https://spec.openapis.org/oas/latest.html>; AsyncAPI: <https://www.asyncapi.com/docs>

## Reliability and security

- Google, SRE books (SRE, Workbook, Building Secure and Reliable Systems): <https://sre.google/books/>
- Amazon Builders’ Library: <https://aws.amazon.com/builders-library/>
- *Timeouts, retries, and backoff with jitter*: <https://aws.amazon.com/builders-library/timeouts-retries-and-backoff-with-jitter/>
- *Making retries safe with idempotent APIs*: <https://aws.amazon.com/builders-library/making-retries-safe-with-idempotent-APIs/>
- Michael Nygard, *Release It!*, 2nd ed.
- NIST SP 800-218 SSDF: <https://csrc.nist.gov/pubs/sp/800/218/final>
- OWASP ASVS/Cheat Sheets/Secure by Design: <https://owasp.org/www-project-application-security-verification-standard/>, <https://cheatsheetseries.owasp.org/>, <https://owasp.org/www-project-secure-by-design-framework/>

## Evolution, code, and organization

- Martin Fowler, *Refactoring*, 2nd ed.; bibliography: <https://martinfowler.com/books/refactoring-bibliography.html>
- Michael Feathers, *Working Effectively with Legacy Code*.
- John Ousterhout, *A Philosophy of Software Design*, 2nd ed.
- Ford, Parsons, Kua, Sadalage, *Building Evolutionary Architectures*, 2nd ed.; overview: <https://martinfowler.com/articles/evo-arch-forward.html>
- Fowler, *Monolith First* and *How to Break a Monolith into Microservices*: <https://martinfowler.com/bliki/MonolithFirst.html>, <https://martinfowler.com/articles/break-monolith-into-microservices.html>
- Winters, Manshreck, Wright, *Software Engineering at Google*: <https://research.google/pubs/software-engineering-at-google/>
- Forsgren, Humble, Kim, *Accelerate*; continuing research: <https://dora.dev/research/>
- Skelton and Pais, *Team Topologies*: <https://teamtopologies.com/book>
- Brooks, *The Mythical Man-Month* and *No Silver Bullet*.
- Hyrum's Law: <https://www.hyrumslaw.com/>

## Algorithms

- Aditya Bhargava, *Grokking Algorithms* (repo PDF digest → `algorithms-source.md`).
- Steven Skiena, *The Algorithm Design Manual*, 3rd ed.
- Sedgewick and Wayne, *Algorithms*, 4th ed.: <https://algs4.cs.princeton.edu/home/>
- CP-Algorithms: <https://cp-algorithms.com/>

## Maintenance policy

- Last source review: 2026-07-13.
- Recheck living standards (NIST, OWASP, DORA, arc42, C4, SRE, Builders’ Library, Zalando/AIP) before high-stakes guidance.
- If book and current official standard conflict, follow the current standard and document the divergence.
- Never obtain or redistribute unauthorized book copies; use publisher, author, library, or legally provided online editions.
