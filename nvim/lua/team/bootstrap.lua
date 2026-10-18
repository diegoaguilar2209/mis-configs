-- Called by install.sh in headless mode: installs parsers and tools synchronously.
local M = {}

function M.run()
  local wanted = _G.TeamParsers or {}
  if vim.fn.executable('tree-sitter') == 1 then
    pcall(function() require('nvim-treesitter').install(wanted):wait(600000) end)
    local have = require('nvim-treesitter').get_installed('parsers')
    local missing = vim.tbl_filter(function(p) return not vim.list_contains(have, p) end, wanted)
    print(('treesitter parsers: %d/%d installed%s\n'):format(#wanted - #missing, #wanted,
      #missing > 0 and (' (missing: ' .. table.concat(missing, ', ') .. ')') or ''))
  else
    print('tree-sitter CLI not found: parsers skipped\n')
  end
  local ok, err = pcall(vim.cmd, 'MasonToolsInstallSync')
  print(ok and 'language servers and formatters: ok\n' or ('mason: ' .. tostring(err) .. '\n'))
end

return M
