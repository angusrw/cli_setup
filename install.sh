#!/bin/bash
DOTFILES="$(cd "$(dirname "$0")" && pwd)"

mkdir -p ~/.config/fish
mkdir -p ~/.config/starship
mkdir -p ~/.config/helix
mkdir -p ~/.config/zellij
mkdir -p ~/.claude/agents

ln -sf "$DOTFILES/fish/config.fish" ~/.config/fish/config.fish
ln -sf "$DOTFILES/starship/mytheme.toml" ~/.config/starship/mytheme.toml
ln -sf "$DOTFILES/helix/config.toml" ~/.config/helix/config.toml
ln -sf "$DOTFILES/zellij/config.kdl" ~/.config/zellij/config.kdl
ln -sf "$DOTFILES/wezterm/.wezterm.lua" ~/.wezterm.lua
ln -sf "$DOTFILES/git/.gitconfig" ~/.gitconfig
ln -sf "$DOTFILES/claude/auto_plan_mode.txt" ~/.claude/auto_plan_mode.txt

for agent in "$DOTFILES/claude/agents/"*.md; do
    ln -sf "$agent" ~/.claude/agents/
done

echo "✅ Dotfiles linked"
