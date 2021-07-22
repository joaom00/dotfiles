CONFIG_PATH = vim.fn.stdpath('config')
DATA_PATH = vim.fn.stdpath('data')
CACHE_PATH = vim.fn.stdpath('cache')
TERMINAL = vim.fn.expand('$TERMINAL')

O = {
  colorscheme = 'xcodedarkhc',
  lang = {
    python = {
      linter = '',
      formatter = 'yapf',
      autoformat = true,
      isort = false,
      diagnostics = {virtual_text = {spacing = 0, prefix = ''}, signs = true, underline = true},
      analysis = {type_checking = 'basic', auto_search_paths = true, use_library_code_types = true}
    }
  },
  formatters = {filetype = {}}
}

require('lang.go').config()
require('lang.clang').config()
require('lang.html').config()
require('lang.css').config()
require('lang.dockerfile').config()
require('lang.elixir').config()
require('lang.graphql').config()
require('lang.json').config()

P = function(v)
  print(vim.inspect(v))
  return v
end

if pcall(require, 'plenary') then
  RELOAD = require('plenary.reload').reload_module

  R = function(name)
    RELOAD(name)
    return require(name)
  end
end
