#!/bin/bash
set -e

if ! command -v brew &> /dev/null; then
    echo "Install Homebrew first: https://brew.sh"
    exit 1
fi

REPO="$(cd "$(dirname "$0")/.." && pwd)"
brew bundle --file="$REPO/Brewfile"

# Aikido SafeChain — supply chain security for package managers
if [ ! -d ~/.safe-chain ]; then
    curl -fsSL https://github.com/AikidoSec/safe-chain/releases/latest/download/install-safe-chain.sh | sh
else
    echo "SafeChain already installed"
fi

echo "✅ Dependencies installed"
