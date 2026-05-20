---
name: git-conventional
description: >
  Review, set up, and manage project versioning using Git and Conventional Commits.
  Use when a project needs versioning audit, initial git setup with Conventional Commits
  config, GitHub integration with gh CLI, commit hygiene validation, or release/changelog
  generation. Triggers on: versionar, git setup, conventional commits, semantic versioning,
  gh cli, changelog, release, tag version.
---

# Git Conventional

Set up and manage project versioning with Conventional Commits and optional GitHub CLI integration.

## Step 1 — Detect Project State

Run in order:

```bash
git rev-parse --is-inside-work-tree 2>/dev/null   # Is it a git repo?
git tag --list                                     # Existing tags?
git remote -v                                      # Remotes?
cat package.json 2>/dev/null | grep version        # Node?
cat *.podspec 2>/dev/null | grep version           # iOS?
grep -r "MARKETING_VERSION" *.xcodeproj/project.pbxproj 2>/dev/null  # Xcode?
cat pyproject.toml 2>/dev/null | grep version      # Python?
cat Cargo.toml 2>/dev/null | grep version          # Rust?
```

Record: git repo (yes/no), tags, latest tag, remotes, version file, current version, stack.

## Step 2 — Propose Versioning Strategy

Based on state, propose to the user:

| Scenario | Recommendation |
|----------|---------------|
| No git repo | Init repo, create `.gitignore`, first commit |
| No tags | Start at `0.1.0` or `1.0.0` based on project maturity |
| Tags but inconsistent | Adopt SemVer from current state |
| Node project | `package.json` version as source of truth |
| Swift/iOS | MARKETING_VERSION in project.pbxproj |
| Python | `pyproject.toml` version |
| Multiple sources | Consolidate to single source |

Always propose **Semantic Versioning** (MAJOR.MINOR.PATCH) with **Conventional Commits**.

Wait for user approval before making changes.

## Step 3 — Conventional Commits Setup

Commit format:

```
<type>(<scope>): <description>

[optional body]

[optional footer(s)]
```

### Types

| Type | SemVer bump | Use when |
|------|------------|----------|
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

Use `!` after type/scope OR `BREAKING CHANGE:` in footer. Either bumps MAJOR.

Examples:
```
feat(auth): add OAuth2 login flow
fix(api): handle null response from user endpoint
feat(ui)!: redesign dashboard layout
chore(deps): update dependencies
```

### Git Hook

Create `.githooks/commit-msg` to validate format:

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
node_modules/
dist/
.env
*.log
.DS_Store
coverage/
```

**Swift/iOS:**
```
.build/
xcuserdata/
DerivedData/
.DS_Store
*.ipa
Pods/
```

**Python:**
```
__pycache__/
*.pyc
.venv/
dist/
*.egg-info/
.env
```

## Step 4 — GitHub Integration

If user uses GitHub or remotes point to `github.com`:

```bash
# Check if gh is installed
which gh || echo "NEEDS_INSTALL"

# Install gh if missing
# macOS:
brew install gh
# Ubuntu/Debian:
sudo apt install gh
# Fedora:
sudo dnf install gh

# Authenticate (interactive — user must complete)
gh auth status 2>/dev/null || echo "Run: gh auth login"
```

After auth, `gh` enables:
- `gh pr create` — create pull requests
- `gh release create vX.Y.Z --generate-notes` — create releases with auto-notes
- `gh issue create` — create issues
- `gh pr merge` — merge PRs
- `gh api` — direct GitHub API access

## Step 5 — Generate Changelog

From conventional commits:

```bash
LAST_TAG=$(git describe --tags --abbrev=0 2>/dev/null || echo "")
LOG_RANGE="${LAST_TAG:+$LAST_TAG..HEAD}"

# Group by type
echo "## What's New\n"
git log $LOG_RANGE --pretty=format:"%s" | grep -E "^feat" | sed 's/^feat(\([^)]*\)):/:sparkles: (\1) /;s/^feat:/:sparkles: /' | sort
echo ""
echo "## Bug Fixes\n"
git log $LOG_RANGE --pretty=format:"%s" | grep -E "^fix" | sed 's/^fix(\([^)]*\)):/:bug: (\1) /;s/^fix:/:bug: /' | sort
echo ""
git log $LOG_RANGE --pretty=format:"%s" | grep -E "BREAKING" && echo "⚠️ Breaking Changes detected"
```

For GitHub releases: `gh release create vX.Y.Z --generate-notes`.

## Rules

- NEVER force-push to main/master without explicit user approval
- NEVER push to remote without user approval (local commits are OK)
- Always use Conventional Commits for commits the agent creates
- Tag format: `vMAJOR.MINOR.PATCH` (e.g., `v1.2.3`)
- Set up `.gitignore` before first commit
- Ask before installing packages or modifying CI configuration

## Language

- Match user's language
- Technical terms keep original English when standard
