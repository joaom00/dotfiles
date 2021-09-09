local M = {}

local status_ok, lsp_signature = pcall(require, "lsp_signature")
if not status_ok then
  JM.notify "Missing lsp_signature dependency"
  return
end

function M.config()
  lsp_signature.setup {
    bind = true,
    fix_pos = false,
    hint_enable = false,
    handler_opts = { border = "rounded" },
    floating_window_above_cur_line = true,
  }
end

function M.setup()
  M.config()
end

return M
