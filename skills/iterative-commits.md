# Skill: Iterative Commits

## Purpose
Make small, atomic commits after each logical change. This creates a clear history, makes code review easier, and makes it simple to undo a specific change if needed.

## When to Use
- Any time you're building or modifying code
- Especially important during multi-step features
- When working on a feature branch

## Pattern

### When to Commit

Commit after each of these:
- A new test is written and passes
- A function or component is implemented
- A bug is fixed
- A refactor is complete
- Configuration is changed
- Documentation is updated

**Do NOT batch everything into one commit at the end.** Each commit should represent one logical change.

### Commit Message Format

```
[type]: [what changed and why]

Types:
  feat:     New feature or functionality
  fix:      Bug fix
  test:     Adding or updating tests
  refactor: Code restructuring without behavior change
  docs:     Documentation only
  style:    Formatting, no code change
  chore:    Build, config, dependency updates
```

### Examples

**Good commits (atomic, clear):**
```
feat: add campaign search input with debounced filtering
test: add tests for campaign search empty state
fix: prevent search from firing on mount with empty query
refactor: extract search logic into useCampaignSearch hook
docs: update TECHNICAL_DOCUMENTATION with search architecture
```

**Bad commits (batched, vague):**
```
update code
fix stuff
WIP
added search and also fixed the bug and updated tests
```

### The Rhythm

```
1. Make a small, focused change
2. Run tests to verify nothing broke
3. Commit with a clear message
4. Move to the next change
```

### Branch Naming

```
feature/[description]    - new features
fix/[description]        - bug fixes
hotfix/[description]     - urgent production fixes
design/[description]     - design/UI work
refactor/[description]   - code restructuring
chore/[description]      - build, config, dependency updates
release/[description]    - NEVER create unless explicitly requested
```

Examples:
- `feature/campaign-search`
- `fix/login-timeout`
- `hotfix/auth-token-expiry`
- `design/dashboard-redesign`

## Checklist
- [ ] Each commit is one logical change
- [ ] Commit message starts with a type prefix
- [ ] Commit message explains what AND why
- [ ] Tests pass before committing
- [ ] No "WIP" or vague messages in final history
