local status_ok, bufferline = pcall(require, "bufferline")
if not status_ok then
  JM.notify "Missing bufferline dependency"
  return
end

local M = {}
local nnoremap = JM.mapper "n"

function M.config()
  bufferline.setup {
    options = {
      numbers = "none", -- | 'ordinal' | 'buffer_id' | 'both'
      close_command = "bdelete! %d", -- can be a string | function, see "Mouse actions"
      right_mouse_command = "bdelete! %d", -- can be a string | function, see "Mouse actions"
      left_mouse_command = "buffer %d", -- can be a string | function, see "Mouse actions"
      middle_mouse_command = nil, -- can be a string | function, see "Mouse actions"
      indicator_icon = "▎",
      buffer_close_icon = "",
      modified_icon = "●",
      close_icon = "",
      left_trunc_marker = "",
      right_trunc_marker = "",
      max_name_length = 14,
      max_prefix_length = 10, -- prefix used when a buffer is de-duplicated
      tab_size = 16,
      diagnostics = "nvim_lsp",
      -- diagnostics_indicator = function(_, _, diagnostics_dict, _)
      --   local s = " "
      --   for e, n in pairs(diagnostics_dict) do
      --     local sym = e == "error" and " " or (e == "warning" and " " or "")
      --     s = s .. n .. sym
      --   end
      --   return s
      -- end,
      diagnostics_indicator = function(count, level)
        local icon = level:match "error" and "" or "" -- "" or ""
        return "" .. icon .. count
      end,
      offsets = { { filetype = "NvimTree", text = "File Explorer", text_align = "left" } },
      show_buffer_icons = true, -- disable filetype icons for buffers
      show_buffer_close_icons = false,
      show_close_icon = true,
      show_tab_indicators = true,
      persist_buffer_sort = true, -- whether or not custom sorted buffers should persist
      separator_style = "thin", -- 'slant' | 'thick' | 'thin' | {'any', 'any'}
      enforce_regular_tabs = false,
      always_show_bufferline = true,
      sort_by = "directory", -- | 'extension' | 'relative_directory' | 'directory' | function(buffer_a, buffer_b)
    },
  }
end

function M.keymappings()
  nnoremap("<TAB>", "<cmd>BufferLineCycleNext<CR>")
  nnoremap("<S-TAB>", "<cmd>BufferLineCyclePrev<CR>")
  nnoremap("<C-x>", "<cmd>BufferLinePickClose<CR>")
  nnoremap("<Space>cr", "<cmd>BufferLineCloseRight<CR>")
  nnoremap("<Space>cl", "<cmd>BufferLineCloseLeft<CR>")
end

function M.setup()
  M.config()
  M.keymappings()
end

return M
