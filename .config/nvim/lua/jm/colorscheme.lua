local M = {}

-----------------------------------------------------------------------------//
-- Aurora Theme {{{1
-----------------------------------------------------------------------------//
function M.aurora()
  vim.cmd "colorscheme aurora"
end

-----------------------------------------------------------------------------//
-- Gruvbuddy Theme {{{1
-----------------------------------------------------------------------------//
function M.gruvbuddy()
  if not pcall(require, "colorbuddy") then
    return
  end

  require("colorbuddy").colorscheme "gruvbuddy"

  local c = require("colorbuddy.color").colors
  local g = require("colorbuddy.group").groups
  local s = require("colorbuddy.style").styles
  local Group = require("colorbuddy.group").Group
  local Color = require("colorbuddy").Color

  Group.new("GoTestSuccess", c.green, nil, s.bold)
  Group.new("GoTestFail", c.red, nil, s.bold)

  -- Group.new('Keyword', c.purple, nil, nil)

  Group.new("TSPunctBracket", c.orange:light():light())

  Group.new("StatuslineError1", c.red:light():light(), g.Statusline)
  Group.new("StatuslineError2", c.red:light(), g.Statusline)
  Group.new("StatuslineError3", c.red, g.Statusline)
  Group.new("StatuslineError3", c.red:dark(), g.Statusline)
  Group.new("StatuslineError3", c.red:dark():dark(), g.Statusline)

  Group.new("pythonTSType", c.red)
  Group.new("goTSType", g.Type.fg:dark(), nil, g.Type)

  Group.new("typescriptTSConstructor", g.pythonTSType)
  Group.new("typescriptTSProperty", c.blue)

  Group.new("WinSeparator", nil, nil)

  -----------------------------------------------------------------------------//
  -- COMPLETION {{{1
  -----------------------------------------------------------------------------//
  Group.new("CmpItemAbbr", g.Comment)
  Group.new("CmpItemAbbrDeprecated", g.Error)
  Group.new("CmpItemAbbrMatchFuzzy", g.CmpItemAbbr.fg:dark(), nil, s.italic)
  Group.new("CmpItemKind", g.Special)
  Group.new("CmpItemMenu", g.NonText)

  -----------------------------------------------------------------------------//
  -- TELESCOPE {{{1
  -----------------------------------------------------------------------------//
  Group.new("TelescopeNormal", nil, c.background:light())
  Group.new("TelescopeTitle", nil, c.background:light())

  -----------------------------------------------------------------------------//
  -- GITSIGNS {{{1
  -----------------------------------------------------------------------------//
  Group.new("GitSignsAdd", c.green)
  Group.new("GitSignsChange", c.yellow)
  Group.new("GitSignsDelete", c.red)

  -- Color.new("gitsignaddbg", "#001a00")
  Color.new("gitsignaddbg", "#283B4D")
  Color.new("difftext", "#36426B")
  Color.new("gitsigndeletebg", "#3f0001")

  Group.new("GitSignsAddLn", c.difftext:light(), c.gitsignaddbg:saturate())
  Group.new("GitSignsChangeLn", nil, c.yellow)
  Group.new("GitSignsDeleteLn", c.white, c.gitsigndeletebg)

  -----------------------------------------------------------------------------//
  -- HOP {{{1
  -----------------------------------------------------------------------------//
  Group.new("HopNextKey", c.pink, nil, s.bold)
  Group.new("HopNextKey1", c.cyan:saturate(), nil, s.bold)
  Group.new("HopNextKey2", c.cyan:dark(), nil)
end

-----------------------------------------------------------------------------//
-- Tokyonight Theme {{{1
-----------------------------------------------------------------------------//
function M.tokyonight()
  vim.g.tokyonight_style = "night"
  vim.g.tokyonight_sidebars = { "qf", "vista_kind", "terminal", "packer", "DiffviewFiles" }
  vim.g.tokyonight_cterm_colors = false
  vim.g.tokyonight_terminal_colors = true
  vim.g.tokyonight_italic_comments = true
  vim.g.tokyonight_italic_keywords = true
  vim.g.tokyonight_italic_functions = false
  vim.g.tokyonight_italic_variables = false
  vim.g.tokyonight_transparent = false
  vim.g.tokyonight_hide_inactive_statusline = true
  vim.g.tokyonight_dark_sidebar = true
  vim.g.tokyonight_dark_float = true
  vim.g.tokyonight_colors = {
    bg_dark = "#16161F",
    bg_popup = "#16161F",
    bg_statusline = "#16161F",
    bg_sidebar = "#16161F",
    bg_float = "#16161F",
  }

  vim.cmd "colorscheme tokyonight"
end

-----------------------------------------------------------------------------//
-- Purpledaze Theme {{{1
-----------------------------------------------------------------------------//
function M.purpledaze()
  vim.g.purpledaze_dev = true
  vim.g.purpledaze_dark_sidebar = true
  vim.g.lightline = { coloscheme = "purpledaze" }

  vim.cmd "colorscheme purpledaze"
end

-----------------------------------------------------------------------------//
-- Omni Theme {{{1
-----------------------------------------------------------------------------//
function M.omni()
  vim.g.omni_dev = true
  vim.g.lightline = { coloscheme = "omni" }

  vim.cmd "colorscheme omni"
end

return M
