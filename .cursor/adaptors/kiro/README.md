<!-- adaptor-contract:v1 -->

# adaptor: kiro

Kiro 项目规则 · `core_rules_export`。

## Status

**implemented（rules export）** — 官方 Kiro layout **待确认**；当前导出 [docs/layout.md](docs/layout.md) · SSOT [core-rules-export.md](../../harness/core/docs/reference/core-rules-export.md)。

## Identity

`adaptor id`: **kiro**

## Install map

与 `install-map.example.json` → `adaptors.kiro`：

| 字段 | 值 |
|------|-----|
| `install_dir` | `.kiro` |
| `growth_dir` | `.growing` |
| `hooks_manifest` | **未定义**（map 未列；实现 Sprint 再补） |

## Includes

- `core_rules_export` — `harness/core/rules` 子集 + `RULES.md` 索引；见 [adaptor-contract.md](../../harness/core/docs/reference/adaptor-contract.md)。

## Install

```bash
bash .cursor/harness/core/bin/install-adaptor-rules-export.sh --adaptor kiro /path/to/project
install-super-cursor /path/to/project --adaptor kiro
```

验收：`bash .cursor/bin/verify-install-rules-export.sh`。

## Next sprint

官方 layout 对齐 · 专有 manifest（待产品文档）。
