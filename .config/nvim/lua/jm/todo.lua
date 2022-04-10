local M = {}

function M.setup()
  local ok, todo_comments = pcall(require, "todo-comments")
  if not ok then
    return
  end

  todo_comments.setup {
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
