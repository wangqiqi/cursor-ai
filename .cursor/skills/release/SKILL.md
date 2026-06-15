---
name: release
description: 打版清单与 semver。patch-per-task 或 tag-per-commit；自治发版→ship agent。
disable-model-invocation: true
---

# release · 清单

`config/release.json` · `config/workflow.json` · tag 规则见 `rules/feedback/tag.mdc`

## 发版模式（`workflow.release.mode`）

| mode | 适用 | /run 收尾 |
|------|------|-----------|
| `patch-per-task`（母版默认） | 开源母版 · Sprint 批量交付 | commit；Sprint 末 **ship** 打 tag |
| `tag-per-commit` | 高频交付业务仓库 | commit + **`release-tag`** 每任务 |

安装 `tag-per-commit`：合并 `templates/workflow.tag-per-commit.json` 到 `workflow.json`，并设 `release.json` → `tag_per_commit: true`。

## semver 原则

| 级别 | 何时用 | 自动？ |
|------|--------|--------|
| **patch** | 单 TASK、文档/修复、tag-per-commit 默认 | tag-per-commit：**是** |
| **minor** | 用户可见新能力、无 breaking | **否** — 须评估 + `RELEASE_ALLOW_MINOR=true` |
| **major** | Breaking change | **几乎从不自动** — 仅用户明确授权 |

## tag-per-commit 每 commit 打版

```bash
./.cursor/bin/runner.sh release-tag          # 默认 patch
RELEASE_BUMP=minor RELEASE_ALLOW_MINOR=true ./.cursor/bin/runner.sh release-tag
```

## patch-per-task 清单

- [ ] 版本已定 · plan 本版 ✅（若用）
- [ ] verify 通过 · 无 WIP
- [ ] **security**（auth/PII）
- [ ] UI/功能本版：**建议** **`/delivery`** 无 Blocker
- [ ] CHANGELOG `[Unreleased]` · manifest bump · docs
- [ ] Annotated tag · push 按团队策略

## 命令

```bash
./.cursor/bin/runner.sh release-check    # P0 全 ✅ 时提示 next patch
./.cursor/bin/runner.sh release-tag        # 在当前 HEAD 打 tag（tag-per-commit）
```

自治 → **ship** agent
