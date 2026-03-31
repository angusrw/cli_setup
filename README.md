# cli_setup

Dotfiles and dev environment config for macOS. Two scripts handle everything: `setup.sh` installs dependencies, `install.sh` symlinks configs into place.

## Components

### WezTerm (terminal emulator)

`config/wezterm/.wezterm.lua` symlinked to `~/.wezterm.lua`

FiraCode Nerd Font, Panda color scheme, dark purple gradient background with grain texture overlay (`grain.jpg` symlinked to `~/grain.jpg`). Fish as default shell. Shift+Enter sends a literal newline for multi-line input.

### Fish (shell)

`config/fish/config.fish` symlinked to `~/.config/fish/config.fish`

- PATH setup (`/opt/homebrew/bin`, `~/.local/bin`)
- Aliases: `uvenv`, `pybase`, `claude_apm`, `typora`
- Starship prompt init
- Auto-starts zellij in interactive sessions
- Aikido SafeChain init

`claude_apm` runs Claude Code with a forced plan-mode system prompt from `~/.claude/auto_plan_mode.txt`.

### Starship (prompt)

`config/starship/mytheme.toml` symlinked to `~/.config/starship/mytheme.toml`

Right-aligned directory/git/language info, left-aligned user/character. Custom python venv display: house icon for local venv, base icon for python_base, name for everything else.

### Zellij (multiplexer)

`config/zellij/` symlinked to `~/.config/zellij/`

Fish shell, nightfox theme, rounded pane frames. Ships with the zellaude plugin, which shows Claude Code activity in the Zellij status bar.

Zellaude files:
- `layouts/default.kdl` loads the plugin in the top bar
- `plugins/zellaude.wasm` renders Claude Code status
- `plugins/zellaude-hook.sh` bridges Claude Code hook events to the plugin via `zellij pipe`, sends desktop notifications on permission requests

How it connects:
1. `~/.claude/settings.json` registers the hook on all Claude Code events
2. `zellaude-hook.sh` receives events and forwards them via `zellij pipe`
3. `zellaude.wasm` renders status in the top bar

### Helix (editor)

`config/helix/config.toml` symlinked to `~/.config/helix/config.toml`

Relative line numbers, multi-buffer tabs, auto-save, bar cursor in insert mode.

### Git

`config/git/.gitconfig` symlinked to `~/.gitconfig`

Aliases: co, br, st, ci, lg, cleanup, ri, fixup, amend, pushf. Pull rebases by default. Push auto-sets upstream.

### uv (Python package manager)

`config/uv/uv.toml` symlinked to `~/.config/uv/uv.toml`

`exclude-newer = "14 days"` only resolves package versions at least 14 days old as a supply chain safety measure.

### Claude Code

**CLAUDE.md** -- `config/claude/CLAUDE.md` symlinked to `~/.claude/CLAUDE.md`. Global behavioral guidelines that bias toward caution: think before coding, simplicity first, surgical changes, goal-driven execution.

**settings.json** -- not symlinked. `install.sh` writes it with path substitution (resolves `__ZELLAUDE_HOOK_PATH__` at install time). Contains model selection (`opus`), `permissions.deny` blocking reads of `.env`/secrets/keys/credentials, and zellaude hooks on all 9 Claude Code events. Pass `--force` to overwrite an existing copy.

**Agents** -- `config/claude/agents/*.md` symlinked to `~/.claude/agents/`. Custom subagent definitions (code-reviewer, debugger, etc.).

**Auto-plan prompt** -- `config/claude/auto_plan_mode.txt` symlinked to `~/.claude/auto_plan_mode.txt`. System prompt for forced plan mode, used via the `claude_apm` fish alias.

**Skills** -- 42 skills (2 custom + 40 community) symlinked from `config/claude/skills/` to `~/.claude/skills/`. See [`config/claude/skills/INDEX.md`](config/claude/skills/INDEX.md) for the full list. To add a skill: run `npx skills add <source>`, copy the directory into `config/claude/skills/`, update the index.

### Cursor

241 `.mdc` rule files in `config/cursor/rules/`. You copy these manually into project `.cursor/rules/` directories as needed. Not managed by `install.sh`. Source: [awesome-cursor-rules-mdc](https://github.com/sanjeed5/awesome-cursor-rules-mdc).

### Claude plugins (installed separately)

You install these via `/plugin` inside Claude Code:
- `claude-plugins-official` marketplace from `anthropics/claude-code`
- [`cc-makefile`](https://github.com/benjaminr/cc-makefile/)

### Aikido SafeChain

Supply chain security that intercepts package manager installs and checks for known vulnerabilities. `setup.sh` installs it to `~/.safe-chain/`. Fish config initializes it. No symlinked config.

### Dependencies

`setup.sh` runs `brew bundle` against the repo's `Brewfile`:

Fish, Starship, Helix, Zellij, WezTerm, FiraCode Nerd Font (required by WezTerm + Starship), uv, jq (used by zellaude-hook.sh), Aikido SafeChain (curl install, skipped if already present).

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
│   │       └── */SKILL.md        <- 42 skills
│   └── cursor/
│       └── rules/*.mdc
├── scripts/
│   ├── install.sh
│   └── setup.sh
├── Brewfile
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

# Check if everything is in sync:
./scripts/install.sh --check
```
