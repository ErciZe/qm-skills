# Skill Creation Guide

Skills are the core component of a Plugin — they inject domain knowledge and workflow guidance into Agents.

---

## Directory Structure

```
skills/{skill-name}/
├── SKILL.md          # Entry file (required)
├── display.txt       # Optional, UI display entries
└── references/       # Optional, supplementary files
```

- Directory name = skill identifier, must be kebab-case
- SKILL.md is uppercase, the only entry file

---

## SKILL.md Format

```markdown
---
name: {skill-name}
displayName: {Display Name}
displayDescription: {Display description}
description: {English description for LLM trigger matching}
version: 1.0.0
tool_triggers:
  - tool: bash
    args:
      command: /my-cli\s+/i
---

# Title

Body content...
```

### Required Frontmatter

- `name`: English identifier
- `description`: Functional description for LLM (used for auto-trigger decisions)

### tool_triggers (Optional)

When matched, automatically appends SKILL.md path to tool output, guiding the Agent to read it.

By tool name: `- tool: generate_image`
By regex: `- tool: bash` + `args.command: /pattern/i`

---

## Three Skill Types + Templates

### A. Tool Usage Guide

Use when the Agent needs to call a CLI / MCP / API.

```markdown
---
name: my-tool-guide
description: Guide for using my-tool CLI. Use when user wants to manage projects or deploy.
version: 1.0.0
tool_triggers:
  - tool: bash
    args:
      command: /my-tool\s+/i
---

# My Tool Guide

## Prerequisites
- my-tool CLI installed

## Quick Start
- List projects: `my-tool list`
- Deploy: `my-tool deploy --env production`

## Examples
### Create a new project
`my-tool create --name "demo" --template typescript`

## Common Mistakes
| Wrong | Correct |
|---|---|
| `my-tool deploy` without --env | Must specify environment |
| Using curl to call API directly | Use my-tool — it handles auth |
```

### B. Workflow Type

Use when there's a clear multi-step process.

```markdown
---
name: publish-workflow
description: Step-by-step workflow for publishing content. Use when user wants to publish articles or posts.
version: 1.0.0
---

# Content Publishing Workflow

## Prerequisites
- Account connected

## Steps

### Step 1: Draft content
Create draft, confirm title and body.

### Step 2: Review checks
- Check for sensitive words
- Confirm images uploaded
- Confirm category tags

### Step 3: Publish
`publish-cli submit --draft-id {id} --schedule now`

### Step 4: Verify
Confirm status is "live" after publishing.

## Error Recovery
| Failure Point | Recovery |
|---|---|
| Step 3 timeout | Retry once; if still fails, check network |
| Step 4 abnormal status | Check review queue |
```

### C. Knowledge Base Type

Use for pure domain knowledge injection.

```markdown
---
name: pricing-rules
description: Pricing rules and discount policies. Use when user asks about pricing, discounts, or promotions.
version: 1.0.0
---

# Pricing Rules

## When to Use
- User asks about pricing strategy
- Need to calculate discounts

## When NOT to Use
- User is just browsing products (no pricing knowledge needed)

## Core Rules
1. New user first order: 10% off
2. Orders >= $300: additional $50 off
3. Members: extra 5% (stacks with threshold discount)

## Decision Table
| User Type | Order Amount | Discount |
|---|---|---|
| New user | < $300 | 10% off |
| New user | >= $300 | 10% off + $50 off |
| Member | < $300 | 15% off |
| Member | >= $300 | 15% off + $50 off |
```

---

## display.txt

UI display entries for Skill capabilities. JSON array:

```json
[
  { "id": "calendar", "type": "capability", "key": "Calendar Management", "value": "View and manage schedules" },
  { "id": "tasks", "type": "capability", "key": "Task Management", "value": "Create and track tasks" }
]
```

- Generate when Skill has multiple independent capability modules
- Skip for single-focus Skills

---

## Writing Tips

> Skill content = "lessons from Agent pitfalls", NOT "tool documentation copy-paste".

1. **Don't repeat tool self-descriptions** — MCP tools have their own description; Skill only covers what they miss
2. **Focus on counter-intuitive constraints** — Parameter format traps, required step order, easy-to-forget prerequisites
3. **Use CORRECT vs WRONG comparisons** — 10x more effective than prose
4. **description should cover synonyms** — Improves auto-trigger hit rate
5. **Start with Prerequisites** — Name dependent connectors / CLIs / permissions

---

## Full Plugin Examples

### Skill-only Plugin (Simplest)

```
faq-helper/
├── plugin.json
└── skills/
    └── faq-lookup/
        └── SKILL.md
```

```json
// plugin.json
{
  "name": "faq-helper",
  "displayName": "FAQ Helper",
  "version": "0.1.0",
  "description": "Look up answers from the FAQ knowledge base",
  "icon": "❓"
}
```

### Skill + CLI Plugin

```
my-workspace/
├── plugin.json
├── skills/
│   └── workspace-ops/
│       ├── SKILL.md
│       └── display.txt
├── clis/
│   └── clis.json
└── resources/
    ├── i18n.json
    └── icon.svg
```

### Full Plugin (Skill + SubAgent + CLI)

```
ecommerce-helper/
├── plugin.json
├── prompt.md
├── skills/
│   └── product-ops/
│       └── SKILL.md
├── subagents/
│   └── listing-optimizer/
│       └── prompt.md
├── clis/
│   └── clis.json
└── resources/
    ├── i18n.json
    ├── recommend.json
    └── icon.svg
```
