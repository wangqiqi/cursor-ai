# Super Cursor

[![Version](https://img.shields.io/badge/version-5.1.15-blue.svg)](CHANGELOG.md)
[![Scaffolds](https://img.shields.io/badge/scaffolds-8%20stacks-green.svg)](.cursor/templates/scaffold/manifest.json)
[![License: MIT](https://img.shields.io/badge/License-MIT-yellow.svg)](LICENSE)

> **Turn Cursor Agent from one-off chats into plan → approve → run → verify workflows you can ship.**

Drop a reusable `.cursor/` SOP into any repo. Sprint plans and learnings live in `.growing/` (`config/workflow.json`) so you can upgrade the template without losing local work.

**中文：** [README.md](README.md)

> **Windows:** Facade paths under `.cursor/` (rules, skills, hooks, …) are **symlinks or text pointers** to `harness/core`. **Verify/smoke scripts** work with `pack-root.sh` without materializing. For **Cursor IDE** to load rules, enable Developer Mode, set `git config core.symlinks true`, and re-clone—or run `bash .cursor/harness/link-cursor-ide.sh` locally without committing the copy. Target repos should use `install-super-cursor.sh --replace`. See [platforms.md](.cursor/docs/platforms.md) (mother repo vs consumer).

---

## Why teams pick this

| Pain | What you get |
|------|----------------|
| Scope creep mid-chat | **`/plan`** + **`gate-check`** — no business code without approval |
| “Done” but broken | **`task-verify`** per task · **`verify`** before release |
| Long epics need babysitting | One **`/run`** can chain ACTIVE tasks when autonomous |
| Rules baked into the repo | Project overrides in **`.growing/`** · installed **`.cursor/` stays read-only** |

---

## Three commands

```text
/master  →  route when lost
/plan      →  slice the Sprint; wait for approval
/run       →  execute; chain tasks in one session when AUTONOMOUS
```

```bash
bash install-super-cursor.sh /path/to/your-project
cd /path/to/your-project && bash onekey_start.sh
```

| When | Use |
|------|-----|
| Learn this repo | **`/learn`** |
| Release | **`/release`** (**ship** agent handles release automation) |

Mantra: **one approved plan · one run session · stop only for decisions · verify before ✅**

Full walkthrough → [quickstart.en.md](.cursor/docs/quickstart.en.md) · Slash SSOT → `.cursor/skills/master/routes.md`

---

## Install (CLI · drag-drop)

Two supported paths (same flat `.cursor/` tree for the IDE) → [install-paths.md](.cursor/docs/reference/install-paths.md):

| Path | How | Best for |
|------|-----|----------|
| **CLI** | `bash install-super-cursor.sh /path/to/project --replace --copy-plan` | Teams · `.growing/` · adaptors |
| **Copy / drop** | Mother: `--pack-dropin` → unpack or drag `.cursor/` into project root → Reload Window | No Git · offline handoff |

| Flag | Purpose |
|------|---------|
| `--profile full\|lite\|rules-only` | Workflow config (default `full`) |
| `--skills-bundle full\|core` | Skill bundle (default `full`=28; `core`=23) |
| `--adaptor kiro\|trae\|opencode\|zcode\|workbuddy` | Extra IDE adaptor (repeatable) |
| `--copy-plan` | Copy `templates/plan.md` → `.growing/plan.md` |
| `--replace` | Remove target `.cursor/` first, then copy |
| `--pack-dropin` | Mother only: tar with `.cursor/` for copy-into-project |
| `--pack-offline` | Mother only: full offline bundle with installer |

Distribution & migration → [migration-catalog.md](.cursor/docs/migration-catalog.md)

---

## Verify (mother repo)

```bash
bash .cursor/bin/template-verify.sh
bash .cursor/bin/cursor-coherence.sh
```

Do not commit root `onekey_start.sh` here (**verify-onekey-template**). **hygiene** / **verify-spike-mother-hygiene-scope** → [migration-catalog.md](.cursor/docs/migration-catalog.md).

`.cursor/skills/` — **28** skills on disk (`template-verify` checks the count).

---

## Docs

```bash
npm install && npm run docs:dev
```

Deep dive: [README.md](README.md) · `.cursor/docs/` · [library-index.md](.cursor/docs/library-index.md)
