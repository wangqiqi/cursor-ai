# Cursor Cloud · MCP（可选配置）

> 官方 SSOT：`cursor.com/docs` — **MCP** · **Cloud Agents** · **cloud-agent/setup**（环境）。母版索引 → `library-index.md` §Cursor 官方平台。

Super Cursor **默认不**把 MCP / Cloud 配置写入 install 复制的 `.cursor/`。需要时从模板复制并 commit。

## 复制路径

| 模板（install 后路径） | 目标 |
|------------------------|------|
| `.cursor/templates/cursorGrowth/mcp.json.example` | `.cursor/mcp.json` |
| `.cursor/templates/cursorGrowth/environment.json.example` | `.cursor/environment.json`（**默认仅 `install`**） |
| `.cursor/templates/cursorGrowth/environment.docker.json.example` | 合并进 `.cursor/environment.json`（**有 Dockerfile 时**） |

```bash
cp .cursor/templates/cursorGrowth/mcp.json.example .cursor/mcp.json
cp .cursor/templates/cursorGrowth/environment.json.example .cursor/environment.json
# 需要 Docker Build 时：把 environment.docker.json.example 里的 "build" 段合并进 environment.json
# 或整文件替换：cp .cursor/templates/cursorGrowth/environment.docker.json.example .cursor/environment.json
```

## MCP（`.cursor/mcp.json`）

- **项目级**工具；全局可用 `~/.cursor/mcp.json`。
- 使用 `${workspaceFolder}` · `${env:NAME}` 插值；**勿** commit 明文密钥。
- 远程 OAuth 可在条目内加 `auth`（`CLIENT_ID` / `CLIENT_SECRET` / `scopes`）。
- Cloud Agents 使用 **团队 MCP**（Dashboard 配置），与本地会话 MCP 分离。
- 设计 MCP 服务 → **mcp** skill。

## Cloud Agents（`.cursor/environment.json`）

- 解析顺序：仓库内 `environment.json` → 个人环境 → 团队环境。
- **`install`**：Build 时执行的幂等脚本（依赖安装、代码生成等）。母版默认模板**只**含此项。
- **`build.dockerfile`**：高级场景（见 `environment.docker.json.example`）；勿 `COPY` 整个项目（Cursor 自行 checkout）。
- **密钥**：Dashboard → Cloud Agents Secrets；不要依赖把 `.env.local` 打进快照。
- **Hooks**：仓库 `.cursor/hooks.json` 在 Cloud 可跑 **command** hooks；`~/.cursor/hooks.json` 不可用。本地 vs Cloud vs Tab 对照 → **`platforms.md` §Cursor Hooks**。
- 部署/compose 约定 → **ops-deploy** skill（与 VM 内 install 脚本分工：install=Build，compose=运行时文档）。

## 与 Super Cursor 闸门

- 本地 Sprint 仍靠 `.cursorGrowth/plan.md` + `runner.sh gate-check`。
- Cloud 跑 agent **不**读取你本机 `.cursorGrowth/`；把验收命令写进 `install` 或 PR 描述。

## Plugin MVP（本地加载 · 非 Marketplace）

仓库根 **`.cursor-plugin/`** 为 **lifecycle 子集**（plan · run · master · learn · scaffold + 核心 rules + hooks）。**主路径仍是** [`install-super-cursor.sh`](../../install-super-cursor.sh) 全量 `.cursor/` — Plugin **不**带 `workflow.json` · 全量 skills · `verify-super-cursor` 契约。

```bash
bash .cursor/bin/sync-plugin-subset.sh    # 母版维护者：从 .cursor/ 刷新子集
bash .cursor/bin/verify-cursor-plugin-mvp.sh
```

范围与 install 差异 → `templates/cursorGrowth/learn/cursor-platform.md` §Plugin MVP · `archive/meta/*_SPIKE_plugin_mvp_scope.md`（Growth 运行时路径）。
