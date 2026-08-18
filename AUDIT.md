# ByaML v2 — Auditoría de repos de referencia

> **Fecha:** 2026-08-17
> **Workspace:** `~/dev/breakingthecloud/byaml-next/_reference/` (clones "tal cual", historia completa, frozen)
> **Org origen:** `brickstore-ai` (histórico) → **Org destino:** `breakingthecloud`
> **Criterio:** qué se salva/migra → se mueve a `breakingthecloud/{nuevo}`. Nada de brickstore-ai se reutiliza en sitio.

## Repos clonados (5, historia completa)

| # | Repo | Stack | Estado | Deliverables salvar | Verdict |
|:-:|------|-------|--------|---------------------|:------:|
| 1 | `byaml-core` | NestJS + Mongo (389 files) | commit `098181e` | Lógica validate/convert/render + schema mgmt; schema **v0.3** en `.brickgpt-sow/schemas/byaml-v0.3.schema.json`; catalog seed scripts; `GITOPS_WORKFLOW.md`; CHANGELOG rico | ⚙️ **extract** → reescribir en Python (ByaML-002) |
| 2 | `byaml-finops-mcp` | Python/uv + PyPI (MIT) | commit `21eaa46` | 8 tools MCP (`get_cost_by_service`, `get_cost_anomalies`, `find_idle_resources`, `get_savings_recommendations`, `detect_missing_tags`, `generate_byaml_from_account`, `validate_byaml`, `estimate_termination_savings`); `schema/byaml-v0.3.schema.json` + `schema/policies.yaml`; server.py | ♻️ **base** → fork a `byaml-mcp` v2 (ByaML-004) |
| 3 | `public-byaml-schema` | byaml-cli Python + Docker + demos (113 files) | commit `1ee44e2` | `byaml-cli` (obsoleto); `byaml-demo/data/schema_v0_2.json` (v0.2 viejo); sample byaml + demos | ☠️ **descartar** (only demos/samples como referencia) |
| 4 | `public-byaml-schema-api` | Python handler + terraform-deploy (14 files) | commit `98dd693` | `byaml_api_handler.py` endpoints latest/versions/catalog; `terraform-deploy/`; SECURITY.md | ♻️ **reescribir** → `byaml-schema-api` v2 (ByaML-003) |
| 5 | `org-byaml-web` | Next.js 14 + framer-motion + tailwind (37 files) | commit `0cdb3d6` | Estructura/marketing byaml.org; deploy-s3 + cloudfront | ♻️ **reescribir** → `byaml-web` v2 narrativa graph (ByaML-005) |

## ⚠️ Discrepancia: `private-byaml-schema`

El research (`research-2026-08-17-byaml-restart-directive.md`) lista `private-byaml-schema` como la
"fuente de verdad del schema v0.3 + publish.sh → S3". **Dicho repo NO existe en GitHub** (verificado:
`brickstore-ai/private-byaml-schema` → 404).

El schema v0.3 y la lógica de publish sí existen, pero ubicados en otros lados:
- `byaml-core/.brickgpt-sow/schemas/byaml-v0.3.schema.json` ← schema v0.3
- `byaml-finops-mcp/schema/byaml-v0.3.schema.json` ← copia del schema v0.3
- `byaml-core/tests-byaml-publish/` + `test/publishing.e2e-spec.ts` ← pruebas/patrón de publish

**Conclusión:** el contenido de `private-byaml-schema` (si existió) está disperso/extraíble de
`byaml-core` + `byaml-finops-mcp`. Para ByaML-003 se reconstruye el `publish.sh` + manifest desde
`byaml-core/GITOPS_WORKFLOW.md` + scripts de publish.

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
