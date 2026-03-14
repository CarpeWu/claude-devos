> [English](README.md) | 中文

# claude-devos

为 Claude Code 打造的结构化开发操作系统。让你的 AI 编程助手拥有一致的行为：了解项目背景、执行代码规范、保护关键文件、自动验证结果，并遵循可复用的工作流完成需求分析、实现计划、代码审查和提交。

没有它，Claude Code 每次会话都从零开始，对你的项目一无所知。有了它，Claude Code 了解你的技术栈，遵守你的规则，并在宣布完成之前跑完测试。

## 前置条件

- 已安装并可用的 [Claude Code](https://docs.anthropic.com/en/docs/claude-code)
- 已安装 `jq`（macOS：`brew install jq`，Linux：`apt install jq`）
- 推荐 macOS 或 Linux。Windows 用户请使用 WSL2 以获得完整兼容性。

## 快速开始

**方式 A：一键安装**

```bash
cd your-project
git clone https://github.com/CarpeWu/claude-devos.git /tmp/claude-devos
/tmp/claude-devos/install.sh
```

**方式 B：手动复制**

```bash
git clone https://github.com/CarpeWu/claude-devos.git /tmp/claude-devos
cp /tmp/claude-devos/template/CLAUDE.md your-project/
cp /tmp/claude-devos/template/CLAUDE.local.md.example your-project/
cp -r /tmp/claude-devos/template/.claude your-project/
cp /tmp/claude-devos/CUSTOMIZE.md your-project/
cd your-project
chmod +x .claude/hooks/*.sh
```

**然后个性化配置：**

在项目目录中打开 Claude Code，将 `CUSTOMIZE.md` 的内容粘贴进去。Claude 会询问你的技术栈、命令和偏好，然后自动改写所有模板文件。

**然后开始开发：**

```bash
claude
```

Claude Code 现在了解你的项目了。告诉它写需求文档、规划功能、实现代码、审查改动或提交——它会自动遵守你的规范。

## 包含内容

```
CLAUDE.md                                 # 项目身份、技术栈、命令、核心原则
CLAUDE.local.md.example                   # 个人偏好模板
.claude/
├── settings.json                         # 权限、禁止命令、hook 注册
├── rules/
│   ├── code-style.md                     # 特定语言的代码规范
│   └── git-workflow.md                   # commit 信息和分支约定
├── hooks/
│   ├── protect-files.sh                  # 阻止 Claude 修改锁文件、.env、生成文件
│   ├── post-edit-reminder.sh             # 编辑代码时定期提醒跑测试
│   └── verify-completion.sh              # 会话结束前强制执行验证
├── skills/
│   ├── spec-feature/SKILL.md             # 工作流：编写功能需求文档
│   ├── plan-task/SKILL.md                # 工作流：创建实现计划
│   ├── code-review/SKILL.md              # 工作流：按规范审查代码改动
│   ├── commit/SKILL.md                   # 工作流：测试、lint 并提交
│   ├── catchup/SKILL.md                  # 工作流：中断后恢复上下文
│   └── validate-setup/SKILL.md           # 工作流：验证 DevOS 配置正确性
├── agents/
│   ├── code-reviewer.md                  # 子 agent：委托代码审查
│   ├── verifier.md                       # 子 agent：委托验证任务
│   └── planner.md                        # 子 agent：委托规划任务
└── knowledge/
    ├── architecture.md                   # 系统架构参考文档
    ├── design-decisions.md               # 架构决策记录（ADR）
    └── domain-glossary.md                # 领域术语和缩写
```

## 你将获得

| 组件 | 作用 |
|------|------|
| **项目身份** | 每次会话 Claude 都了解你的项目名称、技术栈、命令和核心原则 |
| **代码规范** | Claude 编辑匹配文件时自动遵守你的语言约定 |
| **文件保护** | Claude 无法修改锁文件、.env 和生成文件 |
| **测试提醒** | 长时间编辑会话中 Claude 会定期收到跑测试的提示 |
| **完成验证** | Claude 在结束会话前必须验证其工作成果 |
| **结构化工作流** | 需求 → 计划 → 实现 → 审查 → 提交，每个环节都有可复用的 skill |
| **委托 agent** | 将审查、验证、规划任务外包给专注的子 agent |
| **知识库** | 架构文档、决策记录和术语表在每次会话中都可供参考 |

## 示例

`examples/` 目录包含常见技术栈的完整配置参考：Python/FastAPI、Go/stdlib、Rust/Axum 和 TypeScript/Next.js。可以作为 `CUSTOMIZE.md` 输出结果的参考，或直接复制对应文件使用。

## 文档

完整使用文档请参阅 [GUIDE.zh.md](GUIDE.zh.md)：工作流、命令、自动化机制和故障排查。
