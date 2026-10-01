# claude-code-remote

Setup scripts for controlling Claude Code remotely from a phone via Tailscale + SSH + tmux.

## What this repo does

Automates the one-time setup required to SSH into a Mac from a phone and run Claude Code sessions that survive disconnects.

## Files

- `setup.sh` — installs and configures everything (Tailscale, tmux, SSH, tmux.conf)
- `README.md` — full guide and explanation

## How to help users

If a user runs into issues, check in this order:

1. Is Tailscale running? → `sudo brew services start tailscale`
2. Is SSH enabled? → `sudo systemsetup -getremotelogin`
3. Can they reach the Mac? → `tailscale ping <their-mac-hostname>`
4. Is tmux installed? → `tmux -V`

## Scope

This repo is documentation + setup only. No application code.
