# Team shell setup. Sourced from ~/.bashrc by install.sh. Personal additions: ~/.bashrc.local
# shellcheck shell=bash

export DOTFILES="${DOTFILES:-$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)}"
case ":$PATH:" in *":$HOME/.local/bin:"*) ;; *) export PATH="$HOME/.local/bin:$PATH" ;; esac

export EDITOR=nvim
export VISUAL=nvim
export MANPAGER='nvim +Man!'
export BAT_THEME=ansi

# History: big, shared between tmux panes, no duplicates
export HISTSIZE=100000
export HISTFILESIZE=200000
export HISTCONTROL=ignoreboth:erasedups
shopt -s histappend
PROMPT_COMMAND="history -a${PROMPT_COMMAND:+; $PROMPT_COMMAND}"

# --- Tools ------------------------------------------------------------------
if command -v fzf >/dev/null; then
  eval "$(fzf --bash)"  # Ctrl-r history, Ctrl-t files, Alt-c directories
  export FZF_DEFAULT_COMMAND='fd --type f --hidden --exclude .git'
  export FZF_CTRL_T_COMMAND="$FZF_DEFAULT_COMMAND"
  export FZF_DEFAULT_OPTS='--height 40% --layout reverse --border'
fi
command -v zoxide >/dev/null && eval "$(zoxide init bash)"       # z <part of dir name>
command -v starship >/dev/null && eval "$(starship init bash)"   # prompt

# --- Aliases ----------------------------------------------------------------
alias v='nvim'
alias vim='nvim'
alias lg='lazygit'
alias t='tmux-sessionizer'
alias ta='tmux attach || tmux new -s main'
if command -v eza >/dev/null; then
  alias ls='eza --group-directories-first'
  alias ll='eza -lah --group-directories-first --git'
  alias tree='eza --tree --level=2 --git-ignore'
else
  alias ll='ls -lah'
fi
alias gs='git status -sb'
alias gl='git log --oneline --graph --decorate -20'

# --- Python: env/ + pip-tools (team convention) ------------------------------
# mkenv: create env/ with pip-tools and install from requirements*.txt if present
mkenv() {
  python3 -m venv env && source env/bin/activate && pip install -q --upgrade pip pip-tools
  local reqs=(requirements*.txt)
  [[ -e "${reqs[0]}" ]] && pip-sync "${reqs[@]}"
  echo "env/ ready ($(python --version))"
}
# lock: compile requirements*.in into .txt and sync the environment
lock() {
  local f
  for f in requirements*.in; do [[ -e "$f" ]] && pip-compile -q "$f"; done
  pip-sync requirements*.txt
}
# Activate env/ automatically when entering a project that has one
_auto_env() {
  if [[ -z "${VIRTUAL_ENV:-}" && -f env/bin/activate ]]; then
    source env/bin/activate
  elif [[ -n "${VIRTUAL_ENV:-}" && "$PWD" != "$(dirname "$VIRTUAL_ENV")"* ]]; then
    deactivate 2>/dev/null || true
  fi
}
PROMPT_COMMAND="_auto_env; $PROMPT_COMMAND"

# --- WSL ----------------------------------------------------------------------
if grep -qi microsoft /proc/version 2>/dev/null; then
  alias open='wslview 2>/dev/null || explorer.exe'
  alias clip='clip.exe'
fi

[ -f "$HOME/.bashrc.local" ] && source "$HOME/.bashrc.local"
