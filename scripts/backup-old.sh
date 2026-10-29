#!/usr/bin/env bash
# Copy the current terminal configs of this machine to ~/mis-configs-old (or a dated folder if it exists).
# Run it once before ./install.sh. Never copies secrets (.ssh, .aws, .azure, .claude, tokens).
set -euo pipefail

dest="$HOME/mis-configs-old"
[[ -e "$dest" ]] && dest="$HOME/mis-configs-old-$(date +%Y%m%d-%H%M%S)"
mkdir -p "$dest"

items=(.vimrc .vim .tmux.conf .tmux .bashrc .profile .bash_aliases .gitconfig .inputrc
       .config/nvim .config/tmux .config/starship.toml)
for item in "${items[@]}"; do
  if [[ -e "$HOME/$item" ]]; then
    mkdir -p "$dest/$(dirname "$item")"
    cp -a "$HOME/$item" "$dest/$item"
    echo "  saved $item"
  fi
done
echo "Backup in $dest"
