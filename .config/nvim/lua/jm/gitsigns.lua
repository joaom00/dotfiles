local status_ok, gitsigns = pcall(require, "gitsigns")
if not status_ok then
  JM.notify "Missing gitsigns dependency"
  return
end

local M = {}

function M.config()
  JM.gitsigns = {
    signs = {
      add = { hl = "GitSignsAdd", text = "▍", numhl = "GitSignsAddNr", linehl = "GitSignsAddLn" },
      change = { hl = "GitSignsChange", text = "▍", numhl = "GitSignsChangeNr", linehl = "GitSignsChangeLn" },
      delete = { hl = "GitSignsDelete", text = "▸", numhl = "GitSignsDeleteNr", linehl = "GitSignsDeleteLn" },
      topdelete = { hl = "GitSignsDelete", text = "▾", numhl = "GitSignsDeleteNr", linehl = "GitSignsDeleteLn" },
      changedelete = { hl = "GitSignsChange", text = "▍", numhl = "GitSignsChangeNr", linehl = "GitSignsChangeLn" },
    },
  }
end

function M.setup()
  M.config()

  gitsigns.setup {
    signs = JM.gitsigns.signs,
  }
end

return M
