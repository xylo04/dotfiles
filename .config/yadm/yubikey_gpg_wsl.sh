#!/bin/bash

# On the Windows side, download https://github.com/jstarks/npiperelay/releases and unpack it somwhere

# 1. Install socat
sudo apt update && sudo apt install socat -y

# 2. Define paths (Update NPIPERELAY_WIN_PATH to your actual .exe location)
NPIPERELAY_WIN_PATH="/mnt/c/bin/npiperelay.exe"
BASH_RC="$HOME/.bashrc"

# 3. Create the relay snippet
RELAY_SNIPPET="
# YubiKey SSH Bridge
export SSH_AUTH_SOCK=\$HOME/.ssh/agent.sock
if ! pgrep -f npiperelay.exe > /dev/null; then
    rm -f \"\$SSH_AUTH_SOCK\"
    (setsid socat UNIX-LISTEN:\"\$SSH_AUTH_SOCK\",fork EXEC:\"$NPIPERELAY_WIN_PATH -ei -s //./pipe/openssh-ssh-agent\",nofork &) >/dev/null 2>&1
fi"

# 4. Append to .bashrc if not already there
if ! grep -q "npiperelay.exe" "$BASH_RC"; then
    echo "$RELAY_SNIPPET" >> "$BASH_RC"
    echo "Added relay to .bashrc"
else
    echo "Relay already exists in .bashrc"
fi

# 5. Ensure .ssh directory exists
mkdir -p ~/.ssh
chmod 700 ~/.ssh

echo "WSL setup complete. Run 'source ~/.bashrc' to start the bridge."
