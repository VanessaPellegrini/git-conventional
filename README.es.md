# Git Conventional

Skill de agente de IA open-source para **versionar proyectos con Git y Conventional Commits**.

Compatible con cualquier agente que soporte SKILL.md (OpenClaw, Claude Code, Codex, Cursor, y más de 50 más).

## Instalar

```bash
npx skills add VanessaPellegrini/git-conventional
```

## Qué hace

| Funcionalidad | Descripción |
|---------------|-------------|
| Auditoría de versionado | Revisa el estado actual de git/tags y propone una estrategia |
| Setup de Git | Inicializa repo con `.gitignore` y primer commit |
| Conventional Commits | Aplica formato de commits con git hooks de validación |
| GitHub CLI | Instala y configura `gh` para PRs, releases e issues |
| Generación de changelog | Genera changelogs automáticos desde los commits convencionales |

## Ejemplo

```
Vos: "Necesito versionar este proyecto"
Agente: [carga git-conventional]
Agente: "Detectando estado... Proyecto Node.js, sin repo git, sin tags."
Agente: "Propongo: init git repo, empezar en v0.1.0, Conventional Commits con scope por módulo."
```

```
Vos: "Creá un release para la nueva feature de auth"
Agente: "Desde el último tag (v1.1.0), hay 3 feat y 2 fix commits."
Agente: "Subiendo a v1.2.0. Creando tag y release en GitHub..."
```

## Conventional Commits

Cada commit sigue este formato:

```
<tipo>(<ámbito>): <descripción>
```

| Tipo | Impacto en versión | Cuándo usarlo |
|------|-------------------|---------------|
| `feat` | MINOR | Nueva funcionalidad |
| `fix` | PATCH | Corrección de bug |
| `docs` | — | Solo documentación |
| `style` | — | Formato, espacios |
| `refactor` | — | Reestructuración de código |
| `perf` | PATCH | Mejora de rendimiento |
| `test` | — | Tests |
| `chore` | — | Build, CI, herramientas |
| `!` o `BREAKING CHANGE` | MAJOR | Cambio incompatible |

## GitHub CLI

Si el proyecto usa GitHub, la skill instala `gh` y habilita:

```bash
gh pr create --title "feat: agregar búsqueda" --body "Agrega funcionalidad de búsqueda"
gh release create v1.2.0 --generate-notes
gh issue create --title "Bug: login falla en Safari"
```

## Contribuir

Proyecto abierto. Contribuciones bienvenidas.

## Licencia

MIT

---

_Hecho con curiosidad por Van & Purim 🐶_
