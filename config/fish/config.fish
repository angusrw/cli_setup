# PATH
fish_add_path /opt/homebrew/bin
fish_add_path ~/.local/bin

# Homebrew cask directory (if using custom location)
set -gx HOMEBREW_CASK_OPTS "--appdir=~/Apps"

# Aliases
alias uvenv="source .venv/bin/activate.fish"
alias pybase="source ~/python_base/.venv/bin/activate.fish"

alias claude_apm="claude --append-system-prompt (cat ~/.claude/auto_plan_mode.txt)"

# Starship prompt
set -gx STARSHIP_CONFIG "$HOME/.config/starship/mytheme.toml"
starship init fish | source

# Auto-start zellij (only in interactive sessions, avoid nesting)
if status is-interactive
    and not set -q ZELLIJ
    exec zellij
end

source ~/.safe-chain/scripts/init-fish.fish # Safe-chain Fish initialization script
