# Iterative Improvement

## The Flywheel

AI-assisted development is not a one-time setup. It is a compounding system. Every time you work with your agent, you have an opportunity to make the next session better -- for yourself and for the entire team.

The flywheel works like this:

1. **Do work** with your agent on a real task
2. **Notice patterns** -- instructions you repeat, corrections you make, workflows that work well
3. **Create a skill** that encodes that pattern so the agent gets it right next time
4. **Share the skill** to the team repository so everyone benefits

Each rotation of this flywheel makes the team faster. After a few weeks, the agent handles common tasks with minimal guidance because the accumulated skills cover the patterns your team encounters most often.

## Recognizing When to Codify

The signal is repetition. When you find yourself doing any of the following for the third time, it is time to create a skill:

- **Repeating the same instructions** across conversations. "Remember to use our error handling pattern" or "always add loading states to async components" -- if you are saying it more than twice, write it down once.
- **Correcting the same mistake.** If the agent keeps generating code that uses the wrong import path or the wrong date format, a skill that specifies the correct pattern eliminates the issue permanently.
- **Following the same multi-step workflow.** If every PR involves the same sequence of checks, linting, testing, and formatting, encode that sequence as a skill the agent can execute consistently.
- **Explaining the same domain concept.** If the agent keeps confusing "workspace" and "project" in your domain, a skill that defines these terms prevents the confusion.

## Creating a Skill

A skill is a focused markdown file that teaches the agent one thing well. It lives in the `ve-agent-tools/skills/` directory and follows this structure:

- **Purpose:** One sentence explaining when this skill applies
- **Instructions:** Clear, specific steps the agent should follow
- **Examples:** Concrete examples of correct output (and optionally, incorrect output to avoid)
- **Constraints:** Boundaries and edge cases

Keep skills focused. A skill that tries to cover "all of our coding standards" is too broad. A skill that covers "how we name and structure API error responses" is the right size.

## Contributing Skills to ve-agent-tools

When you create a skill that works well for you, contribute it to the shared repository so the whole team benefits.

1. **Test it locally.** Use the skill across at least 2-3 sessions to verify it consistently produces good results.
2. **Write it for a general audience.** Remove references to your specific task and frame the instructions so any team member's agent can follow them.
3. **Add it to the skills directory.** Place it in `ve-agent-tools/skills/`.
4. **Submit a PR.** Include a brief description of the pattern the skill addresses and why it is useful.
5. **Let the team review.** Others may have refinements or edge cases to add.

## Shared Skills Compound Across the Team

When one person codifies a pattern, every person on the team benefits from that point forward. This creates a compounding effect:

- Week 1: Each person works with a baseline agent that knows nothing about your team's conventions.
- Week 4: The agent knows your error handling patterns, testing conventions, and deployment workflow because three people contributed skills.
- Week 8: The agent handles most routine tasks with minimal guidance because the skill library covers the most common patterns across the team.

The team that actively contributes skills improves at a rate that the team that does not contribute cannot match. This is the strategic advantage of treating AI tooling as a team practice, not an individual one.

## What Makes a Good Skill Library

- **Focused skills** that each address one specific pattern or workflow
- **Living documentation** that gets updated when conventions change
- **Coverage of the common cases** -- the 20 patterns that cover 80% of daily work
- **Clear naming** so team members can find relevant skills quickly
- **Version notes** so the team knows when and why a skill was added or changed

## Quick Checklist

- [ ] You notice when you repeat instructions more than twice
- [ ] Repeated patterns are codified as skills in the skills directory
- [ ] Skills are tested locally before being contributed to the shared repo
- [ ] You submit skills via PR so the team can review and refine them
- [ ] You pull the latest skills from ve-agent-tools before starting work
- [ ] The skill library is treated as a living resource, updated as conventions evolve
