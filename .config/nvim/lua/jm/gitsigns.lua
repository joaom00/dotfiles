local ok, gitsigns = pcall(require, "gitsigns")
if not ok then
  JM.notify "Missing gitsigns dependency"
  return
end

local M = {}

function M.config()
  local c = require("colorbuddy.color").colors
  local Group = require("colorbuddy.group").Group
  local Color = require("colorbuddy").Color

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

  gitsigns.setup {
    signs = {
      add = { hl = "GitSignsAdd", text = "│", numhl = "GitSignsAddNr", linehl = "GitSignsAddLn" },
      change = { hl = "GitSignsChange", text = "│", numhl = "GitSignsChangeNr", linehl = "GitSignsChangeLn" },
      delete = { hl = "GitSignsDelete", text = "_", numhl = "GitSignsDeleteNr", linehl = "GitSignsDeleteLn" },
      topdelete = { hl = "GitSignsDelete", text = "‾", numhl = "GitSignsDeleteNr", linehl = "GitSignsDeleteLn" },
      changedelete = { hl = "GitSignsDelete", text = "~", numhl = "GitSignsChangeNr", linehl = "GitSignsChangeLn" },
    },
    numhl = false,
    linehl = false,
    keymaps = {
      noremap = true,
      buffer = true,

      ["n <space>hd"] = { expr = true, "&diff ? ']c' : '<cmd>lua require\"gitsigns\".next_hunk()<CR>'" },
      ["n <space>hu"] = { expr = true, "&diff ? '[c' : '<cmd>lua require\"gitsigns\".prev_hunk()<CR>'" },
    },
    current_line_blame = true,
    current_line_blame_opts = {
      delay = 2000,
      virt_text_pos = "eol",
    },
  }
end

function M.setup()
  M.config()
end

return M
