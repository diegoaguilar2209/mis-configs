-- Called by install.sh in headless mode: installs parsers and tools synchronously.
local M = {}

function M.run()
  -- Remove plugins that are on disk but no longer in plugins.lua
  for _, p in ipairs(vim.pack.get()) do
    if not p.active then
      pcall(vim.pack.del, { p.spec.name })
      print('removed unused plugin ' .. p.spec.name .. '\n')
    end
  end
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
