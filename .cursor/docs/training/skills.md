# Skills 速查

入口均在 `core.mdc`。说 slash 或关键词触发。

| Skill | 触发 | 做什么 | 不做什么 |
|-------|------|--------|----------|
| **master** | `/master` · 从哪开始 | AskQuestion 路由（≤7 项/轮）· README 全场景 | 写代码 · apply |
| **plan** | `/plan` · 拆任务 | Sprint · 先总后分 · plan.md | 写业务代码 |
| **run** | `/run` · 继续 | 实现 · task-verify · commit | 无闸门硬编码 |
| **learn** | `/learn` | `.cursorGrowth/learn/` | 改 `.cursor/` |
| **scaffold** | `/scaffold` | 8 栈骨架 · audit | 未确认覆盖 |
| **git** | commit/push | 提交前清单 · 规范 commit | force-push |
| **finish** | `/finish` · 分支收尾 | merge/PR/保留/丢弃 4 选 1 | 跳过 verify |
| **release** | 发版清单 | CHANGELOG · tag | 自动 push |
| **security** | 审查 | 密钥 · auth · PII 清单 | — |
| **api** | API 变更 | REST/OpenAPI 清单 | — |
| **debug** | 调试 | 隔离 · 模式聚类 | — |
| **test** | 测试 | 单测/集成/E2E · TDD | — |
| **mcp** | MCP | 工具设计要点 | — |
| **refactor** | 重构 | 小步可验证 | — |
| **perf** | 性能 | 测量优先 | — |
| **review** | REV-* · PR 回顾 | 坏味道清单 · 委派 review agent | 写代码 |
| **delivery** | `/delivery` · 上线前 | 7 维交付验收 · finish 前建议 | 替代 task-verify |
| **study** | 学新技术 | 最小示例 · SPIKE 归档 | 项目认知（用 learn） |

Agents：**ship**（发版）· **review** · **spike**（后二者只读）

## 推荐路径

```
迷路:     /master → 主菜单 7 项 → 子问（plan/fix/ship/more）
空仓库:   scaffold → learn → plan → run → verify
卡住:     /master → fix → run 或 plan
```

## master 主菜单（7 项）

`scaffold` · `plan` · `run` · `learn` · `fix` · `ship` · `more`  
审查 / PR / 文档 / submodule / 配置 / **人格** → `more` 子路由。详见 `skills/master/routes.md`。

## 8 栈 scaffold

`react-vite-ts` · `vue-vite-ts` · `nextjs-ts` · `go-api` · `rust-axum` · `python-fastapi` · `java-gradle` · `cpp-cmake`

## install profile

| profile | 说明 |
|---------|------|
| `full` | plan/run + hooks（默认） |
| `lite` | plan/run，无 hooks |
| `rules-only` | 仅 rules/skills |

详见 [quickstart.md](../quickstart.md) · [walkthrough.md](../walkthrough.md)
