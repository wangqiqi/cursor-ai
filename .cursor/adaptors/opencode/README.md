<!-- adaptor-contract:v1 -->

# adaptor: opencode

OpenCode · Harness Core 安装到 `.opencode/`。

## Status

**implemented（core install）** — 官方 OpenCode layout **待确认**；当前按 [docs/layout.md](docs/layout.md) 平铺 core（同 dsh 模式）。

## Identity

`adaptor id`: **opencode**

## Install map

与 `install-map.example.json` → `adaptors.opencode`：

| 字段 | 值 |
|------|-----|
| `install_dir` | `.opencode` |
| `growth_dir` | `.growing` |
| `hooks_manifest` | **未定义**（map 未列） |

## Includes

- `core` — Harness Core 主体；见 [adaptor-contract.md](../../harness/core/docs/reference/adaptor-contract.md)。

## Install

```bash
bash .cursor/harness/core/bin/install-adaptor-opencode.sh /path/to/project
install-super-cursor /path/to/project --adaptor opencode
```

验收：`bash .cursor/bin/verify-install-opencode.sh`。

## Next sprint

官方 OpenCode 配置对齐（待产品文档）。
