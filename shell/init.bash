# Shell setup. Sourced from ~/.bashrc by install.sh. Machine-specific additions: ~/.bashrc.local
# shellcheck shell=bash

export DOTFILES="${DOTFILES:-$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)}"
case ":$PATH:" in *":$HOME/.local/bin:"*) ;; *) export PATH="$HOME/.local/bin:$PATH" ;; esac

# vim stays the default editor; switch to nvim in ~/.bashrc.local when ready
export EDITOR="${EDITOR:-vim}"
export VISUAL="${VISUAL:-$EDITOR}"
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
alias v='nvim'   # vim is still vim
alias lg='lazygit'
alias t='tmux-sessionizer'
alias ta='tmux attach || tmux new -s main'
# ls is untouched; ll and lt use eza when available
if command -v eza >/dev/null; then
  alias ll='eza -lah --group-directories-first --git'
  alias lt='eza --tree --level=2 --git-ignore'
else
  alias ll='ls -lah'
fi
alias gs='git status -sb'
alias gl='git log --oneline --graph --decorate -20'

# --- Python: env/ + pip-tools (my convention) - ------------------------------
# mkenv: create env/ (Python 3.12) and install requirements*.txt. Uses uv (much faster) when available, else pip-tools.
# The files stay pip-tools compatible: requirements.in -> requirements.txt, same as always.
mkenv() {
  local reqs=(requirements*.txt)
  if command -v uv >/dev/null; then
    uv venv --python 3.12 --seed --quiet env && source env/bin/activate || return 1
    [[ -e "${reqs[0]}" ]] && uv pip sync --quiet "${reqs[@]}"
  else
    if ! command -v python3.12 >/dev/null; then
      echo "Python 3.12 not found: install python3.12 or run ./install.sh to get uv" >&2
      return 1
    fi
    python3.12 -m venv env && source env/bin/activate && pip install -q --upgrade pip pip-tools || return 1
    [[ -e "${reqs[0]}" ]] && pip-sync "${reqs[@]}"
  fi
  echo "env/ ready ($(python --version))"
}
# lock: compile each requirements*.in into its .txt and sync env/ to exactly those versions
lock() {
  local f
  for f in requirements*.in; do
    [[ -e "$f" ]] || continue
    if command -v uv >/dev/null; then
      uv pip compile --quiet "$f" -o "${f%.in}.txt"
    else
      pip-compile -q "$f"
    fi
  done
  # No env/ yet: create it (mkenv also syncs). Otherwise sync the existing one.
  if [[ ! -d env ]]; then mkenv; return; fi
  if command -v uv >/dev/null; then
    uv pip sync --quiet --python env/bin/python requirements*.txt
  else
    env/bin/pip-sync requirements*.txt
  fi
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
