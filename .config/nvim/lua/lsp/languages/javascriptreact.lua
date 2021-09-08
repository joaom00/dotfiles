local M = {}

function M.config()
  JM.lang.javascriptreact = {}
end

function M.formatter()
  JM.lang.javascriptreact.formatters = {
    {
      exe = "prettier",
      args = {},
    },
    -- {
    --   exe = "prettier_d_slim",
    --   args = {},
    -- },
    -- {
    --   exe = "prettierd",
    --   args = {},
    -- },
  }
end

function M.linter()
  JM.lang.javascriptreact.linters = {}
end

function M.lsp()
  JM.lang.javascriptreact.lsp = {
    provider = "tsserver",
    setup = {
      cmd = {
        DATA_PATH .. "/lspinstall/typescript/node_modules/.bin/typescript-language-server",
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
