-- Language servers: Mason installs them, nvim-lspconfig defines them, Neovim's built-in client runs them.
-- Neovim 0.12 default keys when a server is attached:
--   K hover · grn rename · gra code action · grr references · gri implementation
--   grt type definition · gO symbols · Ctrl-s signature (insert)
-- Plus the keys from my vimrc (YouCompleteMe / Jedi): gd gD gt gi ,d ,o ,a ,D

local has_node = vim.fn.executable('npm') == 1

local servers = { 'basedpyright', 'lua_ls' }
if has_node then vim.list_extend(servers, { 'bashls', 'yamlls', 'jsonls', 'dockerls' }) end

local tools = { 'black', 'isort', 'sqlfluff', 'shfmt', 'stylua', 'debugpy' }

-- PATH = append: a project's env/ (black, isort...) wins over Mason's copies
require('mason').setup({ PATH = 'append' })
require('mason-lspconfig').setup({ automatic_enable = false })
-- Enable only servers whose binary exists (Mason's or the project's env/), so nothing errors when one is missing
local function enable_available()
  for _, name in ipairs(servers) do
    local cmd = (vim.lsp.config[name] or {}).cmd
    local exe = type(cmd) == 'table' and cmd[1] or nil
    if exe and vim.fn.executable(exe) == 1 and not vim.lsp.is_enabled(name) then vim.lsp.enable(name) end
  end
end
enable_available()
vim.api.nvim_create_autocmd('User', { pattern = 'MasonToolsUpdateCompleted', callback = enable_available })
require('mason-tool-installer').setup({
  ensure_installed = vim.list_extend(vim.deepcopy(servers), tools),
  run_on_start = vim.env.DOTFILES_BOOTSTRAP == nil,
})
_G.TeamMasonTools = true

vim.lsp.config('basedpyright', {
  settings = { basedpyright = { analysis = { typeCheckingMode = 'standard' } } },
})
vim.lsp.config('lua_ls', {
  settings = { Lua = { diagnostics = { globals = { 'vim' } }, workspace = { checkThirdParty = false } } },
})

vim.diagnostic.config({
  severity_sort = true,
  virtual_text = { current_line = true },
  float = { border = 'rounded', source = true },
})

vim.api.nvim_create_autocmd('LspAttach', {
  callback = function(ev)
    local client = vim.lsp.get_client_by_id(ev.data.client_id)
    -- No extra colors from the language server, so the code looks like in my vim
    if client and not vim.g.treesitter_colors then client.server_capabilities.semanticTokensProvider = nil end
    local o = function(desc) return { buffer = ev.buf, desc = desc } end
    vim.keymap.set('n', 'gd', vim.lsp.buf.definition, o('Go to definition'))
    vim.keymap.set('n', 'gD', vim.lsp.buf.declaration, o('Go to declaration'))
    vim.keymap.set('n', 'gt', vim.lsp.buf.hover, o('Show type'))
    vim.keymap.set('n', 'gi', vim.lsp.buf.implementation, o('Go to implementation'))
    vim.keymap.set('n', ',d', vim.lsp.buf.definition, o('Go to definition'))
    vim.keymap.set('n', ',o', vim.lsp.buf.references, o('Find occurrences'))
    vim.keymap.set('n', ',a', vim.lsp.buf.definition, o('Go to assignment'))
    vim.keymap.set('n', ',D', '<cmd>tab split<cr><cmd>lua vim.lsp.buf.definition()<cr>', o('Definition in new tab'))
    if client and client:supports_method('textDocument/completion') then
      vim.lsp.completion.enable(true, client.id, ev.buf, { autotrigger = true })
    end
  end,
})
