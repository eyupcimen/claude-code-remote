#!/bin/bash
# One-command setup for claude-code-remote
# Run: bash setup.sh

set -e

echo "==> Installing Tailscale and tmux..."
brew install tailscale tmux

echo "==> Starting Tailscale service..."
sudo brew services start tailscale

echo "==> Connecting to Tailscale (browser will open)..."
sudo tailscale up

echo ""
echo "==> Done. Your Tailscale IP:"
tailscale ip -4

echo ""
echo "Next steps:"
echo "  1. System Settings → General → Sharing → Remote Login → ON"
echo "  2. Install Tailscale on your phone (same account)"
echo "  3. Install Termius on your phone"
echo "  4. SSH into this machine using the IP above"
echo ""
echo "To start a Claude Code session:"
echo "  tmux new -s myproject && cd ~/Developer/MyProject && claude"
