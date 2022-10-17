local ok, plenary_reload = pcall(require, "plenary.reload")
if not ok then
  RELOADER = require
else
  RELOADER = plenary_reload.reload_module
end

CONFIG_PATH = vim.fn.stdpath "config"
DATA_PATH = vim.fn.stdpath "data"
CACHE_PATH = vim.fn.stdpath "cache"
TERMINAL = vim.fn.expand "$TERMINAL"
USER = vim.fn.expand "$USER"

P = function(v)
  print(vim.inspect(v))
  return v
end

RELOAD = function(...)
  return RELOADER(...)
end

R = function(name)
  RELOAD(name)
  return require(name)
end

JM = {}

local function make_mapper(mode, o)
  local parent_opts = vim.deepcopy(o)

  return function(lhs, rhs, opts)
    opts = type(opts) == "string" and { desc = opts } or opts and vim.deepcopy(opts) or {}
    vim.keymap.set(mode, lhs, rhs, vim.tbl_extend("keep", opts, parent_opts))
  end
end

local map_opts = { remap = true, silent = true }
local noremap_opts = { silent = true }

JM.nmap = make_mapper("n", map_opts)
JM.xmap = make_mapper("x", map_opts)
JM.imap = make_mapper("i", map_opts)
JM.vmap = make_mapper("v", map_opts)
JM.omap = make_mapper("o", map_opts)
JM.tmap = make_mapper("t", map_opts)
JM.smap = make_mapper("s", map_opts)
JM.cmap = make_mapper("c", { remap = true, silent = false })
JM.nnoremap = make_mapper("n", noremap_opts)
JM.xnoremap = make_mapper("x", noremap_opts)
JM.inoremap = make_mapper("i", noremap_opts)
JM.vnoremap = make_mapper("v", noremap_opts)
JM.onoremap = make_mapper("o", noremap_opts)
JM.tnoremap = make_mapper("t", noremap_opts)
JM.snoremap = make_mapper("s", noremap_opts)
JM.cnoremap = make_mapper("c", { silent = false })

function JM.mapper(mode, is_noremap)
  is_noremap = is_noremap or true
  local parent_opts = { noremap = is_noremap, silent = true }

  return function(key, rhs)
    vim.api.nvim_set_keymap(mode, key, rhs, parent_opts)
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
