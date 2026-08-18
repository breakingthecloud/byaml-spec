# BYaML v2 — Directriz (SOFE Architecture Graph)

> **Status:** ✅ Activa — Fase 0 (scaffold + audit) en curso
> **Base research:**
> - `cc-roadmap/research/research-2026-08-16-byaml-reassessment.md`
> - `cc-roadmap/research/research-2026-08-17-byaml-restart-directive.md`
> - Changelog: `cc-roadmap/changelogs/changelog-2026-08-17-session.md`

## 1. Decisión de partida (no re-litigar)

| Antes (brickstore-ai, org BYaML) | Ahora (breakingthecloud) |
|---|---|
| BYaML como "lenguaje de arquitectura" que el usuario escribe/versiona | **SOFE Architecture Graph** — modelo normalizado interno. `.byaml` = wire-format (opcional), NO producto |
| `brickstore-ai/byaml-*` (12 repos) | Repos nuevos `breakingthecloud/*` |
| Catálogo 13 components / 25 relationships (v0.3) | Grafo derivado de SOFE collectors + policies (expandible) |
| byaml-cli standalone | MCP = la interfaz de agente (no CLI que el humano edita) |
| Ñan: plan separado (nan-001/002/003) | Ñan ES la implementación del grafo (fusionar) |

## 2. Principios del relanzamiento

1. **Graph-first:** modelo normalizado (nodos = recursos/servicios, aristas = relaciones,
   atributos = costo/findings/owners). Derivado de **scan**, no autoría manual.
2. **AI-native:** la interfaz es el **MCP** (byaml-mcp v2), no una YAML que el humano edita.
   Input = evaluación/infraestructura; output = grafo + findings + remediation.
3. **Fusión con Ñan:** el grafo lo implementa `nan-graph` (traversal, blast radius, cost propagation).
   UN modelo, una serialización opcional.
4. **Abierto:** Apache-2.0, todo público en `breakingthecloud`.

## 3. Regla de oro

> Un mismo modelo (grafo) · serialización BYaML solo para interop ·
> interfaces AI-native (MCP) · la web y el schema API son **documentación viva**, no producto.

## 4. Estructura de la org `breakingthecloud` (plan)

| Repo | Rol | SoW |
|------|-----|:--:|
| `byaml-spec` | Directriz + schema v0.4 + catalog (fuente de verdad) — ESTE repo | ByaML-001/002 |
| `byaml-schema-api` | schema.byaml.org v2 (registry versionado) | ByaML-003 |
| `byaml-mcp` | MCP v2 (graph + findings + remediation) | ByaML-004 |
| `byaml-web` | byaml.org v2 | ByaML-005 |
| `byaml-catalog` | Catalog vivo (≥17 tipos desde SOFE collectors) | ByaML-006 |
| `nan-graph` (PyPI) | Architecture Graph engine (fusión Ñan) | nan-001/002/003 |
| `sofe` / `sofe-api` | Ya existentes — engine + endpoint graph | — |

## 5. Decisiones tomadas

- **Dominio:** byaml.org (por ahora; narrativa "graph", redirige).
- **Licencia:** Apache-2.0 (aplicar en cada repo desde el scaffold).
- **byaml-core (NestJS+Mongo):** NO se migra tal cual → se extrae lógica validate/convert y se
  **reescribe en Python** (mismo runtime del engine, una sola codebase). Se audita en ByaML-001.
- **byaml-finops-mcp:** es la **base** del MCP v2 (entry point AI-native vivo).
- **`private-byaml-schema`:** repo **local** (no GitHub) en `~/dev/brickstore/brick2026/`. Es la fuente
  del **schema v0.3 + catalog + policies + relationships + publish.sh**. **Migrado** a `byaml-spec/schema/v0.3/`
  en ByaML-001 → base del modelo v0.4 en ByaML-002.
- **DrawBrick / byaml-vscode / byaml-cli:** sin `.byaml` de usuario, quedan en espera/descarte.
- **Repos viejos `brickstore-ai/byaml-*`:** NO se eliminan (histórico). Freeze con README redirect
  se hace en una fase posterior (no bloquea).

## 6. Roadmap de SoWs (Sprint 8)

| SoW | Enfoque | Effort |
|-----|---------|:------:|
| ByaML-001 | Restart scaffold: clone + audit + `byaml-spec` (Apache-2.0) | ~4h |
| ByaML-002 | Architecture Graph v0.4: spec + JSON Schema + `byaml` PyPI (validate/convert) + catalog ≥17 | ~5h |
| ByaML-003 | Schema registry API v2 (schema.byaml.org): versionado + publish.sh + endpoints | ~6h |
| ByaML-004 | byaml-mcp v2: 8+ tools graph+findings+remediation (AI-native) | ~5h |
| ByaML-005 | byaml.org web v2: narrativa graph + demo interactiva + docs | ~6h |
| ByaML-006 | Integración SOFE (graph endpoint + topology) + catalog vivo + deprecación | ~5h |
| nan-001/002/003 | Graph Core / Blast Radius / Cost Propagation (`nan-graph` PyPI) | ~11h |

**Total sprint (sin Ñan):** ~31h · **Con Ñan:** ~42h
