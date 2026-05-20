#!/bin/bash
# Install GitHub CLI (gh) based on the current platform
set -e

if command -v gh &>/dev/null; then
  echo "✅ gh CLI already installed: $(gh --version | head -1)"
  exit 0
fi

OS="$(uname -s)"
ARCH="$(uname -m)"

echo "Installing GitHub CLI for $OS ($ARCH)..."

case "$OS" in
  Darwin)
    if command -v brew &>/dev/null; then
      brew install gh
    else
      echo "Homebrew not found. Install it from https://brew.sh or install gh manually."
      echo "  https://cli.github.com/"
      exit 1
    fi
    ;;
  Linux)
    if command -v apt-get &>/dev/null; then
      curl -fsSL https://cli.github.com/packages/githubcli-archive-keyring.gpg | \
        sudo dd of=/usr/share/keyrings/githubcli-archive-keyring.gpg
      echo "deb [arch=$(dpkg --print-architecture) signed-by=/usr/share/keyrings/githubcli-archive-keyring.gpg] \
        https://cli.github.com/packages stable main" | \
        sudo tee /etc/apt/sources.list.d/github-cli.list >/dev/null
      sudo apt-get update -qq
      sudo apt-get install -y gh
    elif command -v dnf &>/dev/null; then
      sudo dnf install -y gh
    elif command -v yum &>/dev/null; then
      sudo yum install -y gh
    elif command -v pacman &>/dev/null; then
      sudo pacman -S --noconfirm github-cli
    else
      echo "Unsupported package manager. Install gh manually: https://cli.github.com/"
      exit 1
    fi
    ;;
  *)
    echo "Unsupported OS: $OS. Install gh manually: https://cli.github.com/"
    exit 1
    ;;
esac

echo ""
echo "✅ GitHub CLI installed successfully!"
echo ""
echo "Next step — authenticate:"
echo "  gh auth login"
echo ""
echo "This will open a browser to authorize. Choose:"
echo "  - GitHub.com"
echo "  - HTTPS protocol"
echo "  - Login with a web browser"
