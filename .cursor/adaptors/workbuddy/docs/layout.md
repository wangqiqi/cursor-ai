# WorkBuddy `.workbuddy/` 布局（Super Cursor · `includes: core`）

WorkBuddy 官方 `.workbuddy/` 目录规范 **待确认**；本布局与 **dsh** 相同假设：Harness Core 平铺到 `.workbuddy/`。若官方规范冲突（如 skills / memory / mcp.json 约定），以 SPIKE 更新本文件与 `install-adaptor-workbuddy.sh`。

## 目标路径

| 项 | 值 |
|----|-----|
| 安装根 | **`.workbuddy/`** |
| Growth | **`.growing/`**（共享） |
| hooks | **无**（`hooks_manifest`: null） |

## 目录树（安装后）

与 [dsh layout](../../dsh/docs/layout.md) 同构（将 `.dsh` 换为 `.workbuddy`）：

```text
.workbuddy/
├── README.md
├── AGENTS.md
├── skills/
├── rules/
├── bin/
├── config/
├── templates/
├── docs/
├── agents/
└── lib/
```

**刻意不含**：`harness/` · `adaptors/` · cursor-only 切片。母版聚合校验脚本 `verify-super-cursor.sh` / `verify-system.sh` 随 core 树一并复制，但非 adaptor 验收范围。

## `core` 包映射

| 源（母版） | 目标 |
|------------|------|
| `.cursor/harness/core/*` | `.workbuddy/*` |
| 排除 `harness/core/rules/local` | — |
| `.cursor/adaptors/workbuddy/README.md` | `.workbuddy/README.md` |

## 安装

```bash
bash .cursor/harness/core/bin/install-adaptor-workbuddy.sh /path/to/project
install-super-cursor /path/to/project --adaptor workbuddy
```

## 验收

`bash .cursor/bin/verify-install-workbuddy.sh`
