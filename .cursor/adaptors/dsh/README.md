<!-- adaptor-contract:v1 -->

# adaptor: dsh

DeepSeek harness · Harness Core 安装到 `.dsh/`。

## Status

**implemented（core install）** — 官方 DeepSeek layout **待确认**；当前按 [docs/layout.md](docs/layout.md) 自定平铺 core 树。无 hooks。

## Identity

`adaptor id`: **dsh**

## Install map

与 `install-map.example.json` → `adaptors.dsh`：

| 字段 | 值 |
|------|-----|
| `install_dir` | `.dsh` |
| `growth_dir` | `.growing` |
| `hooks_manifest` | **null** |

## Includes

- `core` — Harness Core 主体（skills · rules · bin · config）；见 [adaptor-contract.md](../../harness/core/docs/reference/adaptor-contract.md) §`includes` token。

## Install

```bash
bash .cursor/harness/core/bin/install-adaptor-dsh.sh /path/to/project
# 或与 Cursor 一并：
install-super-cursor /path/to/project --adaptor dsh
```

布局 SSOT → [docs/layout.md](docs/layout.md) · 验收 `bash .cursor/bin/verify-install-dsh.sh`。

## Next sprint

DeepSeek 专有配置 / 官方 layout 对齐（待产品文档）· hooks 若有则另开 Sprint。
