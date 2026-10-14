# Super Cursor MVP (Cursor Plugin)

**不是**完整母版安装。全量 rules · skills · config · Growth → [`install-super-cursor.sh`](../install-super-cursor.sh)。

本目录为 **SPRINT-PLUGIN-MVP** 本地可加载子集（lifecycle skills · 核心 rules · 最小 hooks）。范围见 `.cursorGrowth/archive/meta/*_SPIKE_plugin_mvp_scope.md`。

## 布局（默认发现）

| 路径 | 内容 |
|------|------|
| `rules/` | 核心 `.mdc`（由 `scripts/sync-plugin-subset.sh` 同步，TASK-002+） |
| `skills/` | master · plan · run · learn · scaffold |
| `hooks/hooks.json` | 会话 hooks 契约 |

无 `commands/`（slash 直挂 skill）。

## 验证

```bash
bash .cursor/bin/verify-cursor-plugin-manifest.sh
bash .cursor/bin/verify-cursor-plugin-mvp.sh
```
