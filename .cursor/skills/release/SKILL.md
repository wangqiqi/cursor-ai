---
name: release
description: 打版清单。切版本/tag/CHANGELOG 时用。自治发版→ship agent。
disable-model-invocation: true
---

# release · 清单

`config/release.json` · `config/workflow.json` · tag 规则见 `rules/feedback/tag.mdc`

- [ ] 版本已定 · plan 本版 ✅（若用）
- [ ] verify 通过 · 无 WIP
- [ ] **security**（auth/PII）
- [ ] UI/功能本版：**建议** **`/delivery`** 无 Blocker（见 **delivery** skill）
- [ ] CHANGELOG `[Unreleased]` · manifest bump · docs
- [ ] Annotated tag · push 按团队策略

自治 → **ship** agent
