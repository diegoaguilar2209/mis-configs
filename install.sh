#!/usr/bin/env bash
# Terminal setup for WSL2 / Ubuntu / Debian: Neovim, tmux, modern CLI tools and my configs.
# Safe to re-run: it updates what changed and backs up any file it replaces.
#
# Usage: ./install.sh [--yes] [--no-node] [--no-apt] [--help]
#   --yes      do not ask before replacing existing config files (they are still backed up)
#   --no-node  skip Node.js (only needed for some language servers: bash, yaml, json)
#   --no-apt   skip apt packages (no sudo); install only user-level tools and configs
set -euo pipefail

DOTFILES="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
# shellcheck source=versions.env
source "$DOTFILES/versions.env"

ASSUME_YES=0 WITH_NODE=1 WITH_APT=1
for arg in "$@"; do
  case "$arg" in
    --yes) ASSUME_YES=1 ;;
    --no-node) WITH_NODE=0 ;;
    --no-apt) WITH_APT=0 ;;
    -h|--help) sed -n '2,9p' "$0" | sed 's/^# \{0,1\}//'; exit 0 ;;
    *) echo "Unknown option: $arg" >&2; exit 1 ;;
  esac
done

BIN="$HOME/.local/bin"
OPT="$HOME/.local/opt"
BACKUP="$HOME/.mis-configs-backup/$(date +%Y%m%d-%H%M%S)"
mkdir -p "$BIN" "$OPT" "$HOME/.config"
export PATH="$BIN:$PATH"

say()  { printf '\033[1;34m==>\033[0m %s\n' "$*"; }
warn() { printf '\033[1;33m!!\033[0m %s\n' "$*" >&2; }

case "$(uname -m)" in
  x86_64|amd64) ARCH=x86_64 ;;
  aarch64|arm64) ARCH=aarch64 ;;
  *) echo "Unsupported architecture: $(uname -m)" >&2; exit 1 ;;
esac
IS_WSL=0; grep -qi microsoft /proc/version 2>/dev/null && IS_WSL=1

if [[ $IS_WSL -eq 1 && "$DOTFILES" == /mnt/* ]]; then
  warn "This repo is on the Windows disk ($DOTFILES). Clone it inside WSL (e.g. ~/dev/mis-configs): it is much faster."
fi

download() { # url dest
  curl -fsSL --retry 3 -o "$2" "$1" || { warn "Download failed: $1"; return 1; }
}

installed_version() { # file holding the version we installed last time
  cat "$OPT/.versions/$1" 2>/dev/null || true
}
mark_installed() { mkdir -p "$OPT/.versions"; echo "$2" > "$OPT/.versions/$1"; }

# Install a single binary from a tar.gz release. Args: name version url
install_tar_bin() {
  local name=$1 version=$2 url=$3 tmp found
  if [[ "$(installed_version "$name")" == "$version" && -x "$BIN/$name" ]]; then return 0; fi
  tmp=$(mktemp -d)
  if download "$url" "$tmp/a.tgz"; then
    mkdir "$tmp/x" && tar -xzf "$tmp/a.tgz" -C "$tmp/x"
    found=$(find "$tmp/x" -type f -name "$name" | head -1)
    if [[ -n "$found" ]]; then
      install -m 0755 "$found" "$BIN/$name"
      mark_installed "$name" "$version"
      say "$name $version"
    else
      warn "$name not found inside $url"
    fi
  fi
  rm -rf "$tmp"
}

# ---------------------------------------------------------------------------
say "1/6 System packages"
if [[ $WITH_APT -eq 1 ]] && command -v apt-get >/dev/null; then
  SUDO=""; [[ $EUID -ne 0 ]] && SUDO="sudo"
  $SUDO apt-get update -qq
  $SUDO apt-get install -y -qq git curl unzip tar gzip xz-utils build-essential tmux \
    ripgrep fd-find bat jq shellcheck python3 python3-venv python3-pip wslu >/dev/null 2>&1 \
    || $SUDO apt-get install -y -qq git curl unzip tar gzip xz-utils build-essential tmux \
       ripgrep fd-find bat jq shellcheck python3 python3-venv python3-pip >/dev/null
  # Debian/Ubuntu ship fd and bat under other names
  command -v fdfind >/dev/null && ln -sf "$(command -v fdfind)" "$BIN/fd"
  command -v batcat >/dev/null && ln -sf "$(command -v batcat)" "$BIN/bat"
else
  warn "Skipping apt. Make sure git, curl, tar, a C compiler, tmux and ripgrep are installed."
fi

# ---------------------------------------------------------------------------
say "2/6 Neovim $NVIM_VERSION and tree-sitter $TREE_SITTER_VERSION"
nvim_arch=$([[ $ARCH == x86_64 ]] && echo x86_64 || echo arm64)
if [[ "$(installed_version nvim)" != "$NVIM_VERSION" || ! -x "$BIN/nvim" ]]; then
  tmp=$(mktemp -d)
  if download "https://github.com/neovim/neovim/releases/download/$NVIM_VERSION/nvim-linux-$nvim_arch.tar.gz" "$tmp/nvim.tgz"; then
    rm -rf "$OPT/nvim"
    mkdir -p "$OPT/nvim"
    tar -xzf "$tmp/nvim.tgz" -C "$OPT/nvim" --strip-components=1
    ln -sf "$OPT/nvim/bin/nvim" "$BIN/nvim"
    mark_installed nvim "$NVIM_VERSION"
    say "nvim $NVIM_VERSION"
  fi
  rm -rf "$tmp"
fi
ts_arch=$([[ $ARCH == x86_64 ]] && echo x64 || echo arm64)
if [[ "$(installed_version tree-sitter)" != "$TREE_SITTER_VERSION" || ! -x "$BIN/tree-sitter" ]]; then
  tmp=$(mktemp -d)
  if download "https://github.com/tree-sitter/tree-sitter/releases/download/$TREE_SITTER_VERSION/tree-sitter-linux-$ts_arch.gz" "$tmp/ts.gz"; then
    gunzip -c "$tmp/ts.gz" > "$BIN/tree-sitter" && chmod 0755 "$BIN/tree-sitter"
    mark_installed tree-sitter "$TREE_SITTER_VERSION"
    say "tree-sitter $TREE_SITTER_VERSION"
  fi
  rm -rf "$tmp"
fi

# ---------------------------------------------------------------------------
say "3/6 CLI tools"
go_arch=$([[ $ARCH == x86_64 ]] && echo amd64 || echo arm64)
install_tar_bin fzf "$FZF_VERSION" \
  "https://github.com/junegunn/fzf/releases/download/v$FZF_VERSION/fzf-$FZF_VERSION-linux_$go_arch.tar.gz"
install_tar_bin zoxide "$ZOXIDE_VERSION" \
  "https://github.com/ajeetdsouza/zoxide/releases/download/v$ZOXIDE_VERSION/zoxide-$ZOXIDE_VERSION-$ARCH-unknown-linux-musl.tar.gz"
eza_target=$([[ $ARCH == x86_64 ]] && echo x86_64-unknown-linux-musl || echo aarch64-unknown-linux-gnu)
install_tar_bin eza "$EZA_VERSION" \
  "https://github.com/eza-community/eza/releases/download/$EZA_VERSION/eza_$eza_target.tar.gz"
install_tar_bin starship "$STARSHIP_VERSION" \
  "https://github.com/starship/starship/releases/download/$STARSHIP_VERSION/starship-$ARCH-unknown-linux-musl.tar.gz"
lg_arch=$([[ $ARCH == x86_64 ]] && echo x86_64 || echo arm64)
install_tar_bin lazygit "$LAZYGIT_VERSION" \
  "https://github.com/jesseduffield/lazygit/releases/download/v$LAZYGIT_VERSION/lazygit_${LAZYGIT_VERSION}_linux_$lg_arch.tar.gz"
delta_target=$([[ $ARCH == x86_64 ]] && echo x86_64-unknown-linux-musl || echo aarch64-unknown-linux-gnu)
install_tar_bin delta "$DELTA_VERSION" \
  "https://github.com/dandavison/delta/releases/download/$DELTA_VERSION/delta-$DELTA_VERSION-$delta_target.tar.gz"

if [[ $WITH_NODE -eq 1 ]]; then
  node_arch=$([[ $ARCH == x86_64 ]] && echo x64 || echo arm64)
  base="https://nodejs.org/dist/latest-v$NODE_MAJOR.x"
  if file=$(curl -fsSL "$base/SHASUMS256.txt" | awk -v a="linux-$node_arch.tar.xz" '$2 ~ a"$" {print $2; exit}') && [[ -n "$file" ]]; then
    ver=${file#node-}; ver=${ver%%-linux*}
    if [[ "$(installed_version node)" != "$ver" ]]; then
      tmp=$(mktemp -d)
      if download "$base/$file" "$tmp/node.txz"; then
        rm -rf "$OPT/node" && mkdir -p "$OPT/node"
        tar -xJf "$tmp/node.txz" -C "$OPT/node" --strip-components=1
        for b in node npm npx; do ln -sf "$OPT/node/bin/$b" "$BIN/$b"; done
        mark_installed node "$ver"
        say "node $ver"
      fi
      rm -rf "$tmp"
    fi
  else
    warn "Could not resolve Node.js $NODE_MAJOR; language servers that need it will be skipped."
  fi
fi

# ---------------------------------------------------------------------------
say "4/6 Config files"
link() { # source target
  local src=$1 dst=$2
  if [[ -L "$dst" && "$(readlink "$dst")" == "$src" ]]; then return 0; fi
  if [[ -e "$dst" || -L "$dst" ]]; then
    if [[ $ASSUME_YES -eq 0 ]]; then
      read -r -p "Replace $dst (a backup will be kept)? [y/N] " ans
      [[ "$ans" =~ ^[yYsS]$ ]] || { warn "Kept $dst"; return 0; }
    fi
    mkdir -p "$BACKUP"
    mv "$dst" "$BACKUP/"
    say "Backed up $dst to $BACKUP/"
  fi
  mkdir -p "$(dirname "$dst")"
  ln -s "$src" "$dst"
  say "Linked $dst"
}
link "$DOTFILES/nvim" "$HOME/.config/nvim"
link "$DOTFILES/tmux/tmux.conf" "$HOME/.config/tmux/tmux.conf"
# tmux reads ~/.tmux.conf before ~/.config/tmux/tmux.conf: move an old one out of the way
if [[ -f "$HOME/.tmux.conf" && ! -L "$HOME/.tmux.conf" ]]; then
  mkdir -p "$BACKUP" && mv "$HOME/.tmux.conf" "$BACKUP/" && say "Backed up old ~/.tmux.conf to $BACKUP/"
fi
link "$DOTFILES/starship/starship.toml" "$HOME/.config/starship.toml"
link "$DOTFILES/vim/vimrc" "$HOME/.vimrc"
link "$DOTFILES/bin/mis-configs" "$BIN/mis-configs"
link "$DOTFILES/bin/tmux-sessionizer" "$BIN/tmux-sessionizer"

# Shell: one line in ~/.bashrc, everything else lives in this repo
marker="# mis-configs"
if ! grep -q "$marker" "$HOME/.bashrc" 2>/dev/null; then
  printf '\n%s\n[ -f "%s/shell/init.bash" ] && source "%s/shell/init.bash"\n' "$marker" "$DOTFILES" "$DOTFILES" >> "$HOME/.bashrc"
  say "Added shell init to ~/.bashrc"
fi

# Git: shared settings are included; name and email stay personal
if ! git config --global --get-all include.path 2>/dev/null | grep -qx "$DOTFILES/git/gitconfig"; then
  git config --global --add include.path "$DOTFILES/git/gitconfig"
  say "Included shared git settings"
fi
if [[ -z "$(git config --global user.name || true)" && $ASSUME_YES -eq 0 ]]; then
  read -r -p "Your name for git commits: " gname && [[ -n "$gname" ]] && git config --global user.name "$gname"
  read -r -p "Your email for git commits: " gmail && [[ -n "$gmail" ]] && git config --global user.email "$gmail"
fi

# ---------------------------------------------------------------------------
say "5/6 tmux plugins"
TPM="$HOME/.config/tmux/plugins/tpm"
if [[ ! -d "$TPM" ]]; then
  git -c advice.detachedHead=false clone -q --depth 1 --branch "$TPM_VERSION" https://github.com/tmux-plugins/tpm "$TPM" || warn "Could not clone tpm"
fi
if [[ -x "$TPM/bin/install_plugins" ]]; then
  tmux start-server \; source-file "$HOME/.config/tmux/tmux.conf" 2>/dev/null || true
  "$TPM/bin/install_plugins" >/dev/null 2>&1 || warn "tmux plugins: run prefix + I inside tmux"
  tmux kill-server 2>/dev/null || true
fi

# ---------------------------------------------------------------------------
say "6/6 Neovim plugins, parsers and language servers"
if command -v nvim >/dev/null; then
  # First run installs plugins (pinned in nvim-pack-lock.json), parsers and language servers.
  # Capped at 15 minutes so a network problem never hangs the installer.
  if ! DOTFILES_BOOTSTRAP=1 timeout "${DOTFILES_NVIM_TIMEOUT:-900}" nvim --headless "+lua require('team.bootstrap').run()" +qa 2>&1 | grep -v '^$' | tail -25; then
    warn "Neovim setup did not finish; open nvim once and run :MasonToolsInstall"
  fi
fi

echo
say "Done. Open a new terminal (or run: source ~/.bashrc), then: tmux, and inside it: nvim"
[[ $IS_WSL -eq 1 ]] && say "Windows side (font and terminal): see windows/README.md"
