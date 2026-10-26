# 技术栈 · 整包安装与按需启用

Super Cursor **不按语言拆安装包**：`install-super-cursor.sh` 始终 **整包复制** 母版 `.cursor/`。项目差异通过 **`.cursorGrowth/project-profile.json`** 控制 **运行时启用哪些面**（更快、少占 token），而不是 install 时删减文件。

## 术语

| 概念 | 说明 |
|------|------|
| **整包安装** | 全量 `rules/` · `skills/` · `bin/` 等同版进入目标仓 |
| **按需启用** | 会话 hook、Agent 引导、verify 策略只 **启动** 与本仓 `stacks.primary` 相关的面 |
| **不是** | 为 Java 单独发瘦版 `.cursor`、install 时删除 `rules/tech/cpp.mdc` |

## 绿地 vs 棕地

```mermaid
flowchart LR
  subgraph install [整包安装]
    A[install-super-cursor.sh --replace]
  end
  subgraph green [绿地]
    B[scaffold detect]
    C[scaffold apply id]
    D[adapt --write 对齐 primary]
  end
  subgraph brown [棕地]
    E[scaffold detect]
    F[scaffold adapt --write]
    G[/learn 写 dev-conventions]
  end
  A --> B
  B -->|empty| C
  B -->|established| F
  C --> D
  F --> G
```

| 场景 | 动作 |
|------|------|
| **空仓** | `scaffold apply <id>` → 建议 `scaffold adapt --write` 写入 profile |
| **已有代码** | **禁止**盲目全量 `apply` → `scaffold audit` · **`scaffold adapt`** · `/learn` |
| **升级 `.cursor` 后** | 保留 `.cursorGrowth` → **`scaffold adapt`** 刷新探测 → 核对 `learn/dev-conventions.md` |

## 四层：安装 vs 启用

| 层 | 整包在盘 | 按需启用 |
|----|----------|----------|
| **Workflow / hooks** | ✅ | `--profile full \| lite \| rules-only`（非按语言） |
| **Skills** | ✅ | `--skills-bundle full \| core`；任务触发，不删文件 |
| **`rules/tech/*.mdc`** | ✅ 13 个文件 | Cursor **glob**（编辑匹配扩展名才注入）+ profile **primary** 供 Agent 优先 |
| **`scripts/verify.sh` / layers** | 脚手架或自建 | `project-profile.json` → **`verify.enabled_tiers`** · **`verify.enabled_slices`** |

### Skills 与 profile

Skills 不按栈裁剪。profile 的作用是：让 **run-start** 与 **learn** 标明主栈，避免 Agent 在无必要时引用他栈命令。

## `project-profile.json`（Growth SSOT）

| 字段 | 含义 |
|------|------|
| `stacks.detected[]` | `scaffold.sh` 文件信号探测结果 |
| `stacks.primary[]` | **启用**的主栈（可多栈，如 `java` + `vue`） |
| `verify.enabled_tiers[]` | 允许跑的验收层（默认 `l0` · `l1` · `l2-core`） |
| `verify.enabled_slices[]` | 可选 slice id 白名单；**空** = 仅按 tier 策略（见下节） |
| `tech_rules.mode` | 现仅 `globs-only`（盘内保留全量 tech rules） |

模板与 JSON Schema：

- `.cursor/templates/cursorGrowth/project-profile.example.json`
- `.cursor/templates/cursorGrowth/project-profile.schema.json`

CLI：

```bash
.cursor/bin/scaffold.sh adapt              # 预览（默认 dry-run）
.cursor/bin/scaffold.sh adapt --write      # 写入 .cursorGrowth/project-profile.json
.cursor/bin/scaffold.sh adapt --write --primary=java,vue
```

`run-start` 在存在 profile 时注入一行 **Project profile: primary=…**（省 token，不展开全栈手册）。

## Verify · 按需启用（阶段）

| 阶段 | 行为 |
|------|------|
| **本版** | profile 契约 + `adapt` 默认 tiers；**文档**约定 `enabled_slices` 语义 |
| **SPRINT-VERIFY-STACK-FILTER（候选）** | `verify-layers` 注册表 / `apply-bundle` 按 `primary` 只铺相关 slice；runner 跳过未启用 slice |

消费方已有 `scripts/verify.sh` 时：在 `learn/dev-conventions.md` 写 **DAILY** 命令；profile 的 `enabled_tiers` 供后续脚本读取（母版 `lib/project-profile.sh` 可扩展）。

母版自检仍用 `bash .cursor/bin/template-verify.sh`（与业务 verify 分层无关）。

## 脚手架 manifest（绿地模板）

`scaffold.sh list` · `.cursor/templates/scaffold/manifest.json` 现含 7 栈：`react-vite-ts` · `vue-vite-ts` · `nextjs-ts` · `go-api` · `rust-axum` · `python-fastapi` · `cpp-cmake`。

| 栈 | `rules/tech` | scaffold |
|----|--------------|----------|
| Go · Vue · Python · C++ · Node | ✅ | ✅ 对应 id |
| Java | ✅ `java.mdc` | ❌ 无母版 scaffold → **adapt + local rules + learn** |
| Android | ❌ | ❌ → `.cursorGrowth/rules/local` |

## 交叉引用

- 消费方升级 → [consumer-refresh.md](consumer-refresh.md)
- 脚手架 skill → `scaffold` · [scaffold.md](scaffold.md)
- Growth 目录 → `templates/cursorGrowth/README.md`
