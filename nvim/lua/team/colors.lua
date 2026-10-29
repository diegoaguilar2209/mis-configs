-- Same look as my vim: torte (black background) + vim-airline "dark" theme colors in the
-- statusline and buffer tabs + dark grey line numbers (from my vimrc). Reapplied if the scheme changes.
local function apply()
  local hl = function(group, spec) vim.api.nvim_set_hl(0, group, spec) end
  -- vimrc: highlight LineNr ctermfg=DarkGrey ctermbg=NONE
  hl('LineNr', { fg = '#808080', ctermfg = 8 })
  hl('CursorLineNr', { fg = '#ffff00', ctermfg = 11, bold = true })

  -- Neovim's python.vim is newer than Vim's: make class names and `self` look like in my vim
  hl('pythonClass', { link = 'pythonFunction' })
  hl('pythonClassVar', { link = 'Normal' })

  -- airline "dark": a = mode, b = git/info, c = file name
  local a_normal = { fg = '#00005f', bg = '#dfff00', ctermfg = 17, ctermbg = 190, bold = true }
  local a_insert = { fg = '#00005f', bg = '#00dfff', ctermfg = 17, ctermbg = 45, bold = true }
  local a_visual = { fg = '#000000', bg = '#ffaf00', ctermfg = 232, ctermbg = 214, bold = true }
  local a_replace = { fg = '#ffffff', bg = '#af0000', ctermfg = 255, ctermbg = 124, bold = true }
  local b = { fg = '#ffffff', bg = '#444444', ctermfg = 255, ctermbg = 238 }
  local c = { fg = '#9cffd3', bg = '#202020', ctermfg = 85, ctermbg = 234 }
  hl('MiniStatuslineModeNormal', a_normal)
  hl('MiniStatuslineModeInsert', a_insert)
  hl('MiniStatuslineModeVisual', a_visual)
  hl('MiniStatuslineModeReplace', a_replace)
  hl('MiniStatuslineModeCommand', a_normal)
  hl('MiniStatuslineModeOther', a_insert)
  hl('MiniStatuslineDevinfo', b)
  hl('MiniStatuslineFileinfo', b)
  hl('MiniStatuslineFilename', c)
  hl('MiniStatuslineInactive', { fg = '#4e4e4e', bg = '#1c1c1c', ctermfg = 239, ctermbg = 234 })
  hl('StatusLine', c)
  hl('StatusLineNC', { fg = '#4e4e4e', bg = '#1c1c1c', ctermfg = 239, ctermbg = 234 })

  -- buffer tabs at the top, like airline's tabline
  hl('MiniTablineCurrent', a_normal)
  hl('MiniTablineModifiedCurrent', { fg = '#00005f', bg = '#ffaf00', ctermfg = 17, ctermbg = 214, bold = true })
  hl('MiniTablineVisible', b)
  hl('MiniTablineModifiedVisible', { fg = '#ffaf00', bg = '#444444', ctermfg = 214, ctermbg = 238 })
  hl('MiniTablineHidden', c)
  hl('MiniTablineModifiedHidden', { fg = '#ffaf00', bg = '#202020', ctermfg = 214, ctermbg = 234 })
  hl('MiniTablineFill', { bg = '#000000', ctermbg = 0 })
end

vim.o.background = 'dark'
vim.cmd.colorscheme('torte')
apply()
vim.api.nvim_create_autocmd('ColorScheme', { callback = apply })
