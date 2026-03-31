# cli_setup

Development environment dotfiles and configuration for macOS.

## Components

### Terminal & Shell (symlinked by `scripts/install.sh`)

| Component | Repo Path | Deployed To | Description |
|---|---|---|---|
| WezTerm | `config/wezterm/.wezterm.lua` | `~/.wezterm.lua` | Terminal emulator — FiraCode Nerd Font, Panda color scheme, purple gradient + grain background |
| Fish | `config/fish/config.fish` | `~/.config/fish/config.fish` | Shell — PATH, aliases, starship init, auto-start zellij, SafeChain init |
| Starship | `config/starship/mytheme.toml` | `~/.config/starship/mytheme.toml` | Prompt theme — right-aligned dir/git/lang, custom python venv icons |
| Zellij | `config/zellij/` | `~/.config/zellij/` | Multiplexer — fish shell, nightfox theme, zellaude status bar plugin |
| Helix | `config/helix/config.toml` | `~/.config/helix/config.toml` | Editor — relative line numbers, auto-save, bar cursor in insert |

### Dev Tools (symlinked by `scripts/install.sh`)

| Component | Repo Path | Deployed To | Description |
|---|---|---|---|
| Git | `config/git/.gitconfig` | `~/.gitconfig` | Aliases, pull rebase, auto-setup remote |
| uv | `config/uv/uv.toml` | `~/.config/uv/uv.toml` | Python package manager — `exclude-newer = "14 days"` for supply chain safety |

### AI Coding Tools (managed by `scripts/install.sh`)

| Component | Repo Path | Deployed To | Method | Description |
|---|---|---|---|---|
| Claude CLAUDE.md | `config/claude/CLAUDE.md` | `~/.claude/CLAUDE.md` | symlink | Global behavioral guidelines for Claude Code |
| Claude settings.json | `config/claude/settings.json` | `~/.claude/settings.json` | copy (with path substitution) | Model, permissions.deny, zellaude hooks |
| Claude agents | `config/claude/agents/*.md` | `~/.claude/agents/` | symlink | Custom subagent definitions (code-reviewer, debugger, etc.) |
| Claude auto-plan prompt | `config/claude/auto_plan_mode.txt` | `~/.claude/auto_plan_mode.txt` | symlink | System prompt for forced plan mode, used via `claude_apm` fish alias |
| Claude skills | `config/claude/skills/` | `~/.claude/skills/` | symlink | 42 skills (2 custom + 40 community) |
| Cursor rules | `config/cursor/rules/*.mdc` | per-project `.cursor/rules/` | manual copy | 241 rule files from [awesome-cursor-rules-mdc](https://github.com/sanjeed5/awesome-cursor-rules-mdc) |

### AI Coding Tools (installed separately, documented only)

**Claude plugins** — installed via `/plugin` inside Claude Code:

| Plugin | Source |
|---|---|
| `claude-plugins-official` marketplace | `anthropics/claude-code` |
| `cc-makefile` | [github](https://github.com/benjaminr/cc-makefile/) |

### Dependencies (installed by `scripts/setup.sh`)

| Dependency | Install | Notes |
|---|---|---|
| Fish | `brew install fish` | Shell |
| Starship | `brew install starship` | Prompt |
| Helix | `brew install helix` | Editor |
| Zellij | `brew install zellij` | Multiplexer |
| WezTerm | `brew install --cask wezterm` | Terminal |
| FiraCode Nerd Font | `brew install --cask font-fira-code-nerd-font` | Required by WezTerm + Starship |
| uv | `brew install uv` | Python package manager |
| jq | `brew install jq` | Used by zellaude hook script |
| Aikido SafeChain | `curl` install | Supply chain security for package managers, init'd in fish config |

## Component Details

### Fish

Shell config. Includes:
- PATH setup (`/opt/homebrew/bin`, `~/.local/bin`)
- Aliases: `uvenv`, `pybase`, `claude_apm`, `typora`
- Starship prompt init
- Auto-start zellij in interactive sessions
- Aikido SafeChain init

`claude_apm` alias runs Claude Code with a forced plan-mode system prompt from `~/.claude/auto_plan_mode.txt`.

### Starship

Custom prompt theme. Right-aligned directory/git/language info, left-aligned user/character. Custom python venv display (house icon for local venv, base icon for python_base, name for others).

### Helix

Minimal editor config: relative line numbers, multi-buffer tabs, auto-save, bar cursor in insert mode.

### Zellij

Terminal multiplexer config and zellaude plugin. Symlinks:
- `config.kdl` — fish shell, nightfox theme, rounded pane frames
- `layouts/default.kdl` — default tab with zellaude status bar plugin
- `plugins/zellaude.wasm` — Zellij plugin showing Claude Code activity in the status bar
- `plugins/zellaude-hook.sh` — bridges Claude Code hook events to zellaude plugin via `zellij pipe`, also sends desktop notifications on permission requests

The zellaude system works via:
1. `~/.claude/settings.json` registers the hook on all Claude Code events
2. `zellaude-hook.sh` receives events and forwards them to the plugin via `zellij pipe`
3. `zellaude.wasm` renders status in the Zellij top bar

### WezTerm

Terminal emulator. FiraCode Nerd Font, Panda color scheme, dark purple gradient background with grain texture overlay (`grain.jpg` symlinked to `~/grain.jpg`). Fish as default shell, zellij handles multiplexing. Shift+Enter sends literal newline for multi-line input.

### Git

Aliases (co, br, st, ci, lg, cleanup, ri, fixup, amend, pushf). Pull rebases by default, push auto-sets upstream.

### uv

Python package manager config. `exclude-newer = "14 days"` — only resolves package versions at least 14 days old as a supply chain safety measure.

### Claude Code

**CLAUDE.md** — global behavioral guidelines symlinked to `~/.claude/CLAUDE.md`. Biases toward caution: think before coding, simplicity first, surgical changes, goal-driven execution.

**settings.json** — not symlinked, written by `scripts/install.sh` with path substitution. Contains:
- `"model": "opus"`
- `permissions.deny` — blocks reading `.env`, secrets, keys, credentials
- Zellaude hooks on all 9 Claude Code events (paths resolved at install time from `__ZELLAUDE_HOOK_PATH__` placeholder)

Use `./scripts/install.sh --force` to overwrite an existing `settings.json`. Without `--force`, the file is skipped if it already exists.

**Skills** — 42 skills symlinked from `config/claude/skills/` to `~/.claude/skills/`. See [`config/claude/skills/INDEX.md`](config/claude/skills/INDEX.md) for the full list with descriptions. To add a new skill: `npx skills add <source>`, then copy the skill directory into `config/claude/skills/` and update the index.

### Cursor

241 `.mdc` rule files stored in `config/cursor/rules/`. These are manually copied into project `.cursor/rules/` directories as needed — not symlinked by `scripts/install.sh`. Source: [awesome-cursor-rules-mdc](https://github.com/sanjeed5/awesome-cursor-rules-mdc).

### Aikido SafeChain

Supply chain security — intercepts package manager installs and checks for known vulnerabilities. Installed via `setup.sh`, initialized in fish config. Not a symlinked config — one-time install at `~/.safe-chain/`.

## Repo Structure

```
cli_setup/
├── config/
│   ├── fish/config.fish
│   ├── starship/mytheme.toml
│   ├── helix/config.toml
│   ├── zellij/
│   │   ├── config.kdl
│   │   ├── layouts/default.kdl
│   │   └── plugins/
│   │       ├── zellaude.wasm
│   │       └── zellaude-hook.sh
│   ├── wezterm/
│   │   ├── .wezterm.lua
│   │   └── grain.jpg
│   ├── git/.gitconfig
│   ├── uv/uv.toml
│   ├── claude/
│   │   ├── CLAUDE.md
│   │   ├── settings.json
│   │   ├── auto_plan_mode.txt
│   │   ├── agents/*.md
│   │   └── skills/
│   │       ├── INDEX.md
│   │       └── */SKILL.md        ← 42 skills
│   └── cursor/
│       └── rules/*.mdc
├── scripts/
│   ├── install.sh
│   └── setup.sh
└── README.md
```

## Setup

### New machine

```bash
# 1. Clone
git clone <repo> ~/repos/cli_setup
cd ~/repos/cli_setup

# 2. Install dependencies
chmod +x scripts/setup.sh
./scripts/setup.sh

# 3. Link configs
chmod +x scripts/install.sh
./scripts/install.sh

# To overwrite existing settings.json:
./scripts/install.sh --force
```

### After pulling changes

```bash
./scripts/install.sh
```
