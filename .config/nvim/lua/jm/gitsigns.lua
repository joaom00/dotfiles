local ok, gitsigns = pcall(require, "gitsigns")
if not ok then
  JM.notify "Missing gitsigns dependency"
  return
end

local M = {}

function M.config()
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
