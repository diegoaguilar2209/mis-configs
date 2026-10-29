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
  { src = gh('nvim-tree/nvim-tree.lua'), version = v('1') },        -- F3: folder tree (like NERDTree)
  { src = gh('stevearc/aerial.nvim'), version = v('4') },           -- F4: classes and functions (like Tagbar)
  gh('christoomey/vim-tmux-navigator'),                             -- Ctrl-h/j/k/l across vim and tmux
  gh('tpope/vim-fugitive'),                                         -- :Git, same as in my vim
  gh('rafamadriz/friendly-snippets'),                               -- snippet collection (like vim-snippets)
  { src = gh('vim-test/vim-test'), version = v('3') },              -- \tt \tf \ts: run pytest from the editor
  gh('mfussenegger/nvim-dap'),                                      -- debugger (master: nvim-dap-view needs it)
  gh('mfussenegger/nvim-dap-python'),                               -- debugpy for Python
  { src = gh('igorlfs/nvim-dap-view'), version = v('1') },          -- debugger panels
  { src = gh('coder/claudecode.nvim'), version = v('0') },          -- Claude Code sees my file, selection and diffs
}, { confirm = vim.env.DOTFILES_BOOTSTRAP == nil })

vim.api.nvim_create_user_command('PackUpdate', function() vim.pack.update() end, { desc = 'Update plugins' })

-- Appearance -----------------------------------------------------------------
require('team.colors') -- torte + airline colors, like my vim

require('mini.icons').setup()
require('mini.statusline').setup()
require('mini.tabline').setup() -- buffers as tabs, like airline's tabline
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
-- Colors come from Vim's classic syntax files, exactly like my vim (tree-sitter highlighting
-- paints every variable and call, which looks nothing like torte in vim). Tree-sitter is still
-- used for F4 (aerial) and folds. To try tree-sitter colors: vim.g.treesitter_colors = true in lua/user.
vim.api.nvim_create_autocmd('FileType', {
  callback = function(ev)
    local lang = vim.treesitter.language.get_lang(vim.bo[ev.buf].filetype)
    if not (lang and pcall(vim.treesitter.get_parser, ev.buf, lang)) then return end
    if vim.g.treesitter_colors then
      vim.treesitter.start(ev.buf, lang)
    elseif vim.treesitter.highlighter.active[ev.buf] then
      vim.treesitter.stop(ev.buf) -- Neovim turns it on by default for some filetypes (markdown, lua)
    end
    vim.wo[0][0].foldexpr = 'v:lua.vim.treesitter.foldexpr()'
    vim.wo[0][0].foldmethod = 'expr'
    vim.wo[0][0].foldlevel = 99
  end,
})

-- Finder: same keys I used with CtrlP (local leader is ,) -----------------------
local fzf = require('fzf-lua')
fzf.setup({ 'default-title', winopts = { preview = { layout = 'vertical' } } })
local map = vim.keymap.set
local word = function(picker) return function() picker({ query = vim.fn.expand('<cword>') }) end end
map('n', ',e', fzf.files, { desc = 'Find files (CtrlP)' })
map('n', ',g', fzf.lsp_document_symbols, { desc = 'Symbols in this file' })
map('n', ',G', fzf.lsp_live_workspace_symbols, { desc = 'Symbols in project' })
map('n', ',f', fzf.lines, { desc = 'Lines in open buffers' })
map('n', ',m', fzf.oldfiles, { desc = 'Recent files' })
map('n', ',c', fzf.commands, { desc = 'Commands' })
map('n', ',we', word(fzf.files), { desc = 'Files matching word' })
map('n', ',wg', word(fzf.lsp_document_symbols), { desc = 'Symbols matching word' })
map('n', ',wG', word(fzf.lsp_live_workspace_symbols), { desc = 'Project symbols matching word' })
map('n', ',wf', word(fzf.lines), { desc = 'Lines matching word' })
map('n', ',wm', word(fzf.oldfiles), { desc = 'Recent files matching word' })
map('n', ',wc', word(fzf.commands), { desc = 'Commands matching word' })
map('n', ',pe', function() fzf.files({ query = vim.fn.expand('<cfile>') }) end, { desc = 'Files matching path under cursor' })
map('n', ',r', fzf.live_grep, { desc = 'Search text in project (new)' })

-- F3: folder tree like NERDTree (,t reveals the current file) ------------------
require('mini.icons').mock_nvim_web_devicons() -- file icons for the tree
require('nvim-tree').setup({
  view = { width = 32 },
  renderer = { group_empty = true },
  filters = { dotfiles = false, custom = { '^\\.git$', '__pycache__', '\\.pyc$', '\\.pyo$', '\\.sw[a-z]$', '\\.DS_Store' } },
  on_attach = function(buf)
    local api = require('nvim-tree.api')
    api.config.mappings.default_on_attach(buf)
    local o = function(desc) return { buffer = buf, desc = desc, nowait = true } end
    -- NERDTree keys: o open, s vertical split, i horizontal split, t new tab
    map('n', 'o', api.node.open.edit, o('Open'))
    map('n', 's', api.node.open.vertical, o('Open in vertical split'))
    map('n', 'i', api.node.open.horizontal, o('Open in horizontal split'))
    map('n', 't', api.node.open.tab, o('Open in new tab'))
  end,
})
map('n', '<F3>', '<cmd>NvimTreeToggle<cr>', { desc = 'Folder tree (NERDTree)' })
map('n', ',t', '<cmd>NvimTreeFindFile<cr>', { desc = 'Show current file in the tree' })

-- F4: classes, methods and functions of the file, like Tagbar (focus moves to it) --
require('aerial').setup({
  -- Python uses the Tagbar-like outline in queries/python/aerial.scm (imports, constants,
  -- variables, classes, methods, attributes); other languages ask the language server first.
  backends = { ['_'] = { 'lsp', 'treesitter', 'markdown' }, python = { 'treesitter', 'lsp' } },
  filter_kind = {
    ['_'] = { 'Class', 'Constructor', 'Enum', 'Function', 'Interface', 'Module', 'Method', 'Struct' },
    python = false, -- show every kind the query returns
  },
  layout = { default_direction = 'right', min_width = 30 },
  show_guides = true,
})
map('n', '<F4>', '<cmd>AerialToggle<cr>', { desc = 'Functions and classes (Tagbar)' })

-- Git ------------------------------------------------------------------------
require('gitsigns').setup({
  on_attach = function(buf)
    local gs = require('gitsigns')
    local o = function(desc) return { buffer = buf, desc = desc } end
    map('n', ']c', function() if vim.wo.diff then vim.cmd('normal! ]c') else gs.nav_hunk('next') end end, o('Next git change'))
    map('n', '[c', function() if vim.wo.diff then vim.cmd('normal! [c') else gs.nav_hunk('prev') end end, o('Previous git change'))
    map('n', '<leader>gs', gs.stage_hunk, o('Stage change'))
    map('n', '<leader>gr', gs.reset_hunk, o('Undo change'))
    map('n', '<leader>gp', gs.preview_hunk, o('Preview change'))
    map('n', '<leader>gb', gs.blame_line, o('Blame line'))
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

-- Snippets: Tab expands like UltiSnips (def<Tab>), Ctrl-j / Ctrl-k jump between fields ------
local snippets = require('mini.snippets')
snippets.setup({
  snippets = { snippets.gen_loader.from_lang() }, -- friendly-snippets + nvim/snippets/<lang>.json
  mappings = { expand = '', jump_next = '<C-j>', jump_prev = '<C-k>' },
  expand = {
    match = function(snips) return snippets.default_match(snips, { pattern_fuzzy = '%S+' }) end,
  },
})
map('i', '<Tab>', function()
  if #MiniSnippets.expand({ insert = false }) > 0 then
    vim.schedule(MiniSnippets.expand)
    return ''
  end
  return '\t'
end, { expr = true, desc = 'Expand snippet or insert tab' })

-- Tests (vim-test): runs in a terminal split, with the project's env/ ----------
vim.g['test#strategy'] = 'neovim_sticky'
vim.g['test#neovim#term_position'] = 'botright 15'
vim.g['test#python#runner'] = 'pytest'
map('n', '<leader>tt', '<cmd>TestNearest<cr>', { desc = 'Test under cursor' })
map('n', '<leader>tf', '<cmd>TestFile<cr>', { desc = 'Tests of this file' })
map('n', '<leader>ts', '<cmd>TestSuite<cr>', { desc = 'All tests' })
map('n', '<leader>tl', '<cmd>TestLast<cr>', { desc = 'Repeat last test' })
map('n', '<leader>tv', '<cmd>TestVisit<cr>', { desc = 'Go to last test file' })

-- Debugger: F5 start/continue, F9 breakpoint, F10 over, F6 into, F7 out, F8 panels --
local dap = require('dap')
local debugpy = vim.fn.stdpath('data') .. '/mason/packages/debugpy/venv/bin/python'
require('dap-python').setup(vim.fn.executable(debugpy) == 1 and debugpy or 'python3')
require('dap-python').test_runner = 'pytest'
-- Debug the program with the project's env/ (my convention), else the active virtualenv
require('dap-python').resolve_python = function()
  local env = vim.fn.getcwd() .. '/env/bin/python'
  if vim.fn.executable(env) == 1 then return env end
  if vim.env.VIRTUAL_ENV then return vim.env.VIRTUAL_ENV .. '/bin/python' end
  return 'python3'
end
require('dap-view').setup({ auto_toggle = true })
map('n', '<F5>', dap.continue, { desc = 'Debug: start / continue' })
map('n', '<F9>', dap.toggle_breakpoint, { desc = 'Debug: breakpoint' })
map('n', '<leader>B', function() dap.set_breakpoint(vim.fn.input('Condition: ')) end, { desc = 'Debug: conditional breakpoint' })
map('n', '<F10>', dap.step_over, { desc = 'Debug: step over' })
map('n', '<F6>', dap.step_into, { desc = 'Debug: step into' })
map('n', '<F7>', dap.step_out, { desc = 'Debug: step out' })
map('n', '<F8>', '<cmd>DapViewToggle<cr>', { desc = 'Debug: panels' })
map('n', '<leader>td', function() require('dap-python').test_method() end, { desc = 'Debug test under cursor' })

-- Claude Code: in Claude, /ide connects to this Neovim (also from another tmux pane) --
require('claudecode').setup({ terminal = { provider = 'native', split_side = 'right', split_width_percentage = 0.4 } })
map('n', '<leader>ac', '<cmd>ClaudeCode<cr>', { desc = 'Claude: open / close' })
map('n', '<leader>af', '<cmd>ClaudeCodeFocus<cr>', { desc = 'Claude: focus' })
map('n', '<leader>ab', '<cmd>ClaudeCodeAdd %<cr>', { desc = 'Claude: add this file' })
map('v', '<leader>as', '<cmd>ClaudeCodeSend<cr>', { desc = 'Claude: send selection' })
map('n', '<leader>aa', '<cmd>ClaudeCodeDiffAccept<cr>', { desc = 'Claude: accept change' })
map('n', '<leader>ad', '<cmd>ClaudeCodeDiffDeny<cr>', { desc = 'Claude: reject change' })

-- Git (fugitive, like in my vim): :Git, :Git blame, :Gdiffsplit -----------------
map('n', '<leader>gB', '<cmd>Git blame<cr>', { desc = 'Blame whole file' })
map('n', '<leader>gd', '<cmd>Gdiffsplit<cr>', { desc = 'Diff against index' })

-- Shortcut help --------------------------------------------------------------
local wk = require('which-key')
wk.setup({ preset = 'modern' })
wk.add({
  { '<leader>g', group = 'git' },
  { '<leader>s', group = 'location list' },
  { '<leader>b', group = 'buffers' },
  { '<leader>c', group = 'code' },
  { '<leader>t', group = 'tests' },
  { '<leader>a', group = 'Claude Code' },
  { ',w', group = 'with word under cursor' },
})
