# Changelog

All notable changes to this project (**BYaML Spec**, SOFE Architecture Graph)
will be documented in this file.

The format is based on [Keep a Changelog](https://keepachangelog.com/en/1.0.0/),
and this project adheres to [Semantic Versioning](https://semver.org/spec/v2.0.0.html).

## [0.2.0] - 2026-08-18

### Added
- **Schema v0.4 (Architecture Graph, graph-first)** — definido en **ByaML-002** SOBRE `nan-graph`:
  - `schema/v0.4/graph-v0.4.schema.json` — JSON Schema (draft 2020-12): `version`/`id`/`generated_from`/`nodes[]`/`edges[]`/`insights`.
  - `schema/v0.4/catalog.yaml` — **52 tipos** (baseline 18 = SOFE collectors + extendido), con aliases v0.3→v0.4 (`aws.nat-gateway→aws.natgateway`, `aws.secrets-manager→aws.secretsmanager`).
  - `schema/v0.4/relationships.yaml` — matriz from/to/type + vocabulario `rel_types` (13).
  - `schema/v0.4/examples/*.byaml` — **3 ejemplos** validados (minimal, sofe-eval, terraform).
  - `schema/v0.4/SPEC.md` — spec del modelo. `schema/v0.4/manifest.json` — registry v0.4.
- **`breakingthecloud/byaml-py`** (paquete PyPI `byaml` v0.4.0a1) — models pydantic + `validate` (JSON Schema + catalog + relationships), `convert.from_terraform` / `convert.from_evaluation`, `dump`/`load`, CLI (`byaml validate|convert|dump`). 11 tests pytest ✓, build ✓.

### Changed
- Confirmado: **v0.3 como formato de usuario DEJA DE EXISTIR** — evoluciona a v0.4 (grafo dentro de nan-graph + BYaML v2). `.byaml` = wire-format de interop, NO producto.

## [0.1.0] - 2026-08-17

### Added
- **Repo inicial** `breakingthecloud/byaml-spec` (OSS, Apache-2.0) — fuente de verdad de la directriz del relanzamiento.
- `README.md` — overview del repo y estado del Sprint 8.
- `DIRECTIVE.md` — directriz y decisiones del relanzamiento BYaML v2 (SOFE Architecture Graph):
  graph-first, AI-native via MCP, fusión con Ñan (`nan-graph`), Apache-2.0.
- `AUDIT.md` — auditoría de los 5 repos `brickstore-ai` clonados (salvar/descartar + plan de migración).
- `LICENSE` — Apache-2.0.
- `schema/v0.3/` — **schema v0.3 migrado** de `private-byaml-schema` (repo local): `schema.json`,
  `catalog.yaml`, `policies.yaml`, `relationships.yaml`, `manifest.json`.
- `scripts/publish.sh` — publica schema/catalog/policies/relationships a S3 (adaptado a `schema/<version>/`).

### Notes
- Workspace de referencia: `~/dev/breakingthecloud/byaml-next/_reference/` (5 repos brickstore-ai clonados "tal cual" con historia completa + `private-byaml-schema` local copiado).
- `private-byaml-schema` NO està en GitHub — es repo **local** (`~/dev/brickstore/brick2026/`); su contenido se migró a `byaml-spec/schema/v0.3/`.
- Freeze/README redirect de repos viejos `brickstore-ai/*` → **pendiente** (fase posterior, no bloquea).
