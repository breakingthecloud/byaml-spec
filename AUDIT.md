# ByaML v2 — Auditoría de repos de referencia

> **Fecha:** 2026-08-17
> **Workspace:** `~/dev/breakingthecloud/byaml-next/_reference/` (clones "tal cual", historia completa, frozen)
> **Org origen:** `brickstore-ai` (histórico) → **Org destino:** `breakingthecloud`
> **Criterio:** qué se salva/migra → se mueve a `breakingthecloud/{nuevo}`. Nada de brickstore-ai se reutiliza en sitio.

## Repos clonados (6 en total: 5 remotos GitHub + 1 local brickstore)

| # | Repo | Stack | Estado | Deliverables salvar | Verdict |
|:-:|------|-------|--------|---------------------|:------:|
| 1 | `byaml-core` | NestJS + Mongo (389 files) | commit `098181e` | Lógica validate/convert/render + schema mgmt; schema **v0.3** en `.brickgpt-sow/schemas/byaml-v0.3.schema.json`; catalog seed scripts; `GITOPS_WORKFLOW.md`; CHANGELOG rico | ⚙️ **extract** → reescribir en Python (ByaML-002) |
| 2 | `byaml-finops-mcp` | Python/uv + PyPI (MIT) | commit `21eaa46` | 8 tools MCP (`get_cost_by_service`, `get_cost_anomalies`, `find_idle_resources`, `get_savings_recommendations`, `detect_missing_tags`, `generate_byaml_from_account`, `validate_byaml`, `estimate_termination_savings`); `schema/byaml-v0.3.schema.json` + `schema/policies.yaml`; server.py | ♻️ **base** → fork a `byaml-mcp` v2 (ByaML-004) |
| 3 | `public-byaml-schema` | byaml-cli Python + Docker + demos (113 files) | commit `1ee44e2` | `byaml-cli` (obsoleto); `byaml-demo/data/schema_v0_2.json` (v0.2 viejo); sample byaml + demos | ☠️ **descartar** (only demos/samples como referencia) |
| 4 | `public-byaml-schema-api` | Python handler + terraform-deploy (14 files) | commit `98dd693` | `byaml_api_handler.py` endpoints latest/versions/catalog; `terraform-deploy/`; SECURITY.md | ♻️ **reescribir** → `byaml-schema-api` v2 (ByaML-003) |
| 5 | `org-byaml-web` | Next.js 14 + framer-motion + tailwind (37 files) | commit `0cdb3d6` | Estructura/marketing byaml.org; deploy-s3 + cloudfront | ♻️ **reescribir** → `byaml-web` v2 narrativa graph (ByaML-005) |
| 6 | `private-byaml-schema` | Repo **local** (`~/dev/brickstore/brick2026/`, sin remote) | sin commits git | **Schema v0.3 + catalog + policies + relationships + publish.sh** ← fuente de verdad del modelo | ♻️ **migrar** (hecho) → `byaml-spec/schema/v0.3/` + `scripts/publish.sh` |

## ✅ Resuelto: `private-byaml-schema`

> El research (`research-2026-08-17-byaml-restart-directive.md`) lista `private-byaml-schema` como la
> "fuente de verdad del schema v0.3 + publish.sh → S3". Inicialmente parecía no existir (no está en
> GitHub `brickstore-ai/` → 404). **Corregido:** es un repo **local** en la máquina, fuera de GitHub:
> `~/dev/brickstore/brick2026/private-byaml-schema` (sin remote, sin commits git — solo `git init`).

### Contenido del repo local (20 files)
- `schema/byaml-v0.3.schema.json` ← **schema v0.3** (fuente de verdad)
- `catalog/component-catalog.yaml` (v0.3, 1025 líneas) + `catalog/versions/` (v1.0.0-13types, v1.0.1, v1.0.2)
- `catalog/policy-rules.yaml` + `catalog/relationship-matrix.yaml`
- `publish.sh` → publica a S3 bucket `byaml-schema-registry` (schema/catalog/policies/relationships + manifest)
- validators JS (`validate*.js`), `examples/*.byaml`, `migration/v02-to-v03.md`

### Acción tomada (ByaML-001)
1. Copiado "tal cual" → `_reference/private-byaml-schema/` (workspace de referencia).
2. **Migrado el contenido servible** → `breakingthecloud/byaml-spec`:
   - `schema/v0.3/{schema.json, catalog.yaml, policies.yaml, relationships.yaml}`
   - `schema/v0.3/manifest.json`
   - `scripts/publish.sh` (adaptado a la nueva estructura `schema/<version>/`)
3. El schema v0.3 se usa como base para el modelo v0.4 (grafo-first) en ByaML-002/003.

## Repos brickstore-ai NO clonados (fuera de alcance / en espera)

`byaml-core-deploy`, `byaml-vscode`, `fest-byaml-demo`, `drawbrick-api`, `drawbrick-vscode`,
`brickswagger`, `landing-next-2025`, `duku`, `storefront-ai`, `brickstore`, `admin-ui`, etc.
→ No se clonan en Fase 0. Solo se revisan si un audit puntual lo pide (no bloquea).

## Plan de migración (qué mover adónde)

| Activo | De | A |
|--------|----|---|
| Schema v0.3 + policies | `byaml-core` + `byaml-finops-mcp/schema` | `breakingthecloud/byaml-spec` (source) → `byaml-schema-api` (serve) |
| Lógica validate/convert | `byaml-core/src/modules/byaml/*` | Reescribir en Python → `breakingthecloud/byaml` (ByaML-002) |
| 8 tools MCP | `byaml-finops-mcp/server.py` + `src/` | Fork → `breakingthecloud/byaml-mcp` v2 (ByaML-004) |
| Endpoints schema API | `public-byaml-schema-api` | `breakingthecloud/byaml-schema-api` (ByaML-003) |
| Web byaml.org | `org-byaml-web` | `breakingthecloud/byaml-web` (ByaML-005) |
| Catalog ≥17 tipos | catalog seed en `byaml-core` + collectors SOFE | `breakingthecloud/byaml-catalog` (ByaML-006) |
| Graph engine | (deps of Ñan) | `nan-graph` PyPI (nan-001/002/003) |

## Estado del freeze brickstore-ai

**🔴 Pendiente** (decisión usuario): NO se hace README redirect en `brickstore-ai/*` en ByaML-001.
Como ya no se usa nada de brickstore-ai en sitio, lo importante se MUEVE a `breakingthecloud`
y el freeze/redirect de los repos viejos queda para una fase posterior.
