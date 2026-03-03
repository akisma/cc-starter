# Spec-Driven Development

## The Core Idea

The spec is the prompt. When you write a clear, precise specification before touching code, you give the AI agent exactly what it needs to generate correct implementations on the first pass. When you skip the spec and describe what you want in vague terms, you get vague results and burn cycles iterating on code that never should have been written that way.

This is not a new idea -- specification-first approaches have been around for decades. What has changed is that AI agents can now translate well-written specs directly into working code. The quality of your spec determines the quality of the output.

Reference: ThoughtWorks, "Spec-Driven Development: Unpacking 2025's New Engineering Practices"
https://www.thoughtworks.com/en-us/insights/blog/agile-engineering-practices/spec-driven-development-unpacking-2025-new-engineering-practices

## Write Specs in Domain Language, Not Implementation Details

A spec should describe **what the system does**, not **how it does it**. Use the language your product team, stakeholders, and users would recognize.

Bad example:
> "Create a POST endpoint at /api/users that validates the email field with a regex, hashes the password with bcrypt, and inserts a row into the users table."

Good example:
> "When a new user registers with a valid email and password, the system creates their account and sends a welcome email. If the email is already in use, the system rejects the registration and explains why."

The first version locks you into implementation choices before you have validated the behavior. The second version describes the behavior and lets the agent (or engineer) choose the right implementation.

## Given / When / Then Format

Structure your specs using Given/When/Then. This format is unambiguous, testable, and maps directly to test cases that your agent can generate.

```
Given a user is on the registration page
When they submit a valid email and a password that meets requirements
Then the system creates their account
And sends a welcome email to the provided address
And redirects to the dashboard

Given a user is on the registration page
When they submit an email that is already registered
Then the system displays an error message: "An account with this email already exists"
And does not create a duplicate account
```

Each scenario becomes a test case. The agent reads the spec, generates the implementation, and generates the tests -- all from the same source of truth.

## The Spec-Driven Workflow

1. **Write the spec** -- describe every scenario in Given/When/Then format using domain language
2. **Review the spec** -- walk through it with your team. Are the scenarios complete? Are edge cases covered?
3. **Hand the spec to the agent** -- the agent generates implementation code and tests from the spec
4. **Run the tests** -- verify that the generated code satisfies every scenario
5. **Iterate on the spec, not the code** -- if behavior needs to change, update the spec first, then regenerate

The critical shift is in step 5. When something is wrong, resist the urge to patch the code directly. Go back to the spec, clarify the behavior, and let the agent regenerate. This keeps the spec and code in sync and prevents drift.

## Why This Matters for AI-Assisted Development

- **Specs are deterministic prompts.** A well-written Given/When/Then scenario produces consistent code generation across sessions.
- **Specs survive compaction.** When a long conversation gets summarized, implementation details are lost but spec scenarios are preserved because they are concise and structured.
- **Specs are reviewable by non-engineers.** Product managers and designers can validate specs without reading code. This keeps the whole team aligned.
- **Specs reduce iteration cycles.** Getting the spec right before generating code is faster than generating code, finding it wrong, explaining the fix, and regenerating.

## Quick Checklist

- [ ] Every feature starts with a written spec before any code is generated
- [ ] Specs use domain language that stakeholders can review
- [ ] Scenarios follow Given/When/Then format
- [ ] Edge cases and error conditions are explicitly covered
- [ ] When behavior changes, the spec is updated first and code is regenerated
