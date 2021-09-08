local M = {}

M.config = function()
  JM.lualine = {
    active = true,
    style = "lvim",
    options = {
      icons_enabled = nil,
      component_separators = nil,
      section_separators = nil,
      theme = nil,
      disabled_filetypes = nil,
    },
    sections = { lualine_a = nil, lualine_b = nil, lualine_c = nil, lualine_x = nil, lualine_y = nil, lualine_z = nil },
    inactive_sections = {
      lualine_a = nil,
      lualine_b = nil,
      lualine_c = nil,
      lualine_x = nil,
      lualine_y = nil,
      lualine_z = nil,
    },
    tabline = nil,
    extensions = nil,
    on_config_done = nil,
  }
end

M.setup = function()
  require("jm.lualine.styles").update()
  require("jm.lualine.utils").validate_theme()

  local lualine = require "lualine"
  lualine.setup(JM.lualine)
end

return M
