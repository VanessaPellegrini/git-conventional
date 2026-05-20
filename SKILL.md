---
name: git-conventional
description: Review, set up, and manage project versioning using Git and Conventional Commits. Use when a project needs versioning audit, initial git setup with Conventional Commits config, GitHub integration with gh CLI, commit hygiene validation, or release/changelog generation. Triggers on: versionar, git setup, conventional commits, semantic versioning, gh cli, changelog, release, tag version.
---

# Git Conventional — Agent Versioning Skill

Review project versioning and set up Conventional Commits with optional GitHub integration.

## Workflow

### 1. Detect Project State

Run these checks in order:

```bash
git status                  # Is it a git repo?
git tag --list              # Any existing tags?
git remote -v               # Remotes configured?
cat package.json 2>/dev/null | grep version   # Node project?
cat *.podspec 2>/dev/null | grep version       # iOS pod?
grep -r "version" *.xcodeproj/project.pbxproj 2>/dev/null  # Xcode?
cat pyproject.toml 2>/dev/null | grep version   # Python?
```

Record: `{ gitRepo, hasTags, latestTag, remotes, versionFile, currentVersion }`.

### 2. Propose Versioning Strategy

Based on the project state, propose:

| Scenario | Recommendation |
|---|---|
| No git repo | Init repo, add `.gitignore`, first commit |
| No tags | Start at `0.1.0` or `1.0.0` depending on maturity |
| Tags but no pattern | Adopt SemVer from current state |
| Node project | Use `package.json` version as source of truth |
| Swift/iOS | Use MARKETING_VERSION in project.pbxproj |
| Python | Use `pyproject.toml` version |
| Multiple version sources | Consolidate to single source, add sync script |

Always propose **Semantic Versioning** (`MAJOR.MINOR.PATCH`) with **Conventional Commits**.

### 3. Conventional Commits Setup

Enforce this commit format:

```
<type>(<scope>): <description>

[optional body]

[optional footer(s)]
```

**Types:**

| Type | SemVer bump | Use when |
|---|---|---|
| `feat` | MINOR | New feature |
| `fix` | PATCH | Bug fix |
| `docs` | none | Documentation only |
| `style` | none | Formatting, semicolons |
| `refactor` | none | Code restructure |
| `perf` | PATCH | Performance improvement |
| `test` | none | Adding/updating tests |
| `chore` | none | Build, CI, tooling |
| `ci` | none | CI configuration |
| `build` | none | Build system |
| `revert` | PATCH | Revert a commit |

**Breaking changes:** Use `!` after type/scope or add `BREAKING CHANGE:` in footer → bumps MAJOR.

Examples:
```
feat(auth): add OAuth2 login flow
fix(api): handle null response from user endpoint
feat(ui)!: redesign dashboard layout
chore(deps): update dependencies to latest versions
```

For detailed rules and edge cases, see [references/conventional-commits.md](references/conventional-commits.md).

### 4. Git Hooks (Optional but Recommended)

Install commit-msg hook to validate format:

```bash
# Create .githooks/commit-msg
mkdir -p .githooks
cat > .githooks/commit-msg << 'HOOK'
#!/bin/sh
MSG=$(cat "$1")
PATTERN="^(feat|fix|docs|style|refactor|perf|test|chore|ci|build|revert)(\(.+\))?!?: .{1,100}"
if ! echo "$MSG" | grep -qE "$PATTERN"; then
  echo "ERROR: Invalid commit message format."
  echo "Expected: <type>(<scope>): <description>"
  echo "Types: feat, fix, docs, style, refactor, perf, test, chore, ci, build, revert"
  exit 1
fi
HOOK
chmod +x .githooks/commit-msg
git config core.hooksPath .githooks
```

### 5. GitHub Integration

If the user uses GitHub or remotes point to `github.com`:

```bash
# Check if gh is installed
which gh || bash scripts/install-gh.sh

# Authenticate (interactive — user must complete)
gh auth status 2>/dev/null || echo "Run: gh auth login"
```

After authentication, `gh` enables:
- `gh pr create` — create pull requests
- `gh release create v1.0.0` — create releases with auto-notes
- `gh issue create` — create issues
- `gh pr merge` — merge PRs
- `gh api` — direct API access

### 6. Generate Changelog

From Conventional Commits, generate a changelog:

```bash
# Get commits since last tag
LAST_TAG=$(git describe --tags --abbrev=0 2>/dev/null || echo "")
LOG_RANGE="${LAST_TAG:+$LAST_TAG..HEAD}"

# Group by type
echo "## Changes\n"
git log $LOG_RANGE --pretty=format:"%s" | \
  grep -E "^feat" | sed 's/^feat/✨/' | sort && echo
git log $LOG_RANGE --pretty=format:"%s" | \
  grep -E "^fix" | sed 's/^fix/🐛/' | sort && echo
git log $LOG_RANGE --pretty=format:"%s" | \
  grep -E "BREAKING" | sed 's/^/⚠️ /' | sort && echo
```

For release notes: `gh release create vX.Y.Z --generate-notes`.

## Rules

- **NEVER** force-push to `main`/`master` without explicit user approval.
- **NEVER** push to remote without user approval. Local commits are fine.
- Always use Conventional Commits format for commits the agent creates.
- Tag format: `vMAJOR.MINOR.PATCH` (e.g., `v1.2.3`).
- `.gitignore` must be set up before first commit.
