local api, fn = vim.api, vim.fn
local fmt = string.format
local l = vim.log.levels

local plenary_ok, plenary_reload = pcall(require, "plenary.reload")
if not plenary_ok then
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

--- Convert a list or map of items into a value by iterating all it's fields and transforming
--- them with a callback
---@generic T : table
---@param callback fun(T, T, key: string | number): T
---@param list T[]
---@param accum T?
---@return T
function jm.fold(callback, list, accum)
  accum = accum or {}
  for k, v in pairs(list) do
    accum = callback(accum, v, k)
    assert(accum ~= nil, "The accumulator must be returned on each iteration")
  end
  return accum
end

---@generic T : table
---@param callback fun(item: T, key: string | number, list: T[]): T
---@param list T[]
---@return T[]
function jm.map(callback, list)
  return jm.fold(function(accum, v, k)
    accum[#accum + 1] = callback(v, k, accum)
    return accum
  end, list, {})
end

---@generic T : table
---@param callback fun(T, key: string | number)
---@param list T[]
function jm.foreach(callback, list)
  for k, v in pairs(list) do
    callback(v, k)
  end
end

---Require a module using `pcall` and report any errors
---@param module string
---@param opts {silent: boolean, message: string}?
---@return boolean, any
function jm.require(module, opts)
  opts = opts or { silent = false }
  local ok, result = pcall(require, module)
  if not ok and not opts.silent then
    if opts.message then
      result = opts.message .. "\n" .. result
    end
    vim.notify(result, l.ERROR, { title = fmt("Error requiring: %s", module) })
  end
  return ok, result
end

local function validate_autocmd(name, cmd)
  local keys = { "event", "buffer", "pattern", "desc", "command", "group", "once", "nested" }
  local incorrect = jm.fold(function(accum, _, key)
    if not vim.tbl_contains(keys, key) then
      table.insert(accum, key)
    end
    return accum
  end, cmd, {})
  if #incorrect == 0 then
    return
  end
  vim.schedule(function()
    vim.notify("Incorrect keys: " .. table.concat(incorrect, ", "), "error", {
      title = fmt("Autocmd: %s", name),
    })
  end)
end

---Create an autocommand
---returns the group ID so that it can be cleared or manipulated.
---@param name string The name of the autocommand group
---@param ... Autocommand A list of autocommands to create
---@return number
function jm.augroup(name, ...)
  local commands = { ... }
  assert(name ~= "User", "The name of an augroup CANNOT be User")
  assert(#commands > 0, fmt("You must specify at least one autocommand for %s", name))
  local id = api.nvim_create_augroup(name, { clear = true })
  for _, autocmd in ipairs(commands) do
    validate_autocmd(name, autocmd)
    local is_callback = type(autocmd.command) == "function"
    api.nvim_create_autocmd(autocmd.event, {
      group = name,
      pattern = autocmd.pattern,
      desc = autocmd.desc,
      callback = is_callback and autocmd.command or nil,
      command = not is_callback and autocmd.command or nil,
      once = autocmd.once,
      nested = autocmd.nested,
      buffer = autocmd.buffer,
    })
  end
  return id
end

function jm.command(name, rhs, opts)
  opts = opts or {}
  api.nvim_create_user_command(name, rhs, opts)
end

---------------------------------------------------------------------------------
-- Toggle list
---------------------------------------------------------------------------------
--- Utility function to toggle the location or the quickfix list
---@param list_type '"quickfix"' | '"location"'
---@return string?
local function toggle_list(list_type)
  local is_location_target = list_type == "location"
  local cmd = is_location_target and { "lclose", "lopen" } or { "cclose", "copen" }
  local is_open = jm.is_vim_list_open()
  if is_open then
    return vim.cmd[cmd[1]]()
  end
  local list = is_location_target and fn.getloclist(0) or fn.getqflist()
  if vim.tbl_isempty(list) then
    local msg_prefix = (is_location_target and "Location" or "QuickFix")
    return vim.notify(msg_prefix .. " List is Empty.", vim.log.levels.WARN)
  end

  local winnr = fn.winnr()
  vim.cmd[cmd[2]]()
  if fn.winnr() ~= winnr then
    vim.cmd.wincmd "p"
  end
end

function jm.toggle_qf_list()
  toggle_list "quickfix"
end
function jm.toggle_loc_list()
  toggle_list "location"
end

---Check whether or not the location or quickfix list is open
---@return boolean
function jm.is_vim_list_open()
  for _, win in ipairs(api.nvim_list_wins()) do
    local buf = api.nvim_win_get_buf(win)
    local location_list = fn.getloclist(0, { filewinid = 0 })
    local is_loc_list = location_list.filewinid > 0
    if vim.bo[buf].filetype == "qf" or is_loc_list then
      return true
    end
  end
  return false
end

--- Call the given function and use `vim.notify` to notify of any errors
--- this function is a wrapper around `xpcall` which allows having a single
--- error handler for all errors
---@param msg string
---@param func function
---@vararg any
---@return boolean, any
---@overload fun(fun: function, ...): boolean, any
function jm.wrap_err(msg, func, ...)
  local args = { ... }
  if type(msg) == "function" then
    args, func, msg = { func, unpack(args) }, msg, nil
  end
  return xpcall(func, function(err)
    msg = msg and fmt("%s:\n%s", msg, err) or err
    vim.schedule(function()
      vim.notify(msg, l.ERROR, { title = "ERROR" })
    end)
  end, unpack(args))
end

---Determine if a value of any type is empty
---@param item any
---@return boolean?
function jm.empty(item)
  if not item then
    return true
  end
  local item_type = type(item)
  if item_type == "string" then
    return item == ""
  end
  if item_type == "number" then
    return item <= 0
  end
  if item_type == "table" then
    return vim.tbl_isempty(item)
  end
  return item ~= nil
end

---@generic T
---Given a table return a new table which if the key is not found will search
---all the table's keys for a match using `string.match`
---@param map T
---@return T
function jm.p_table(map)
  return setmetatable(map, {
    __index = function(tbl, key)
      if not key then
        return
      end
      for k, v in pairs(tbl) do
        if key:match(k) then
          return v
        end
      end
    end,
  })
end

---check if a certain feature/version/commit exists in nvim
---@param feature string
---@return boolean
function jm.has(feature)
  return fn.has(feature) > 0
end
