# Cursor 平台对齐（消费方 / 母版维护）

> 差距全表 → `.cursorGrowth/archive/meta/*_SPIKE_cursor_official_align.md`（母版仓）· 官方主题索引 → `.cursor/docs/library-index.md` §Cursor 官方平台。

## 已采纳（维持）

| 面 | 做法 |
|----|------|
| Rules | `.cursor/rules/*.mdc` + 根 `AGENTS.md`；Bugbot 规则**不进** `.mdc` |
| Skills | `.cursor/skills/<name>/SKILL.md`；生命周期类 `disable-model-invocation: true` → 仅显式 `/skill` |
| Hooks | `.cursor/hooks.json` + `.cursor/hooks/*.sh`（项目根相对路径） |
| Subagents | `.cursor/agents/*.md`（review · ship · spike） |
| 闸门 | `runner.sh gate-check` · `.cursorGrowth/plan.md` 元数据 |

## 本 Sprint 变更中

| 项 | 状态 |
|----|------|
| 退役 `.cursor/commands/` | TASK-004 · slash 与内容均以 skill 为 SSOT |
| MCP / Cloud / Bugbot 模板 | `templates/cursorGrowth/` 可选复制，不随 install 默认注入 |

## Monorepo 消费方

- 子包可加嵌套 `AGENTS.md` 与 `.cursor/skills/`（官方支持目录级发现）。
- 文件级 skill 优先用 frontmatter **`paths`**（优于仅 rules 的 `globs`）。
- Cloud Agents：提交 repo hooks + 可选 `.cursor/environment.json`；密钥走 Dashboard，不进 git。

## 分发

- **默认**：`install-super-cursor.sh` + profile（full / lite / rules-only）。
- **Plugin 形态**：见 Sprint TASK-006 / archive；非 install 替代品。
