# Local rules（目标项目私有）

安装 Super Cursor **之后**，在此目录添加 `.mdc` 规则（须**用户**发起或明确要求，Agent 不得自动创建）。

- 公司命名、内部路径、团队 globs 等 **项目特化** 约定放这里
- **delivery** 通用 7 维清单在 **delivery** skill；团队额外门禁或路径约定可写 `local/delivery-*.mdc` 或 `/learn` → `acceptance.md`
- **不要**把项目认知写进 `.cursor/` 其他目录 — 用 **`/learn`** → `.cursorGrowth/learn/`
- 母版 `.cursor/`（rules/skills/hooks/config 等）**默认只读** — 见 `core.mdc`「.cursor 不可变」

示例：

```
.cursor/rules/local/
  naming.mdc
  internal-api.mdc
```

Authoring 可参考 `~/.cursor/skills-cursor/create-rule/`。社区 rules 索引 → [docs/rules-catalog.md](../docs/rules-catalog.md)。
