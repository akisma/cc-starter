# Skill: Spec-Driven Development

## Purpose
Build features by writing a specification first, then using that spec as the prompt for implementation. This produces more predictable results and reduces back-and-forth iteration.

## When to Use
- Starting any new feature or component
- When requirements are complex or multi-step
- When multiple people need to agree on behavior before building
- When you want the AI to generate code that matches specific expectations

## Process

### Step 1: Write the Spec

Use domain-oriented language that describes business intent, not implementation details.

**Good spec structure:**
```markdown
# Feature: [Name]

## What It Does
[1-2 sentence description of the feature's purpose]

## Who It's For
[The user or persona this serves]

## Behavior

### Scenario: [Happy path]
- Given: [starting state]
- When: [user action]
- Then: [expected outcome]

### Scenario: [Edge case]
- Given: [starting state]
- When: [unusual action]
- Then: [expected outcome]

## Constraints
- [Performance requirements]
- [Security requirements]
- [Compatibility requirements]

## Out of Scope
- [What this feature does NOT do]
```

### Step 2: Review the Spec

Before implementing, verify:
- Does it cover the happy path?
- Does it cover error cases?
- Is it specific enough that two different developers would build roughly the same thing?
- Is it free of implementation details (how) and focused on behavior (what)?

### Step 3: Implement from the Spec

Use the spec as your primary prompt. Each Given/When/Then scenario becomes a test case. The implementation should make all scenarios pass.

### Step 4: Iterate on the Spec, Not the Code

If the result isn't right, update the spec first, then regenerate. Don't patch code directly - that leads to drift between intent and implementation.

## Example

**Bad prompt:** "Add a search bar to the page"

**Good spec:**
```markdown
# Feature: Campaign Search

## What It Does
Lets users quickly find campaigns by name, status, or date range.

## Behavior

### Scenario: Search by name
- Given: User is on the campaigns list page
- When: User types "Holiday" in the search bar
- Then: List filters to show only campaigns with "Holiday" in the name
- Then: Results update as the user types (debounced 300ms)

### Scenario: No results
- Given: User is on the campaigns list page
- When: User types a search term that matches nothing
- Then: List shows "No campaigns found" message
- Then: Search bar stays populated with the search term

### Scenario: Clear search
- Given: User has an active search filter
- When: User clicks the X button in the search bar
- Then: Search bar clears
- Then: Full campaign list is restored
```

## Reference
- [Thoughtworks: Spec-Driven Development](https://www.thoughtworks.com/en-us/insights/blog/agile-engineering-practices/spec-driven-development-unpacking-2025-new-engineering-practices)

## Checklist
- [ ] Spec covers happy path scenarios
- [ ] Spec covers error/edge cases
- [ ] Spec uses domain language, not implementation details
- [ ] Each scenario is testable (Given/When/Then)
- [ ] Spec reviewed before implementation begins
