local M = {}

function M.config()
  JM.lang.go = {}
end

function M.formatter()
  JM.lang.go.formatters = {
    -- {
    --   exe = "gofmt",
    --   args = {},
    -- },
    {
      exe = "goimports",
      args = {},
    },
    -- {
    --   exe = "gofumpt",
    --   args = {},
    -- },
  }
end

function M.linter()
  JM.lang.go.linters = {}
end

function M.lsp()
  JM.lang.go.lsp = {
    provider = "gopls",
    setup = {
      cmd = {
        DATA_PATH .. "/lspinstall/go/gopls",
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
