<!-- adaptor-contract:v1 -->

# adaptor: trae

Trae 项目规则 · `core_rules_export`。

## Status

**implemented（rules export）** — 官方 Trae 项目规则走 `.trae/rules/*.md`；本 adaptor 导出 [docs/layout.md](docs/layout.md) · SSOT [core-rules-export.md](../../harness/core/docs/reference/core-rules-export.md)。

## Identity

`adaptor id`: **trae**

## Install map

与 `install-map.example.json` → `adaptors.trae`：

| 字段 | 值 |
|------|-----|
| `install_dir` | `.trae` |
| `growth_dir` | `.growing` |
| `hooks_manifest` | **null** |

## Includes

- `core_rules_export` — 与 Kiro 同导出集；见 [adaptor-contract.md](../../harness/core/docs/reference/adaptor-contract.md)。

## Install

```bash
bash .cursor/harness/core/bin/install-adaptor-rules-export.sh --adaptor trae /path/to/project
install-super-cursor /path/to/project --adaptor trae
```

验收：`bash .cursor/bin/verify-install-rules-export.sh`。

## Next sprint

规则 frontmatter 对齐 Trae 语义（`description`/`alwaysApply`/`globs`）；当前 `.md` 保留 Cursor 风格 frontmatter，正文为通用规则（另开 Sprint）。
