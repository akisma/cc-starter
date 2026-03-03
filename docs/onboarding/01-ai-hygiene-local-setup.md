# AI Hygiene and Local Setup

## Why This Matters

Your local AI setup determines the quality of every interaction you have with your agent. A well-configured environment means the agent understands your project, has access to the right tools, and produces consistent results. A poorly configured one means you spend half your time re-explaining context and fixing avoidable mistakes.

There are three layers to get right: your project prompt (CLAUDE.md), your skills library, and your MCP server connections.

## CLAUDE.md: Your Project's System Prompt

CLAUDE.md is the first thing your AI agent reads when it starts a conversation. Think of it as the onboarding document you would hand a new team member on day one. It lives at the root of your project and should contain:

- **Project overview** -- what this codebase does, who it serves, and why it exists
- **Architecture decisions** -- the stack, key patterns, and conventions the team follows
- **Coding standards** -- naming conventions, file organization, test expectations
- **Domain language** -- the specific terms your team uses and what they mean
- **Boundaries** -- what the agent should and should not do without asking

The CLAUDE.md file is not a wishlist. It is a set of concrete instructions that shape every response. If you tell the agent "we use TypeScript strict mode and never use `any`," it will follow that rule in every file it touches.

## Skills: Compressed Reusable Knowledge

Skills are packaged instructions that teach your agent how to perform specific tasks. Rather than explaining your deployment process every time, you encode it once as a skill and the agent can invoke it on demand.

- Skills live in the `ve-agent-tools/skills/` directory
- Each skill is a focused markdown file with clear instructions
- Skills are loaded on demand, not all at once -- this keeps context lean
- Examples: commit formatting, PR review checklist, test generation patterns, code review standards

When you find yourself repeating the same instruction to your agent, that is a signal to create a skill.

## MCP Servers: Extending Your Agent's Capabilities

Model Context Protocol (MCP) servers connect your agent to external tools and data sources. Without them, your agent can only work with what is in its context window. With them, it can query documentation, search memory, interact with GitHub, and more.

The key MCP servers for our setup:

- **Context7** -- provides up-to-date documentation for libraries and frameworks. Instead of relying on training data that may be outdated, the agent queries current docs in real time.
- **OpenMemory (Mem0)** -- persistent memory across sessions. The agent remembers decisions, preferences, and context from previous conversations.
- **GitHub MCP** -- direct interaction with repositories, issues, and pull requests without leaving the agent conversation.

Each MCP server requires an API key stored in your environment. These keys are never committed to the repository.

## Prerequisites

Before running the setup script, you need three things installed on your machine:

### 1. Node.js

Node.js runs JavaScript tooling and MCP servers. Check if you have it:

```bash
node --version
```

If not installed, go to https://nodejs.org/ and download the LTS version. Alternatively, engineers can use `nvm` or `brew install node`.

### 2. Git

Git tracks changes to your code. Check if you have it:

```bash
git --version
```

macOS users: git ships with Xcode Command Line Tools. If prompted to install them, say yes. Windows users: download from https://git-scm.com/.

### 3. Claude Code

Claude Code is the AI agent CLI. Install it:

```bash
npm install -g @anthropic-ai/claude-code
```

After installing, run `claude` once to authenticate with your Anthropic account. It will open a browser window to complete sign-in.

Verify it's working:

```bash
claude --version
```

For full installation docs, see https://docs.anthropic.com/en/docs/claude-code.

## Getting Set Up

Once the prerequisites are installed, run the setup script from the ve-agent-tools repo, pointing it at your project:

```bash
./setup.sh ~/path/to/your/project
```

The script will:

1. Ask your role (engineer or product/design)
2. Copy the right CLAUDE.md profile to your project
3. Set up shared skills in `.claude/skills/`
4. Walk you through MCP server setup (Context7, OpenMemory, GitHub)
5. Set up Beads task tracking (engineers)

After setup, open your project directory in Claude Code and start a conversation. The agent will automatically read your CLAUDE.md and skills.

## Quick Checklist

- [ ] Node.js is installed (`node --version`)
- [ ] Git is installed (`git --version`)
- [ ] Claude Code is installed (`claude --version`)
- [ ] `setup.sh` has run successfully against your project
- [ ] CLAUDE.md exists at your project root with project-specific instructions
- [ ] Skills directory is populated in `.claude/skills/`
- [ ] A test conversation confirms the agent reads your CLAUDE.md (ask it "what project are you working on?" to verify)
