local M = {}

function M.setup()
  JM.nnoremap("<leader>ld", "<cmd>TroubleToggle workspace_diagnostics<CR>", "trouble: toggle")
  JM.nnoremap("<leader>lr", "<cmd>TroubleToggle lsp_references<CR>", "trouble: lsp references")
end

function M.config()
  local trouble = require "trouble"
  JM.nnoremap("]d", function()
    trouble.previous { skip_groups = true, jump = true }
  end, "trouble: previous item")
  JM.nnoremap("[d", function()
    trouble.next { skip_groups = true, jump = true }
  end, "trouble: next item")
  trouble.setup { auto_close = true, auto_preview = false }
end

return M
