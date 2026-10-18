local group = vim.api.nvim_create_augroup('team', { clear = true })

-- Flash the yanked text
vim.api.nvim_create_autocmd('TextYankPost', {
  group = group,
  callback = function() vim.hl.on_yank({ timeout = 150 }) end,
})

-- Reopen files at the last cursor position
vim.api.nvim_create_autocmd('BufReadPost', {
  group = group,
  callback = function(ev)
    local mark = vim.api.nvim_buf_get_mark(ev.buf, '"')
    if mark[1] > 0 and mark[1] <= vim.api.nvim_buf_line_count(ev.buf) then
      pcall(vim.api.nvim_win_set_cursor, 0, mark)
    end
  end,
})

-- Two-space indent for config and web files
vim.api.nvim_create_autocmd('FileType', {
  group = group,
  pattern = { 'lua', 'yaml', 'json', 'jsonc', 'toml', 'markdown', 'html', 'css', 'javascript', 'typescript' },
  callback = function() vim.opt_local.shiftwidth = 2; vim.opt_local.tabstop = 2 end,
})

-- Reload files changed outside Neovim (for example by Claude Code or git)
vim.api.nvim_create_autocmd({ 'FocusGained', 'BufEnter' }, {
  group = group,
  command = 'checktime',
})
