# Claude Code Remote — Control Claude from Your Phone

Control your Claude Code sessions from anywhere using Tailscale, tmux, and SSH. No cloud services, no subscriptions — just a direct encrypted tunnel to your Mac.

---

## The Problem

Claude Code runs on your Mac. You start a task, walk away, and have no way to check progress or send new instructions unless you're sitting at your computer.

Claude Code's built-in Remote Control feature solves this — but it's not available to everyone yet.

---

## The Solution

Three tools, zero cloud dependency:

| Tool | What it does |
|---|---|
| **Tailscale** | Creates an encrypted tunnel between your Mac and phone — works anywhere, no port forwarding needed |
| **tmux** | Keeps your terminal session alive even when you disconnect |
| **SSH** | Lets your phone connect to your Mac's terminal |

```
Phone (anywhere)
  → Tailscale tunnel
    → SSH into Mac
      → tmux session
        → Claude Code
```

---

## Setup (one time)

### 1. Install Tailscale and tmux on Mac

```bash
brew install tailscale tmux
sudo brew services start tailscale
sudo tailscale up
```

A browser window opens. Create a free account at tailscale.com and log in.

### 2. Enable SSH on Mac

System Settings → General → Sharing → Remote Login → turn on

### 3. Get your Mac's Tailscale IP

```bash
tailscale ip -4
```

Save this — you'll use it to connect from your phone.

### 4. Install Tailscale on your phone

Download from the App Store or Google Play. Log in with the same account.

Both devices will show as "Connected" in the Tailscale dashboard.

### 5. Install an SSH client on your phone

**iOS:** [Termius](https://apps.apple.com/app/termius-ssh-shell-client/id549039908) (free tier is enough)  
**Android:** [JuiceSSH](https://play.google.com/store/apps/details?id=com.sonelli.juicessh) or Termius

Add a new host:
- **Host:** your Tailscale IP from step 3
- **Username:** your Mac username
- **Password:** your Mac login password

---

## Daily Usage

### Start a Claude Code session

On your Mac (or from your phone via SSH):

```bash
tmux new -s myproject
cd ~/Developer/MyProject
claude
```

### Reconnect from your phone

Open Termius, connect to your Mac, then:

```bash
tmux attach -t myproject
```

You're back exactly where you left off.

### Run multiple projects in parallel

```bash
# Start sessions
tmux new -s project-a
tmux new -s project-b

# List all active sessions
tmux ls

# Switch between them
tmux attach -t project-a
tmux attach -t project-b
```

Inside tmux, switch sessions with `Ctrl+B, S`.

---

## Why tmux matters

Without tmux, closing your SSH connection kills Claude mid-task. tmux keeps the session running on the Mac even when your phone disconnects — reconnect later and everything is still there.

---

## Why Tailscale instead of port forwarding

Opening SSH to the public internet (port forwarding) exposes your Mac to brute force attacks. Tailscale creates a private encrypted mesh network — only your authenticated devices can connect. Nothing is publicly exposed.

---

## Troubleshooting

**"Failed to connect to local Tailscale service"**
```bash
sudo brew services start tailscale
```

**SSH connection refused**  
Make sure Remote Login is enabled: System Settings → General → Sharing → Remote Login

**tmux session not found**
```bash
tmux ls   # list existing sessions
tmux new -s newsession   # create a new one
```

---

## Requirements

- Mac with Homebrew
- iPhone or Android phone
- Free Tailscale account (up to 3 devices free)
- Claude Code installed on Mac

---

## What this doesn't do

This gives you full terminal access — you can read Claude's output and type new instructions. It does not send push notifications when Claude finishes a task. For that, combine this setup with a notification tool like [Gotify](https://gotify.net) and a Claude Code `Notification` hook.
