local M = {}

function M.setup()
  local db = require "dashboard"
  -- local home = os.getenv "HOME"
  -- db.preview_command = "cat | lolcat -F 0.3"
  -- db.preview_file_path = home .. "/.config/nvim/static/neovim.cat"
  db.preview_file_height = 12
  db.preview_file_width = 80
  db.custom_center = {
    {
      icon = "  ",
      desc = "Find File              ",
      action = "lua require('jm.telescope').fd()",
    },
    {
      icon = "  ",
      desc = "Recents                ",
      action = "Telescope oldfiles",
    },
    {
      icon = "  ",
      desc = "Projects               ",
      action = "lua require('jm.telescope').project()",
    },
    {
      icon = "  ",
      desc = "Find Word              ",
      action = "lua require('jm.telescope').live_grep()",
    },
    {
      icon = "  ",
      desc = "Neovim Files           ",
      aciton = "lua require('jm.telescope').edit_neovim()",
    },
    {
      icon = "  ",
      desc = "Colorscheme            ",
      action = "Telescope colorscheme",
    },
  }
end

return M
