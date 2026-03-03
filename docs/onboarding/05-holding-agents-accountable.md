# Holding Agents Accountable

## "Done" Means Done

When an AI agent says "I've completed the task," that statement is not inherently trustworthy. The agent is optimized to be helpful, and sometimes that means it reports completion prematurely -- before tests have run, before edge cases have been handled, before documentation has been updated.

Your job is to define what "done" actually means and verify it every time. This is not about distrusting the tool. It is about applying the same standard you would apply to any team member: show your work.

## The Definition of Done

A task is done when all of the following are true:

- **Tests pass.** Not "I wrote the tests" -- they actually ran and passed. Every test. Including the ones that existed before the change.
- **Build succeeds.** The project compiles and builds without errors or new warnings.
- **The feature works.** If it is a user-facing change, it has been visually verified in a running environment.
- **Documentation is updated.** If the change affects APIs, configuration, or user-facing behavior, the relevant docs reflect the new state.
- **No regressions.** Existing functionality still works. The agent did not break something else while fixing the target issue.

## Why TDD Matters (Even If You Are Not an Engineer)

Test-Driven Development is not just a coding practice. It is an accountability framework. When the agent writes tests first and then writes the implementation to make them pass, you get:

- **A clear contract** for what the code should do, written before the code exists
- **Automated verification** that the contract is satisfied
- **Regression protection** so future changes do not silently break existing behavior

You do not need to write the tests yourself. The agent writes them. But you need to verify that the tests are meaningful (not trivially passing) and that they actually ran.

## Questions to Ask Your Agent

After every task, ask these questions. Do not skip them.

**"Did you run the tests?"**
Not "did you write tests" -- did you actually execute them? What was the output? If the agent says it wrote tests but did not run them, the tests are unverified and potentially broken.

**"Does it build?"**
A successful build means the code compiles, dependencies resolve, and there are no type errors. If the agent made changes across multiple files, a build failure may not be obvious from the diff alone.

**"Did you update the docs?"**
If the agent added a new API endpoint, changed a configuration option, or altered user-facing behavior, the documentation should reflect that change. Outdated docs are worse than no docs because they actively mislead.

**"What did you change that I did not ask for?"**
Agents sometimes refactor adjacent code, update dependencies, or "improve" things outside the scope of the task. These changes may be beneficial, but they need to be reviewed explicitly.

**"Are there any edge cases you did not handle?"**
A direct question forces the agent to disclose gaps it might otherwise gloss over. The agent knows its own limitations better than its summary suggests.

## Verification Workflow

1. **Review the agent's summary.** Read what it says it did.
2. **Check the test output.** Look for the actual pass/fail results, not just the agent's claim.
3. **Run the build yourself** if you have any doubt. A single command should confirm.
4. **Spot-check the diff.** Look at what files changed and whether the changes match the task scope.
5. **Test the feature manually** for user-facing changes. Click through it. Try the unhappy path.

## The Contractor Analogy

An agent saying "done" without evidence is like a contractor saying "the wiring is finished" without an inspection. You would not flip the breaker on faith. You would check the work, run the tests, and verify the result before accepting it.

The agent is a powerful tool. It is not a replacement for professional judgment. Verify every time.

## Quick Checklist

- [ ] "Done" is defined: tests pass, build succeeds, docs updated, feature verified
- [ ] You ask "did you run the tests?" after every task and review the output
- [ ] You confirm the build passes, not just that the agent says it does
- [ ] You review the diff for out-of-scope changes
- [ ] You manually verify user-facing changes in a running environment
- [ ] You ask about unhandled edge cases before accepting completion
