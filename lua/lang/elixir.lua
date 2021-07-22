local M = {}

M.config = function()
  O.lang.elixir = {
    formatter = {exe = 'mix', args = {'format'}, stdin = true},
    lsp = {path = DATA_PATH .. '/lspinstall/elixir/elixir-ls/language_server.sh'}
  }
end

M.format = function()
  O.formatters.filetype['elixir'] = {
    function()
      return {
        exe = O.lang.elixir.formatter.exe,
        args = O.lang.elixir.formatter.args,
        stdin = O.lang.elixir.formatter.stdin
      }
    end
  }

  require('formatter.config').set_defaults {logging = false, filetype = O.formatters.filetype}
end

M.lint = function()
  -- TODO: implement linters (if applicable)
  return 'No linters configured!'
end

M.lsp = function()
  require('lspconfig').elixirls.setup {cmd = {O.lang.elixir.lsp.path}, on_attach = require('lsp').common_on_attach}
end

M.dap = function()
  -- TODO: implement dap
  return 'No DAP configured!'
end

return M
