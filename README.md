# Claude Cowork Fix for Windows

A dead-simple, one-click script to resolve the recurring `virtiofs` and Plan9 mount RPC errors in the Claude desktop app for Windows. 

## The Problem
When using Claude's Cowork feature on Windows, the underlying Linux virtual machine can crash or get stuck, throwing an error like:
`RPC error -1: failed to ensure virtiofs mount: Plan9 mount failed: bad address`

Simply restarting the Claude app doesn't fix it because the background processes and the Windows Subsystem for Linux (WSL) remain in a frozen state.

## The Solution
`Fix-Claude-Cowork.bat` automates the manual workaround. With one double-click, it:
1. Force-kills all lingering Claude background processes.
2. Issues a `wsl --shutdown` command to completely reset the virtual file system.

## Usage
1. Download `Fix-Claude-Cowork.bat` to your desktop or workspace.
2. Whenever Claude throws the Cowork error, make sure Claude is closed, then double-click the script.
3. Relaunch Claude.

## Note on Working Directories
To prevent this error from happening in the first place, ensure your project folder is not located inside a cloud-synced directory (like OneDrive or Google Drive) and that the file path contains no spaces or symbolic links. 

## License
MIT License - Copyright (c) 2026 Jake Steinerman