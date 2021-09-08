local M = {}

function M.config()
  JM.lang.typescript = {}
end

function M.formatter()
  JM.lang.typescript.formatters = {
    {
      exe = "prettier",
      args = {},
    },
    -- {
    --   exe = "prettierd",
    --   args = {},
    -- },
    -- {
    --   exe = "prettier_d_slim",
    --   args = {},
    -- },
  }
end

function M.linter()
  JM.lang.typescript.linters = {}
end

function M.lsp()
  JM.lang.typescript.lsp = {
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
