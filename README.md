# Claude Cowork Fix for Windows (Interactive Edition)

A surgical, interactive CLI tool to resolve the "VM service not running" and "Plan9 mount" errors in the Claude Desktop app for Windows.

## The Problem
Claude Cowork runs inside a lightweight Linux container (WSL2). On Windows, this container is highly sensitive to:
1. **Network Conflicts:** Tools like Tailscale, ZeroTier, or VPNs can block the virtual network creation.
2. **Resource Locking:** Apps like Ollama or Docker can "lock" the WSL environment, preventing Claude from booting.
3. **Ghost Services:** The `CoworkVMService` often gets stuck in a "Starting" or "Stopping" loop.

## How This Script Fixes It
Unlike a "nuclear option" that kills everything, this script is **interactive and surgical**:

1. **Auto-Elevation:** Automatically requests Admin privileges to manage Windows Services.
2. **Conflict Detection:** Scans your active processes for a "hit list" of known offenders (Tailscale, Ollama, Docker, etc.).
3. **User Consent:** For every app found, it asks: *Do you want to stop this app?*
4. **Surgical Strike:** It resets the Claude services and WSL environment only after you give the green light.
5. **Feedback Loop:** After each attempt, it asks: *Did that fix it?* If yes, the script exits immediately without touching any other apps.

## Usage
1. Download `Fix-Claude-Cowork.bat` to your machine.
2. **Double-click** the file (or run it from PowerShell).
3. Follow the on-screen prompts to selectively stop conflicting apps.
4. Once Claude is running, you can safely restart your other tools!

## Known "Conflict" Apps Detected
* **VPNs/Mesh:** Tailscale, ZeroTier, OpenVPN, WireGuard
* **Local AI/Containers:** Ollama, LM Studio, Docker Desktop
* **Remote Access:** Rainway, Parsec

---
*Created by [Jake Steinerman](https://github.com/Jastman)*