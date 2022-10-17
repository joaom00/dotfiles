local M = {}

function M.config()
  require("lsp_signature").setup {
    bind = true,
    toggle_key = "<C-x>",
    floating_window = true,
    floating_window_above_cur_line = true,
    hint_enable = true,
    fix_pos = false,
    max_height = 4,
  }
end

return M
