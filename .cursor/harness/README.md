# Super Cursor harness（位于 `.cursor/harness/`）

**分区 SSOT 在 `.cursor/` 包内**，不在仓库根目录。

| 路径 | 角色 |
|------|------|
| `.cursor/harness/core/` | Harness Core（skills · rules · bin[core] · config · …） |
| `.cursor/adaptors/cursor/` | Cursor 能力（hooks · cursor-only verify · 部分 docs） |
| `.cursor/adaptors/{dsh,kiro,trae,opencode}/` | 占位 · 后续 adaptor Sprint |
| `.cursor/skills` 等平铺目录 | **`assemble.sh` 生成** — **不入 git**（见根 `.gitignore`）；IDE / verify 用平铺布局 |

```bash
bash .cursor/harness/assemble.sh       # 本地开发：生成平铺树
bash .cursor/template-verify.sh        # 母版 CI / 全量验收（先 assemble）
bash .cursor/bin/verify-harness-layout.sh
```

映射草案 → `config/install-map.example.json`（assemble 后路径）。
