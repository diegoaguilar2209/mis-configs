-- Same keys as my vimrc. Leader is \ and local leader is , (press one and wait: which-key lists the rest).
local map = vim.keymap.set

-- My shortcuts (vimrc)
map('n', '<leader>l', '<cmd>bnext<cr>', { desc = 'Next buffer' })
map('n', '<leader>h', '<cmd>bprevious<cr>', { desc = 'Previous buffer' })
map('n', '<leader>d', '<cmd>bp <bar> bd #<cr>', { desc = 'Close buffer, keep window' })
map('n', '<leader>bl', '<cmd>ls<cr>', { desc = 'List buffers' })
map('n', '<C-s>', '<cmd>update<cr>', { desc = 'Save if changed' })

-- Location list (vimrc)
map('n', '<leader>sn', '<cmd>lnext<cr>', { desc = 'Next location' })
map('n', '<leader>sp', '<cmd>lprev<cr>', { desc = 'Previous location' })
map('n', '<leader>se', '<cmd>lopen<cr>', { desc = 'Open location list' })
map('n', '<leader>sl', '<cmd>llist<cr>', { desc = 'List locations' })

-- \e showed Syntastic errors: now the LSP diagnostics of this file in the location list
map('n', '<leader>e', function() vim.diagnostic.setloclist() end, { desc = 'Errors of this file' })

map('n', '<Esc>', '<cmd>nohlsearch<cr>', { desc = 'Clear search highlight' })
map('t', '<Esc><Esc>', [[<C-\><C-n>]], { desc = 'Exit terminal mode' })
