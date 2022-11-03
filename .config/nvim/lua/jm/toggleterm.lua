local M = {}
-- local nnoremap = JM.mapper "n"
-- local tnoremap = JM.mapper "t"

-- local Terminal = toggleterm_terminal.Terminal

-- local float_handler = function(term)
--   if vim.fn.mapcheck("jk", "t") ~= "" then
--     vim.api.nvim_buf_del_keymap(term.bufnr, "t", "jk")
--     vim.api.nvim_buf_del_keymap(term.bufnr, "t", "<esc>")
--   end
-- end

-- local gcommit = Terminal:new {
--   cmd = "git commit",
--   count = 3,
--   hidden = true,
--   direction = "window",
--   start_in_insert = true,
--   close_on_exit = true,
--   float_opts = { border = "curved" },
--   on_open = float_handler,
-- }

-- local lazydocker = Terminal:new {
--   cmd = "lazydocker",
--   count = 2,
--   hidden = true,
--   direction = "float",
--   float_opts = { border = "curved" },
--   on_open = float_handler,
-- }

function M.config()
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

-- function M.gcommit_toggle()
--   gcommit:toggle()
-- end

-- function M.lazydocker_toggle()
--   lazydocker:toggle()
-- end

-- local tw_channels = {}

-- function M.twitch_chat_toggle(channel)
--   channel = channel or tw_channels.last_channel or vim.fn.input "Twitch Channel > "

--   if not tw_channels[channel] then
--     tw_channels[channel] = Terminal:new {
--       hidden = true,
--       cmd = "twt -c " .. channel,
--       start_in_insert = false,
--       direction = "float",
--       float_opts = { border = "curved" },
--       on_close = function()
--         tw_channels.last_channel = channel
--       end,
--     }
--   end

--   tw_channels[channel]:toggle()
-- end

function M.setup()
  JM.nnoremap("<F9>", "<cmd>ToggleTermOpenAll<CR>")
  JM.nnoremap("<leader>gc", "<cmd>lua require('jm.toggleterm').gcommit_toggle()<CR>")
  JM.nnoremap("<space>d", "<cmd>lua require('jm.toggleterm').lazydocker_toggle()<CR>")
  JM.nnoremap("<space>t", "<cmd>lua require('jm.toggleterm').twitch_chat_toggle()<CR>")
  JM.tnoremap("<F10>", "<C-\\><C-n>:ToggleTermCloseAll<CR>")
  JM.tnoremap("<Esc><Esc>", "<C-\\><C-n>")
end


return M
