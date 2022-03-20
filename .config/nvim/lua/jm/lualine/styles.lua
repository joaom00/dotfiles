local M = {}

local components = require "jm.lualine.components"
local ghn_count = require("github-notifications").statusline_notification_count
local package = require "package-info"

local styles = { lvim = nil, default = nil, none = nil }

local function pkg_info()
  return package.get_status()
end

styles.none = {
  style = "none",
  options = { icons_enabled = true, component_separators = "", section_separators = "", disabled_filetypes = {} },
  sections = { lualine_a = {}, lualine_b = {}, lualine_c = {}, lualine_x = {}, lualine_y = {}, lualine_z = {} },
  inactive_sections = {
    lualine_a = {},
    lualine_b = {},
    lualine_c = {},
    lualine_x = {},
    lualine_y = {},
    lualine_z = {},
  },
  tabline = {},
  extensions = {},
}

styles.default = {
  style = "default",
  options = {
    icons_enabled = true,
    component_separators = { "", "" },
    section_separators = { "", "" },
    disabled_filetypes = {},
  },
  sections = {
    lualine_a = { "mode" },
    lualine_b = { "branch" },
    lualine_c = { "filename" },
    lualine_x = { "encoding", "fileformat", "filetype" },
    lualine_y = { "progress" },
    lualine_z = { "location" },
  },
  inactive_sections = {
    lualine_a = {},
    lualine_b = {},
    lualine_c = { "filename" },
    lualine_x = { "location" },
    lualine_y = {},
    lualine_z = {},
  },
  tabline = {},
  extensions = {},
}

styles.lvim = {
  style = "lvim",
  options = {
    icons_enabled = true,
    component_separators = "",
    section_separators = "",
    disabled_filetypes = { "dashboard", "NvimTree", "Outline" },
  },
  sections = {
    lualine_a = { components.mode },
    lualine_b = { components.branch, components.filename },
    lualine_c = { components.diff, components.python_env, pkg_info },
    lualine_x = {
      components.diagnostics,
      ghn_count,
      components.treesitter,
      components.spaces,
      components.lsp,
      components.filetype,
    },
    lualine_y = {},
    lualine_z = { components.scrollbar },
  },
  inactive_sections = {
    lualine_a = { "filename" },
    lualine_b = {},
    lualine_c = {},
    lualine_x = {},
    lualine_y = {},
    lualine_z = {},
  },
  tabline = {},
  extensions = { "nvim-tree" },
}

function M.get_style(style)
  local style_keys = vim.tbl_keys(styles)
  if not vim.tbl_contains(style_keys, style) then
    JM.notify("Invalid lualine style: " .. style, "error", "Lualine")
    JM.notify('"lvim" style is applied.', "info", "Lualine")
    style = "lvim"
  end

  return vim.deepcopy(styles[style])
end

function M.update()
  require("jm.lualine").config()
  local style = M.get_style(JM.lualine.style)
  if JM.lualine.options.theme == nil then
    JM.lualine.options.theme = JM.colorscheme
  end

  JM.lualine = vim.tbl_deep_extend("keep", JM.lualine, style)
end

return M
