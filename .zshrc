export PYENV_ROOT="$HOME/.pyenv"
[[ -d $PYENV_ROOT/bin ]] && export PATH="$PYENV_ROOT/bin:$PATH"
eval "$(pyenv init - zsh)"

. "$HOME/.local/bin/env"
alias pybase="source ~/python_base/.venv/bin/activate"
alias uvenv="source .venv/bin/activate"

alias code="code-insiders"

starship_theme() {
  local config="$HOME/.config/starship/$1.toml"
  if [[ -f "$config" ]]; then
    echo "$1" > "$HOME/.config/starship/current-theme"
    export STARSHIP_CONFIG="$config"
    echo "✅ Switched to Starship theme: $1"
    exec $SHELL
  else
    echo "❌ Theme not found: $1"
    echo "📂 Available themes:"
    for file in "$HOME/.config/starship/"*.toml; do
      basename "${file%.toml}"
    done
  fi
}

if [[ -f "$HOME/.config/starship/current-theme" ]]; then
  current_theme=$(<"$HOME/.config/starship/current-theme")
  export STARSHIP_CONFIG="$HOME/.config/starship/$current_theme.toml"
fi


alias claude_apm="claude --append-system-prompt \"\$(cat ~/.claude/auto_plan_mode.txt)\""

alias ptable="ps -fp \$(pgrep -d, python)"

eval "$(starship init zsh)"
