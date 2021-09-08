local M = {}

function M.config()
  JM.lang.html = {}
end

function M.formatter()
  JM.lang.html.formatters = {
    {
      exe = "prettier",
      args = {},
    },
    -- {
    --   exe = "prettierd",
    --   args = {},
    -- },
  }
end

function M.linter()
  JM.lang.html.linters = {}
end

function M.lsp()
  JM.lang.html.lsp = {
    provider = "html",
    setup = {
      cmd = {
        "node",
        DATA_PATH .. "/lspinstall/html/vscode-html/html-language-features/server/dist/node/htmlServerMain.js",
        "--stdio",
      },
    },
  }
end

function M.setup()
  M.config()
  M.formatter()
  M.linter()
  M.lsp()
end

return M
