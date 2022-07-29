local M = {}

function M.setup()
  JM.nnoremap("<leader>lt", "<Cmd>TodoTrouble<CR>", "trouble: todos")
end

function M.config()
  local todo = require "todo-comments"
  todo.setup {
    search = {
      command = "rg",
      args = {
        "--color=never",
        "--no-heading",
        "--with-filename",
        "--line-number",
        "--column",
      },
      pattern = [[\b(KEYWORDS)\b]],
    },
  }
end

return M
