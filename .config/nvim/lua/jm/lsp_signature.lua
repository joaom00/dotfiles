local status_ok, lsp_signature = pcall(require, "lsp_signature")
if not status_ok then
  JM.notify "Missing lsp_signature dependency"
  return
end

local M = {}

function M.config()
  lsp_signature.setup {
    bind = true,
    -- doc_lines = 4,
    toggle_key = "<C-x>",
    floating_window = true,
    floating_window_above_cur_line = true,
    hint_enable = true,
    fix_pos = false,
    -- floating_window_above_first = true,
    log_path = vim.fn.expand "$HOME" .. "/tmp/sig.log",
    -- hi_parameter = "Search",
    -- zindex = 1002,
    timer_interval = 100,
    extra_trigger_chars = {},
    handler_opts = {
      border = "rounded", -- "shadow", --{"╭", "─" ,"╮", "│", "╯", "─", "╰", "│" },
    },
    max_height = 4,
  }
end

function M.setup()
  M.config()
end

return M
