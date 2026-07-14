# principal-software-architect

[![License](https://img.shields.io/badge/License-Apache_2.0-blue.svg)](LICENSE)
[![skills.sh](https://img.shields.io/badge/skills.sh-principal--software--architect-111827)](https://skills.sh/diogoX451/principal-software-architect/principal-software-architect)

**Idioma:** [English](README.md) | **Português (Brasil)**

**Agent Skill** para arquitetura de software em nível principal — design de
sistema, trade-offs, ADRs, estratégia de crescimento e revisões de arquitetura.

Compatível com o formato aberto [Agent Skills](https://agentskills.io) e com o
ecossistema [skills.sh](https://skills.sh) — funciona com **Claude Code**,
**Codex**, **Cursor**, **OpenCode**, **Grok** e vários outros agentes.

## O que faz

Quando ativada, o agente age como um **Principal Software Architect**:

- Enquadra restrições e invariantes antes de propor estrutura
- Compara opções com custo de reversão e aderência ao caminho de produto existente
- Produz ADRs para decisões difíceis de reverter
- Revisa arquiteturas com achados ranqueados por severidade
- Prefere expandir a camada mais baixa correta em vez de inventar frameworks paralelos
- **Detecta padrões** e código **fora de padrão** (Clean Architecture `P-*` / `X-*`, GoF `G-*`, microsserviços `MS-*` / `X-MS-*`)
- Emite uma **Architecture Baseline Line** para cada unidade analisada
- Suporta **validação multiagente** (PRIMARY → ADVERSARY → SYNTH) antes do veredito final
- Fundamenta Clean Architecture no digest Martin (`clean-architecture-source.md`, a partir do PDF do repositório)
- Fundamenta design de objetos no digest GoF (`design-patterns-source.md`, PDF Gamma et al.)
- Fundamenta **prontidão de produção** multi-serviço no digest Fowler (`microservices-source.md`)
- Destila *Clean Code* em padrões contextuais `CC-*` / `XC-*` com evidência e tooling do repositório
- Emite uma **Code Baseline Line** para cada unidade de implementação inspecionada
- Converte os 11 capítulos de *Entendendo Algoritmos* em regras `ALG-*` / `XA-*` de correção, complexidade, exatidão, estruturas de dados e benchmark
- Emite uma **Algorithm Baseline Line** para cada caminho algorítmico material
- Encaminha dados distribuídos, atributos de qualidade, confiabilidade, segurança, evolução de legado, comunicação de arquitetura e ownership de time para padrões focados
- Emite apenas baselines especialistas **aplicáveis** — sem teatro de compliance vazio
- **Sempre responde no idioma da conversa**; IDs de catálogo e esqueletos de baseline permanecem legíveis por máquina

## Instalação

### Recomendado — CLI [skills.sh](https://skills.sh)

```bash
npx skills add diogoX451/principal-software-architect
```

Instalação global (nível de usuário, todos os projetos):

```bash
npx skills add diogoX451/principal-software-architect -g -y
```

Listar sem instalar:

```bash
npx skills add diogoX451/principal-software-architect --list
```

Página do diretório:
[skills.sh/diogoX451/principal-software-architect/principal-software-architect](https://skills.sh/diogoX451/principal-software-architect/principal-software-architect)

> **Nota:** o PromptScript não suporta instalação global de skills. Use o
> comando com escopo de projeto (sem `-g`) dentro do repositório alvo.

### Alternativa — clone + script de instalação

```bash
git clone https://github.com/diogoX451/principal-software-architect.git
cd principal-software-architect
./scripts/install.sh
```

Instala em:

| Harness | Caminho |
|---------|---------|
| Claude Code | `~/.claude/skills/principal-software-architect/` |
| Grok | `~/.grok/skills/principal-software-architect/` |
| Codex (opt-in) | `INSTALL_CODEX=1 ./scripts/install.sh` |

### Manual

Copie a pasta da skill:

```bash
cp -R skills/principal-software-architect ~/.claude/skills/
cp -R skills/principal-software-architect ~/.grok/skills/
```

### Local ao projeto (compartilhamento em time, sem CLI)

```bash
mkdir -p .claude/skills .grok/skills
cp -R skills/principal-software-architect .claude/skills/
cp -R skills/principal-software-architect .grok/skills/
```

## Uso

- Slash: `/principal-software-architect`
- Linguagem natural: *"revisão de arquitetura do caminho de billing"*, *"devemos separar este serviço?"*, *"escreva um ADR para a abstração do bus"*, *"audite este módulo contra Clean Architecture"*, *"valide este design com multiagente"*

### Architecture Baseline Line

Para cada unidade analisada o agente emite (esqueleto em inglês; campos de texto livre e a explicação ao redor seguem o idioma da conversa):

```text
BASELINE | <unit> | expected: … | observed: … | fit: align|partial|drift | patterns: [P-…] | violations: [X-…] | suggestion: …
```

### Validação multiagente

```text
VALIDATION | agents: [ARCH-PRIMARY, ARCH-ADVERSARY, ARCH-SYNTH] | agreement: high|medium|low | unresolved: N | ready: yes|no
```

### Code Baseline Line

```text
CODEBASELINE | <unit> | responsibility: … | observed: … | fit: clean|mixed|drift | practices: [CC-…] | violations: [XC-…] | next: …
```

### Algorithm Baseline Line

```text
ALGBASELINE | <unit> | problem: … | data: … | choice: … | complexity: <time; space> | preconditions: … | exactness: exact|approximate|probabilistic | fit: sound|conditional|drift | practices: [ALG-…] | violations: [XA-…] | next: …
```

### Baselines especialistas

Carregados somente quando forem materiais:

| Preocupação | IDs | Baseline |
|---|---|---|
| Modelagem de domínio / DDD | `DOM-*` / `XDOM-*` | `DOMBASELINE` |
| Dados distribuídos | `DATA-*` / `XD-*` | `DATABASELINE` |
| Contratos de API | `API-*` / `XAPI-*` | `APIBASELINE` |
| Atributos de qualidade / ATAM | `QA-*` / `XQ-*` | `QUALITYBASELINE` |
| Confiabilidade / SRE | `REL-*` / `XR-*` | `RELBASELINE` |
| Arquitetura segura | `SEC-*` / `XS-*` | `SECBASELINE` |
| Evolução / legado | `EVO-*` / `XE-*` | `EVOBASELINE` |
| C4, arc42 e ADRs | `DOC-*` / `XDOC-*` | `DOCBASELINE` |
| Ownership e entrega | `ENG-*` / `XENG-*` | `ENGBASELINE` |

## Layout (padrão Agent Skills)

```text
principal-software-architect/
├── README.md                       # English
├── README.pt-BR.md                 # Português (Brasil)
├── LICENSE
├── scripts/install.sh
├── agents/                         # definição de agente Claude Code (opcional)
│   └── principal-software-architect.md
└── skills/
    └── principal-software-architect/
        ├── SKILL.md                # obrigatório — instruções + gatilhos
        ├── agents/openai.yaml      # metadados de UI Codex
        ├── references/             # carregar sob demanda
        │   ├── clean-architecture-source.md   # digest PDF Martin
        │   ├── design-patterns-source.md      # digest PDF GoF (G-*)
        │   ├── microservices-source.md        # production-ready Fowler (MS-*)
        │   ├── clean-architecture-patterns.md
        │   ├── clean-code-source.md           # digest Clean Code
        │   ├── clean-code-standards.md        # catálogo executável CC-*/XC-*
        │   ├── algorithms-source.md           # digest Bhargava (11 caps.)
        │   ├── algorithm-selection-standards.md # catálogo ALG-*/XA-*
        │   ├── domain-modeling-standards.md
        │   ├── api-contract-standards.md
        │   ├── distributed-data-standards.md
        │   ├── quality-attribute-evaluation.md
        │   ├── reliability-resilience-standards.md
        │   ├── secure-architecture-standards.md
        │   ├── evolution-legacy-standards.md
        │   ├── architecture-communication-standards.md
        │   ├── engineering-organization-standards.md
        │   ├── source-bibliography.md          # links canônicos + manutenção
        │   ├── multi-agent-validation.md
        │   ├── decision-framework.md
        │   └── architecture-review-checklist.md
        └── templates/
            ├── architecture-decision-record.md
            ├── architecture-review-report.md
            └── architecture-baseline-matrix.md
```

## Design deste pacote de skill

| Princípio | Aplicação |
|-----------|-----------|
| Progressive disclosure | SKILL.md enxuto; detalhe de Clean Architecture nas references |
| Descrição rica em gatilhos | Frontmatter lista quando auto-invocar |
| Multi-harness | Mesmo `SKILL.md` para Claude/Grok; agent file é aditivo |
| Idioma da conversa | Prosa para o usuário segue o chat; esqueletos P-*/G-*/MS-*/X-*/CC-* + BASELINE ficam estáveis |
| Fonte Clean Architecture | Digest PDF em `clean-architecture-source.md` |
| Padrões de projeto GoF | Digest do livro em `design-patterns-source.md` (`G-*`) |
| Microsserviços production-ready | Digest Fowler em `microservices-source.md` (`MS-*` / `X-MS-*`) |
| Fonte Clean Code | PDF destilado em orientação por capítulo e padrões contextuais |
| Fonte de algoritmos | PDF destilado em seleção, complexidade, exatidão e validação |
| Fontes online canônicas | DDIA, DDD Reference, SEI/ATAM, Google SRE, AWS Builders’ Library, NIST, OWASP, Zalando/AIP, C4, arc42, Fowler, DORA e papers primários |
| Roteamento por preocupação | References especialistas só quando o risco/decisão for material |
| Multiagente | Protocolo PRIMARY / ADVERSARY / SYNTH para cruzamento |
| Sem lock-in SaaS | Markdown puro + script de install / `npx skills add` |

## Versionamento

Tags seguem `vMAJOR.MINOR.PATCH`. O histórico de releases fica nas tags Git; o
`SKILL.md` mantém apenas os campos portáveis `name` e `description` no frontmatter.

## Contribuindo

Veja [CONTRIBUTING.md](CONTRIBUTING.md). Mantenha a skill acionável (instruções
para o agente), não um livro-texto.

## Licença

Apache-2.0 — © Diogo Almeida
