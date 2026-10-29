local o = vim.opt

o.number = true
o.signcolumn = 'yes'
o.scrolloff = 8
o.wrap = false
o.colorcolumn = '80'

o.expandtab = true
o.shiftwidth = 2 -- like my vimrc; Python files use 4 (Neovim's PEP 8 default)
o.tabstop = 2
o.softtabstop = 2
o.autoindent = true
o.fileformat = 'unix'
o.path:append('**')

o.ignorecase = true
o.smartcase = true
o.inccommand = 'split'

o.splitright = true
o.splitbelow = true
o.termguicolors = false -- use the terminal's palette, exactly like my vim (t_Co=256, torte)
o.winborder = 'rounded'
o.mouse = 'a'
o.updatetime = 250
o.timeoutlen = 400

o.undofile = true
o.swapfile = false
o.confirm = true

o.list = true
o.listchars = { tab = '» ', trail = '·', nbsp = '␣' }

-- Built-in completion menu (Neovim 0.12): fuzzy, popup with border, no auto-insert
o.completeopt = { 'menuone', 'noselect', 'popup', 'fuzzy' }
o.pumborder = 'rounded'

-- System clipboard: inside tmux Neovim uses tmux, which forwards to Windows via OSC 52
o.clipboard = 'unnamedplus'

-- Not copied from my vimrc on purpose:
--   autochdir: it breaks project-wide search (fzf, grep). Enable it in lua/user/init.lua if I miss it.
vim.filetype.add({ extension = { pck = 'sql' } })
