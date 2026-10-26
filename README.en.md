# Super Cursor (English)

> Chinese is the canonical language of this project; **this file is a minimal English entry point.**
> Canonical docs: [README.md](README.md) · [`docs/`](https://wangqiqi.github.io/cursor-ai/)

Super Cursor turns "how to work with an AI agent" from chat conventions into an installable,
reusable, evolvable workflow master: **rules + skills + hooks + config**, installed once and
usable in every repository. Project-specific knowledge lives in `.growing/` (git-ignored),
never in the shared template.

## What you get

```text
.cursor/
├── harness/     mother SSOT: core/ + link-cursor-ide.sh
├── adaptors/    cursor/ (hooks) · other IDE placeholders
├── template-verify.sh   CI entry (runs link-cursor-ide first; no flat copy)
└── (symlink protocol) skills/ · rules/ · hooks/ · bin/ … — point at core/adaptors; install target gets a copied flat tree
```

## Install into any project

```bash
git clone https://github.com/wangqiqi/cursor-ai.git
cd cursor-ai
./install-super-cursor.sh /path/to/your-project          # default profile: full
# or, from anywhere inside a git project:
SUPER_CURSOR_HOME=$PWD ./install-super-cursor.sh --setup-shell
```

| Option | Effect |
|--------|--------|
| `--profile full\|lite\|rules-only` | `full` (default, hooks on) · `lite` (no hooks) · `rules-only` (no gate) |
| `--replace` | delete the target `.cursor/` first (recommended for upgrades) |
| `--copy-plan` | seed `.growing/plan.md` |

Supported on **Linux · macOS · Windows (Git Bash)**. No `rsync` → `cp -a`; no `jq` → `python`
(forced with `SC_FORCE_PYTHON=1`, which CI exercises). Per-skill platform scope is documented
in `.cursor/docs/platforms.md` — note that the `maintain` skill is Linux-only.

## Three commands to remember

```text
/learn   # first thing after install: fill in project knowledge
/plan    # break a Sprint into tasks (no ACTIVE task yet)
/run     # implement the ACTIVE task
```

Lost? `/master` routes you via a ≤7-item menu. Everything else is auto-selected by the agent.

## How it stays honest

The template ships its own gates, and they are wired into CI:

```bash
bash .cursor/harness/link-cursor-ide.sh # mother: IDE protocol symlinks (template-verify also runs this)
bash .cursor/template-verify.sh         # mother repo, full suite (CI)
bash .cursor/bin/consumer-smoke.sh
bash .cursor/verify-super-cursor.sh
bash .cursor/bin/cursor-coherence.sh
```

Edit mother SOP under `.cursor/harness/core/` and `.cursor/adaptors/` — see `.cursor/harness/README.md`.

- **Gate** — `PLAN_APPROVED` is required before code is written; a fresh install *blocks* until you plan.
- **Acceptance** — every task needs an executable acceptance command; prose acceptance **fails**
  (`task-verify` is fail-closed). Genuinely manual checks must be declared as `manual: <steps>`.
- **Standalone** — `config/denylist.txt` is scanned across `.cursor/` so no author, machine path
  or company codename leaks into the shared template.
- **Portability** — `verify-portability.sh` bans GNU-only constructs and hardcoded `python3`.
- **Protocol** — `verify-roo-compat.sh` keeps frontmatter within open protocol fields, so the
  same content can be copied to `.roo/`.

## Design principles

1. **Universal only** — no company paths; any repository can install it.
2. **Config over fork** — behaviour switches live in `config/*.json`, validated by `config/schema.json`.
3. **Growth boundary** — project knowledge only in `.growing/`.
4. **Immutable after install** — the agent does not edit `.cursor/` unless you ask.
5. **Protocol-agnostic** — open skills/rules protocol; `.cursor/` can be copied to `.roo/`.
6. **Effectiveness over verbosity** — fewer round-trips beats shorter replies.

## Links

- Quickstart (EN): [`quickstart.en.md`](.cursor/docs/quickstart.en.md) · 中文: [`quickstart.md`](.cursor/docs/quickstart.md)
- Cross-platform notes: [`platforms.md`](.cursor/docs/platforms.md)
- Rules catalog: [`rules-catalog.md`](.cursor/docs/rules-catalog.md)
- Hosted docs: <https://wangqiqi.github.io/cursor-ai/>
