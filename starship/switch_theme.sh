#!/bin/bash
# ~/.config/switch_theme.sh

case "$1" in
  pills_mono)
    export STARSHIP_CONFIG=~/.config/pills_mono.toml
    ;;
  pills_normal)
    export STARSHIP_CONFIG=~/.config/pills_normal.toml
    ;;
  pills_pastel)
    export STARSHIP_CONFIG=~/.config/pills_pastel.toml
    ;;
  gruvbox)
    export STARSHIP_CONFIG=~/.config/gruvbox.toml
    ;;
  jetpack)
    export STARSHIP_CONFIG=~/.config/jetpack.toml
    ;;
  pastel)
    export STARSHIP_CONFIG=~/.config/pastel_powerline.toml
    ;;
  *)
    echo "Usage: $0 {pills_mono|pills_normal|pills_pastel|gruvbox|jetpack|pastel}"
    exit 1
esac

exec $SHELL