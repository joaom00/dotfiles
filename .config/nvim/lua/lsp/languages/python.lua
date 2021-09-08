local M = {}

function M.config()
  JM.lang.python = {}
end

function M.formatter()
  JM.lang.python.formatters = {
    {
      exe = "yapf",
      args = {},
    },
    -- {
    --   exe = "isort",
    --   args = {},
    -- },
  }
end

function M.linter()
  JM.lang.python.linters = {}
end

function M.lsp()
  JM.lang.python.lsp = {
    provider = "pyright",
    setup = {
      cmd = {
        DATA_PATH .. "/lspinstall/python/node_modules/.bin/pyright-langserver",
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
