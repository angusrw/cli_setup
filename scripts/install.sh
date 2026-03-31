#!/bin/bash
set -e

DOTFILES="$(cd "$(dirname "$0")/.." && pwd)/config"
FORCE=false
[ "$1" = "--force" ] && FORCE=true

mkdir -p ~/.config/{fish,starship,helix,zellij/layouts,zellij/plugins,uv} ~/.claude/{agents,skills}

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
ln -sf "$DOTFILES/uv/uv.toml" ~/.config/uv/uv.toml

# Claude Code
ln -sf "$DOTFILES/claude/CLAUDE.md" ~/.claude/CLAUDE.md
ln -sf "$DOTFILES/claude/auto_plan_mode.txt" ~/.claude/auto_plan_mode.txt
for agent in "$DOTFILES/claude/agents/"*.md; do
    ln -sf "$agent" ~/.claude/agents/
done

# Claude Code settings.json (not symlinked — written with resolved paths)
ZELLAUDE_HOOK="$HOME/.config/zellij/plugins/zellaude-hook.sh"
if [ ! -f ~/.claude/settings.json ] || [ "$FORCE" = true ]; then
    sed "s|__ZELLAUDE_HOOK_PATH__|$ZELLAUDE_HOOK|g" "$DOTFILES/claude/settings.json" > ~/.claude/settings.json
    echo "✅ settings.json written"
else
    echo "⚠️  ~/.claude/settings.json already exists, use --force to overwrite"
fi

# Claude Code skills
for skill in "$DOTFILES/claude/skills"/*/; do
    [ -d "$skill" ] || continue
    name="$(basename "$skill")"
    ln -sfn "$skill" ~/.claude/skills/"$name"
done

echo "✅ Dotfiles linked"
