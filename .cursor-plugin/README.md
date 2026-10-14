# Super Cursor MVP (Cursor Plugin)

**不是**完整母版安装。全量 rules · skills · config · Growth → [`install-super-cursor.sh`](../install-super-cursor.sh)。

本目录为 **Plugin MVP + agents** 本地可加载子集（lifecycle skills · **ship/review/spike** · 核心 rules · 最小 hooks）。范围见 `*_SPIKE_plugin_mvp_scope.md` · `*_SPIKE_plugin_agents_scope.md`（Growth）。

## 布局（默认发现）

| 路径 | 内容 |
|------|------|
| `rules/` | 核心 `.mdc`（`bash .cursor/bin/sync-plugin-subset.sh` 从 `.cursor/` 同步；`feedback/verify.mdc` 须与母版分组门禁一致） |
| `skills/` | master · plan · run · learn · scaffold |
| `agents/` | ship · review · spike |
| `hooks/hooks.json` | 会话 hooks 契约 |

无 `commands/`（slash 直挂 skill）· 无 `config/`（**先 install** 再依赖 hooks 读 `workflow.json`）。

## 与 install / skills-bundle

| 轨 | 说明 |
|----|------|
| **install**（默认 28 skills） | SSOT · 全量 config/hooks/verify |
| **`--skills-bundle core`**（23） | 非 Plugin；仍 install 到 `.cursor/` |
| **本 Plugin**（5 skills） | 本地子集；≠ core。三轨矩阵 → `cursor-platform.md` §分发三轨 |

## 验证

```bash
bash .cursor/bin/verify-cursor-plugin-manifest.sh
bash .cursor/bin/verify-cursor-plugin-mvp.sh
```
