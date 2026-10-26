# Super Cursor harness（位于 `.cursor/harness/`）

**分区 SSOT 在 `.cursor/` 包内**，不在仓库根目录。

| 路径 | 角色 |
|------|------|
| `.cursor/harness/core/` | Harness Core（skills · rules · bin[core] · config · …） |
| `.cursor/adaptors/cursor/` | Cursor 能力（hooks · cursor-only verify · 部分 docs） |
| `.cursor/adaptors/{dsh,kiro,trae,opencode}/` | 占位 · 后续 adaptor Sprint |
| `.cursor/skills` 等平铺目录 | **`assemble.sh` 生成** — **不入 git**（见根 `.gitignore`）；IDE / verify 用平铺布局 |

```bash
bash .cursor/harness/assemble.sh       # 生成平铺树（给 Cursor IDE / verify）
bash .cursor/harness/clean-assembled.sh  # 删掉平铺副本，只留 harness+adaptors（减冗余）
bash .cursor/template-verify.sh        # 母版 CI（内部先 assemble）
bash .cursor/bin/verify-harness-layout.sh   # 需先 assemble
```

**磁盘上两套目录是正常的**：改文件只动 `harness/core` / `adaptors`；平铺树可随时 `clean` 再 `assemble`。

映射草案 → `config/install-map.example.json`（assemble 后路径）。
