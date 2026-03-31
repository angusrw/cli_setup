#!/bin/bash
set -e

DOTFILES="$(cd "$(dirname "$0")/.." && pwd)/config"
FORCE=false
CHECK=false
for arg in "$@"; do
    case "$arg" in
        --force) FORCE=true ;;
        --check) CHECK=true ;;
    esac
done

# --- check mode ---

check_link() {
    local target="$1" link="$2"
    if [ -L "$link" ] && [ "$(readlink "$link")" = "$target" ]; then
        echo "  ✅ $link"
    elif [ -L "$link" ]; then
        echo "  ⚠️  $link -> $(readlink "$link") (expected $target)"
    elif [ -e "$link" ]; then
        echo "  ⚠️  $link exists but is not a symlink"
    else
        echo "  ❌ $link missing"
    fi
}

check_file() {
    local path="$1"
    if [ -f "$path" ]; then
        echo "  ✅ $path"
    else
        echo "  ❌ $path missing"
    fi
}

if [ "$CHECK" = true ]; then
    echo "Symlinks:"
    check_link "$DOTFILES/fish/config.fish" ~/.config/fish/config.fish
    check_link "$DOTFILES/starship/mytheme.toml" ~/.config/starship/mytheme.toml
    check_link "$DOTFILES/helix/config.toml" ~/.config/helix/config.toml
    check_link "$DOTFILES/zellij/config.kdl" ~/.config/zellij/config.kdl
    check_link "$DOTFILES/zellij/layouts/default.kdl" ~/.config/zellij/layouts/default.kdl
    check_link "$DOTFILES/zellij/plugins/zellaude.wasm" ~/.config/zellij/plugins/zellaude.wasm
    check_link "$DOTFILES/zellij/plugins/zellaude-hook.sh" ~/.config/zellij/plugins/zellaude-hook.sh
    check_link "$DOTFILES/wezterm/.wezterm.lua" ~/.wezterm.lua
    check_link "$DOTFILES/wezterm/grain.jpg" ~/grain.jpg
    check_link "$DOTFILES/git/.gitconfig" ~/.gitconfig
    check_link "$DOTFILES/uv/uv.toml" ~/.config/uv/uv.toml
    check_link "$DOTFILES/claude/CLAUDE.md" ~/.claude/CLAUDE.md
    check_link "$DOTFILES/claude/auto_plan_mode.txt" ~/.claude/auto_plan_mode.txt
    for agent in "$DOTFILES/claude/agents/"*.md; do
        check_link "$agent" ~/.claude/agents/"$(basename "$agent")"
    done
    for skill in "$DOTFILES/claude/skills"/*/; do
        [ -d "$skill" ] || continue
        name="$(basename "$skill")"
        check_link "$skill" ~/.claude/skills/"$name"
    done

    echo ""
    echo "Files:"
    check_file ~/.claude/settings.json

    exit 0
fi

# --- install mode ---

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
