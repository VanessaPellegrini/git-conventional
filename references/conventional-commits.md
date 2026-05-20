# Conventional Commits Reference

Based on [Conventional Commits 1.0.0](https://www.conventionalcommits.org/en/v1.0.0/).

## Specification

### Commit Message Structure

```
<type>[optional scope][!]: <description>

[optional body]

[optional footer(s)]
```

### Rules

1. **Type** must be one of the standard types (feat, fix, etc.) or a custom type agreed upon by the team.
2. **Scope** is optional and enclosed in parentheses. Represents the module/component affected.
3. **Breaking change** indicated by `!` before `:` OR `BREAKING CHANGE:` in footer.
4. **Description** is mandatory, concise, in imperative mood ("add feature" not "added feature").
5. **Body** is optional, separated by blank line. Explain *why*, not *how*.
6. **Footer(s)** are optional, one per line. Format: `Token: Value`.

### Complete Type Reference

| Type | Description | Version Impact |
|---|---|---|
| `feat` | New feature for the user | MINOR (or MAJOR with `!`) |
| `fix` | Bug fix for the user | PATCH (or MAJOR with `!`) |
| `docs` | Documentation changes | none |
| `style` | Formatting, missing semicolons, etc. | none |
| `refactor` | Code restructuring without behavior change | none |
| `perf` | Performance improvement | PATCH |
| `test` | Adding or updating tests | none |
| `chore` | Build process, tooling, dependencies | none |
| `ci` | CI/CD configuration | none |
| `build` | Build system or external dependencies | none |
| `revert` | Reverting a previous commit | PATCH |

### Examples

#### Simple commit
```
feat: add email notification on signup
```

#### Scoped commit
```
fix(auth): resolve token expiration edge case
```

#### Breaking change (exclamation)
```
feat(api)!: change user endpoint response format
```

#### Breaking change (footer)
```
feat(api): change user endpoint response format

BREAKING CHANGE: user endpoint now returns { data: {...} } instead of {...}
```

#### Multiple footers
```
fix(parser): handle empty input gracefully

Refs: #123
Reviewed-by: @username
```

### Semantic Versioning Mapping

| Commit | Version bump |
|---|---|
| `fix:` | PATCH (1.0.0 → 1.0.1) |
| `feat:` | MINOR (1.0.0 → 1.1.0) |
| `BREAKING CHANGE:` or `!` | MAJOR (1.0.0 → 2.0.0) |
| Everything else | No bump (chore, docs, etc.) |

### Scope Examples by Project Type

- **Full-stack**: `api`, `ui`, `db`, `auth`, `core`
- **Frontend**: `components`, `hooks`, `styles`, `routes`, `state`
- **Backend**: `controllers`, `models`, `middleware`, `routes`, `services`
- **Mobile**: `views`, `viewmodels`, `models`, `services`, `networking`
- **Library**: `export`, `types`, `utils`, `config`

### Integration with Tools

- **commitlint**: Lint commit messages in CI
- **standard-version** / **semantic-release**: Auto-versioning + changelog
- **conventional-changelog**: Generate changelogs from commits
- **gh release create --generate-notes**: GitHub release notes from conventional commits

### Common `.gitignore` Templates

#### Node.js
```
node_modules/
dist/
.env
*.log
.DS_Store
coverage/
```

#### Swift/iOS
```
.build/
xcuserdata/
*.xcworkspace/xcuserdata/
DerivedData/
.DS_Store
*.ipa
Pods/
```

#### Python
```
__pycache__/
*.pyc
.venv/
dist/
*.egg-info/
.env
```
