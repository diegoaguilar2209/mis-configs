local o = vim.opt

o.number = true
o.relativenumber = true
o.signcolumn = 'yes'
o.cursorline = true
o.scrolloff = 8
o.wrap = false
o.colorcolumn = '88' -- black's line length

o.expandtab = true
o.shiftwidth = 4
o.tabstop = 4
o.smartindent = true

o.ignorecase = true
o.smartcase = true
o.inccommand = 'split'

o.splitright = true
o.splitbelow = true
o.termguicolors = true
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
