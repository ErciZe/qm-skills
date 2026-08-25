# Plugin Spec Reference

One-stop reference for plugin.json fields, SubAgent, CLI Tools, and i18n configuration.

---

## 1. plugin.json Fields

### Metadata Fields

| Field | Type | Required | Description |
|---|---|---|---|
| name | string | ✅ | Plugin name (human-readable, slugified as plugin id) |
| description | string | ✅ | One-line description of what the plugin does |
| version | string | Recommended | Semantic version for upgrade detection |
| id | string | — | Explicit plugin id (defaults to slugified name) |
| displayName | string | — | Display name (falls back to name) |
| longDescription | string | — | Long description (Markdown) for detail page |
| author | string / {name, email, url} | — | Author |
| icon | string | — | Emoji / image filename under resources/ / HTTP(S) URL |
| category | string | Recommended | Category for grouping (free text, e.g. "finance", "hr", "devops") |
| tags | string[] | — | Tags for search and classification |

### Component Fields

| Field | Type | Description |
|---|---|---|
| subAgents | object[] | SubAgent array (must be explicitly declared, not scanned) |
| recommend | object[] | Homepage recommended prompts (also accepts resources/recommend.json) |


### plugin.json Example

```json
{
  "name": "my-plugin",
  "displayName": "My Plugin",
  "version": "0.1.0",
  "description": "One-line description of what it does",
  "author": "Your Name",
  "icon": "🔧",
  "category": "finance",
  "tags": ["keyword1", "keyword2"]
}
```

---

## 2. SubAgent

### Core Mechanism

**Dual confirmation**: plugin.json → `subAgents[]` declaration + `subagents/<id>/` directory exists → registered. Either missing → skipped with warning.

Registered id format: `${pluginId}:${subAgentId}`. Host Agent dispatches via `sessions_spawn(agent_id="my-plugin:product-analyzer")`.

### Directory Structure

```
subagents/{id}/
├── prompt.md           # Default systemPrompt source
└── handlers/           # customTools handlers (optional, advanced)
    └── {tool}.js
```

### Declaration Fields

| Field | Type | Required | Description |
|---|---|---|---|
| id | string | ✅ | Must match directory name |
| description | string | ✅ | Dispatch description for host Agent |
| systemPromptFile | string | — | Defaults to subagents/<id>/prompt.md |
| tools | "inherit" / string[] | — | inherit = inherit host Agent toolset |
| skills | object[] | — | Accessible Skill list |
| timeoutSeconds | number | — | Timeout, default 300 |
| customTools | object[] | — | Custom JS tools (advanced) |

### Skills Reference

```json
"skills": [
  { "id": "my-skill", "mode": "systemPrompt" },
  { "id": "big-reference", "mode": "indexed" }
]
```

Selection rule:
- Skill < 2K tokens AND usage > 80% → `systemPrompt`
- Skill > 5K tokens AND usage < 50% → `indexed`
- Otherwise → lean toward `indexed`

### customTools Handler (Advanced, most don't need)

```javascript
// subagents/{id}/handlers/{tool}.js — CommonJS
module.exports = async function(args, ctx) {
  // ctx.fetch / ctx.log / ctx.sessionKey / ctx.workspaceDir
  const { param } = args;
  return { result: "value" }; // Serialized as JSON back to SubAgent
};
```

Constraints: No fs / child_process / process.env; path must stay within plugin directory.

### Declaration Example

```json
{
  "subAgents": [
    {
      "id": "listing-optimizer",
      "description": "Optimize product titles and descriptions to improve search ranking",
      "tools": "inherit",
      "timeoutSeconds": 300,
      "skills": [
        { "id": "product-ops", "mode": "systemPrompt" }
      ]
    }
  ]
}
```

---

## 3. CLI Tools

### File Location

`clis/clis.json` (top-level field: `tools`). Takes priority over plugin.json inline.

### Format

```json
{
  "tools": [
    {
      "id": "my-cli",
      "displayName": "My CLI",
      "description": "Tool description",
      "verifyArgs": ["--version"],
      "usageExamples": ["my-cli run --target prod"],
      "exposure": "all-agents",
      "source": { ... }
    }
  ]
}
```

### Fields

| Field | Required | Description |
|---|---|---|
| id | ✅ | Tool ID |
| source | ✅ | Install source (pick one of three) |
| displayName | — | Display name |
| description | — | Description |
| verifyArgs | — | Verification args, e.g. ["--version"] |
| usageExamples | — | Usage examples |
| exposure | — | "declared-agents" (default) or "all-agents" |

### Three Install Sources

**A. npm-package**
```json
{ "type": "npm-package", "packageName": "@scope/cli", "version": "1.0.0", "binName": "cli" }
```

**B. bundled-binary**
```json
{
  "type": "bundled-binary",
  "binName": "my-cli",
  "platforms": {
    "darwin-arm64": { "path": "bin/my-cli-darwin-arm64" },
    "darwin-x64": { "path": "bin/my-cli-darwin-x64" },
    "linux-x64": { "path": "bin/my-cli-linux-x64" },
    "win32-x64": { "path": "bin/my-cli-win32-x64.exe" }
  }
}
```

**C. node-cli**
```json
{ "type": "node-cli", "entry": "scripts/my-cli.js", "commandName": "my-cli", "moduleFormat": "esm" }
```

---

## 4. i18n (Internationalization)

### File

`resources/i18n.json` — **must use entries format** (flat format is not supported and silently ignored).

### Format

```json
{
  "version": "1.0",
  "defaultLocale": "zh",
  "entries": {
    "plugin.displayName": { "en": "My Plugin", "ja": "マイプラグイン" },
    "plugin.description": { "en": "English description" },
    "skill.{skillId}.name": { "en": "Skill Name" },
    "skill.{skillId}.description": { "en": "Skill description" },
    "skill.{skillId}.display.{entryId}.key": { "en": "Title" },
    "skill.{skillId}.display.{entryId}.value": { "en": "Description" },
    "cli.{cliId}.displayName": { "en": "CLI Name" },
    "subAgent.{subAgentId}.description": { "en": "SubAgent description" }
  }
}
```

### Rules

- `defaultLocale` language is written directly in source files — **do not** repeat in entries
- entries contain only non-default language translations
- skillId = directory name under skills/, cliId = tool id in clis.json

### Translation Priority

P0 Required: plugin.displayName, plugin.description
P1 Recommended: skill name/description, cli displayName
P2 Optional: display.txt entries, longDescription

---

## 5. Resources

### recommend.json

```json
[
  {
    "title": "Section title",
    "prompts": [
      { "text": "Suggested prompt 1" },
      { "text": "Suggested prompt 2" }
    ]
  }
]
```

### Icon

- Place under `resources/`; write just the filename in plugin.json (system auto-prepends resources/ prefix)
- Supports SVG / PNG / JPG / GIF / WebP
- Recommended: 256×256

---

## 6. Key Conventions

| Rule | Description |
|---|---|
| plugin.json is the single source of truth | System only reads plugin.json to decide what to load |
| skills/ is auto-scanned | Any directory with SKILL.md is recognized; no need to list in plugin.json |
| SubAgent dual confirmation | Both declaration + directory must exist to register |
| All paths relative to plugin root | No traversal allowed |
| clis.json top-level field is `tools` | Not an array, not `cliTools` |
| i18n uses entries format | Flat key-value format is not supported |

---

## 7. Common Mistakes

| Mistake | Correct Approach |
|---|---|
| clis.json as `[...]` | Must be `{ "tools": [...] }` |
| SubAgent declared but no directory | Both declaration + directory required |
| Handler uses fs | First version only supports network/computation |
| Skill directory with underscores | Use kebab-case |
| i18n in flat format | Use entries format |
| display.txt not a JSON array | Must be `[{id, type, key, value}]` |
| Icon path as resources/resources/ | Write filename only; system auto-prepends prefix |
