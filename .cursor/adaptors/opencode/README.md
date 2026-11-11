<!-- adaptor-contract:v1 -->

# adaptor: opencode

OpenCode · Harness Core 安装到 `.opencode/`。

## Status

**misaligned（待按官方重做）** — 官方 OpenCode **不使用 `.opencode/` 目录**，项目规则走根目录 `AGENTS.md`、配置走 `opencode.json`（`instructions` 数组可引用 `.cursor/rules/*.md`）。当前 `install-adaptor-opencode.sh` 平铺 core 到 `.opencode/` 是**自创假设，OpenCode 不会读取**。详见 [docs/layout.md](docs/layout.md) §官方对照。

## Identity

`adaptor id`: **opencode**

## Install map

与 `install-map.example.json` → `adaptors.opencode`：

| 字段 | 值 |
|------|-----|
| `install_dir` | `.opencode` |
| `growth_dir` | `.growing` |
| `hooks_manifest` | **null** |

## Includes

- `core` — Harness Core 主体；见 [adaptor-contract.md](../../harness/core/docs/reference/adaptor-contract.md)。

## Install

```bash
bash .cursor/harness/core/bin/install-adaptor-opencode.sh /path/to/project
install-super-cursor /path/to/project --adaptor opencode
```

布局 SSOT → [docs/layout.md](docs/layout.md) · 验收 `bash .cursor/bin/verify-install-opencode.sh`。

## Next sprint

OpenCode 官方安装根钉死后：对照 SPIKE 差距表更新 `layout.md` / `install-adaptor-opencode.sh`（另开 Sprint；当前与 dsh 同 core 平铺假设）。
