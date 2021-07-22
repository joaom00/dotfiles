CONFIG_PATH = vim.fn.stdpath('config')
DATA_PATH = vim.fn.stdpath('data')
CACHE_PATH = vim.fn.stdpath('cache')
TERMINAL = vim.fn.expand('$TERMINAL')

O = {colorscheme = 'xcodedarkhc', lang = {}, formatters = {filetype = {}}}

require('lang.go').config()
require('lang.clang').config()
require('lang.html').config()
require('lang.css').config()
require('lang.dockerfile').config()
require('lang.elixir').config()
require('lang.graphql').config()
require('lang.json').config()
require('lang.lua').config()
require('lang.python').config()

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
