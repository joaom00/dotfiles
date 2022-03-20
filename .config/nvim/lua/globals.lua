CONFIG_PATH = vim.fn.stdpath "config"
DATA_PATH = vim.fn.stdpath "data"
CACHE_PATH = vim.fn.stdpath "cache"
TERMINAL = vim.fn.expand "$TERMINAL"
USER = vim.fn.expand "$USER"

P = function(v)
  print(vim.inspect(v))
  return v
end

R = function(name)
  require("plenary.reload").reload_module(name)
  return require(name)
end

JM = {}

function JM.mapper(mode, is_noremap)
  is_noremap = is_noremap or true
  local map_opts = { noremap = is_noremap, silent = true }

  return function(key, rhs)
    vim.api.nvim_set_keymap(mode, key, rhs, map_opts)
  end
end

function JM.notify(message, level, title)
  local status_ok, notify = pcall(require, "notify")
  if not status_ok then
    return
  end
  level = level or "error"

  notify(message, level, { title = title or "Dependecy Error" })
end
