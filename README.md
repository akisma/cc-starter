# CC Starter

Shared AI agent configuration, skills, and onboarding materials for teams using Claude Code.

This repo provides everything your team needs to work effectively with Claude Code: ready-to-use configurations for engineers and product/design folks, shared skills, MCP server setup, and presentation-ready documentation.

---

## Prerequisites

You need these installed before running the setup script:

| Tool | Install | Verify |
|------|---------|--------|
| **Node.js** | `brew install node` or [nodejs.org](https://nodejs.org/) (LTS) | `node --version` |
| **Git** | Already on macOS. Windows: [git-scm.com](https://git-scm.com/) | `git --version` |
| **Claude Code** | `npm install -g @anthropic-ai/claude-code` | `claude --version` |

After installing Claude Code, run `claude` once to authenticate with your Anthropic account.

See `docs/onboarding/01-ai-hygiene-local-setup.md` for detailed instructions.

---

## Quick Start

### Don't have a project yet?

If you're starting from scratch (common for POCs and design prototypes), create a project first:

```bash
npm create vite@latest my-project -- --template react-ts
cd my-project
npm install
git init && git add -A && git commit -m "initial scaffold"
```

When you're ready to share your work, ask your GitHub admin to create a repo under the org. Then push your local project to it.

Then run the setup script below pointing at that directory.

### 1. Run the setup script

Point it at an existing project — the directory where your code already lives (with a `package.json`, `pom.xml`, `.git/`, etc.):

```bash
./setup.sh ~/Documents/code/my-project
```

The script will:
- Ask your role (engineer or product/design)
- Copy the right `CLAUDE.md` profile to your project
- Set up shared skills in `.claude/skills/`
- Walk you through MCP server setup (Context7, OpenMemory, GitHub)
- Set up Beads task tracking (engineers)

### 2. Fill in project details and commit

Open `CLAUDE.md` in your project, fill in the Project Info section, and **commit it to git**. This is shared team configuration — everyone on the project uses the same `CLAUDE.md`.

### 3. Personal overrides (optional)

Add a `CLAUDE.local.md` for personal preferences (like git mode). Claude Code auto-gitignores this file — it's never committed.

| File | Committed? | Who sees it |
|------|------------|-------------|
| `CLAUDE.md` | Yes | Whole team |
| `CLAUDE.local.md` | No (auto-gitignored) | Just you |
| `~/.claude/CLAUDE.md` | N/A | Just you, all projects |

### 4. Start working

Open your project in Claude Code. The AI assistant will automatically read your `CLAUDE.md`, `CLAUDE.local.md`, and skills.

---

## Updating Your Project

When improvements are pushed to profiles or skills, pull the latest and run:

```bash
./update.sh ~/Documents/code/my-project
```

This updates your `CLAUDE.md` and skills to the latest versions while preserving your Project Info. MCP servers and personal settings (`CLAUDE.local.md`) are not touched. **Do this regularly to stay current.**

---

## Two Profiles

### Engineer (`profiles/engineer/CLAUDE.md`)

Full-featured configuration for developers:
- Research -> Plan -> Implement workflow
- TDD (test-driven development)
- Multi-agent patterns for parallel work
- Configurable git mode (read-only, approval, or autonomous)
- Beads task tracking with TodoWrite fallback
- Context management and compaction awareness
- Skill creation guidance
- Java + TypeScript language standards

### Product & Design (`profiles/product-design/CLAUDE.md`)

Simplified configuration for non-engineers:
- Spec-first workflow (describe what you want, iterate)
- Git handled by the agent with plain-language explanations
- Agent always explains and waits for approval before acting
- "Done" means tests pass, build succeeds, docs updated
- Wispr speech-to-text for voice-driven input
- Context management in plain language

---

## Shared Skills

Skills are detailed guides that help AI agents follow consistent patterns. Located in `skills/`:

### Workflow Skills
| Skill | Purpose |
|-------|---------|
| `spec-driven-dev.md` | Write specs first, implement from specs |
| `iterative-commits.md` | Atomic commit patterns and branch naming |
| `pr-workflow.md` | Creating review-ready pull requests |
| `skill-creation.md` | How to create and contribute new skills |

### React/Frontend Skills
| Skill | Purpose |
|-------|---------|
| `zustand-store-testing.md` | Testing Zustand stores with Vitest |
| `component-creation.md` | React component patterns |
| `dom-utility-testing.md` | Testing DOM utilities |
| `store-first-feature.md` | TDD: state first, then UI |

---

## MCP Servers

The setup script walks you through configuring these MCP servers at user scope (keys stay out of the project):

| Server | Purpose | API Key? |
|--------|---------|----------|
| Context7 | Up-to-date library documentation | Free at context7.com/dashboard |
| OpenMemory (Mem0) | Persistent memory across sessions | At mem0.ai |
| GitHub MCP | PRs, issues, repo interaction | GitHub PAT |

These are one-time setup — once configured, they work across all your projects.

---

## Agent Roles

For agent role inspiration, browse **[VoltAgent/awesome-claude-code-subagents](https://github.com/VoltAgent/awesome-claude-code-subagents)**. If you find a role that fits your work, copy the individual `.md` file into your project and reference it at the start of a session. Don't install the full collection — keep it simple.

---

## Onboarding Docs

Presentation-ready materials in `docs/onboarding/`:

| # | Document | Audience |
|---|----------|----------|
| 01 | AI Hygiene & Local Setup | Both |
| 02 | Spec-Driven Development | Both |
| 03 | Context Engineering & Compaction | Both |
| 04 | Codebase Readiness | Both |
| 05 | Holding Agents Accountable | Both |
| 06 | Engineering Workflow | Engineers |
| 07 | Product & Design Workflow | Product/Design |
| 08 | Iterative Improvement & Skills | Both |

---

## Contributing Skills

When you create a pattern that others would benefit from:

1. Create and test it in your project's `.claude/skills/` first
2. Generalize it (remove project-specific references)
3. Copy it to this repo's `skills/` directory
4. Update the skills table in this README
5. Create a PR

See `skills/skill-creation.md` for the full guide.

---

## Repo Structure

```
cc-starter/
  profiles/
    engineer/CLAUDE.md           # Engineer configuration
    product-design/CLAUDE.md     # Product/Design configuration
  skills/                        # Shared skill documents
  docs/
    onboarding/                  # Meeting presentation materials
  setup.sh                       # Initial project setup
  update.sh                      # Pull latest profile + skills into a project
```

---

## Using a Different AI Tool?

This repo is built for Claude Code, but the CLAUDE.md profiles work with any AI tool that reads a project-level markdown file. Copy your profile to the filename your tool expects:

| Tool | Config file |
|------|-------------|
| Claude Code | `CLAUDE.md` (already set up by `setup.sh`) |
| JetBrains Junie | `.junie/guidelines.md` |
| Cursor | `.cursorrules` |
| Windsurf | `.windsurfrules` |
| GitHub Copilot | `.github/copilot-instructions.md` |

The content is the same — just the filename differs.
