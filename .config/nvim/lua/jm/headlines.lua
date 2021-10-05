local status_ok, headlines = pcall(require, "headlines")
if not status_ok then
  JM.notify "Missing headlines dependency"
  return
end

local M = {}

function M.config()
  vim.fn.sign_define("Headline1", { linehl = "Headline1" })

  headlines.setup {
    markdown = {
      headline_signs = { "Headline1" },
      codeblock_sign = "CodeBlock",
      dash_highlight = "Dash",
    },
  }
end

function M.setup()
  M.config()
end

return M
