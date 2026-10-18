-- Team Neovim config (Neovim 0.12+). Plugins are managed by the built-in vim.pack;
-- versions are pinned in nvim-pack-lock.json, which is committed so everyone gets the same ones.
-- Personal tweaks go in lua/user/init.lua (git-ignored), never in these files.

if vim.fn.has('nvim-0.12') == 0 then
  vim.notify('This config needs Neovim 0.12 or later. Run ~/dotfiles/install.sh', vim.log.levels.ERROR)
  return
end

vim.g.mapleader = ' '
vim.g.maplocalleader = ' '

require('team.options')
require('team.keymaps')
require('team.autocmds')
require('team.plugins')
require('team.lsp')

pcall(require, 'user') -- optional personal overrides
