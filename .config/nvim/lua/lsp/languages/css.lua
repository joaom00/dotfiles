local M = {}

function M.config()
  JM.lang.css = {}
end

function M.formatter()
  JM.lang.css.formatters = {
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
  JM.lang.css.linters = {}
end

function M.lsp()
  JM.lang.css.lsp = {
    provider = "cssls",
    setup = {
      cmd = {
        "node",
        DATA_PATH .. "/lspinstall/css/vscode-css/css-language-features/server/dist/node/cssServerMain.js",
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
