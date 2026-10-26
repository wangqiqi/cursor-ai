# Super Cursor harness（母版 SSOT）

母版仓 **源文件** 分区；消费方仍通过 `install-super-cursor.sh` 得到 **`$PROJECT/.cursor/`**（组装视图）。

| 路径 | 角色 |
|------|------|
| `harness/core/` | Harness Core（skills · rules · bin[core] · config · …） |
| `adaptors/cursor/` | Cursor 能力（hooks · cursor-only verify · 部分 docs） |
| `adaptors/{dsh,kiro,trae,opencode}/` | 占位 · 后续 adaptor Sprint |
| `.cursor/` | **`harness/assemble.sh` 输出** — 仍入 git，供 verify 与未升级工具链 |

```bash
bash harness/assemble.sh          # 刷新仓库根 .cursor/
bash .cursor/bin/verify-harness-layout.sh
```

映射草案 → `.cursor/config/install-map.example.json` · SPIKE 归档 → `.growing/archive/meta/`。
