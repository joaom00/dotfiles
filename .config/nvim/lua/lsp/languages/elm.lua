local M = {}

function M.config()
  JM.lang.elm = {}
end

function M.formatter()
  JM.lang.elm.formatters = {
    {
      exe = "elm_format",
      args = {},
    },
  }
end

function M.linter()
  JM.lang.elm.linters = {}
end

function M.lsp()
  JM.lang.elm.lsp = {
    provider = "elmls",
    setup = {
      cmd = { DATA_PATH .. "/lspinstall/elm/node_modules/.bin/elm-language-server" },
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
