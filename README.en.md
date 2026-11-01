# Super Cursor

[![Version](https://img.shields.io/badge/version-5.0.8-blue.svg)](CHANGELOG.md)
[![Scaffolds](https://img.shields.io/badge/scaffolds-8%20stacks-green.svg)](.cursor/templates/scaffold/manifest.json)
[![License: MIT](https://img.shields.io/badge/License-MIT-yellow.svg)](LICENSE)

> **Turn Cursor Agent from one-off chats into plan → approve → run → verify workflows you can ship.**

Drop a reusable `.cursor/` SOP into any repo. Sprint plans and learnings live in `.growing/` (`config/workflow.json`) so you can upgrade the template without losing local work.

**中文：** [README.md](README.md)

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

## Install flags

| Flag | Purpose |
|------|---------|
| `--profile minimal\|standard\|full` | Install size |
| `--skills-bundle minimal\|standard\|full` | Skill bundle ([skills-bundle.md](.cursor/docs/skills-bundle.md)) |
| `--no-growth` | Copy `.cursor/` only |
| `--dry-run` | Preview |

[distribution-channels.md](.cursor/docs/distribution-channels.md) · [migration-catalog.md](.cursor/docs/migration-catalog.md)

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
