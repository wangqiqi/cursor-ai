# .cursorGrowth

**Git 不跟踪。** 存放从**本项目**学到的认知，与通用 `.cursor/` SOP 分离。

## 目录

| 路径 | 用途 |
|------|------|
| `learn/` | `/learn`（**learn** skill）写入；首次运行创建下表文件 |
| `logs/` | 可选：本地 hook 或会话日志 |
| `perception/` | 可选：用户偏好、临时上下文 |

### `/learn` 产出文件（首次运行创建）

| 文件 | 内容 |
|------|------|
| `learn/dev-conventions.md` | 命名、目录、测试/verify 命令、分支策略 |
| `learn/module-map.md` | 模块边界、入口、依赖方向 |
| `learn/release-rhythm.md` | 发版频率、谁打 tag、CHANGELOG 习惯 |
| `learn/changelog-insights.md` | 近期对外变更摘要 |
| `learn/last-sync.md` | 本次同步时间、来源、待确认项 |
| `learn/acceptance.md` | （可选）design tokens · i18n · OpenAPI — 供 **delivery** skill；母版模板 `templates/cursorGrowth/learn/acceptance.md` |

## 如何更新 learn/

在 Cursor 中运行 **`/learn`** 或说「学习项目开发过程」。

Agent 会读 `CHANGELOG.md`、git 历史、`archive/` 等，更新 `learn/*.md`。

## 读取顺序（Agent）

1. `.cursor/rules` — 通用 SOP
2. `.cursor/config` — 路径与开关
3. **本目录 `learn/`** — 项目特化（若存在）

## 注意

- 勿手动把 learn 内容复制进 `.cursor/` 再提交
- 团队共享 learn 内容请用其他渠道（wiki、docs），不要提交 `.cursorGrowth/`
- 根目录 **`.cursorignore`** 应排除 `logs/` · `perception/` · `.env`；**勿** ignore 整个 `learn/`
