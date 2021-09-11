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
      name_formatter = function(buf) -- buf contains a "name", "path" and "bufnr"
        if buf.name:match "%.md" then
          return vim.fn.fnamemodify(buf.name, ":t:r")
        end
      end,
      max_name_length = 18,
      max_prefix_length = 15, -- prefix used when a buffer is de-duplicated
      tab_size = 18,
      diagnostics = "nvim_lsp",
      diagnostics_indicator = function(_, _, diagnostics_dict, _)
        local s = " "
        for e, n in pairs(diagnostics_dict) do
          local sym = e == "error" and " " or (e == "warning" and " " or "")
          s = s .. n .. sym
        end
        return s
      end,
      custom_filter = function(buf_number)
        if vim.bo[buf_number].filetype ~= "<i-dont-want-to-see-this>" then
          return true
        end
        if vim.fn.bufname(buf_number) ~= "<buffer-name-I-dont-want>" then
          return true
        end
        if vim.fn.getcwd() == "<work-repo>" and vim.bo[buf_number].filetype ~= "wiki" then
          return true
        end
      end,
      offsets = { { filetype = "NvimTree", text = "File Explorer", text_align = "left" } },
      show_buffer_icons = true, -- disable filetype icons for buffers
      show_buffer_close_icons = true,
      show_close_icon = true,
      show_tab_indicators = true,
      persist_buffer_sort = true, -- whether or not custom sorted buffers should persist
      separator_style = "slant", -- 'slant' | 'thick' | 'thin' | {'any', 'any'}
      enforce_regular_tabs = false,
      always_show_bufferline = true,
      sort_by = "id", -- | 'extension' | 'relative_directory' | 'directory' | function(buffer_a, buffer_b)
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
