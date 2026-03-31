#!/bin/bash
DOTFILES="$(cd "$(dirname "$0")" && pwd)/config"

mkdir -p ~/.config/fish
mkdir -p ~/.config/starship
mkdir -p ~/.config/helix
mkdir -p ~/.config/zellij/layouts
mkdir -p ~/.config/zellij/plugins
mkdir -p ~/.claude/agents

# Fish
ln -sf "$DOTFILES/fish/config.fish" ~/.config/fish/config.fish

# Starship
ln -sf "$DOTFILES/starship/mytheme.toml" ~/.config/starship/mytheme.toml

# Helix
ln -sf "$DOTFILES/helix/config.toml" ~/.config/helix/config.toml

# Zellij
ln -sf "$DOTFILES/zellij/config.kdl" ~/.config/zellij/config.kdl
ln -sf "$DOTFILES/zellij/layouts/default.kdl" ~/.config/zellij/layouts/default.kdl
ln -sf "$DOTFILES/zellij/plugins/zellaude.wasm" ~/.config/zellij/plugins/zellaude.wasm
ln -sf "$DOTFILES/zellij/plugins/zellaude-hook.sh" ~/.config/zellij/plugins/zellaude-hook.sh

# WezTerm
ln -sf "$DOTFILES/wezterm/.wezterm.lua" ~/.wezterm.lua
ln -sf "$DOTFILES/wezterm/grain.jpg" ~/grain.jpg

# Git
ln -sf "$DOTFILES/git/.gitconfig" ~/.gitconfig

# uv
mkdir -p ~/.config/uv
ln -sf "$DOTFILES/uv/uv.toml" ~/.config/uv/uv.toml

# Claude Code
ln -sf "$DOTFILES/claude/auto_plan_mode.txt" ~/.claude/auto_plan_mode.txt
for agent in "$DOTFILES/claude/agents/"*.md; do
    ln -sf "$agent" ~/.claude/agents/
done

echo "✅ Dotfiles linked"
