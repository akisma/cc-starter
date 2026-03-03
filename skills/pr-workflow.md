# Skill: Pull Request Workflow

## Purpose
Create pull requests that are easy to review, clearly communicate what changed and why, and are ready to merge when submitted.

## When to Use
- When a feature, fix, or piece of work is complete on a branch
- When you want feedback on work in progress (draft PR)

## Process

### Step 1: Verify Before Creating the PR

Before creating a PR, confirm:
- [ ] All tests pass
- [ ] Build succeeds
- [ ] No lint errors or warnings
- [ ] Documentation is updated
- [ ] Branch is up to date with the base branch

### Step 2: Create the PR

**Title:** Short, descriptive, under 70 characters.

```
feat: add campaign search with debounced filtering
fix: resolve token expiration on long sessions
design: new dashboard layout with responsive grid
```

**Description template:**

```markdown
## Summary
[1-3 bullet points describing what this PR does and why]

## Changes
- [Specific change 1]
- [Specific change 2]
- [Specific change 3]

## How to Test
1. [Step to verify the change works]
2. [Step to verify edge cases]

## Screenshots (if UI changes)
[Before/after or just the new state]
```

### Step 3: Self-Review

Before requesting review:
- Read through every changed file
- Check for debug code, console.logs, commented-out code
- Verify no secrets or credentials are included
- Ensure commit history is clean (no "fix typo" chains)

## PR Size Guidelines

| Size | Lines Changed | Review Time | Risk |
|------|--------------|-------------|------|
| Small | < 200 | Quick | Low |
| Medium | 200-500 | Moderate | Medium |
| Large | 500+ | Long | High - consider splitting |

**Prefer small PRs.** A feature can be split into multiple PRs (e.g., data layer first, then UI, then integration).

## Example

**Good PR:**
```
Title: feat: add campaign search with debounced filtering

## Summary
- Adds a search bar to the campaigns list page
- Filters campaigns by name as the user types (300ms debounce)
- Shows "No campaigns found" for empty results

## Changes
- New `useCampaignSearch` hook for search logic
- Updated `CampaignList` component with search input
- Added 6 tests covering search, empty state, and clear

## How to Test
1. Go to /campaigns
2. Type "Holiday" in the search bar
3. Verify list filters to matching campaigns
4. Clear the search and verify full list returns
```

## Checklist
- [ ] Title is descriptive and under 70 characters
- [ ] Description explains what and why
- [ ] "How to Test" section is included
- [ ] All tests pass
- [ ] Build succeeds
- [ ] No debug code or secrets
- [ ] PR is a reasonable size (< 500 lines preferred)
