-- Plugins: few, well maintained, each with a clear job. Managed by vim.pack (built into Neovim 0.12).
-- Update: :PackUpdate (review the changes, :write to accept), then commit nvim-pack-lock.json.
local gh = function(repo) return 'https://github.com/' .. repo end
local v = vim.version.range

-- Re-run :TSUpdate after nvim-treesitter changes (must be defined before vim.pack.add)
vim.api.nvim_create_autocmd('PackChanged', {
  callback = function(ev)
    local d = ev.data
    if d.spec.name == 'nvim-treesitter' and d.kind ~= 'delete' then
      if not d.active then vim.cmd.packadd('nvim-treesitter') end
      pcall(vim.cmd, 'TSUpdate')
    end
  end,
})

vim.pack.add({
  { src = gh('folke/tokyonight.nvim'), version = v('4') },          -- color scheme
  { src = gh('nvim-treesitter/nvim-treesitter'), version = 'main' }, -- syntax parsers
  { src = gh('neovim/nvim-lspconfig'), version = v('2') },          -- language server definitions
  { src = gh('mason-org/mason.nvim'), version = v('2') },           -- installs servers and formatters
  { src = gh('mason-org/mason-lspconfig.nvim'), version = v('2') },
  gh('WhoIsSethDaniel/mason-tool-installer.nvim'),
  { src = gh('stevearc/conform.nvim'), version = v('9') },          -- format on save
  gh('ibhagwan/fzf-lua'),                                           -- find files, grep, buffers
  { src = gh('lewis6991/gitsigns.nvim'), version = v('2') },        -- git changes in the gutter
  { src = gh('folke/which-key.nvim'), version = v('3') },           -- shows available shortcuts
  { src = gh('nvim-mini/mini.nvim'), version = v('0') },            -- statusline, icons, pairs, surround
  { src = gh('stevearc/oil.nvim'), version = v('2') },              -- edit directories like a buffer
  gh('christoomey/vim-tmux-navigator'),                             -- Ctrl-h/j/k/l across vim and tmux
}, { confirm = vim.env.DOTFILES_BOOTSTRAP == nil })

vim.api.nvim_create_user_command('PackUpdate', function() vim.pack.update() end, { desc = 'Update plugins' })

-- Appearance -----------------------------------------------------------------
require('tokyonight').setup({ style = 'night' })
vim.cmd.colorscheme('tokyonight')

require('mini.icons').setup()
require('mini.statusline').setup()
require('mini.pairs').setup()
require('mini.surround').setup()
require('mini.ai').setup()

-- Treesitter -----------------------------------------------------------------
local parsers = {
  'python', 'sql', 'bash', 'yaml', 'json', 'toml', 'dockerfile', 'markdown', 'markdown_inline',
  'lua', 'vim', 'vimdoc', 'query', 'regex', 'gitcommit', 'diff', 'java', 'scala', 'hcl', 'terraform',
}
_G.TeamParsers = parsers
if vim.fn.executable('tree-sitter') == 1 and vim.env.DOTFILES_BOOTSTRAP == nil then
  require('nvim-treesitter').install(parsers) -- no-op when already installed
end
vim.api.nvim_create_autocmd('FileType', {
  callback = function(ev)
    if pcall(vim.treesitter.start, ev.buf) then
      vim.wo[0][0].foldexpr = 'v:lua.vim.treesitter.foldexpr()'
      vim.wo[0][0].foldmethod = 'expr'
      vim.wo[0][0].foldlevel = 99
    end
  end,
})

-- Finder ---------------------------------------------------------------------
local fzf = require('fzf-lua')
fzf.setup({ 'default-title', winopts = { preview = { layout = 'vertical' } } })
local map = vim.keymap.set
map('n', '<leader>ff', fzf.files, { desc = 'Find files' })
map('n', '<leader>fg', fzf.live_grep, { desc = 'Search text in project' })
map('n', '<leader>fw', fzf.grep_cword, { desc = 'Search word under cursor' })
map('n', '<leader>fb', fzf.buffers, { desc = 'Open buffers' })
map('n', '<leader>fr', fzf.oldfiles, { desc = 'Recent files' })
map('n', '<leader>fh', fzf.helptags, { desc = 'Help' })
map('n', '<leader>fk', fzf.keymaps, { desc = 'Keymaps' })
map('n', '<leader>fd', fzf.diagnostics_document, { desc = 'Diagnostics' })
map('n', '<leader>/', fzf.blines, { desc = 'Search in this file' })
map('n', '<leader><leader>', fzf.files, { desc = 'Find files' })

-- Files ----------------------------------------------------------------------
require('oil').setup({ view_options = { show_hidden = true } })
map('n', '-', '<cmd>Oil<cr>', { desc = 'Open parent directory' })

-- Git ------------------------------------------------------------------------
require('gitsigns').setup({
  on_attach = function(buf)
    local gs = require('gitsigns')
    local o = function(desc) return { buffer = buf, desc = desc } end
    map('n', ']h', function() gs.nav_hunk('next') end, o('Next change'))
    map('n', '[h', function() gs.nav_hunk('prev') end, o('Previous change'))
    map('n', '<leader>hs', gs.stage_hunk, o('Stage change'))
    map('n', '<leader>hr', gs.reset_hunk, o('Undo change'))
    map('n', '<leader>hp', gs.preview_hunk, o('Preview change'))
    map('n', '<leader>hb', gs.blame_line, o('Blame line'))
  end,
})
map('n', '<leader>gg', function()
  vim.cmd('tabnew | terminal lazygit')
  vim.cmd('startinsert')
  vim.api.nvim_create_autocmd('TermClose', { buffer = 0, once = true, command = 'bdelete!' })
end, { desc = 'Lazygit' })

-- Formatting -----------------------------------------------------------------
-- Uses the project's own tools first (activate env/ so its black/isort win), Mason's as fallback.
require('conform').setup({
  formatters_by_ft = {
    python = { 'isort', 'black' },
    sql = { 'sqlfluff' },
    sh = { 'shfmt' },
    bash = { 'shfmt' },
    lua = { 'stylua' },
  },
  format_on_save = function(buf)
    if vim.g.disable_autoformat or vim.b[buf].disable_autoformat then return end
    return { timeout_ms = 3000, lsp_format = 'fallback' }
  end,
})
vim.api.nvim_create_user_command('FormatToggle', function()
  vim.g.disable_autoformat = not vim.g.disable_autoformat
  vim.notify('Format on save: ' .. (vim.g.disable_autoformat and 'off' or 'on'))
end, { desc = 'Toggle format on save' })
map('n', '<leader>cf', function() require('conform').format({ lsp_format = 'fallback' }) end, { desc = 'Format file' })

-- Shortcut help --------------------------------------------------------------
local wk = require('which-key')
wk.setup({ preset = 'modern' })
wk.add({
  { '<leader>f', group = 'find' },
  { '<leader>h', group = 'git changes' },
  { '<leader>g', group = 'git' },
  { '<leader>c', group = 'code' },
  { '<leader>x', group = 'lists' },
})
