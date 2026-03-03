# Skill: Creating New Skills

## Purpose
Recognize when a repeated pattern should become a reusable skill, create it properly, and contribute it to the shared team repository.

## When to Use
- You've done the same kind of task 3+ times
- You find yourself giving the same instructions repeatedly
- A pattern works well and others would benefit from it
- You've solved a tricky problem and want to capture the solution

## Recognizing a Skill Opportunity

Ask yourself:
- "Am I explaining this same thing again?"
- "Did I just solve something I'll need to solve again?"
- "Would a new team member need to figure this out from scratch?"

If yes to any of these, it's time for a skill.

## Skill Template

Create a file in `.claude/skills/[skill-name].md`:

```markdown
# Skill: [Name]

## Purpose
[1-2 sentences: what this skill helps you accomplish]

## When to Use
- [Scenario 1]
- [Scenario 2]
- [Scenario 3]

## Process

### Step 1: [First thing to do]
[Explanation and/or code example]

### Step 2: [Second thing to do]
[Explanation and/or code example]

### Step 3: [Third thing to do]
[Explanation and/or code example]

## Examples

### Good Example
[Show the pattern done correctly]

### Anti-Pattern
[Show what to avoid and why]

## Checklist
- [ ] [Verification item 1]
- [ ] [Verification item 2]
- [ ] [Verification item 3]
```

## Naming Conventions

- Use lowercase, hyphen-separated names: `store-first-feature.md`, not `StoreFirstFeature.md`
- Name should describe the *what*, not the *when*: `zustand-store-testing.md`, not `when-testing-stores.md`
- Keep names concise but descriptive

## Where Skills Live

- **Project-level:** `.claude/skills/` in your project - auto-loaded by Claude Code
- **Shared:** `ve-agent-tools/skills/` - the team's shared skill library

## Contributing to the Shared Repo

When you create a skill that others would benefit from:

1. Verify it works well in your project first
2. Generalize it - remove project-specific references
3. Copy it to `ve-agent-tools/skills/`
4. Update the skills table in `ve-agent-tools/README.md`
5. Create a PR to the ve-agent-tools repo

**Before contributing, ask:**
- Is this general enough for other projects?
- Does it reference any project-specific code? (Remove it)
- Would someone unfamiliar with your project understand it?

## Good Skills vs. Bad Skills

**Good skill:** Captures a repeatable *process* with clear steps
```
# Skill: Store-First Feature Development
1. Define state shape
2. Define actions
3. Write tests
4. Implement store
5. Build UI
```

**Bad skill:** Just a code snippet with no context
```
# Skill: Create Store
Use zustand to create a store.
```

**Good skill:** Includes anti-patterns and checklist
**Bad skill:** Only shows the happy path

## Checklist
- [ ] Skill has a clear Purpose section
- [ ] "When to Use" scenarios are specific
- [ ] Process steps are actionable
- [ ] At least one example is included
- [ ] Checklist for verification is included
- [ ] No project-specific references (if contributing to shared repo)
