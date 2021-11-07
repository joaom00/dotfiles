local M = {}

function M.config()
  JM.lang.sh = {}
end

function M.formatter()
  JM.lang.sh.formatters = {
    {
      exe = "shfmt",
      args = {},
    },
  }
end

function M.linter()
  JM.lang.sh.linters = {}
end

function M.lsp()
  JM.lang.sh.lsp = {
    provider = "bashls",
    setup = {
      cmd = {
        DATA_PATH .. "/lspinstall/bash/node_modules/.bin/bash-language-server",
        "start",
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
