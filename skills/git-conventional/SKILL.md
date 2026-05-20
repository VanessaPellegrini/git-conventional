---
name: git-conventional
description: >
  Teach, audit, and manage project versioning using Git, Semantic Versioning, and Conventional Commits.
  Use when a project needs to check whether it is already versioned, initialize Git, define a versioning
  strategy, validate commit hygiene, configure GitHub CLI, or generate changelogs and release notes.
  Triggers on: versioning, git setup, conventional commits, semantic versioning, gh cli, changelog,
  release, tags, commit format.
---

# Git Conventional

Help the user understand whether a repository is already versioned, then guide them through Git setup,
Semantic Versioning, Conventional Commits, and optional GitHub CLI integration.

## Operating Principles

- Explain the current state first in simple language.
- Use a teaching tone for non-experts.
- Prefer the smallest correct change.
- Do not assume the repository is versioned until Git, tags, and version source are checked.
- Ask before changing files, installing dependencies, or modifying CI.

## Step 1 — Detect Current State

Check, in order:

```bash
git rev-parse --is-inside-work-tree 2>/dev/null
git tag --list
git remote -v
git status --short
git log --oneline -5 2>/dev/null
```

Then inspect the stack-specific source of truth when relevant:

```bash
cat package.json 2>/dev/null | grep version
cat *.podspec 2>/dev/null | grep version
grep -r "MARKETING_VERSION" *.xcodeproj/project.pbxproj 2>/dev/null
cat pyproject.toml 2>/dev/null | grep version
cat Cargo.toml 2>/dev/null | grep version
```

Record whether the repo has Git, tags, a latest tag, remotes, a version source, and a current version.

## Step 2 — Explain the State

Classify the repository for the user:

| Scenario | Meaning | Recommendation |
|----------|---------|----------------|
| No Git repo | Not versioned yet | Initialize Git, add `.gitignore`, create the first commit |
| Git but no tags | Versioned, but not released | Start semantic versioning with `0.1.0` or `1.0.0` |
| Tags but inconsistent version source | Versioning exists but is fragmented | Choose a single source of truth |
| GitHub project | Collaboration and release flow available | Install and configure `gh` |
| No commit conventions | History is harder to automate | Add Conventional Commits |

Always propose **Semantic Versioning** (`MAJOR.MINOR.PATCH`) together with **Conventional Commits**.

## Step 3 — Propose a Path

When the repository is not versioned yet, suggest this sequence:

1. Initialize Git.
2. Add `.gitignore`.
3. Make the first commit.
4. Add tags when the project is ready to release.
5. Install and configure `gh` if GitHub is used.
6. Add Conventional Commits validation.

Wait for user approval before making changes.

## Step 4 — Conventional Commits Setup

Commit format:

```bash
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
| `test` | none | Adding or updating tests |
| `chore` | none | Build, CI, tooling, deps |
| `ci` | none | CI configuration |
| `build` | none | Build system |
| `revert` | PATCH | Reverting a commit |

### Breaking Changes

Use `!` after type or scope, or `BREAKING CHANGE:` in the footer. Either one bumps MAJOR.

Examples:

```bash
feat(auth): add OAuth2 login flow
fix(api): handle null response from user endpoint
feat(ui)!: redesign dashboard layout
chore(deps): update dependencies
```

### Git Hook

Create `.githooks/commit-msg` to validate the format:

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

```bash
node_modules/
dist/
.env
*.log
.DS_Store
coverage/
```

**Swift/iOS:**

```bash
.build/
xcuserdata/
DerivedData/
.DS_Store
*.ipa
Pods/
```

**Python:**

```bash
__pycache__/
*.pyc
.venv/
dist/
*.egg-info/
.env
```

## Step 5 — GitHub Integration

If the project uses GitHub or the remote points to `github.com`:

```bash
which gh || echo "NEEDS_INSTALL"

# macOS
brew install gh

# Ubuntu/Debian
sudo apt install gh

# Fedora
sudo dnf install gh

gh auth status 2>/dev/null || echo "Run: gh auth login"
```

After authentication, `gh` enables:

- `gh pr create` for pull requests
- `gh release create vX.Y.Z --generate-notes` for releases with notes
- `gh issue create` for issues
- `gh pr merge` for merges
- `gh api` for direct GitHub API access

## Step 6 — Generate Changelog

From conventional commits:

```bash
LAST_TAG=$(git describe --tags --abbrev=0 2>/dev/null || echo "")
LOG_RANGE="${LAST_TAG:+$LAST_TAG..HEAD}"

echo "## What's New\n"
git log $LOG_RANGE --pretty=format:"%s" | grep -E "^feat" | sort
echo ""
echo "## Bug Fixes\n"
git log $LOG_RANGE --pretty=format:"%s" | grep -E "^fix" | sort
echo ""
git log $LOG_RANGE --pretty=format:"%s" | grep -E "BREAKING" && echo "⚠️ Breaking Changes detected"
```

For GitHub releases: `gh release create vX.Y.Z --generate-notes`.

## Rules

- Never force-push to `main` or `master` without explicit user approval.
- Never push to a remote without user approval unless the user asked for it.
- Always use Conventional Commits for commits created by the agent.
- Use tags in the form `vMAJOR.MINOR.PATCH`.
- Set up `.gitignore` before the first commit.
- Ask before installing packages or modifying CI configuration.

## Language

- Match the user's language.
- Keep technical terms in English when that is the standard.
