# ~/.profile: executed by the command interpreter for login shells.
# This file is not read by bash(1), if ~/.bash_profile or ~/.bash_login
# exists.
# see /usr/share/doc/bash/examples/startup-files for examples.
# the files are located in the bash-doc package.

# the default umask is set in /etc/profile; for setting the umask
# for ssh logins, install and configure the libpam-umask package.
#umask 022

# set PATH so it includes user's private bin if it exists
if [ -d "$HOME/bin" ] ; then
    PATH="$HOME/bin:$PATH"
fi

# set PATH so it includes user's private bin if it exists
if [ -d "$HOME/.local/bin" ] ; then
    PATH="$HOME/.local/bin:$PATH"
fi

### xylo04 additions ###

# GPG SSH auth
if [[ $SSH_AUTH_SOCK != /tmp/ssh* ]] ; then
    export GPG_TTY="$(tty)"
    export SSH_AUTH_SOCK=$(gpgconf --list-dirs agent-ssh-socket)
    gpgconf --launch gpg-agent
fi

# golang
if [ -d "$HOME/go/bin" ] ; then
    PATH="$HOME/go/bin:$PATH"
fi

# npm global
if [ -d "$HOME/.npm-global/bin" ] ; then
    PATH=$HOME/.npm-global/bin:$PATH
fi

# pip3
if [ -d "$HOME/Library/Python/3.8/bin" ] ; then
    PATH=$HOME/Library/Python/3.8/bin:$PATH
fi

# gcloud
if [ -d "$HOME/lib/google-cloud-sdk" ]; then
    if [ -n "$BASH_VERSION" ]; then
        [ -s "$HOME/lib/google-cloud-sdk/path.bash.inc" ] && \. "$HOME/lib/google-cloud-sdk/path.bash.inc"
        [ -s "$HOME/lib/google-cloud-sdk/completion.bash.inc" ] && \. "$HOME/lib/google-cloud-sdk/completion.bash.inc"
    fi
    if [ -n "$ZSH_VERSION" ]; then
        [ -s "$HOME/lib/google-cloud-sdk/path.zsh.inc" ] && \. "$HOME/lib/google-cloud-sdk/path.zsh.inc"
        [ -s "$HOME/lib/google-cloud-sdk/completion.zsh.inc" ] && \. "$HOME/lib/google-cloud-sdk/completion.zsh.inc"
    fi
fi

# sdkman
if [ -d $HOME/.sdkman ]; then
    SDKMAN_DIR="$HOME/.sdkman"
    [[ -s "$HOME/.sdkman/bin/sdkman-init.sh" ]] && source "$HOME/.sdkman/bin/sdkman-init.sh"
fi
if command -v javac &> /dev/null; then
    JAVA_HOME="$(dirname $(dirname $(realpath $(which javac))))"
fi

# Node version manager
if [ -d $HOME/.nvm ]; then
    NVM_DIR="$HOME/.nvm"
    [ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh"
    [ -s "$NVM_DIR/bash_completion" ] && \. "$NVM_DIR/bash_completion"
fi

# Ruby version manager
if [ -d $HOME/.rvm ]; then
  PATH="$PATH:$HOME/.rvm/bin"
  [[ -s "$HOME/.rvm/scripts/rvm" ]] && source "$HOME/.rvm/scripts/rvm"
fi

# Homebrew
if [ -d /opt/homebrew ]; then
  eval "$(/opt/homebrew/bin/brew shellenv)"
fi

# Android SDK
if [ -d $HOME/Library/Android/sdk ]; then
    export ANDROID_HOME=$HOME/Library/Android/sdk
    export PATH=$PATH:$ANDROID_HOME/emulator
    export PATH=$PATH:$ANDROID_HOME/platform-tools
fi

EDITOR=vi
GO111MODULE=on
GPG_TTY=$(tty)

# Debian packaging
DEBEMAIL="xylo04@gmail.com"
DEBFULLNAME="Chris Keller"
HISTCONTROL=ignoreboth
if [ -f /usr/lib/mc/mc.sh ]; then
    . /usr/lib/mc/mc.sh
fi
alias dquilt="quilt --quiltrc=${HOME}/.quiltrc-dpkg"
complete -F _quilt_completion $_quilt_complete_opt dquilt

