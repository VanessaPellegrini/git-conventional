# git-conventional 🐶

> Configuración de agente para versionar proyectos con Git, Conventional Commits y GitHub CLI.

Hecho con curiosidad por Van & Purim 🐶

---

## ¿Qué es esto?

Es una **skill para agentes de IA** (como OpenClaw, Codex, etc.) que les permite:

1. **Auditar el estado de versionamiento** de cualquier proyecto
2. **Proponer una estrategia** de versionado apropiada
3. **Configurar Git + Conventional Commits** desde cero
4. **Instalar y configurar GitHub CLI** (`gh`) para gestión de PRs, releases e issues
5. **Generar changelogs** automáticamente a partir de los commits

Y este README explica a humanos cómo funciona todo.

---

## ¿Qué es Git?

Git es un sistema de control de versiones. Piensa en él como un **historial infinito de guardado** para tu código.

```bash
# Iniciar un repositorio
git init

# Ver qué cambió
git status

# Guardar cambios
git add .
git commit -m "feat: add login page"

# Subir a GitHub
git push origin main
```

### Conceptos clave

| Concepto | Qué es |
|---|---|
| **Repo** | La carpeta de tu proyecto + todo su historial |
| **Commit** | Un "guardado" con mensaje descriptivo |
| **Branch** | Una línea de desarrollo paralela |
| **Tag** | Una etiqueta para marcar una versión (ej: `v1.0.0`) |
| **Remote** | La copia en la nube (GitHub, GitLab, etc.) |
| **PR** | Pull Request — pedir que integren tus cambios |

---

## ¿Qué son los Conventional Commits?

Un estándar para escribir mensajes de commit consistentes y legibles:

```
<tipo>(<ámbito>): <descripción>
```

### Ejemplos

```
feat(auth): agregar login con Google
fix(api): corregir error cuando el usuario no existe
docs: actualizar README
chore(deps): actualizar dependencias
feat(ui)!: rediseñar dashboard completo  ← Breaking change!
```

### Tipos

| Tipo | Cuándo usarlo | Impacta versión |
|---|---|---|
| `feat` | Nueva funcionalidad | Minor (1.0.0 → 1.1.0) |
| `fix` | Corrección de bug | Patch (1.0.0 → 1.0.1) |
| `docs` | Solo documentación | No |
| `style` | Formato, espacios | No |
| `refactor` | Reestructurar código | No |
| `perf` | Mejora de rendimiento | Patch |
| `test` | Tests | No |
| `chore` | Herramientas, CI, deps | No |
| `!` o `BREAKING CHANGE` | Cambio incompatible | Major (1.0.0 → 2.0.0) |

### ¿Por qué usarlos?

- **Changelogs automáticos** — cada `feat` y `fix` se convierte en una entrada
- **Versionado semántico automático** — el tipo de commit determina si subir PATCH, MINOR o MAJOR
- **Historial legible** — cualquier persona entiende qué cambió y por qué
- **Colaboración más fácil** — estándar común entre desarrolladores

---

## ¿Cómo funciona esta skill de agente?

Cuando un agente con esta skill revisa tu proyecto, hace esto:

### Paso 1: Diagnóstico
Detecta si tu proyecto tiene Git, si tiene tags, qué sistema de paquetes usa (npm, Swift, Python, etc.), y cuál es la versión actual.

### Paso 2: Propuesta
Te sugiere una estrategia de versionado basada en tu proyecto. No cambia nada sin tu aprobación.

### Paso 3: Configuración
Si aceptas, configura:
- `.gitignore` apropiado para tu stack
- Git hooks para validar que los commits sigan el formato correcto
- GitHub CLI (`gh`) si usas GitHub

### Paso 4: Uso continuo
A partir de ahí, el agente hace commits con formato convencional, genera tags, crea releases y PRs usando `gh`.

---

## Instalación como skill

### En OpenClaw

```bash
openclaw skills add git-conventional /ruta/a/esta/carpeta
```

### En otro agente

Copiá la carpeta `git-conventional/` al directorio de skills de tu agente. El archivo `SKILL.md` contiene las instrucciones que el agente sigue.

---

## GitHub CLI (`gh`)

Si usás GitHub, esta skill instala `gh` automáticamente. ¿Para qué sirve?

```bash
# Crear un Pull Request
gh pr create --title "feat: add search" --body "Adds search functionality"

# Crear un release
gh release create v1.2.0 --generate-notes

# Crear un issue
gh issue create --title "Bug: login fails on Safari"

# Ver estado de PRs
gh pr status
```

### Instalación manual

```bash
# macOS
brew install gh

# Ubuntu/Debian
sudo apt install gh

# Autenticarse
gh auth login
```

---

## Estructura del repositorio

```
git-conventional/
├── SKILL.md                          # Instrucciones para el agente
├── README.md                         # Este archivo (para humanos)
├── references/
│   └── conventional-commits.md       # Referencia completa de Conventional Commits
└── scripts/
    └── install-gh.sh                 # Script para instalar GitHub CLI
```

---

## Licencia

MIT

---

_Hecho con curiosidad por Van & Purim 🐶_
