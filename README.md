# cli_setup

Development environment dotfiles and config.

## Prerequisites

```bash
brew install fish
brew install starship
brew install zellij
brew install helix
brew install --cask wezterm
brew install --cask font-fira-code-nerd-font
brew install uv
```

## Install

```bash
git clone ...
cd .../cli_setup
chmod +x install.sh
./install.sh
```

This symlinks all config files to their expected locations. Existing files will be overwritten.

## What's included

| Tool | Config | Purpose |
|---|---|---|
| WezTerm | `~/.wezterm.lua` | Terminal emulator |
| Fish | `~/.config/fish/config.fish` | Shell |
| Starship | `~/.config/starship/*.toml` | Prompt theme |
| Helix | `~/.config/helix/config.toml` | Terminal editor |
| Zellij | `~/.config/zellij/config.kdl` | Multiplexer |
| Git | `~/.gitconfig` | Git config and aliases |
| Claude | `~/.claude/` | Custom agents and prompts |
