# plan · run

迷路或刚安装 → **`/master`** · 再 `/plan` → `/run` · `/learn` → `.cursorGrowth/learn/`

1. `config/workflow.json` · 复制 `templates/plan.md` → 根目录（**gitignore，不提交**）
2. **`/plan`** — 先总后分：Goal · Done when（含门面/coherence）· ROADMAP → 再拆 TASK · **执行顺序**
3. **`/run`** — 按 `ACTIVE` 执行；门面变更 **同 commit 同步 README**；Sprint 收尾对照 Done when 并归档
4. **`/ia`**（可选）— 导航/角色大改：先结构稿 `docs/design/*-ia*` · `ia.mdc` R1–R4
5. **`/delivery`**（可选）— UI/功能 Sprint：**finish** 前建议 7 维走查（含 §5 导航与 IA）；Blocker 须先报告
6. **`/finish`** — merge / PR / 保留 / 丢弃

闸门与 CLI：见 `rules/workflow.mdc`

`task_id.prefixes_skip`（`SPIKE-` / `REV-` / `DOC-`）：`next-task` 自动推进时跳过，不 bypass `gate-check`。

```bash
./.cursor/bin/runner.sh gate-check
./.cursor/bin/runner.sh task-verify
./.cursor/bin/runner.sh verify
./.cursor/bin/runner.sh next-task
```

| Hook | 脚本 |
|------|------|
| beforeSubmitPrompt | `growth-init.sh` |
| sessionStart | `run-start.sh` |
| stop | `run-stop.sh` |

打版：**release** skill · **ship** agent · [naming.md](naming.md)
