# Harness × IDE 对照（SPIKE-003 摘要）

完整表与风险见 `.growing/archive/meta/SPIKE-003-ide-adaptor-matrix.md`。

| 环境 | 安装根 | Adaptor 厚度 | 文档入口 |
|------|--------|--------------|----------|
| Cursor | `.cursor/` | 厚（hooks · Cloud · Bugbot） | https://cursor.com/docs |
| DeepSeek `.dsh` | `.dsh/` | Core 已装（`install-adaptor-dsh.sh` · layout **假设**） | [adaptors/dsh/docs/layout.md](../../adaptors/dsh/docs/layout.md) |
| Kiro | `.kiro/` | rules export（`core_rules_export`） | [adaptors/kiro/docs/layout.md](../../adaptors/kiro/docs/layout.md) |
| Trae | `.trae/` | rules export（同 Kiro 集） | [adaptors/trae/docs/layout.md](../../adaptors/trae/docs/layout.md) |
| OpenCode | 产品约定 | 中 | https://opencode.ai/docs |
| VS Code 系 | `AGENTS.md` 等 | 薄 | https://code.visualstudio.com/docs/copilot |

映射草案：`config/install-map.example.json`。占位 adaptor 机器验收 → [adaptor-contract.md](adaptor-contract.md)（`verify-adaptor-contract.sh`）。
