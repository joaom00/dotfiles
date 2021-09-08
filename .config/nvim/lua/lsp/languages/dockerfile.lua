local M = {}

function M.config()
  JM.lang.docker = {}
end

function M.formatter()
  JM.lang.docker.formatters = {}
end

function M.linter()
  JM.lang.docker.linters = {}
end

function M.lsp()
  JM.lang.docker.lsp = {
    provider = "dockerls",
    setup = {
      cmd = {
        DATA_PATH .. "/lspinstall/dockerfile/node_modules/.bin/docker-langserver",
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
