# Super Cursor MVP (Cursor Plugin)

**不是**完整母版安装。全量 rules · skills · config · Growth → [`install-super-cursor.sh`](../install-super-cursor.sh)。

本目录为 **Plugin MVP + agents** 本地可加载子集（lifecycle skills · **ship/review/spike** · 核心 rules · 最小 hooks）。范围见 `*_SPIKE_plugin_mvp_scope.md` · `*_SPIKE_plugin_agents_scope.md`（Growth）。

## 布局（默认发现）

| 路径 | 内容 |
|------|------|
| `rules/` | 核心 `.mdc`（`bash .cursor/bin/sync-plugin-subset.sh` 从 `.cursor/` 同步） |
| `skills/` | master · plan · run · learn · scaffold |
| `agents/` | ship · review · spike |
| `hooks/hooks.json` | 会话 hooks 契约 |

无 `commands/`（slash 直挂 skill）。

## 验证

```bash
bash .cursor/bin/verify-cursor-plugin-manifest.sh
bash .cursor/bin/verify-cursor-plugin-mvp.sh
```
