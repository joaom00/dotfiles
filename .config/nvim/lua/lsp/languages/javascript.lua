local M = {}

function M.config()
  JM.lang.javascript = {}
end

function M.formatter()
  JM.lang.javascript.formatters = {
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
  JM.lang.javascript.linters = {
    {
      exe = "eslint",
    },
    -- {
    --   exe = "eslint_d",
    -- },
  }
end

function M.lsp()
  JM.lang.javascript.lsp = {
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
