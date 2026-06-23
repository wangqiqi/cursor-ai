# Building on Super Cursor

## Principles

1. **Universal only** — rules/skills must work in any repo; no hardcoded org paths.
2. **Config over fork** — behavior toggles live in `.cursor/config/*.json`.
3. **Three pillars** — `rules/communication/` · `rules/execution/` · `rules/feedback/`.
4. **Growth boundary** — project learnings in `.cursorGrowth/` only; use `/learn`.
5. **Token** — 仅 `core.mdc` + `workflow.mdc` alwaysApply；细则在 skills。
6. **Immutable after install** — Agent must not modify `.cursor/**` unless the user explicitly asks to change or improve `.cursor`. Suggest only; wait for confirmation.
7. **Cross-platform** — scripts target Linux · macOS · Git Bash; shared helpers in `.cursor/lib/platform.sh` (see `docs/platforms.md`).

不确定从哪开始 → **`/master`**（AskQuestion 路由到 plan/run/scaffold 等）。

## Cursor ignore

- **`.cursorignore`**（仓库根）— Agent / Tab / `@` **硬排除**；安装脚本与 scaffold apply 会写入/合并（含 `node_modules/` · `.venv/` · `target/` 等）
- **`.gitignore`** — 主要管 git 与索引；**不能**替代 `.cursorignore` 拦 Agent 读 `.env`
- **`.cursorGrowth/learn/`** — **不要** ignore；`logs/` · `perception/` 可 ignore

## Add a rule

Create `.cursor/rules/<topic>.mdc`:

```yaml
---
description: One-line purpose
globs: "**/*.ts"   # optional
alwaysApply: false
---
```

Use meta-skills from `~/.cursor/skills-cursor/create-rule/` when authoring.

## Add a skill

Create `.cursor/skills/<name>/SKILL.md` with `name` + `description`.

## Local overrides (target project only)

After install, a project may add:

```
.cursor/rules/local/     # not part of the template repo
```

Never commit company-specific paths into the **template** repository.

## Install

```bash
./install-super-cursor.sh /path/to/project
```

## Workflow modes

Edit `config/workflow.json` after install:

| Mode | Setting |
|------|---------|
| Full plan/run + hooks | defaults |
| Rules/skills only | `workflow.enabled: false`, `hooks_enabled: false` |
| Stack-specific verify hints | 默认已 `enabled: true`，对齐 `scripts/test.sh` |

See `config/README.md` for all keys. Copy `templates/plan.md` when using the plan workflow.

## Closed-loop checklist

| Step | Entry |
|------|--------|
| Plan | `/plan` · Done when 可含 `delivery 无 Blocker` |
| Implement | `/run` · `task-verify` |
| Product gate | `/delivery` · **release** §分支前建议 |
| Branch / tag | `/release` · **git** |
| Release | **release** / **ship** · verify + security + delivery |

Verify template integrity:

```bash
bash .cursor/bin/cursor-coherence.sh
bash .cursor/bin/template-verify.sh
```
