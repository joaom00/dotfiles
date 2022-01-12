local M = {}

local null_ls = require "null-ls"
local services = require "lsp.null-ls.services"

local METHOD = null_ls.methods.CODE_ACTION

local is_registered = function(name)
  local query = {
    name = name,
    method = METHOD,
  }
  return require("null-ls.sources").is_registered(query)
end

function M.list_registered(filetype)
  local registered_providers = services.list_registered_providers_names(filetype)
  return registered_providers[METHOD] or {}
end

function M.list_configured(actions_configs)
  local actors, errors = {}, {}

  for _, config in ipairs(actions_configs) do
    vim.validate {
      ["config.name"] = { config.name, "string" },
    }

    local name = config.name:gsub("-", "_")
    local actor = null_ls.builtins.code_actions[name]

    if not actor then
      JM.notify("Not a valid code_actions: " .. config.name)
      errors[name] = {} -- Add data here when necessary
    elseif is_registered(config.name) then
      vim.notify("Skipping registering  the source more than once", vim.log.levels.TRACE)
    else
      local command
      if actor._opts.command then
        command = services.find_command(actor._opts.command)
      end
      if not command and actor._opts.command ~= nil then
        -- JM.notify("Not found: " .. actor._opts.command)
        errors[name] = {} -- Add data here when necessary
      else
        table.insert(
          actors,
          actor.with {
            command = command, -- could be nil
            extra_args = config.args,
            filetypes = config.filetypes,
          }
        )
      end
    end
  end

  return { supported = actors, unsupported = errors }
end

function M.setup(actions_configs)
  if vim.tbl_isempty(actions_configs) then
    return
  end

  local actions = M.list_configured(actions_configs)
  null_ls.register { sources = actions.supported }
end

return M
