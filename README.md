# Git Conventional

Open-source AI agent skill for **project versioning with Git and Conventional Commits**.

Compatible with any agent that supports SKILL.md (OpenClaw, Claude Code, Codex, Cursor, and 50+ more).

## Install

```bash
npx skills add VanessaPellegrini/git-conventional
```

## What it does

| Feature | Description |
|---------|-------------|
| Versioning audit | Review current git/tag state and propose a versioning strategy |
| Git setup | Initialize repo with `.gitignore` and first commit |
| Conventional Commits | Enforce commit format with git hooks |
| GitHub CLI | Install and configure `gh` for PRs, releases, and issues |
| Changelog generation | Auto-generate changelogs from conventional commits |

## Example

```
You: "I need to version this project"
Agent: [loads git-conventional]
Agent: "Detecting project state... Node.js project, no git repo, no tags."
Agent: "Proposing: init git repo, start at v0.1.0, Conventional Commits with scope by module."
```

```
You: "Create a release for the new auth feature"
Agent: "Since last tag (v1.1.0), there are 3 feat and 2 fix commits."
Agent: "Bumping to v1.2.0. Creating tag and GitHub release..."
```

## Conventional Commits

Every commit follows this format:

```
<type>(<scope>): <description>
```

| Type | Version bump | Use when |
|------|-------------|----------|
| `feat` | MINOR | New feature |
| `fix` | PATCH | Bug fix |
| `docs` | — | Documentation only |
| `style` | — | Formatting |
| `refactor` | — | Code restructure |
| `perf` | PATCH | Performance improvement |
| `test` | — | Adding/updating tests |
| `chore` | — | Build, CI, tooling |
| `!` or `BREAKING CHANGE` | MAJOR | Incompatible change |

## GitHub CLI

If the project uses GitHub, the skill installs `gh` and enables:

```bash
gh pr create --title "feat: add search" --body "Adds search"
gh release create v1.2.0 --generate-notes
gh issue create --title "Bug: login fails on Safari"
```

## Contributing

Open project. Contributions welcome.

## License

MIT

---

_Made with curiosity by Van & Purim 🐶_
