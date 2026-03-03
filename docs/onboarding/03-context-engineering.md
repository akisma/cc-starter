# Context Engineering

## Context Is a Finite Resource

Every AI agent operates within a context window -- a fixed amount of information it can hold in working memory at any given time. Everything you put into that window competes for space: your CLAUDE.md, the files the agent reads, conversation history, tool outputs, and the agent's own reasoning.

More context does not mean better results. Irrelevant context actively degrades performance by diluting the signal the agent needs to do its job. Context engineering is the discipline of putting the right information in front of the agent at the right time.

References:
- Anthropic, "Effective Context Engineering for AI Agents": https://www.anthropic.com/engineering/effective-context-engineering-for-ai-agents
- Martin Fowler, "Context Engineering for Coding Agents": https://martinfowler.com/articles/exploring-gen-ai/context-engineering-coding-agents.html

## The Three Layers of Context

### CLAUDE.md -- Your System Prompt

This is always loaded. It sets the baseline: project conventions, domain language, boundaries. Keep it focused. If a piece of information is only relevant to specific tasks, it does not belong here -- it belongs in a skill.

### Skills -- Compressed Reusable Knowledge

Skills are loaded on demand when the agent needs them. This is the key difference from stuffing everything into CLAUDE.md. A skill for "writing database migrations" only enters context when a migration task begins. This keeps the window clean for the current task.

### Just-in-Time Retrieval

Tools like Context7 and file search pull information into context only when the agent needs it. Instead of pre-loading every API doc into the conversation, the agent queries for the specific function signature it needs at the moment it needs it. This is dramatically more efficient than loading everything upfront.

## Compaction: The Silent Quality Killer

**What it is.** When a conversation grows too long for the context window, the system automatically summarizes older parts of the conversation to make room. This is called compaction.

**Why it matters.** Compaction loses details. Specific variable names, exact error messages, nuanced decisions -- these get compressed into vague summaries. After compaction, the agent may forget decisions you made earlier in the conversation, repeat mistakes you already corrected, or lose track of the current state of the code.

**How to recognize it.** The agent starts asking questions you already answered. It forgets constraints you established. It contradicts earlier decisions. Quality visibly degrades in the second half of a long session.

**How to avoid it:**

- **Right-size your tasks.** One conversation per focused task. "Implement user registration" is a good scope. "Build the entire auth system" is too broad for a single session.
- **Multiple focused sessions over marathons.** Five 30-minute conversations produce better results than one 3-hour conversation. Start each new session with a brief summary of where you left off.
- **Start new conversations with summaries.** When you begin a follow-up session, paste a 3-5 line summary of the previous session's outcomes and decisions. This gives the agent clean, accurate context without the noise of a compacted history.
- **Offload completed context.** Once a subtask is done and verified, move on to a new conversation for the next subtask. Do not keep dragging completed work through the window.

## Practical Guidelines

- **Before starting a task**, ask yourself: what does the agent need to know right now? Load that, and only that.
- **Watch for context pollution.** If you paste a 500-line file but only need the agent to modify 20 lines, point it to the specific section.
- **Use skills instead of re-explaining.** If you catch yourself typing the same instructions across conversations, create a skill.
- **Monitor conversation length.** If a conversation is stretching past 15-20 back-and-forth exchanges, consider wrapping up the current task and starting fresh.

## Quick Checklist

- [ ] CLAUDE.md contains only project-wide, always-relevant information
- [ ] Task-specific knowledge is encoded in skills, not crammed into CLAUDE.md
- [ ] You start new conversations for new tasks instead of continuing marathon sessions
- [ ] Follow-up sessions begin with a concise summary of prior decisions
- [ ] You use just-in-time retrieval (Context7, file search) instead of pre-loading docs
- [ ] You recognize the signs of compaction and know when to start fresh
