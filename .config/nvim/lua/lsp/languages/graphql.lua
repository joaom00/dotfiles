local M = {}

function M.config()
  JM.lang.graphql = {}
end

function M.formatter()
  JM.lang.graphql.formatters = {}
end

function M.linter()
  JM.lang.graphql.linters = {}
end

function M.lsp()
  JM.lang.graphql.lsp = {
    provider = "graphql",
    setup = {
      cmd = {
        "graphql-lsp",
        "server",
        "-m",
        "stream",
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
