> [English](GUIDE.md) | 中文

# DevOS 使用指南

## 项目结构

DevOS 模板中每个文件的作用：

| 文件 | 用途 |
|------|------|
| `CLAUDE.md` | 项目身份：名称、描述、技术栈、关键命令、核心原则。每次会话都会加载。 |
| `CLAUDE.local.md` | 个人偏好（沟通风格、本地路径）。已 gitignore，可选。 |
| `.claude/settings.json` | 注册 hooks、预批准安全命令、屏蔽危险命令。 |
| `.claude/rules/code-style.md` | 代码规范。当 Claude 编辑匹配 `globs:` 模式的文件时自动加载。 |
| `.claude/rules/git-workflow.md` | commit 信息格式和分支约定。每次会话都加载（无 globs = 无条件加载）。 |
| `.claude/hooks/protect-files.sh` | PreToolUse hook。阻止编辑锁文件、`.env`、生成文件、CI 配置。 |
| `.claude/hooks/post-edit-reminder.sh` | PostToolUse hook。编辑期间定期提醒 Claude 跑测试。 |
| `.claude/hooks/verify-completion.sh` | Stop hook。在会话结束前强制 Claude 验证其工作。 |
| `.claude/skills/spec-feature/SKILL.md` | 编写功能需求文档的工作流。 |
| `.claude/skills/plan-task/SKILL.md` | 创建逐步实现计划的工作流。 |
| `.claude/skills/code-review/SKILL.md` | 按项目规范审查改动的工作流。 |
| `.claude/skills/commit/SKILL.md` | 测试、lint 并用规范信息提交的工作流。 |
| `.claude/skills/catchup/SKILL.md` | 中断或上下文压缩后恢复进度的工作流。 |
| `.claude/skills/validate-setup/SKILL.md` | 验证 DevOS 配置是否正确的工作流。 |
| `.claude/agents/code-reviewer.md` | 委托代码审查的子 agent 定义（只读工具，专注范围）。 |
| `.claude/agents/verifier.md` | 委托验证任务的子 agent 定义。 |
| `.claude/agents/planner.md` | 委托规划和设计任务的子 agent 定义。 |
| `.claude/knowledge/architecture.md` | 系统架构参考：组件、数据流、依赖关系。 |
| `.claude/knowledge/design-decisions.md` | 架构决策记录（ADR），记录为何如此构建。 |
| `.claude/knowledge/domain-glossary.md` | 领域特定术语、缩写和命名约定。 |

---

## 本文档涵盖内容

1. DevOS 是什么及其作用
2. 安装
3. 必须定制的内容
4. 日常使用：命令和工作流
5. 自动发生的事情
6. 故障排查

---

## 1. DevOS 是什么及其作用

DevOS 是 Claude Code 的配置模板。它让你的项目结构化，使 Claude Code 行为一致：遵守代码规范、保护不希望被修改的文件、完成前跑测试、按可复用工作流处理常见任务。

模板具体提供 **20 个文件**，分为六类：

| 分类 | 文件 | 用途 |
|------|------|------|
| 项目身份 | `CLAUDE.md`、`CLAUDE.local.md` | 告知 Claude 项目是什么、使用什么技术栈、运行什么命令 |
| 配置 | `.claude/settings.json` | 注册 hooks 并预批准/屏蔽特定 shell 命令 |
| 规范 | `.claude/rules/code-style.md`、`git-workflow.md` | Claude 自动遵守的代码规范 |
| Skills | `.claude/skills/` 下的 6 个 `SKILL.md` | 需求、计划、审查、提交、恢复、验证的逐步工作流 |
| Hooks | `.claude/hooks/` 下的 3 个 shell 脚本 | 自动化守卫：文件保护、测试提醒、完成验证 |
| Agents | `code-reviewer.md`、`verifier.md`、`planner.md` | 委托用的子 agent 角色 |
| 知识库 | `.claude/knowledge/` 下的 3 个文件 | 架构参考、设计决策、领域术语 |

**重要说明：** 模板中所有命令、权限和代码规范默认使用 Node.js/TypeScript + npm。如果你使用其他技术栈，`CUSTOMIZE.md` 提示词会处理适配。手动定制时，你需要修改 `CLAUDE.md`、`.claude/settings.json`、`.claude/rules/code-style.md` 和 `.claude/hooks/protect-files.sh`。

---

## 2. 安装

### 第一步：将文件复制到你的项目

```bash
git clone https://github.com/CarpeWu/claude-devos.git /tmp/claude-devos
cp /tmp/claude-devos/template/CLAUDE.md your-project/
cp /tmp/claude-devos/template/CUSTOMIZE.md your-project/
cp /tmp/claude-devos/template/CLAUDE.local.md.example your-project/
cp -r /tmp/claude-devos/template/.claude your-project/
cd your-project
```

### 第二步：赋予 hook 脚本执行权限

```bash
chmod +x .claude/hooks/*.sh
```

这一步是必须的。没有执行权限，hooks 不会触发。

### 第三步：更新 `.gitignore`

```bash
echo "CLAUDE.local.md" >> .gitignore
echo ".claude/settings.local.json" >> .gitignore
```

`CLAUDE.local.md` 包含个人偏好，`.claude/settings.local.json` 包含个人配置覆盖，两者都不应纳入版本控制。

### 第四步：确认已安装 `jq`

三个 hook 脚本都需要 `jq` 来解析 Claude Code 的 JSON 输入：

```bash
command -v jq || echo "Install jq: brew install jq (macOS) or apt install jq (Linux)"
```

没有 `jq`，每个 hook 都会以错误码 1 退出。hooks 会优雅降级（不会导致 Claude Code 崩溃），但所有守卫机制都将失效。

Windows 用户：hook 脚本需要 bash 环境，请使用 WSL2 以获得完整兼容性，或使用 Git Bash 作为部分替代方案。

### 第五步：个性化配置

将 `CUSTOMIZE.md` 的内容粘贴到 Claude Code 中。它会读取模板文件，询问你的项目情况，然后改写所有内容以匹配你的技术栈。详见 `CUSTOMIZE.md`。

---

## 3. 必须定制的内容

运行 `CUSTOMIZE.md` 会自动处理这些。手动定制时，需要修改以下内容：

### 必须做（不做模板无法正常工作）：

**`CLAUDE.md` — 替换所有占位符：**
- `[PROJECT_NAME]` → 实际项目名称
- `[One-line description...]` → 项目的实际描述
- `[e.g., TypeScript 5.x]` → 实际语言
- `[e.g., Next.js 14]` → 实际框架
- `[e.g., PostgreSQL via Prisma]` → 实际数据库
- `npm test`、`npm run lint`、`npm run typecheck`、`npm run dev` → 实际命令

**`.claude/settings.json` — 适配权限：**

`allow` 列表预批准命令，将 `npm`/`npx` 条目替换为你的实际命令。`deny` 列表屏蔽危险命令，将 `"Bash(npm publish*)"` 替换为你的等效命令或直接删除。

**`.claude/rules/code-style.md` — 为你的语言重写：**

修改 `globs:` 模式，并为你的语言约定重写所有规则。

**`.claude/hooks/protect-files.sh` — 适配保护模式：**

添加你的锁文件（如 `poetry.lock`、`go.sum`、`Cargo.lock`），删除不适用的模式。

### 建议做（不做模板能运行但内容是通用的）：

**`.claude/knowledge/architecture.md`、`design-decisions.md`、`domain-glossary.md`** — 填入你的实际架构、决策和术语。不填的话，Claude 在规划和审查时没有项目特定的知识可参考。

### 验证：

让 Claude 执行 `validate the devos setup`，检查未替换的占位符和缺失的配置。

---

## 4. 日常使用

### 开始一个功能（完整工作流）：

**编写需求文档：**

```
write a spec for user authentication
```

Claude 按照 `.claude/skills/spec-feature/SKILL.md` 的工作流执行：提问澄清需求，读取相关代码和 `architecture.md`，然后生成需求文档。

**规划实现：**

```
plan the implementation for the auth spec
```

Claude 按照 `.claude/skills/plan-task/SKILL.md` 的工作流执行：读取需求文档，分析受影响的文件，输出编号的逐步实现计划。

**实现：**

```
implement the auth plan
```

无需特殊 skill——Claude 按计划执行。实现过程中 hooks 会自动触发（见第 5 节）。

**审查：**

```
review the changes
```

Claude 按照 `.claude/skills/code-review/SKILL.md` 的工作流执行：运行 `git diff`，对照代码规范和需求文档检查，输出分级的发现（critical/suggestion/nitpick）。

**提交：**

```
commit these changes
```

Claude 按照 `.claude/skills/commit/SKILL.md` 的工作流执行：跑测试和 lint，审查 diff，生成规范的 commit 信息，暂存并提交。

### 恢复工作：

上下文压缩后（Claude Code 会告知你）或新会话开始时：

```
catch me up
```

Claude 按照 `.claude/skills/catchup/SKILL.md` 的工作流执行：读取近期 git log，检查未提交的改动、stash 内容和自动记忆笔记，然后总结已完成的工作和下一步。

### 验证配置：

```
validate the devos setup
```

Claude 按照 `.claude/skills/validate-setup/SKILL.md` 的工作流执行：扫描所有 DevOS 文件中未替换的占位符、缺失的权限、没有执行权限的 hooks 和配置不一致。

### 委托给 agent：

**委托代码审查：**

```
have the code reviewer agent review the current diff
```

Claude 启动 code-reviewer 子 agent（`.claude/agents/code-reviewer.md`），该 agent 仅有只读工具，按项目规范进行审查。

**委托验证：**

```
have the verifier agent check that all tests pass and lint is clean
```

Claude 启动 verifier 子 agent（`.claude/agents/verifier.md`），运行你的测试和 lint 命令并报告结果。

**委托规划：**

```
have the planner agent design the architecture for the notification system
```

Claude 启动 planner 子 agent（`.claude/agents/planner.md`），分析代码库并生成设计文档。

---

## 5. 自动发生的事情

### 每次会话启动时：

1. 加载 `CLAUDE.md` — Claude 了解你的项目、技术栈和原则
2. 加载 `CLAUDE.local.md`（如存在）— Claude 了解你的个人偏好
3. 加载自动记忆 — Claude 记住过去会话中的模式
4. 加载无条件规范（`git-workflow.md`，没有 `globs:`）
5. 索引 skill 描述 — Claude 能将自然语言匹配到正确的 skill
6. 解析 `settings.json` — hooks 注册完毕，权限生效

### 当 Claude 编辑代码文件时：

**编辑前 — `protect-files.sh` 触发（PreToolUse hook）：**

- 解析工具输入 JSON，提取目标文件路径
- 检查文件是否匹配任何保护模式（锁文件、`.env`、生成文件、CI 配置）
- 若受保护：**阻止编辑**（退出码 2），Claude 收到错误信息，无法修改该文件
- 若不受保护：静默放行（退出码 0）

**编辑后 — `post-edit-reminder.sh` 触发（PostToolUse hook）：**

- 跳过非代码文件（`.md`、`.json`、`.yaml` 等）
- 检查节流时间戳——如果距上次提醒超过 120 秒，向 Claude 输出一条提醒，建议考虑跑测试
- 不足 120 秒：静默（退出码 0）
- 仅供参考，不阻止任何操作。编辑已经完成。

### 当 Claude 编辑匹配代码规范 glob 的文件时：

`.claude/rules/code-style.md` 中的条件规范会自动加载，因为其 `globs:` 模式匹配了当前文件。Claude 无需提示即遵守这些规范。

### 当 Claude 尝试结束时：

**`verify-completion.sh` 触发（Stop hook）：**

- 分析会话 transcript，寻找 Claude 已执行验证步骤的证据（跑了测试、跑了 lint、确认改动符合需求）
- 验证证据不足：**阻止结束**（输出验证清单），Claude 执行缺失的步骤
- 验证证据充分：允许 Claude 结束（退出码 0）
- 这防止了 Claude 在未实际测试的情况下宣布"完成"。基于 transcript 的检测避免了无限循环——一旦 Claude 执行了验证步骤，transcript 中就有了证据，下次检查即可通过。

---

## 6. 故障排查

### Hooks 未触发

**现象：** Claude 编辑受保护文件未被阻止，从未收到测试提醒，或未经验证就结束了。

**检查 1：脚本是否有执行权限？**

```bash
ls -la .claude/hooks/
```

每个 `.sh` 文件都需要 `x` 权限。修复方法：

```bash
chmod +x .claude/hooks/*.sh
```

**检查 2：是否安装了 `jq`？**

```bash
command -v jq
```

三个 hooks 都需要 `jq` 解析 Claude Code 的输入。若缺失，每个 hook 都以退出码 1 退出并向 stderr 输出诊断信息。安装方法：`brew install jq`（macOS）或 `apt install jq`（Linux）。

**检查 3：hooks 是否在 settings.json 中注册？**

打开 `.claude/settings.json`，确认 `hooks` 对象存在，且 `PreToolUse`、`PostToolUse`、`Stop` 各有条目，指向 `.claude/hooks/` 下正确的脚本路径。

**检查 4：手动测试 hook 输出。**

```bash
echo '{"tool_name":"Write","tool_input":{"file_path":"package-lock.json"}}' | .claude/hooks/protect-files.sh
echo $?
```

退出码 2 表示 hook 正确阻止。退出码 0 表示放行。退出码 1 表示发生错误（可能是缺少 `jq`）。

### Skills 未被调用

**现象：** 你说"review my code"，Claude 做了通用审查而不是按结构化 skill 工作流执行。

**原因：** Claude 通过 skill 的描述字段匹配自然语言请求。描述与你的措辞不匹配时，skill 不会激活。

**修复 1：** 使用与 skill 名称更接近的明确措辞："write a spec for..."、"plan the task..."、"do a code review of..."、"commit these changes"、"catch me up"、"validate the devos setup"。

**修复 2：** 编辑 skill 的 `SKILL.md`，改进其描述。每个 skill 文件顶部的描述字段就是 Claude 用来匹配的内容。

### 上下文过长

**现象：** Claude 响应变慢、开始重复，或忘记了早先的对话内容。

**使用 `/compact`** 压缩对话历史，同时保留关键上下文。Claude Code 在上下文很长时会自动执行，你也可以随时手动触发。

**使用 `/clear`** 开始零历史的全新对话。Claude 仍有 `CLAUDE.md`、规范和自动记忆——只是丢失了当前对话。

**`/clear` 之后说 `catch me up`**，从 git 历史和自动记忆中快速重建上下文。

**何时用哪个：**

- `/compact` — 任务进行中，上下文变长但需要保持连续性
- `/clear` 然后 `catch me up` — 切换任务、重新开始，或上下文已无法挽救
- 直接开启新的 `claude` 会话 — 效果等同于 `/clear`，适合切换分支或休息后回来继续
