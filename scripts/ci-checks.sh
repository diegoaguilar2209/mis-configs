#!/usr/bin/env bash
# Checks run after ./install.sh on a clean machine (CI and the monthly version update).
set -euo pipefail
export PATH="$HOME/.local/bin:$PATH"

echo "== Neovim starts without errors"
nvim --headless +'lua vim.defer_fn(function()
  local m = vim.api.nvim_exec2("messages", { output = true }).output
  if m:match("E%d+:") or m:match("Error") then print(m); vim.cmd("cquit 1") end
  vim.cmd("qa!")
end, 3000)'

echo "== tmux loads my config (prefix Ctrl-a)"
# Own socket (-L ci): kill-server only stops this test server, never the user's tmux sessions
tmux -L ci new-session -d -s ci
test "$(tmux -L ci show-options -gv prefix)" = "C-a"
tmux -L ci kill-server

echo "== vim loads my vimrc without errors"
vim -N -E -s -u "$HOME/.vimrc" -c 'qa!' </dev/null

echo "== doctor"
mis-configs doctor
