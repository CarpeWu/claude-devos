# ROLE

You are a world-class Claude Code architect and expert developer.

You deeply understand:

- Claude Code internal workflow
- CLAUDE.md architecture
- context engineering
- AI-driven software development systems
- skills, commands, hooks, and automation patterns
- memory and knowledge management for AI coding
- agentic development workflows
- scalable AI-assisted engineering practices

You are also familiar with:

- official Claude Code best practices
- workflows used by experienced Claude Code developers
- AI-first development systems and DevOS concepts

Your task is to design a **high-quality Claude Code DevOS (Development Operating System)**.

The goal is to create a **reusable personal development framework** that allows a developer to efficiently build projects with Claude Code.
---

# CONTEXT

I want to build a **Claude Code DevOS**.

DevOS is a reusable project framework that enables:

- AI-driven development
- structured workflows for Claude
- reusable prompt and automation components
- persistent project knowledge
- verification-driven development
- scalable Claude-assisted engineering

The system must follow **Claude Code best practices**:

https://code.claude.com/docs/en/best-practices

The framework should support:

- structured Claude interactions
- modular reusable workflows
- persistent knowledge management
- verification pipelines
- scalable architecture

This DevOS is currently intended for **personal development**, but it should be **extensible to team usage later**.

## TWO-PHASE DESIGN REQUIREMENT

This DevOS must be designed for two-phase usage:

**Phase 1 — Generic Template (now):**

- Provide structure, conventions, and placeholder content
- No project-specific assumptions
- All examples must be immediately reusable as-is

**Phase 2 — Project Customization (later):**

- A developer will run Claude Code against this template
  to adapt it for a specific project
- The template must make Phase 2 easy and obvious
- Use clear placeholders like [PROJECT_NAME], [TECH_STACK]
  to mark customization points

---

# IMPORTANT REQUIREMENT

Do NOT immediately generate the DevOS template.

You must think and design the architecture **step by step**.

Follow the process below strictly.
---

# CORE DESIGN PRINCIPLES

Your architecture must incorporate the following advanced concepts:

## 1. Persistent Knowledge

The system must include a structured project knowledge system.

Example:

.claude/knowledge/

Purpose:

- architecture documentation
- domain knowledge
- design decisions
- system overview

Claude should use this knowledge to understand the project before generating code.

---

## 2. Structured Project Memory

Claude Code relies heavily on persistent context.

The system must clearly define:

CLAUDE.md

Purpose:

- project instructions
- coding standards
- development rules
- mandatory workflows

This file acts as **the main memory and instruction layer for Claude**.

---

## 3. Verification-Driven Development (VDD)

Claude should never be trusted blindly.

The system must enforce **verification loops**, including:

- testing
- linting
- validation
- review passes

Claude must verify its own output before completion.

The system should also include guardrails for common Claude failure modes, such as mandatory verification before task completion and stop-and-ask triggers for ambiguous situations.

---

## 4. Specification-First Workflow

The system must support **specification-first development**, where:

spec → implementation → verification

Claude should write or refine specifications before coding.

---

## 5. Modular AI Workflows

The system should include reusable Claude automation modules.

Examples may include:

skills
commands
hooks

These enable reusable development workflows.
---

# REQUIRED PROCESS

Follow these steps sequentially.

---

## STEP 1 — Extract Claude Code Engineering Principles

Analyze Claude Code best practices and derive the key principles required for building a Claude-driven development system.

Focus on:

- context engineering
- planning before coding
- iterative workflows
- verification and testing
- context management
- documentation

---

## STEP 2 — Identify Core DevOS Components

Identify the essential components of a Claude DevOS.

Note: CLAUDE.md has a layered architecture in Claude Code — root-level, directory-level, and .claude/rules/ for conditional loading. Your component design must reflect this.

Examples include (but are not limited to):

CLAUDE.md
.claude/knowledge
.claude/rules
.claude/skills
.claude/commands
.claude/hooks

Explain the role and responsibilities of each component.

---

## STEP 3 — Design the DevOS Architecture

Design the full architecture of the system.

Explain:

- how components interact
- how Claude reads knowledge and rules
- how development workflows are orchestrated
- how context is managed
- how Claude performs planning and execution

---

## STEP 4 — Design the Reusable DevOS Template

Define the full repository structure.

Include:

- directory layout
- Claude-specific directories
- documentation structure
- automation files

Provide a clear repository tree.

---

## STEP 5 — Design the Development Workflow

Explain how developers should use DevOS with Claude Code.

Include:

- project initialization
- feature development workflow
- specification workflow
- verification workflow
- context management

---

## STEP 6 — Provide Example Core Files

Provide example versions of key files.

Examples include:

CLAUDE.md
example skill
example command
example hook (with lifecycle slot structure)
example knowledge document (as fillable structure)
example .claude/rules/ file

Each example must be:

- minimal but production-quality in structure
- clearly marked with customization points for Phase 2
- well-commented explaining design intent

---

## STEP 7 — Extension Strategy

Explain how DevOS can evolve later.

Include strategies for:

- adding new skills
- creating specialized workflows
- expanding the knowledge system
- scaling for teams
- integrating CI/CD

---

# OUTPUT STRUCTURE

Your response must contain the following sections:

1. Claude Code Engineering Principles
2. DevOS Core Components
3. DevOS Architecture
4. DevOS Template Structure
5. Development Workflow
6. Example Core Files
7. Extension Strategy

Formatting rules:

- Directory structures must use code block with tree format
- All file examples must be complete, copy-pasteable code blocks
- Architecture interactions should include a diagram (text-based or Mermaid)

---

# QUALITY REQUIREMENTS

Take time to think deeply.

The result must be:

- highly structured
- practical for real projects
- aligned with Claude Code best practices
- reusable across many projects
- designed for long-term use

Additionally:

- CLAUDE.md must be token-efficient — concise rules, not exhaustive documentation
  (it is loaded into every conversation and consumes context window)
- CLAUDE.md should demonstrate awareness of the layered architecture
  (root-level, directory-level, and .claude/rules/ for conditional loading)
- Hooks must define lifecycle slots (PreToolUse / PostToolUse / Stop)
  even if empty, with comments explaining their purpose
- Knowledge documents must be placeholder structures, not filled content
- Example files must be well-commented, explaining what to customize in Phase 2
- The system must include explicit guardrails
  (verification gates, ambiguity stop-triggers)
  as structural components, not just documented advice

Avoid shallow explanations.

Focus on **real developer workflows and system architecture**.