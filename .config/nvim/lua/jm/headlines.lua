local M = {}

local status_ok, headlines = pcall(require, "headlines")
if not status_ok then
  JM.notify "Missing headlines dependency"
  return
end

function M.config()
  vim.cmd [[highlight Headline1 guibg=#1e2718]]
  vim.cmd [[highlight Headline2 guibg=#21262d]]
  vim.cmd [[highlight CodeBlock guibg=#1c1c1c]]
  vim.cmd [[highlight Dash guibg=#D19A66 gui=bold]]
  vim.fn.sign_define("Headline1", { linehl = "Headline1" })
  vim.fn.sign_define("Headline2", { linehl = "Headline2" })

  headlines.setup {
    markdown = {
      headline_signs = { "Headline1", "Headline2" },
      codeblock_sign = "CodeBlock",
      dash_highlight = "Dash",
    },
  }
end

function M.setup()
  M.config()
end

return M
