#!/usr/bin/env bash
# Copy this machine's current tmux and vim configs INTO the repo, exactly as they are:
#   ~/.tmux.conf, every file at the top of ~/.tmux/ (yank.sh, *.conf...), ~/.vimrc, ~/.vim/ (except plugins)
# If a file in $HOME is already a link to the repo, the original is taken from ~/mis-configs-old
# or the newest ~/.mis-configs-backup/<date>/. Review with `git diff` and commit.
set -euo pipefail
REPO="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"

# Where to find the original of $1 (path relative to $HOME)
original() {
  local rel=$1 cand
  if [[ -e "$HOME/$rel" && "$(readlink -f "$HOME/$rel")" != "$REPO"* ]]; then echo "$HOME/$rel"; return; fi
  [[ -e "$HOME/mis-configs-old/$rel" ]] && { echo "$HOME/mis-configs-old/$rel"; return; }
  # backups are named by date, so reverse glob order = newest first
  local backups=("$HOME"/.mis-configs-backup/*/) i
  for (( i=${#backups[@]}-1; i>=0; i-- )); do
    cand=${backups[i]}
    [[ -e "$cand$(basename "$rel")" ]] && { echo "$cand$(basename "$rel")"; return; }
  done
}

copy() { # source dest
  [[ -z "$1" ]] && return 0
  mkdir -p "$(dirname "$2")"
  cp -a "$1" "$2"
  echo "  imported ${1/#$HOME/~} -> ${2#"$REPO"/}"
}

echo "tmux"
copy "$(original .tmux.conf)" "$REPO/tmux/tmux.conf"
if [[ -d "$HOME/.tmux" ]]; then
  for f in "$HOME"/.tmux/*; do
    [[ -f "$f" && ! -L "$f" ]] && copy "$f" "$REPO/tmux/$(basename "$f")"
  done
fi

echo "vim"
copy "$(original .vimrc)" "$REPO/vim/vimrc"
if [[ -d "$HOME/.vim" ]]; then
  for d in "$HOME"/.vim/*; do
    name=$(basename "$d")
    case "$name" in plugged|autoload|undo|swap|backup|view|bundle) continue ;; esac
    [[ -L "$d" ]] && continue
    rm -rf "${REPO:?}/vim/$name"
    copy "$d" "$REPO/vim/$name"
  done
fi

echo
echo "Done. Review with: git -C $REPO status && git -C $REPO diff"
echo "No secrets are touched (.ssh, .aws, .azure, .claude are never read)."
