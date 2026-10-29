-- Neovim config (0.12+) that keeps the same keys as my vimrc (vim/vimrc), with modern tools underneath:
-- LSP instead of YouCompleteMe/Jedi/Syntastic, fzf-lua instead of CtrlP, nvim-tree instead of NERDTree, aerial instead of Tagbar.
-- Plugins are managed by the built-in vim.pack and pinned in nvim-pack-lock.json.
-- Machine-only tweaks: lua/user/init.lua (git-ignored).

if vim.fn.has('nvim-0.12') == 0 then
  vim.notify('This config needs Neovim 0.12 or later. Run ~/dev/mis-configs/install.sh', vim.log.levels.ERROR)
  return
end

-- nvim-tree replaces netrw as the file explorer
vim.g.loaded_netrw = 1
vim.g.loaded_netrwPlugin = 1

vim.g.mapleader = '\\'      -- same as Vim's default, like in my vimrc
vim.g.maplocalleader = ','

require('team.options')
require('team.keymaps')
require('team.autocmds')
require('team.plugins')
require('team.lsp')

pcall(require, 'user')
