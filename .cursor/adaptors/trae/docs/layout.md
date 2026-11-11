# Trae `.trae/` 布局（`core_rules_export`）

> ✅ **已按官方机制对齐**：Trae 项目规则走 `.trae/rules/*.md`（Markdown）。

## 官方机制（2026-11 核实）

| 项 | 官方 Trae |
|----|------|
| 项目规则 | `.trae/rules/`（Markdown，frontmatter 用 `description` / `alwaysApply` / `globs`） |
| 全局规则 | `~/.trae-cn/user_rules`（Windows `%userprofile%/.trae-cn/user_rules`） |
| AGENTS.md | 项目根 `AGENTS.md`（兼容，跨 IDE 复用） |

## 导出产物（本 adaptor）

```text
.trae/
├── README.md          # adaptors/trae/README.md
├── RULES.md           # 生成：rules/**/*.md 索引
└── rules/             # harness/core/rules → .md（无 local；原 .mdc 重命名 .md）
```

## Growth

**`.growing/`** 共享；`rules/local` → `.growing/rules/local`。

## 安装

```bash
bash .cursor/harness/core/bin/install-adaptor-rules-export.sh --adaptor trae /path/to/project
install-super-cursor /path/to/project --adaptor trae
```

## 验收

`bash .cursor/bin/verify-install-rules-export.sh`。
