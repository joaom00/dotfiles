local M = {}

local nnoremap = JM.mapper "n"
local tnoremap = JM.mapper "t"

local Terminal = require("toggleterm.terminal").Terminal

local gcommit = Terminal:new {
  cmd = "git commit",
  hidden = true,
  direction = "float",
  close_on_exit = true,
  float_opts = { border = "curved" },
  on_close = function()
    vim.fn.histadd("cmd", "DiffviewRefresh")
    vim.cmd "DiffviewRefresh"
  end,
}

local lazygit = Terminal:new {
  cmd = "lazygit",
  hidden = true,
  direction = "float",
  float_opts = { border = "curved" },
}

function M.config()
  require("toggleterm").setup {
    size = function(term)
      if term.direction == "horizontal" then
        return 15
      elseif term.direction == "vertical" then
        return vim.o.columns * 0.4
      end
    end,
    open_mapping = [[<c-t>]],
    hide_numbers = true,
    shade_filetypes = {},
    shade_terminals = true,
    shading_factor = 1, -- the degree by which to darken to terminal colour, default: 1 for dark backgrounds, 3 for light
    start_in_insert = true,
    insert_mappings = true,
    persist_size = true,
    direction = "vertical", -- 'vertical' | 'horizontal' | 'window' | 'float'
  }
end

function M.gcommit_toggle()
  gcommit:toggle()
end
function M.lazygit_toggle()
  lazygit:toggle()
end

function M.keymappings()
  nnoremap("<F9>", "<cmd>ToggleTermOpenAll<CR>")
  nnoremap("<leader>gc", "<cmd>lua require('jm.toggleterm').gcommit_toggle()<CR>")
  nnoremap("<space>l", "<cmd>lua require('jm.toggleterm').lazygit_toggle()<CR>")
  tnoremap("<F10>", "<C-\\><C-n>:ToggleTermCloseAll<CR>")
  tnoremap("<Esc><Esc>", "<C-\\><C-n>")
end

function M.setup()
  M.config()
  M.keymappings()
end

return M
