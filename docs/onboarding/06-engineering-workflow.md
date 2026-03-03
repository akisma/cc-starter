# Engineering Workflow

*Audience: Engineers*

## You Are Leading a Team of Agents

The shift in AI-assisted engineering is not about typing less code. It is about operating as a technical lead who directs, reviews, and coordinates the work of multiple AI agents. Your job is to set direction, define standards, and verify results -- the same skills you would use managing junior developers, but at much higher throughput.

## Git Workflow

Discipline in git practices becomes more important when agents are generating code, because the volume of changes increases significantly.

- **Branch naming:** `feature/`, `fix/`, `hotfix/`, `design/`, `refactor/`, `chore/` prefixes followed by a short descriptive slug. Example: `feature/user-registration`, `fix/email-validation-edge-case`. **Never create `release/` branches unless explicitly requested.**
- **Atomic commits:** Each commit should represent one logical change. If the agent generates a large diff, break it into multiple commits with clear messages. Ask the agent to commit incrementally rather than all at once.
- **Pull requests:** Every change goes through a PR, even if the agent wrote it. PRs are where you verify the agent's work, check for scope creep, and ensure tests and build pass in CI.
- **Commit messages:** Use conventional commit format. The agent should explain *why* the change was made, not just *what* changed.

## Agent Teams: Multi-Agent Patterns

You are not limited to a single agent conversation. For complex tasks, spawn multiple agents working in parallel:

- **One agent writes tests while another implements.** The test-writing agent works from the spec. The implementation agent works from the same spec independently. When both finish, run the tests against the implementation.
- **One agent handles the backend while another handles the frontend.** Give each agent its own branch and merge when both are complete.
- **A review agent inspects the output of a build agent.** After one agent completes a task, hand the diff to a second agent with the instruction to review it critically.

For agent role ideas, browse https://github.com/VoltAgent/awesome-claude-code-subagents. Copy individual `.md` files that fit your workflow -- don't install the full collection.

When spawning subagents, give each one a clearly scoped task, the relevant files, and explicit instructions about what "done" looks like. Vague delegation produces vague results.

## The TDD Loop

Red-green-refactor is the core development cycle with AI agents:

1. **Red:** Write a failing test (or have the agent write it from the spec). Confirm it fails for the right reason.
2. **Green:** Have the agent write the minimum code to make the test pass. Confirm it passes.
3. **Refactor:** Have the agent clean up the implementation without changing behavior. Confirm tests still pass.

This loop gives you a verification checkpoint at every step. If the agent drifts off course, you catch it immediately instead of discovering problems after 200 lines of generated code.

## Maximizing Agent Quality

- **`/effort max`** -- Use this flag when the agent is working on complex reasoning tasks: architectural decisions, tricky algorithms, subtle bug investigations. It tells the agent to spend more compute on thinking through the problem rather than rushing to a response.
- **Beads for task tracking** -- Use Beads to break work into discrete, trackable units. Each bead represents a task with clear inputs, outputs, and completion criteria. This prevents the sprawl that happens when an agent tries to do too much in one session.

## Practical Tips

- **Start each session with a plan.** Tell the agent what you are building, what files are involved, and what the acceptance criteria are. Do not let the agent guess.
- **Review diffs, not just summaries.** The agent's summary of what it did may omit important details. Always look at the actual code changes.
- **Keep sessions focused.** One feature, one bug fix, one refactor per session. Start a new conversation for the next task.
- **Use the agent for the tedious parts.** Boilerplate, test scaffolding, type definitions, documentation -- these are high-value agent tasks that free you for design and architecture decisions.

## Quick Checklist

- [ ] Branch naming follows `feature/`, `fix/`, `hotfix/`, `design/`, `refactor/`, `chore/` conventions
- [ ] Commits are atomic with clear messages explaining the "why"
- [ ] Every change goes through a PR with CI verification
- [ ] You use multi-agent patterns for complex or parallelizable tasks
- [ ] The TDD loop (red-green-refactor) is your default development cycle
- [ ] `/effort max` is used for complex reasoning tasks
- [ ] Sessions are focused on one task with clear acceptance criteria
