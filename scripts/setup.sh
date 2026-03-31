#!/bin/bash
set -e

if ! command -v brew &> /dev/null; then
    echo "Install Homebrew first: https://brew.sh"
    exit 1
fi

brew install fish
brew install starship
brew install helix
brew install zellij
brew install --cask wezterm
brew install --cask font-fira-code-nerd-font
brew install uv
brew install jq

# Aikido SafeChain — supply chain security for package managers
curl -fsSL https://github.com/AikidoSec/safe-chain/releases/latest/download/install-safe-chain.sh | sh

echo "Done"
