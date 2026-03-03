# Engineering Agent Guide

> This file configures how AI coding agents work with your codebase. Place it at the root of your project as `CLAUDE.md`.

---

## Project Info (fill in and commit)

<!-- PROJECT: [Your project name] -->
<!-- STACK: [e.g., React 19, TypeScript, Vite, Tailwind, Zustand] -->
<!-- TEST_CMD: npm test -->
<!-- BUILD_CMD: npm run build -->
<!-- LINT_CMD: npm run lint -->

## Git Mode

**Default: read-only.** You handle all git. The agent never creates branches, commits, or PRs.

To override this for yourself, add a `CLAUDE.local.md` file (auto-gitignored) with one of:
- `GIT_MODE: approval -- Agent explains git actions, waits for your OK.`
- `GIT_MODE: autonomous -- Agent handles branching, commits, PRs freely.`

---

## Rule 1: Ask Before You Build

**Never implement code without explicit permission.**

When you have a solution:
1. **Explain** your options clearly
2. **Recommend** which you think is best and why
3. **WAIT** for approval before writing any code

Bad: "I'll create a simpler approach..." (then implementing it)
Good: "I see 3 options: A, B, C. I recommend B because... Which should I implement?"

**You CAN implement without asking when:**
- User explicitly says "do it", "go ahead", "implement that"
- User asks for something specific by name
- You're fixing obvious typos or syntax errors in code already being written

---

## Rule 2: Research, Plan, Implement

**Never jump straight to coding.** Always follow this sequence:

```
1. RESEARCH  ->  Read docs/ first, then explore the codebase
2. PLAN      ->  Create a detailed plan, verify it with the user
3. IMPLEMENT ->  TDD: failing test first, then code to pass, refactor, repeat
```

**Research always starts with documentation.** Read `docs/TECHNICAL_DOCUMENTATION.md` and any relevant files in `docs/` before exploring source code. These files describe the architecture, patterns, and decisions that shaped the codebase.

**Implementation always means TDD.** Every feature, bug fix, or refactor starts with a failing test. If you are writing production code without a test that demands it, stop.

Say: "Let me read the project docs and research the codebase before creating a plan."

For complex architectural decisions, use `/effort max` to engage maximum reasoning capacity.

---

## Rule 3: Tests First (TDD)

**No production code without a failing test first.** This is not optional.

```
1. Write a failing test that describes the expected behavior
2. Write the minimal code to make it pass
3. Refactor while keeping tests green
4. Repeat for the next behavior
```

- Never skip tests to "save time"
- Never write code without a test that proves it works
- Never disable or comment out tests to make them pass
- If you're unsure what to test, ask
- If a plan has 5 steps, each step starts with a test

---

## Rule 4: Keep It Simple

- The simple solution is usually the right one
- Don't over-engineer or add abstractions prematurely
- If it feels complicated, stop and ask for direction

---

## Rule 5: Clean Code Only

**NEVER do these:**
- Hardcode passwords, API keys, or secrets
- Leave old code next to new code
- Create versioned names like `handleClickV2`
- Leave TODO comments in final code
- Create random test, debug, or scratch files
- Scatter .md files around the project (use `docs/` folder)

**ALWAYS do these:**
- Delete old code when replacing it
- Use meaningful names (`userName` not `x`, `userID` not `id`)
- Use early returns to reduce nesting

---

## Rule 6: "Done" Means Done

**Nothing is complete until ALL of these are true:**

- [ ] All tests pass (run the test command, don't assume)
- [ ] Build succeeds (run the build command, don't assume)
- [ ] Documentation is updated (in `docs/` or inline where appropriate)
- [ ] Old/unused code is deleted
- [ ] No errors, no warnings, no lint violations

**Run tests and build OFTEN** - after every significant change, not just at the end. If tests fail, STOP everything and fix them before continuing.

**If tests or build fail:**
1. STOP immediately - do not continue with other tasks
2. Fix ALL issues until everything passes
3. Re-run to verify the fix
4. Resume your original task

---

## Rule 7: When Stuck, Ask

Don't spiral into complex solutions. Instead:
1. Stop
2. Tell the user you're stuck
3. Present your options and ask which direction they prefer

Say: "I see two approaches: A vs B. Which do you prefer?"

---

## Context Management

**Avoid working past compaction.** When a conversation gets long:

- Break large tasks into right-sized pieces
- Prefer multiple focused sessions over one marathon session
- When you notice context getting heavy, proactively say: "We're getting deep into this conversation. Want to wrap up this piece and start fresh for the next part?"
- If starting a new session, begin with a summary of what's been done and what's next
- Re-read this CLAUDE.md file when context is long - it's your north star

---

## Use Multiple Agents

Leverage subagents for better results:

- Spawn agents to explore different parts of the codebase in parallel
- Use one agent to write tests while another implements features
- Delegate research tasks: "I'll have an agent investigate the database schema while I analyze the API structure"
- For complex refactors: one agent identifies changes, another implements them

Say: "I'll spawn agents to tackle different aspects of this problem" whenever a task has multiple independent parts.

For a library of agent role examples, browse [awesome-claude-code-subagents](https://github.com/VoltAgent/awesome-claude-code-subagents). If you find a role that fits, copy the `.md` file to your project and reference it at the start of a session (e.g., "Your role for this session is [role]. See [path-to-file]."). Do not install the full collection — pick only what you need.

---

## Git Workflow

**Default: read-only.** Check `CLAUDE.local.md` for any override.

### Branch naming:
- `feature/[description]` - new features
- `fix/[description]` - bug fixes
- `hotfix/[description]` - urgent production fixes
- `design/[description]` - design/UI work
- `refactor/[description]` - code restructuring
- `chore/[description]` - build, config, dependency updates
- `release/[description]` - **NEVER create or modify release branches unless explicitly requested**

### Commits:
- Make atomic commits after each logical change
- Write clear commit messages that explain the *why*
- Don't batch everything into one commit at the end

### Pull Requests:
- Create PRs when a piece of work is complete and tested
- PR description should summarize what changed and why
- Ensure tests pass and build succeeds before creating a PR

---

## Task Tracking

**Primary: Beads (`bd`)**
Use `bd` commands for task management. Beads provides dependency tracking, persistence across sessions, and multi-agent coordination.

**Fallback: TodoWrite**
If Beads isn't installed, use the built-in TodoWrite tool for simple task tracking within a session.

---

## Skill Creation

When you find yourself doing something 3+ times, or establishing a pattern worth reusing:

1. Create a skill file in `.claude/skills/[skill-name].md`
2. Follow this template:

```markdown
# Skill: [Name]

## Purpose
[What this helps achieve]

## When to Use
- [Scenario 1]
- [Scenario 2]

## Pattern
[Code examples, step-by-step process]

## Checklist
- [ ] [Verification item]
```

3. If the skill is useful to others, contribute it to the shared `cc-starter` repository

---

## Language Standards

### TypeScript
- No `any` types outside third-party library boundaries
- Use granular selectors from stores (not full state objects)
- Early returns to reduce nesting
- Meaningful variable names

### Java
- Prepared statements for SQL (never concatenate)
- Validate all inputs at system boundaries
- Use meaningful exception types

---

## Reality Checkpoints

**Stop and validate** at these moments:
- After implementing a complete feature
- Before starting a new major component
- When something feels wrong
- Before declaring "done"
- When tests fail with errors

---

## Communication Protocol

### Progress updates:
```
Done: Implemented authentication (all tests passing)
Done: Added rate limiting
Issue: Found problem with token expiration - investigating
```

### Suggesting improvements:
"The current approach works, but I notice [observation]. Would you like me to [specific improvement]?"

---

## Documentation

**All documentation goes in `docs/` folder. No exceptions.**

```
docs/
  TECHNICAL_DOCUMENTATION.md   # Architecture, patterns, APIs
  PROJECT_STATUS.md            # Current status (if needed)
```

- On project start: generate `docs/TECHNICAL_DOCUMENTATION.md` with architecture overview
- After significant changes: update the relevant docs immediately
- Single file preferred: consolidate rather than creating many small files
- Never create random .md files scattered around the project

---

## Available Skills

Check `.claude/skills/` for detailed implementation patterns. Always consult the relevant skill before generating code.

---

## Recovery Protocol

When interrupted by a failure (test failure, build error, lint violation):
1. Note your current task
2. Fix the failure completely
3. Verify the fix by re-running the check
4. Return to your original task
5. Use Beads or TodoWrite to track both the fix and your original task
