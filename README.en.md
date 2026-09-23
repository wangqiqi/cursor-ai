# Super Cursor (English)

> Chinese is the canonical language of this project; **this file is a minimal English entry point.**
> Canonical docs: [README.md](README.md) · [`docs/`](https://wangqiqi.github.io/cursor-ai/)

Super Cursor turns "how to work with an AI agent" from chat conventions into an installable,
reusable, evolvable workflow master: **rules + skills + hooks + config**, installed once and
usable in every repository. Project-specific knowledge lives in `.cursorGrowth/` (git-ignored),
never in the shared template.

## What you get

```text
.cursor/
├── rules/       4 always-on + 49 glob/description-scoped rules
├── skills/      28 skills (plan · run · learn · scaffold · debug · test · review …)
├── commands/    10 slash entries
├── agents/      ship · review · spike (subagents)
├── hooks/       growth-init · run-start · run-stop
├── config/      workflow.json · release.json · roles.json · schema.json · denylist.txt
└── bin/         runner.sh · scaffold.sh · template-verify.sh · consumer-smoke.sh · verify-*.sh
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
| `--copy-plan` | seed `.cursorGrowth/plan.md` |

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
bash .cursor/bin/template-verify.sh     # mother repo, full suite
bash .cursor/bin/consumer-smoke.sh      # install into a throwaway project and use it
bash .cursor/verify-super-cursor.sh     # layout + cross-checks (works in target projects too)
bash .cursor/bin/cursor-coherence.sh    # skills/agents/rules registration
```

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
3. **Growth boundary** — project knowledge only in `.cursorGrowth/`.
4. **Immutable after install** — the agent does not edit `.cursor/` unless you ask.
5. **Protocol-agnostic** — open skills/rules protocol; `.cursor/` can be copied to `.roo/`.
6. **Effectiveness over verbosity** — fewer round-trips beats shorter replies.

## Links

- Quickstart (EN): [`quickstart.en.md`](.cursor/docs/quickstart.en.md) · 中文: [`quickstart.md`](.cursor/docs/quickstart.md)
- Cross-platform notes: [`platforms.md`](.cursor/docs/platforms.md)
- Rules catalog: [`rules-catalog.md`](.cursor/docs/rules-catalog.md)
- Hosted docs: <https://wangqiqi.github.io/cursor-ai/>
