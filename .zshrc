# Enable Powerlevel10k instant prompt. Should stay close to the top of ~/.zshrc.
# Initialization code that may require console input (password prompts, [y/n]
# confirmations, etc.) must go above this block; everything else may go below.
if [[ -r "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh" ]]; then
  source "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh"
fi

# ============================================
# Zsh Configuration: Oh My Zsh and Aliases
# ============================================

# Path to your Oh My Zsh installation.
export ZSH="$HOME/.oh-my-zsh"

# Set Zsh theme
ZSH_THEME="powerlevel10k/powerlevel10k"

# Plugins
plugins=(
  git 
  # You can add more plugins here, for example:
  zsh-autosuggestions
  zsh-syntax-highlighting
)

# Source Oh My Zsh
source "$ZSH/oh-my-zsh.sh"

# ============================================
# History and Terminal Settings (from .bashrc)
# ============================================

# Don't put duplicate lines or lines starting with a space in the history.
# For Zsh, this is controlled by HIST_IGNORE_DUPS and HIST_IGNORE_SPACE.
# HIST_STAMPS is a Zsh feature for history timestamps.
# The following settings are for cross-shell compatibility and are good practice.
HISTFILE=~/.zsh_history
HISTSIZE=1000
SAVEHIST=2000
setopt APPEND_HISTORY
setopt HIST_IGNORE_ALL_DUPS
setopt HIST_IGNORE_SPACE

# Auto-update the terminal window size.
# Zsh handles this automatically, but this is harmless.
#：setopt checkwinsize

# Make `less` more friendly for non-text input files.
[ -x /usr/bin/lesspipe ] && eval "$(SHELL=/bin/sh lesspipe)"

# ============================================
# Prompt and Colors (from .bashrc)
# ============================================

# Zsh handles the prompt via themes, but you can override it if you want.
# Oh My Zsh's themes are generally more powerful and feature-rich.
# I've commented out the original PS1 block to avoid conflicts.
# The `ls` and `grep` aliases below will still provide color.

# enable color support of ls and add handy aliases
if [ -x /usr/bin/dircolors ]; then
    test -r ~/.dircolors && eval "$(dircolors -b ~/.dircolors)" || eval "$(dircolors -b)"
    alias ls='ls --color=auto'
    alias grep='grep --color=auto'
    alias fgrep='fgrep --color=auto'
    alias egrep='egrep --color=auto'
fi

# ============================================
# Aliases and Functions (from .bashrc)
# ============================================

# some more ls aliases
alias ll='ls -alF'
alias la='ls -A'
alias l='ls -CF'

# Add an "alert" alias for long running commands.
alias alert='notify-send --urgency=low -i "$([ $? = 0 ] && echo terminal || echo error)" "$(history|tail -n1|sed -e '\''s/^\s*[0-9]\+\s*//;s/[;&|]\s*alert$//'\'')"'

# You can still source an external aliases file if you use one.
if [ -f ~/.zsh_aliases ]; then
    . ~/.zsh_aliases
fi

# ============================================
# Bash Compatibility
# ============================================

# Most of the Bash-specific features (like `shopt`)
# are not needed in Zsh as it has its own, often superior, ways of handling them.
# The Bash completion block is also replaced by Zsh's native completion.
# So we don't need to include those parts.

# To customize prompt, run `p10k configure` or edit ~/.p10k.zsh.
[[ ! -f ~/.p10k.zsh ]] || source ~/.p10k.zsh
