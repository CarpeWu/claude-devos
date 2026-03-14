> English | [中文](GUIDE.zh.md)

# DevOS Usage Guide

## Project Structure

Every file in the DevOS template and what it does:

| File                                     | Purpose                                                      |
| ---------------------------------------- | ------------------------------------------------------------ |
| `CLAUDE.md`                              | Project identity: name, description, tech stack, key commands, core principles. Loaded every session. |
| `CLAUDE.local.md`                        | Personal preferences (communication style, local paths). Gitignored. Optional. |
| `.claude/settings.json`                  | Registers hooks, pre-approves safe commands, blocks dangerous commands. |
| `.claude/rules/code-style.md`            | Coding standards. Loaded automatically when Claude edits files matching the `globs:` pattern. |
| `.claude/rules/git-workflow.md`          | Commit message format and branching conventions. Loaded every session (no globs = unconditional). |
| `.claude/hooks/protect-files.sh`         | PreToolUse hook. Blocks edits to lockfiles, `.env`, generated files, CI configs. |
| `.claude/hooks/post-edit-reminder.sh`    | PostToolUse hook. Reminds Claude to run tests periodically during editing. |
| `.claude/hooks/verify-completion.sh`     | Stop hook. Forces Claude to verify its work before ending the session. |
| `.claude/skills/spec-feature/SKILL.md`   | Workflow for writing a feature specification document.       |
| `.claude/skills/plan-task/SKILL.md`      | Workflow for creating a step-by-step implementation plan.    |
| `.claude/skills/code-review/SKILL.md`    | Workflow for reviewing changes against project standards.    |
| `.claude/skills/commit/SKILL.md`         | Workflow for testing, linting, and committing with a conventional message. |
| `.claude/skills/catchup/SKILL.md`        | Workflow for resuming context after a break or context compaction. |
| `.claude/skills/validate-setup/SKILL.md` | Workflow for verifying DevOS is correctly configured.        |
| `.claude/agents/code-reviewer.md`        | Subagent definition for delegated code review (read-only tools, focused scope). |
| `.claude/agents/verifier.md`             | Subagent definition for delegated verification tasks.        |
| `.claude/agents/planner.md`              | Subagent definition for delegated planning and design tasks. |
| `.claude/knowledge/architecture.md`      | System architecture reference: components, data flow, dependencies. |
| `.claude/knowledge/design-decisions.md`  | Architecture decision records (ADRs) documenting why things are built a certain way. |
| `.claude/knowledge/domain-glossary.md`   | Domain-specific terminology, abbreviations, and naming conventions. |

---

## What This Document Covers

1. What DevOS is and what it gives you
2. Installation
3. What you must customize
4. Day-to-day usage: commands and workflows
5. What happens automatically
6. Troubleshooting

---

## 1. What DevOS Is and What It Gives You

DevOS is a configuration template for Claude Code. It structures your project so Claude Code behaves consistently: following your coding standards, protecting files you don't want touched, running tests before finishing, and following repeatable workflows for common tasks.

Concretely, the template gives you **20 files** organized into six categories:

| Category         | Files                                                        | Purpose                                                      |
| ---------------- | ------------------------------------------------------------ | ------------------------------------------------------------ |
| Project identity | `CLAUDE.md`, `CLAUDE.local.md`                               | Tells Claude what your project is, what stack you use, what commands to run |
| Settings         | `.claude/settings.json`                                      | Registers hooks and pre-approves/blocks specific shell commands |
| Rules            | `.claude/rules/code-style.md`, `git-workflow.md`             | Coding standards Claude follows automatically                |
| Skills           | 6 `SKILL.md` files in `.claude/skills/`                      | Step-by-step workflows for spec, plan, review, commit, catchup, validate |
| Hooks            | 3 shell scripts in `.claude/hooks/`                          | Automated guardrails: file protection, test reminders, completion verification |
| Agents           | `.claude/agents/code-reviewer.md`, `verifier.md`, `planner.md` | Subagent roles for delegation                                |
| Knowledge        | 3 files in `.claude/knowledge/`                              | Architecture reference, design decisions, domain glossary    |

**Important:** Every command, permission, and code style rule in the template defaults to Node.js/TypeScript with npm. If you use a different stack, the `CUSTOMIZE.md` prompt handles adaptation. If you're customizing manually, you must adapt `CLAUDE.md`, `.claude/settings.json`, `.claude/rules/code-style.md`, and `.claude/hooks/protect-files.sh`.

---

## 2. Installation

### Step 1: Copy the files into your project

```bash
git clone https://github.com/YOUR_ORG/claude-devos.git /tmp/claude-devos
cp /tmp/claude-devos/template/CLAUDE.md your-project/
cp /tmp/claude-devos/CUSTOMIZE.md your-project/
cp /tmp/claude-devos/template/CLAUDE.local.md.example your-project/
cp -r /tmp/claude-devos/template/.claude your-project/
cd your-project
```

### Step 2: Make hook scripts executable

```bash
chmod +x .claude/hooks/*.sh
```

This is required. The hooks won't fire if they aren't executable.

### Step 3: Update your `.gitignore`

```bash
echo "CLAUDE.local.md" >> .gitignore
echo ".claude/settings.local.json" >> .gitignore
```

`CLAUDE.local.md` contains personal preferences. `.claude/settings.local.json` contains personal setting overrides. Neither belongs in version control.

### Step 4: Verify `jq` is installed

All three hook scripts require `jq` to parse JSON input from Claude Code:

```bash
command -v jq || echo "Install jq: brew install jq (macOS) or apt install jq (Linux)"
```

Without `jq`, every hook exits with error code 1. The hooks degrade gracefully (they don't crash Claude Code), but none of the guardrails will function.

Windows users: hook scripts require a bash environment. Use WSL2 for full compatibility, or Git Bash as a partial alternative.

### Step 5: Customize for your project

Paste the contents of `CUSTOMIZE.md` into Claude Code. It will read the template files, ask about your project, and rewrite everything to match your stack. See `CUSTOMIZE.md` for details.

---

## 3. What You Must Customize

If you run `CUSTOMIZE.md`, this is handled for you. If you're customizing manually, here's what needs to change:

### Must-do (template won't work correctly without these):

**`CLAUDE.md` — Replace every placeholder:**

- `[PROJECT_NAME]` → your actual project name
- `[One-line description...]` → what your project actually is
- `[e.g., TypeScript 5.x]` → your actual language
- `[e.g., Next.js 14]` → your actual framework
- `[e.g., PostgreSQL via Prisma]` → your actual database
- `npm test`, `npm run lint`, `npm run typecheck`, `npm run dev` → your actual commands

**`.claude/settings.json` — Adapt permissions:**

The `allow` list pre-approves commands. Replace `npm`/`npx` entries with your actual commands. The `deny` list blocks dangerous commands. Replace `"Bash(npm publish*)"` with your equivalent or remove it.

**`.claude/rules/code-style.md` — Rewrite for your language:**

Change the `globs:` pattern and rewrite every rule for your language conventions.

**`.claude/hooks/protect-files.sh` — Adapt protected patterns:**

Add your lockfiles (e.g., `poetry.lock`, `go.sum`, `Cargo.lock`). Remove patterns that don't apply.

### Should-do (template works but is generic):

**`.claude/knowledge/architecture.md`, `design-decisions.md`, `domain-glossary.md`** — Fill with your actual architecture, decisions, and terminology. Until you do, Claude has no project-specific knowledge to draw on during planning and review.

### Validate:

Ask Claude to `validate the devos setup` to catch unresolved placeholders and missing configurations.

---

## 4. Day-to-Day Usage

### Starting a feature (full workflow):

**Write a spec:**

```
write a spec for user authentication
```

Claude follows the workflow from `.claude/skills/spec-feature/SKILL.md`: asks clarifying questions, reads relevant code and `architecture.md`, then writes a spec document.

**Plan the implementation:**

```
plan the implementation for the auth spec
```

Claude follows the workflow from `.claude/skills/plan-task/SKILL.md`: reads the spec, analyzes affected files, outputs a numbered step-by-step plan.

**Implement:**

```
implement the auth plan
```

No special skill — Claude follows the plan. During implementation, hooks fire automatically (see section 5).

**Review:**

```
review the changes
```

Claude follows the workflow from `.claude/skills/code-review/SKILL.md`: runs `git diff`, checks against code style rules and the spec, outputs categorized findings (critical/suggestion/nitpick).

**Commit:**

```
commit these changes
```

Claude follows the workflow from `.claude/skills/commit/SKILL.md`: runs tests and lint, reviews the diff, writes a conventional commit message, stages and commits.

### Resuming work:

After a context compaction (Claude Code tells you when this happens) or at the start of a new session:

```
catch me up
```

Claude follows the workflow from `.claude/skills/catchup/SKILL.md`: reads recent git log, checks for uncommitted changes, stashed work, and auto memory notes, then summarizes what was done and what's next.

### Validating your setup:

```
validate the devos setup
```

Claude follows the workflow from `.claude/skills/validate-setup/SKILL.md`: scans all DevOS files for unresolved placeholders, missing permissions, non-executable hooks, and configuration mismatches.

### Delegating to agents:

**Code review delegation:**

```
have the code reviewer agent review the current diff
```

Claude spawns the code-reviewer subagent (`.claude/agents/code-reviewer.md`) which is restricted to read-only tools and reviews against project standards.

**Verification delegation:**

```
have the verifier agent check that all tests pass and lint is clean
```

Claude spawns the verifier subagent (`.claude/agents/verifier.md`) to run your test and lint commands and report results.

**Planning delegation:**

```
have the planner agent design the architecture for the notification system
```

Claude spawns the planner subagent (`.claude/agents/planner.md`) to analyze the codebase and produce a design document.

---

## 5. What Happens Automatically

### On every session start:

1. `CLAUDE.md` is loaded — Claude knows your project, stack, and principles
2. `CLAUDE.local.md` is loaded if it exists — Claude knows your personal preferences
3. Auto memory is loaded — Claude remembers patterns from past sessions
4. Unconditional rules (`git-workflow.md`, which has no `globs:`) are loaded
5. Skill descriptions are indexed — Claude can match natural language to the right skill
6. `settings.json` is parsed — hooks are registered, permissions are active

### When Claude edits code files:

**Before the edit — `protect-files.sh` fires (PreToolUse hook):**

- Parses the tool input JSON to extract the target file path
- Checks if the file matches any protected pattern (lockfiles, `.env`, generated files, CI configs)
- If protected: **blocks the edit** (exits with code 2), Claude receives the error message and cannot modify the file
- If not protected: allows silently (exits with code 0)

**After the edit — `post-edit-reminder.sh` fires (PostToolUse hook):**

- Skips non-code files (`.md`, `.json`, `.yaml`, etc.)
- Checks a throttle timestamp file — if more than 120 seconds have passed since the last reminder, outputs a plain text reminder to stderr suggesting Claude consider running tests
- If less than 120 seconds: silent (exits with code 0)
- This is informational only — it does not block anything. The edit has already completed.

### When Claude edits files matching your code style glob:

The conditional rule in `.claude/rules/code-style.md` is automatically loaded because its `globs:` pattern matches the active file. Claude follows those coding standards without being asked.

### When Claude tries to finish:

**`verify-completion.sh` fires (Stop hook):**

- Analyzes the session transcript for evidence that Claude performed verification steps (ran tests, ran lint, confirmed changes match the request)
- If insufficient verification evidence is found: **blocks the stop** (outputs a verification checklist), and Claude performs the missing steps
- If verification evidence is present: allows Claude to stop (exits with code 0)
- This prevents Claude from declaring "done" without actually testing. The transcript-based check avoids infinite loops — once Claude runs the verification steps, the transcript contains that evidence, so the next check passes.

---

## 6. Troubleshooting

### Hooks not firing

**Symptom:** Claude edits protected files without being blocked, never gets test reminders, or finishes without verification.

**Check 1: Are the scripts executable?**

```bash
ls -la .claude/hooks/
```

Every `.sh` file needs the `x` permission. Fix:

```bash
chmod +x .claude/hooks/*.sh
```

**Check 2: Is `jq` installed?**

```bash
command -v jq
```

All three hooks require `jq` to parse input from Claude Code. If missing, every hook exits with code 1 and prints a diagnostic to stderr. Install with `brew install jq` (macOS) or `apt install jq` (Linux).

**Check 3: Are hooks registered in settings.json?**

Open `.claude/settings.json` and verify the `hooks` object exists with entries for `PreToolUse`, `PostToolUse`, and `Stop`, each pointing to the correct script path under `.claude/hooks/`.

**Check 4: Check hook output manually.**

```bash
echo '{"tool_name":"Write","tool_input":{"file_path":"package-lock.json"}}' | .claude/hooks/protect-files.sh
echo $?
```

Exit code 2 means the hook blocked correctly. Exit code 0 means it allowed. Exit code 1 means an error occurred (likely missing `jq`).

### Skills not being invoked

**Symptom:** You say "review my code" and Claude does a generic review instead of following the structured skill workflow.

**Cause:** Claude matches natural language to skills using the skill's description. If the description doesn't match your phrasing, the skill won't activate.

**Fix 1:** Use more explicit language that matches the skill name: "write a spec for...", "plan the task...", "do a code review of...", "commit these changes", "catch me up", "validate the devos setup".

**Fix 2:** Edit the skill's `SKILL.md` to improve its description. The description at the top of each skill file is what Claude uses for matching.

### Context getting too long

**Symptom:** Claude's responses slow down, get repetitive, or lose track of earlier conversation.

**Use `/compact`** to compress the conversation history while preserving key context. Claude Code does this automatically when context gets very long, but you can trigger it manually anytime.

**Use `/clear`** to start a fresh conversation with zero history. Claude still has `CLAUDE.md`, rules, and auto memory — it only loses the current conversation.

**After a `/clear`, say `catch me up`** to quickly rebuild context from git history and auto memory.

**When to use which:**

- `/compact` — mid-task, context is getting long but you want continuity
- `/clear` then `catch me up` — switching tasks, starting fresh, or context is beyond recovery
- Just start a new `claude` session — same effect as `/clear`, use when switching branches or coming back after a break