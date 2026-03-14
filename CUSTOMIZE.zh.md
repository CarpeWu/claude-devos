> [English](CUSTOMIZE.md) | 中文

# DevOS 个性化配置提示词

## 使用方法

将下方分隔线以下的全部内容粘贴到 Claude Code 中。支持两种使用方式：

**直接开始（推荐）：** 直接粘贴提示词。Claude 会分组逐一提问，大多数问题 5 秒内就能回答。当它询问开发原则时，请花 60 秒认真思考——这个答案会影响之后的每一次交互。

**提前准备：** 如果你已经写好了项目信息，将它们附在提示词后面一起粘贴。Claude 会自动提取已有答案，只询问缺少的部分。

---

## Prompt

I need you to customize the DevOS template installed in this project. Follow these instructions exactly.

**PHASE 1: READ THE TEMPLATE**

Read every file in the DevOS template. Do this silently — don't summarize what you read.

Files to read:
- `CLAUDE.md`
- `.claude/settings.json`
- `.claude/rules/code-style.md`
- `.claude/rules/git-workflow.md`
- `.claude/hooks/protect-files.sh`
- `.claude/hooks/post-edit-reminder.sh`
- `.claude/hooks/verify-completion.sh`
- Every `SKILL.md` in `.claude/skills/` subdirectories
- Every file in `.claude/agents/`
- Every file in `.claude/knowledge/`

Identify every placeholder (anything in `[square brackets]`), every npm/node-specific default, and every value that needs customization.

**PHASE 2: COLLECT INFORMATION**

Check whether the developer pasted project details after this prompt. If they did, extract every answer you can from what they wrote. Only ask about what's missing.

If they didn't paste anything (or you need more information), ask the following questions in THREE groups. Wait for answers after each group before proceeding.

**Group 1 — Identity and stack (you should be able to answer these immediately):**

1. What is the project name?
2. What does it do, in one sentence?
3. What is the primary programming language and version?
4. What framework(s) and version(s), if any?
5. What database and ORM/driver, if any?

**Group 2 — Commands (look these up in your package.json / Makefile / pyproject.toml / Cargo.toml if you're not sure):**

6. What is the exact command to run tests? (e.g., `pytest`, `go test ./...`, `cargo test`)
7. What is the exact command to run the linter? (e.g., `ruff check .`, `golangci-lint run`)
8. What is the exact command to run type checking? (Type `N/A` if your language doesn't have this)
9. What is the exact command to start the dev server? (Type `N/A` if not applicable)
10. Are there other commands Claude should be allowed to run without asking? (e.g., `cargo build`, `python manage.py migrate`, `make build`) List them or type "none."
11. Are there any dangerous commands Claude should be blocked from running, beyond the defaults? The defaults already block: `rm -rf /`, `git push`, `git rebase`, `curl`, `wget`, and package publishing. List any additions or type "defaults are fine."

**Group 3 — Conventions (this one matters — take 60 seconds to think before answering):**

12. What are 3–6 development principles that should guide every decision Claude makes on this project? These go at the top of CLAUDE.md and override everything else.

    Examples of strong principles:
    - "Every public function must have a test before the PR is opened"
    - "Prefer pure functions — isolate side effects at the boundaries"
    - "No ORMs — write SQL directly using prepared statements"
    - "Errors are values, never throw exceptions"
    - "Optimize for readability over cleverness"
    - "Feature flags on every new user-facing change"

    Don't say "write clean code" — that means nothing. Be specific about what you actually enforce in code review.

13. What are the source file extensions and directory patterns? (e.g., `src/**/*.py`, `**/*.go`, `lib/**/*.rb`, `src/**/*.{ts,tsx}`) This controls when code style rules activate.

14. Are there any lockfiles or generated files to protect beyond the defaults? Defaults already protect: `package-lock.json`, `yarn.lock`, `pnpm-lock.yaml`, `.env*`, `*.generated.*`, `*.gen.*`, and CI workflow files. List additions (e.g., `poetry.lock`, `go.sum`, `Cargo.lock`) or type "defaults are fine."

15. Are there any naming conventions in this project that differ from your language's standard? (e.g., "We use snake_case for database columns but camelCase in TypeScript" or "All service files are named with a `-service` suffix") Type "standard conventions" if nothing unusual.

**PHASE 3: CUSTOMIZE ALL FILES**

Once you have all answers, modify every file. Follow these rules precisely:

**`CLAUDE.md`:**
- Replace every bracketed placeholder with real values
- Replace the tech stack section with the actual stack
- Replace all four key commands with the developer's actual commands
- Replace core principles with the developer's stated principles
- Keep the section structure (Identity, Tech Stack, Key Commands, Core Principles, References)
- Keep the pointers to rules, skills, agents, and knowledge directories
- Remove any Node.js/npm references if the project doesn't use Node

**`.claude/settings.json`:**
- Replace all `npm`/`npx` entries in `allow` with the developer's actual commands, using glob patterns (e.g., `"Bash(pytest*)"`, `"Bash(cargo test*)"`)
- Replace `"Bash(npm publish*)"` in `deny` with the equivalent for the developer's ecosystem, or remove it if there's no equivalent
- Add any additional allow/deny entries the developer specified
- Keep all hook registrations exactly as they are — hooks are language-agnostic
- Keep the `Read`, `Edit`, `WebFetch`, `mcp` entries in `allow` unchanged

**`.claude/rules/code-style.md`:**
- Change the `globs:` frontmatter to the developer's file extensions and directory patterns
- Rewrite every rule in the body to match the developer's language conventions
- Incorporate any non-standard naming conventions the developer specified
- Maintain the same section headers: Naming, Functions, Error Handling, Imports/Structure
- Write rules that are specific and actionable, not vague ("use descriptive names" is bad, "function names are verb phrases describing the action performed" is good)

**`.claude/rules/git-workflow.md`:**
- No changes unless the developer's answers imply different git conventions

**`.claude/hooks/protect-files.sh`:**
- Replace the `PROTECTED_PATTERNS` array entries: remove patterns that don't apply to the developer's stack, add patterns they specified
- Keep `*.env*`, `*.generated.*`, `*.gen.*`, and `.github/workflows/*` — these are universal
- Keep all script logic unchanged

**`.claude/hooks/post-edit-reminder.sh`:**
- No changes — this script is language-agnostic. Confirm by reading it.

**`.claude/hooks/verify-completion.sh`:**
- No changes — this script is language-agnostic. Confirm by reading it.

**All SKILL.md files in `.claude/skills/`:**
- Scan for any npm/node-specific references. Replace any you find with the developer's equivalents.
- If skills reference CLAUDE.md for commands (e.g., the commit skill), leave those references — they'll resolve correctly since CLAUDE.md is now customized.

**`.claude/agents/code-reviewer.md`, `verifier.md`, and `planner.md`:**
- Scan for language-specific references. These should already be language-agnostic. Confirm and leave unchanged.

**`.claude/knowledge/architecture.md`:**
- Replace `[PROJECT_NAME]` and `[type of application]` with real values from the developer's answers
- Replace the example component diagram with:
  ```
  <!-- TODO: Draw your system's component diagram here -->
  ```
- In every template section (Key Patterns, Directory Mapping, Data Flow, External Dependencies), replace example content with:
  ```
  <!-- TODO: Fill in for your project -->
  ```
- Keep the section structure and table headers intact

**`.claude/knowledge/design-decisions.md`:**
- Replace the example ADRs with a single template:
  ```
  <!-- Add your architecture decision records below using this format:

  ## ADR-001: [Title]
  - **Date**: YYYY-MM-DD
  - **Status**: Accepted | Deprecated | Superseded
  - **Context**: What problem were you solving?
  - **Decision**: What did you decide?
  - **Consequences**: What are the tradeoffs?
  -->
  ```

**`.claude/knowledge/domain-glossary.md`:**
- Clear all example rows from every table
- Add at the top:
  ```
  <!-- TODO: Add your domain-specific terms, abbreviations, and naming conventions -->
  ```
- Keep the table headers and structure

**PHASE 4: VALIDATE**

Run `/validate-setup`. Show me the output.

Then do an independent check: run `grep -rn '\[.*\]' CLAUDE.md .claude/rules/ .claude/hooks/ .claude/skills/ .claude/agents/ .claude/knowledge/` and check every match. Ignore:
- Markdown links `[text](url)`
- Bash array syntax `[`, `]`, `[[`, `]]`
- Shell test expressions
- The ADR template in design-decisions.md (that `[Title]` is intentional)
- Regex character classes

If any real unresolved placeholders remain, fix them.

**PHASE 5: REPORT**

Give me a final report with exactly three sections:

**Changed files:** A numbered list of every file you modified, with a one-sentence summary of what changed.

**Manual TODOs:** A list of what I still need to fill in by hand (architecture diagram, design decisions, domain glossary, personal preferences in CLAUDE.local.md). For each, tell me when it becomes important — immediately, or when I hit a specific situation.

**Verification:** Confirm that zero unresolved placeholders remain, that all commands in settings.json match my actual tools, and that the code style rules match my language.
