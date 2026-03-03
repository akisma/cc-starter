# Product and Design Workflow

*Audience: Product Managers and Designers*

## You Do Not Need to Be an Engineer

AI agents have changed who can directly build and iterate on software. You do not need to know git commands, programming languages, or terminal syntax. You need to know what you want, how to describe it clearly, and how to verify that the result matches your intent.

Your agent handles the technical mechanics. Your job is to direct the work and evaluate the output.

## Starting a New POC

If you're building something from scratch, you need a project directory before the AI setup works. Ask an engineer to help, or run these commands yourself:

```bash
npm create vite@latest my-project -- --template react-ts
cd my-project
npm install
git init && git add -A && git commit -m "initial scaffold"
```

Then run `setup.sh` from the ve-agent-tools repo pointing at your new project. Once CLAUDE.md is in place, your agent can help you with everything from there.

## How Your Agent Handles Git (So You Don't Have To)

Version control still happens, but the agent manages it for you. Here is what you need to know:

- **"Save my work"** -- Tell the agent this, and it will commit your changes with a descriptive message. It will explain what it is saving and why before it acts.
- **"Submit for review"** -- The agent creates a pull request, writes a summary of the changes, and provides you with a link. An engineer on the team reviews and approves it.
- **"Go back to how it was before"** -- The agent can undo changes and restore previous versions. Describe what you want to revert, and it handles the mechanics.

The agent will always explain what it is about to do before it does it. If it says "I am going to create a new branch and commit these three files," you can confirm or redirect before anything happens. You are in control.

## Speech-to-Text with Wispr

Typing detailed descriptions can be slow. Wispr (https://www.wispr.com/) converts your speech to text in real time, so you can describe what you want conversationally and have it transcribed directly into your agent conversation. This is especially useful for describing UI flows, dictating spec scenarios, and providing feedback by talking through what needs to change.

## The Spec-First Iteration Loop

This is your core workflow. It has four steps, and you repeat them until the result is right.

### Step 1: Describe What You Want

Be specific about behavior, not implementation. Use domain language. Focus on what the user sees and does.

Good: "When a user clicks 'Add to Cart,' the item count in the header updates immediately, and a confirmation toast appears for 3 seconds."

Not helpful: "Make the cart work better."

### Step 2: The Agent Builds It

The agent takes your description, generates the code, and either shows you a preview or tells you how to see the result. It explains what it built and any decisions it made.

### Step 3: You Review the Result

Look at the output. Click through it. Try edge cases. Does it match what you described? Is something off? Does the flow feel right?

### Step 4: Iterate

Tell the agent what to change. Be specific: "The toast should appear at the top of the screen, not the bottom" or "The animation is too slow -- make it 200ms instead of 500ms." The agent adjusts and you review again.

This loop typically takes 2-5 cycles to reach a solid result. Each cycle should take minutes, not hours.

## How the Agent Explains Before Acting

A well-configured agent does not silently make changes. Before taking action, it will:

- State what it understands your request to be
- Describe the changes it plans to make
- Flag any ambiguity or decisions it needs your input on
- Wait for your confirmation before proceeding

If the agent is not doing this, tell it: "Before making changes, explain your plan and wait for my approval." This instruction can also be added to your CLAUDE.md so it applies to every session.

## Tips for Effective Agent Collaboration

- **Start with outcomes, not solutions.** Say "users need to compare two products side by side" rather than "add a comparison table component."
- **Reference existing patterns.** "Make it work like the filtering on the search page" gives the agent a concrete model to follow.
- **Give feedback on specifics.** "The spacing between cards feels too tight" is actionable. "It does not look right" is not.
- **One change at a time.** Describe one modification per message. This keeps the iteration loop fast and avoids confusion.

## Quick Checklist

- [ ] You describe features in terms of user behavior, not technical implementation
- [ ] You use "save my work" and "submit for review" instead of git commands
- [ ] The agent explains its plan before making changes
- [ ] You review every result visually and interactively before approving
- [ ] Wispr is installed for speech-to-text input
- [ ] Iteration happens in small, specific cycles rather than large rewrites
