# Codebase Readiness

## AI Amplifies What Is Already There

An AI agent working in a clean, well-structured codebase will produce clean, well-structured code. An AI agent working in a messy codebase will produce more mess, faster. Before investing in AI-assisted workflows, take an honest look at the state of your codebase and fix the issues that will block the agent from being effective.

This is not about achieving perfection. It is about removing the specific categories of tech debt that cause AI agents to fail, loop, or produce low-quality output.

## Tech Debt That Blocks AI Effectiveness

### Deploy Friction Kills Iteration

If deploying a change takes 45 minutes and three manual steps, you cannot iterate quickly with AI. The AI-assisted workflow depends on rapid cycles: generate code, test it, see the result, adjust. Every minute of deploy friction multiplies across dozens of iterations per day.

- **Target state:** One command to deploy to a preview environment. Vercel, Netlify, or equivalent for frontend. Automated staging deploys for backend services.
- **Red flag:** Manual deploy steps documented in a wiki that nobody reads. Deploy scripts that require specific local machine configurations.

### Brittle APIs Break Agent Workflows

When the agent generates code that calls an internal API, and that API has undocumented side effects, inconsistent error responses, or version mismatches, the agent cannot debug the problem effectively. It will hallucinate fixes or loop endlessly.

- **Target state:** APIs have typed contracts (OpenAPI specs, GraphQL schemas, or TypeScript interfaces). Error responses are consistent and descriptive.
- **Red flag:** API behavior that differs between environments. Endpoints that return different shapes depending on undocumented conditions.

### Missing or Inconsistent Tests

If the codebase has no tests, the agent has no way to verify its own work. If the codebase has flaky tests that sometimes pass and sometimes fail, the agent wastes cycles chasing phantom failures.

- **Target state:** A test suite that runs in under 5 minutes and passes consistently. Clear patterns for unit, integration, and end-to-end tests.
- **Red flag:** Tests that are skipped, commented out, or fail intermittently. No test infrastructure at all.

### Unclear Project Structure

When files are scattered without consistent organization, the agent spends context window space figuring out where things go instead of building features.

- **Target state:** A predictable file structure where the agent can infer where new code belongs based on existing patterns.
- **Red flag:** Multiple competing patterns for the same type of file. Business logic mixed into UI components.

## Run a Codebase Analysis First

Before bringing an AI agent into a project, run a structured analysis:

1. **Can you deploy in one step?** If not, fix the deploy pipeline first.
2. **Does the test suite pass reliably?** If not, fix or remove flaky tests.
3. **Are API contracts documented?** If not, add TypeScript types or OpenAPI specs for the endpoints the agent will interact with.
4. **Is the project structure consistent?** If not, establish conventions and document them in CLAUDE.md.
5. **Are there known landmines?** Document any areas of the codebase where the agent should not make changes without human review.

Use Vercel or a similar platform for quick deploy verification. Being able to see a live preview of every change is essential for the rapid iteration loop that makes AI-assisted development effective.

## Prioritization

You do not need to fix everything before starting. Focus on:

1. **Deploy pipeline** -- this unblocks everything else
2. **Test infrastructure** -- this lets the agent verify its own work
3. **API contracts** -- this prevents the agent from generating code against wrong assumptions
4. **Project structure and CLAUDE.md** -- this improves output quality over time

## Quick Checklist

- [ ] Deployment to a preview environment takes one command and under 5 minutes
- [ ] The test suite passes consistently with no flaky tests
- [ ] API contracts are documented with typed interfaces or specs
- [ ] Project file structure follows a consistent, predictable pattern
- [ ] Known problem areas are documented so the agent avoids them
- [ ] CLAUDE.md reflects the actual state of the codebase, not an aspirational one
