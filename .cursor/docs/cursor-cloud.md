# Cursor Cloud · MCP（可选配置）

> 官方 SSOT：`cursor.com/docs` — **MCP** · **Cloud Agents** · **cloud-agent/setup**（环境）。母版索引 → `library-index.md` §Cursor 官方平台。

Super Cursor **默认不**把 MCP / Cloud 配置写入 install 复制的 `.cursor/`。需要时从模板复制并 commit。

## 复制路径

| 模板（install 后路径） | 目标 |
|------------------------|------|
| `.cursor/templates/cursorGrowth/mcp.json.example` | `.cursor/mcp.json` |
| `.cursor/templates/cursorGrowth/environment.json.example` | `.cursor/environment.json` |

```bash
cp .cursor/templates/cursorGrowth/mcp.json.example .cursor/mcp.json
cp .cursor/templates/cursorGrowth/environment.json.example .cursor/environment.json
# 编辑：删掉未用的 example 块 · build 段仅在有 Dockerfile 时保留
```

## MCP（`.cursor/mcp.json`）

- **项目级**工具；全局可用 `~/.cursor/mcp.json`。
- 使用 `${workspaceFolder}` · `${env:NAME}` 插值；**勿** commit 明文密钥。
- 远程 OAuth 可在条目内加 `auth`（`CLIENT_ID` / `CLIENT_SECRET` / `scopes`）。
- Cloud Agents 使用 **团队 MCP**（Dashboard 配置），与本地会话 MCP 分离。
- 设计 MCP 服务 → **mcp** skill。

## Cloud Agents（`.cursor/environment.json`）

- 解析顺序：仓库内 `environment.json` → 个人环境 → 团队环境。
- **`install`**：Build 时执行的幂等脚本（依赖安装、代码生成等）。
- **`build.dockerfile`**：高级场景；勿 `COPY` 整个项目（Cursor 自行 checkout）。
- **密钥**：Dashboard → Cloud Agents Secrets；不要依赖把 `.env.local` 打进快照。
- **Hooks**：仓库 `.cursor/hooks.json` 在 Cloud 可跑 **command** hooks；`~/.cursor/hooks.json` 不可用。本地 vs Cloud vs Tab 对照 → **`platforms.md` §Cursor Hooks**。
- 部署/compose 约定 → **ops-deploy** skill（与 VM 内 install 脚本分工：install=Build，compose=运行时文档）。

## 与 Super Cursor 闸门

- 本地 Sprint 仍靠 `.cursorGrowth/plan.md` + `runner.sh gate-check`。
- Cloud 跑 agent **不**读取你本机 `.cursorGrowth/`；把验收命令写进 `install` 或 PR 描述。
