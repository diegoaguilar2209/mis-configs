-- Leader is <Space>. Press it and wait: which-key shows every shortcut below.
local map = vim.keymap.set

map('n', '<Esc>', '<cmd>nohlsearch<cr>', { desc = 'Clear search highlight' })
map('n', '<leader>w', '<cmd>write<cr>', { desc = 'Save file' })
map('n', '<leader>q', '<cmd>quit<cr>', { desc = 'Close window' })

-- Move selected lines up and down
map('v', 'J', ":m '>+1<cr>gv=gv", { desc = 'Move selection down' })
map('v', 'K', ":m '<-2<cr>gv=gv", { desc = 'Move selection up' })

-- Keep the cursor centered when jumping
map('n', '<C-d>', '<C-d>zz')
map('n', '<C-u>', '<C-u>zz')
map('n', 'n', 'nzzzv')
map('n', 'N', 'Nzzzv')

-- Diagnostics
map('n', '<leader>d', vim.diagnostic.open_float, { desc = 'Show diagnostic' })
map('n', '<leader>xq', vim.diagnostic.setqflist, { desc = 'Diagnostics to quickfix' })

-- Terminal: leave insert mode with Esc Esc
map('t', '<Esc><Esc>', [[<C-\><C-n>]], { desc = 'Exit terminal mode' })
