# 1. Disable the conflicting Windows SSH Agent
Stop-Service ssh-agent -ErrorAction SilentlyContinue
Set-Service ssh-agent -StartupType Disabled

# 2. Create GPG Config Directory if it doesn't exist
$gpgPath = "$env:APPDATA\gnupg"
if (!(Test-Path $gpgPath)) { New-Item -ItemType Directory -Path $gpgPath }

# 3. Write gpg-agent.conf
$agentConf = @"
enable-ssh-support
enable-win32-openssh-support
"@
Set-Content -Path "$gpgPath\gpg-agent.conf" -Value $agentConf

# 4. Identify YubiKey and write scdaemon.conf
$yubiName = Get-PnpDevice -Class SoftwareDevice | 
            Where-Object { $_.FriendlyName -like "*YubiKey*" } | 
            Select-Object -ExpandProperty FriendlyName -First 1

if ($yubiName) {
    Set-Content -Path "$gpgPath\scdaemon.conf" -Value "reader-port `"$yubiName`""
    Write-Host "Bound GPG to: $yubiName" -ForegroundColor Green
}

# 5. Set System-wide Environment Variable
[Environment]::SetEnvironmentVariable("SSH_AUTH_SOCK", "\\.\pipe\openssh-ssh-agent", "User")
$env:SSH_AUTH_SOCK = "\\.\pipe\openssh-ssh-agent"

# 6. Force Git to use System SSH
git config --global core.sshCommand "C:/Windows/System32/OpenSSH/ssh.exe"

# 7. Restart GPG
gpg-connect-agent killagent /bye
gpg-connect-agent /bye

Write-Host "Windows setup complete. Restart your terminal for changes to take effect." -ForegroundColor Cyan
