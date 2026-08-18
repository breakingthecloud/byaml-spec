# BYaML Architecture Graph v0.4 — Spec

> **Status:** ✅ Definido (ByaML-002). Base del modelo de la fusión Ñan × BYaML (SOFE Architecture Graph).
> **Repo:** `breakingthecloud/byaml-spec`
> **Schema:** `schema/v0.4/graph-v0.4.schema.json` (JSON Schema draft 2020-12)
> **Catalog:** `schema/v0.4/catalog.yaml` (≥17 tipos desde SOFE collectors)
> **Relationships:** `schema/v0.4/relationships.yaml` (matriz from/to/type)

## 1. Qué es

El **Architecture Graph v0.4** es el modelo normalizado (graph-first) del relanzamiento BYaML v2.
Un grafo dirigido etiquetado:
- **Nodos** = recursos / servicios (`id`, `type`, `layer`, `region`, `account`, `cost`, `findings`, `owner`)
- **Aristas** = relaciones tipadas (`from`, `to`, `type`, `weight`)
- **Atributos** = costo, findings, owners, policies

> Regla de oro (ver DIRECTIVE.md): un mismo modelo (grafo) · serialización BYaML solo para interop ·
> interfaces AI-native (MCP) · la web y el schema API son documentación viva, no producto.

## 2. Principios

1. **Derivado, no autoría:** el grafo se **genera** (SOFE scan, Terraform plan, AWS account, CDK).
   Nadie lo escribe a mano en producción.
2. **Un modelo:** BYaML v0.4 ES la serialización del mismo modelo que consume `nan-graph`.
   No dos formatos. `nan-graph` es el **motor**; `.byaml` es el **wire format**.
3. **Catalog abierto:** `type` no se limita a 13. Baseline = tipos de los SOFE collectors (≥17),
   expandible con tipos custom (warning, no error, para edge cases).

## 3. Modelo

```
Graph v0.4
├── version: "0.4"
├── id?: string
├── generated_from?: { source, eval_id, account, scanned_at, provider }
├── nodes[]: { id, type, layer?, region?, account?, label?, cost?, findings?, owner?, attributes? }
├── edges[]: { from, to, type?, label?, weight? }
└── insights?: { spof[], blast_radius{}, cost_chains[] }   # opcional; precomputa nan-graph
```

### Layering (v0.4)
`edge · networking · compute · data · storage · security · integration · observability · other`

### Tipos (type)
Canonical: `aws.<resource>` alineado a los `resource_type` de los SOFE collectors.
Aliases v0.3 → v0.4: `aws.nat-gateway → aws.natgateway`, `aws.secrets-manager → aws.secretsmanager`.

### Relaciones (edge.type)
Vocabulario: `invokes · routes_to · origin · reads · writes · reads_writes · publishes_to · triggers · monitors · hosts · depends_on · calls · contains`.
Validación contra `relationships.yaml`: combos fuera de la matriz → **WARNING** (no error).

## 4. Interfaz — paquete `byaml` (PyPI)

```python
from byaml import Graph, load, dump, validate, convert

g = convert.from_terraform("tfplan.json", account="279624932954")  # IaC → Graph
g = convert.from_evaluation(findings, cost_map)                  # scan → Graph
ok, errors = validate(g, schema="v0.4")                          # pydantic + JSON Schema
Graph.dump(g, "out.byaml")                                       # serializar
g2 = load("out.byaml")
```

```bash
pip install byaml
byaml validate out.byaml
byaml convert --terraform tfplan.json -o graph.byaml
byaml dump --json graph.byaml
```

## 5. Consumo con nan-graph

`nan-graph` (PyPI `nan-graph` / npm `@carloscortezcloud/nan-graph`) es el motor del grafo:
traversal (BFS/DFS), blast radius, cost chain, fan-in, SPOF. BYaML v0.4 es una serialización
que `nan-graph` puede `from_object`/`from_yaml`. El schema v0.4 valida lo que Ñan procesa.

## 6. Archivos

| Archivo | Rol |
|---------|-----|
| `schema/v0.4/graph-v0.4.schema.json` | JSON Schema (draft 2020-12) |
| `schema/v0.4/catalog.yaml` | Catálogo de tipos (≥17 baseline SOFE + extendido) |
| `schema/v0.4/relationships.yaml` | Matriz de relaciones válidas |
| `schema/v0.4/examples/*.byaml` | 3 ejemplos (minimal, sofe-eval, terraform) |
| `../v0.3/` | Modelo v0.3 migrado (base del v0.4) |

## 7. Fuera de alcance (ByaML-002)

- Traversal/blast radius/cost propagation → `nan-graph` (nan-001/002/003)
- Schema registry API → ByaML-003
- MCP tools → ByaML-004
- Migración de datos v0.3 → no (wire format cambió; converter one-way desde IaC/scan)
