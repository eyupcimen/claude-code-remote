#!/bin/bash
# claude-code-remote setup
# Run: bash setup.sh

set -e

GREEN='\033[0;32m'
YELLOW='\033[1;33m'
NC='\033[0m'

step() { echo -e "\n${GREEN}==>${NC} $1"; }
warn() { echo -e "${YELLOW}!${NC} $1"; }

# Check macOS
if [[ "$OSTYPE" != "darwin"* ]]; then
  echo "This script is for macOS only."
  exit 1
fi

# Check Homebrew
if ! command -v brew &>/dev/null; then
  echo "Homebrew not found. Install it first: https://brew.sh"
  exit 1
fi

step "Installing Tailscale and tmux..."
brew install tailscale tmux

step "Starting Tailscale service..."
sudo brew services start tailscale

step "Connecting to Tailscale..."
warn "A browser window will open. Log in or create a free account at tailscale.com"
sudo tailscale up

TAILSCALE_IP=$(tailscale ip -4 2>/dev/null || echo "unavailable")

step "Enabling SSH (Remote Login)..."
sudo systemsetup -setremotelogin on 2>/dev/null && echo "SSH enabled." || \
  warn "Could not enable SSH automatically. Do it manually: System Settings → General → Sharing → Remote Login → ON"

step "Installing tmux config..."
TMUX_CONF="$HOME/.tmux.conf"
if [ ! -f "$TMUX_CONF" ]; then
  cat > "$TMUX_CONF" <<'EOF'
# Better colors
set -g default-terminal "screen-256color"

# Increase scrollback
set -g history-limit 10000

# Mouse support (useful on phone)
set -g mouse on

# Status bar
set -g status-right '#(tailscale ip -4 2>/dev/null) | %H:%M'
set -g status-interval 30
EOF
  echo "tmux config written to ~/.tmux.conf"
else
  warn "~/.tmux.conf already exists, skipping."
fi

echo ""
echo "========================================"
echo "  Setup complete"
echo "========================================"
echo ""
echo "  Mac Tailscale IP: ${TAILSCALE_IP}"
echo "  SSH username:     $(whoami)"
echo ""
echo "  Phone setup:"
echo "  1. Install Tailscale → same account"
echo "  2. Install Termius (iOS) or JuiceSSH (Android)"
echo "  3. Add host: ${TAILSCALE_IP} / $(whoami)"
echo ""
echo "  Start a Claude Code session:"
echo "  tmux new -s myproject"
echo "  cd ~/Developer/MyProject && claude"
echo ""
echo "  Reconnect from phone:"
echo "  tmux attach -t myproject"
echo "========================================"
