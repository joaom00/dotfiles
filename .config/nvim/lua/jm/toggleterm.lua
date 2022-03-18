local status_ok, toggleterm = pcall(require, "toggleterm")
if not status_ok then
  JM.notify "Missing toggleterm dependency"
  return
end

local toggleterm_terminal_ok, toggleterm_terminal = pcall(require, "toggleterm.terminal")
if not toggleterm_terminal_ok then
  JM.notify "Failed to load terminal module in toggleterm"
  return
end

local M = {}
local nnoremap = JM.mapper "n"
local tnoremap = JM.mapper "t"

local Terminal = toggleterm_terminal.Terminal

local float_handler = function(term)
  if vim.fn.mapcheck("jk", "t") ~= "" then
    vim.api.nvim_buf_del_keymap(term.bufnr, "t", "jk")
    vim.api.nvim_buf_del_keymap(term.bufnr, "t", "<esc>")
  end
end

local gcommit = Terminal:new {
  cmd = "git commit",
  hidden = true,
  direction = "window",
  start_in_insert = true,
  close_on_exit = true,
  float_opts = { border = "curved" },
  on_open = float_handler,
}

local lazygit = Terminal:new {
  cmd = "lazygit",
  hidden = true,
  direction = "float",
  float_opts = { border = "curved" },
  on_open = float_handler,
}

local lazydocker = Terminal:new {
  cmd = "lazydocker",
  hidden = true,
  direction = "float",
  float_opts = { border = "curved" },
  on_open = float_handler,
}

function M.config()
  toggleterm.setup {
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

function M.lazydocker_toggle()
  lazydocker:toggle()
end

local tw_channels = {}

function M.twitch_chat_toggle(channel)
  channel = channel or vim.fn.input "Twitch Channel > "

  if not tw_channels[channel] then
    tw_channels[channel] = Terminal:new {
      hidden = true,
      cmd = "twt -c " .. channel,
      start_in_insert = false,
      direction = "float",
      float_opts = { border = "curved" },
    }
  end

  tw_channels[channel]:toggle()
end

function M.keymappings()
  nnoremap("<F9>", "<cmd>ToggleTermOpenAll<CR>")
  nnoremap("<leader>gc", "<cmd>lua require('jm.toggleterm').gcommit_toggle()<CR>")
  nnoremap("<space>l", "<cmd>lua require('jm.toggleterm').lazygit_toggle()<CR>")
  nnoremap("<space>d", "<cmd>lua require('jm.toggleterm').lazydocker_toggle()<CR>")
  nnoremap("<space>t", "<cmd>lua require('jm.toggleterm').twitch_chat_toggle()<CR>")
  tnoremap("<F10>", "<C-\\><C-n>:ToggleTermCloseAll<CR>")
  tnoremap("<Esc><Esc>", "<C-\\><C-n>")
end

function M.setup()
  M.config()
  M.keymappings()
end

return M
