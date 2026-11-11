<!-- adaptor-contract:v1 -->

# adaptor: dsh

DeepSeek harness · Harness Core 安装到 `.dsh/`。

## Status

**misaligned（待按官方重做）** — 官方 DeepSeek Harness（dsh）配置在**用户级** `~/.dsh`（`$DSH_HOME`），全局指令在 `~/.agents/AGENTS.md`、skills 在 `~/.agents/skills/`，**不在项目内**；且为 Developer Preview（允许 breaking changes）。当前 `install-adaptor-dsh.sh` 平铺 core 到项目 `.dsh/` 是**方向性错位**。详见 [docs/layout.md](docs/layout.md) §官方对照。

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

DeepSeek 官方 harness 目录公开后：对照 SPIKE 差距表更新本 `layout.md` 与 `install-adaptor-dsh.sh`（另开 Sprint；无 Breaking 假设前保持当前 core 平铺）。
