#!/usr/bin/env bash
# Look up the latest release of each tool in versions.env and update the file.
# Keeps each value's style (with or without a leading "v"). Prints what changed.
# Needs gh (authenticated). Used monthly by .github/workflows/versions.yml; can also run by hand.
set -euo pipefail
cd "$(dirname "$0")/.."

declare -A REPOS=(
  [NVIM_VERSION]=neovim/neovim
  [TREE_SITTER_VERSION]=tree-sitter/tree-sitter
  [FZF_VERSION]=junegunn/fzf
  [ZOXIDE_VERSION]=ajeetdsouza/zoxide
  [EZA_VERSION]=eza-community/eza
  [STARSHIP_VERSION]=starship/starship
  [LAZYGIT_VERSION]=jesseduffield/lazygit
  [DELTA_VERSION]=dandavison/delta
  [UV_VERSION]=astral-sh/uv
  [GITLEAKS_VERSION]=gitleaks/gitleaks
)

changed=0
for key in "${!REPOS[@]}"; do
  current=$(sed -n "s/^${key}=//p" versions.env)
  [[ -n "$current" ]] || continue
  latest=$(gh api "repos/${REPOS[$key]}/releases/latest" --jq .tag_name 2>/dev/null) || {
    echo "skip $key: could not read ${REPOS[$key]}" >&2; continue; }
  latest=${latest#v}
  [[ "$current" == v* ]] && latest="v$latest"
  if [[ "$latest" != "$current" ]]; then
    sed -i "s/^${key}=.*/${key}=${latest}/" versions.env
    echo "- $key: $current → $latest"
    changed=1
  fi
done
[[ $changed -eq 1 ]] || echo "Everything is up to date." >&2
