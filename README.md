> English | [中文](README.zh.md)

# claude-devos

A structured operating system for Claude Code. It gives your AI coding agent
consistent behavior: project awareness, coding standards enforcement, file
protection, automated verification, and repeatable workflows for specs,
plans, reviews, and commits.

Without it, Claude Code starts every session with zero context about your
project. With it, Claude Code knows your stack, follows your rules, and
runs your tests before declaring it's done.

## Prerequisites

- [Claude Code](https://docs.anthropic.com/en/docs/claude-code) installed and working
- `jq` installed (`brew install jq` on macOS, `apt install jq` on Linux)
- macOS or Linux recommended. Windows users: use WSL2 for full compatibility.

## Quick Start

**Option A: One-command install**

```bash
cd your-project
git clone https://github.com/CarpeWu/claude-devos.git /tmp/claude-devos
/tmp/claude-devos/install.sh
```

**Option B: Manual copy**

```bash
git clone https://github.com/CarpeWu/claude-devos.git /tmp/claude-devos
cp /tmp/claude-devos/template/CLAUDE.md your-project/
cp /tmp/claude-devos/template/CLAUDE.local.md.example your-project/
cp -r /tmp/claude-devos/template/.claude your-project/
cp /tmp/claude-devos/CUSTOMIZE.md your-project/
cd your-project
chmod +x .claude/hooks/*.sh
```

**Then customize:**

Open Claude Code in your project directory and paste the contents of
`CUSTOMIZE.md`. Claude will ask about your stack, commands, and preferences,
then rewrite every template file to match.

**Then start building:**

```bash
claude
```

Claude Code now knows your project. Ask it to write a spec, plan a feature,
implement code, review changes, or commit — it follows your standards
automatically.

## What's Inside

```
CLAUDE.md                                 # Project identity, stack, commands, principles
CLAUDE.local.md.example                   # Personal preferences template
.claude/
├── settings.json                         # Permissions, blocked commands, hook registration
├── rules/
│   ├── code-style.md                     # Language-specific coding standards
│   └── git-workflow.md                   # Commit message and branching conventions
├── hooks/
│   ├── protect-files.sh                  # Blocks edits to lockfiles, .env, generated files
│   ├── post-edit-reminder.sh             # Periodic reminder to run tests during editing
│   └── verify-completion.sh              # Forces verification pass before session ends
├── skills/
│   ├── spec-feature/SKILL.md             # Workflow: write a feature specification
│   ├── plan-task/SKILL.md                # Workflow: create an implementation plan
│   ├── code-review/SKILL.md              # Workflow: review changes against standards
│   ├── commit/SKILL.md                   # Workflow: test, lint, and commit with message
│   ├── catchup/SKILL.md                  # Workflow: summarize context after a break
│   └── validate-setup/SKILL.md           # Workflow: verify DevOS is configured correctly
├── agents/
│   ├── code-reviewer.md                  # Subagent: delegated code review
│   ├── verifier.md                       # Subagent: delegated verification tasks
│   └── planner.md                        # Subagent: delegated planning tasks
└── knowledge/
    ├── architecture.md                   # System architecture reference
    ├── design-decisions.md               # Architecture decision records
    └── domain-glossary.md                # Domain terminology and abbreviations
```

## What You Get

| Component                   | What it does                                                 |
| --------------------------- | ------------------------------------------------------------ |
| **Project identity**        | Claude knows your name, stack, commands, and principles every session |
| **Code style rules**        | Claude follows your language conventions when editing matching files |
| **File protection**         | Lockfiles, .env, and generated files cannot be modified by Claude |
| **Test reminders**          | Claude gets periodic nudges to run tests during long editing sessions |
| **Completion verification** | Claude must verify its work before ending a session          |
| **Structured workflows**    | Spec → Plan → Implement → Review → Commit, each with a repeatable skill |
| **Delegated agents**        | Offload review, verification, and planning to focused subagents |
| **Knowledge base**          | Architecture, decisions, and glossary available to every session |

## Examples

The `examples/` directory contains fully-customized reference configurations
for common stacks: Python/FastAPI, Go/stdlib, Rust/Axum, and
TypeScript/Next.js. Use them as a reference for what `CUSTOMIZE.md` produces,
or copy the relevant files directly.

## Documentation

See [GUIDE.md](GUIDE.md) for complete usage documentation: workflows,
commands, what happens automatically, and troubleshooting.