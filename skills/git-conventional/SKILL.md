---
name: git-conventional
description: >
  Git + SemVer + Conventional Commits. Detect/init versioning, validate commits, configure gh CLI, generate changelogs.
  Triggers on: versioning, git setup, conventional commits, semantic versioning, gh cli, changelog, release, tags.
---

# Git Conventional

Detect repo state -> guide Git + SemVer + Conventional Commits + gh CLI.

## Step 1 — Detect State

Run these, record findings:

```bash
git rev-parse --is-inside-work-tree 2>/dev/null
git tag --list
git remote -v
git status --short
git log --oneline -5 2>/dev/null
# Version source (pick relevant):
cat package.json | grep version
grep "MARKETING_VERSION" *.xcodeproj/project.pbxproj
cat pyproject.toml | grep version
```

## Step 2 — Assess & Propose

| State | Meaning | Action |
|-------|---------|--------|
| No Git | Not versioned | Init + .gitignore + first commit |
| Git, no tags | Versioned, no releases | Start SemVer at 0.1.0 or 1.0.0 |
| Tags, inconsistent version | Fragmented | Single source of truth |
| GitHub remote | Collaboration ready | Install + configure `gh` |

Always propose **SemVer** + **Conventional Commits**. Wait for approval before changes.

## Step 3 — Conventional Commits

Format: `<type>(<scope>): <description>`

| Type | SemVer | Use when |
|------|--------|----------|
| `feat` | MINOR | New feature |
| `fix` | PATCH | Bug fix |
| `docs` | none | Documentation |
| `style` | none | Formatting |
| `refactor` | none | Restructure, no behavior change |
| `perf` | PATCH | Performance |
| `test` | none | Tests |
| `chore` | none | Build, CI, deps |
| `ci` | none | CI config |
| `build` | none | Build system |
| `revert` | PATCH | Revert |

**Breaking:** `!` after type/scope or `BREAKING CHANGE:` in footer -> bumps MAJOR.

```
feat(auth): add OAuth2 login flow
fix(api): handle null response
feat(ui)!: redesign dashboard
chore(deps): update dependencies
```

## Step 4 — Git Hook (optional)

```bash
mkdir -p .githooks
cat > .githooks/commit-msg << 'HOOK'
#!/bin/sh
MSG=$(cat "$1")
PATTERN="^(feat|fix|docs|style|refactor|perf|test|chore|ci|build|revert)(\(.+\))?!?: .{1,100}"
if ! echo "$MSG" | grep -qE "$PATTERN"; then
  echo "ERROR: Invalid commit message. Expected: type(scope): description"
  exit 1
fi
HOOK
chmod +x .githooks/commit-msg
git config core.hooksPath .githooks
```

## Step 5 — GitHub CLI

If remote is github.com:

```bash
which gh || echo "NEEDS_INSTALL"
gh auth status 2>/dev/null || echo "Run: gh auth login"
```

Enables: `gh pr create/merge`, `gh release create vX.Y.Z --generate-notes`, `gh issue create`.

## Step 6 — Changelog

```bash
LAST_TAG=$(git describe --tags --abbrev=0 2>/dev/null)
git log ${LAST_TAG:+$LAST_TAG..HEAD} --pretty=format:"%s" | grep -E "^feat" | sort
git log ${LAST_TAG:+$LAST_TAG..HEAD} --pretty=format:"%s" | grep -E "^fix" | sort
```

Or: `gh release create vX.Y.Z --generate-notes`

## Rules

- No force-push to main without explicit approval
- No push to remote without approval
- Agent always uses Conventional Commits
- Tags: `vMAJOR.MINOR.PATCH`
- .gitignore before first commit
- Ask before installing packages or modifying CI
- Match user's language; technical terms in English
