---
name: git-conventional
description: >
  Git + SemVer + Conventional Commits. Detect/init versioning, validate commits, configure gh CLI, generate changelogs.
  Triggers on: versioning, git setup, conventional commits, semantic versioning, gh cli, changelog,
  release, tags, commit format.
---

# Git Conventional

Detect repo state -> guide through Git, SemVer, Conventional Commits, gh CLI.

## Operating Principles

- Explain state in simple language first
- Teaching tone for non-experts
- Smallest correct change
- Don't assume versioning — verify Git, tags, version source
- Ask before changing files, installing deps, modifying CI

## Step 1 — Detect Current State

```bash
git rev-parse --is-inside-work-tree 2>/dev/null
git tag --list
git remote -v
git status --short
git log --oneline -5 2>/dev/null
```

Stack-specific version source:

```bash
cat package.json 2>/dev/null | grep version
cat *.podspec 2>/dev/null | grep version
grep -r "MARKETING_VERSION" *.xcodeproj/project.pbxproj 2>/dev/null
cat pyproject.toml 2>/dev/null | grep version
cat Cargo.toml 2>/dev/null | grep version
```

Record: Git present? tags? latest tag? remotes? version source? current version?

## Step 2 — Explain State

| Scenario | Meaning | Recommendation |
|----------|---------|----------------|
| No Git repo | Not versioned | Init Git, add .gitignore, first commit |
| Git but no tags | Versioned, not released | Start SemVer at 0.1.0 or 1.0.0 |
| Tags but inconsistent version source | Fragmented versioning | Choose single source of truth |
| GitHub project | Collaboration + release flow | Install + configure gh |
| No commit conventions | Hard to automate history | Add Conventional Commits |

Always propose **SemVer** (`MAJOR.MINOR.PATCH`) + **Conventional Commits**.

## Step 3 — Propose Path

Unversioned repo sequence:
1. Init Git
2. Add .gitignore
3. First commit
4. Tags when ready to release
5. Install + configure gh (if GitHub)
6. Add Conventional Commits validation

Wait for approval before changes.

## Step 4 — Conventional Commits

Format:

```
<type>(<scope>): <description>

[optional body]

[optional footer(s)]
```

### Types

| Type | SemVer bump | Use when |
|------|-------------|----------|
| `feat` | MINOR | New feature |
| `fix` | PATCH | Bug fix |
| `docs` | none | Documentation only |
| `style` | none | Formatting, whitespace |
| `refactor` | none | Code restructure, no behavior change |
| `perf` | PATCH | Performance improvement |
| `test` | none | Adding/updating tests |
| `chore` | none | Build, CI, tooling, deps |
| `ci` | none | CI configuration |
| `build` | none | Build system |
| `revert` | PATCH | Reverting a commit |

### Breaking Changes

`!` after type/scope, or `BREAKING CHANGE:` in footer. Either bumps MAJOR.

```
feat(auth): add OAuth2 login flow
fix(api): handle null response from user endpoint
feat(ui)!: redesign dashboard layout
chore(deps): update dependencies
```

### Git Hook

```bash
mkdir -p .githooks
cat > .githooks/commit-msg << 'HOOK'
#!/bin/sh
MSG=$(cat "$1")
PATTERN="^(feat|fix|docs|style|refactor|perf|test|chore|ci|build|revert)(\(.+\))?!?: .{1,100}"
if ! echo "$MSG" | grep -qE "$PATTERN"; then
  echo "ERROR: Invalid commit message format."
  echo "Expected: type(scope): description"
  echo "Types: feat, fix, docs, style, refactor, perf, test, chore, ci, build, revert"
  exit 1
fi
HOOK
chmod +x .githooks/commit-msg
git config core.hooksPath .githooks
```

### .gitignore Templates

**Node.js:**
```
node_modules/ dist/ .env *.log .DS_Store coverage/
```

**Swift/iOS:**
```
.build/ xcuserdata/ DerivedData/ .DS_Store *.ipa Pods/
```

**Python:**
```
__pycache__/ *.pyc .venv/ dist/ *.egg-info/ .env
```

## Step 5 — GitHub Integration

If remote points to github.com:

```bash
which gh || echo "NEEDS_INSTALL"

# macOS:  brew install gh
# Ubuntu: sudo apt install gh
# Fedora: sudo dnf install gh

gh auth status 2>/dev/null || echo "Run: gh auth login"
```

After auth, enables:
- `gh pr create` / `gh pr merge`
- `gh release create vX.Y.Z --generate-notes`
- `gh issue create`
- `gh api`

## Step 6 — Generate Changelog

```bash
LAST_TAG=$(git describe --tags --abbrev=0 2>/dev/null || echo "")
LOG_RANGE="${LAST_TAG:+$LAST_TAG..HEAD}"

echo "## What's New\n"
git log $LOG_RANGE --pretty=format:"%s" | grep -E "^feat" | sort
echo ""
echo "## Bug Fixes\n"
git log $LOG_RANGE --pretty=format:"%s" | grep -E "^fix" | sort
echo ""
git log $LOG_RANGE --pretty=format:"%s" | grep -E "BREAKING" && echo "Breaking Changes detected"
```

GitHub releases: `gh release create vX.Y.Z --generate-notes`

## Rules

- No force-push to main/master without explicit approval
- No push to remote without approval unless user asked
- Agent always uses Conventional Commits
- Tags: `vMAJOR.MINOR.PATCH`
- Set up .gitignore before first commit
- Ask before installing packages or modifying CI

## Language

- Match user's language
- Technical terms in English when standard
