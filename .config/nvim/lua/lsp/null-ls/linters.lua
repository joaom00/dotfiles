local M = {}
local linters_by_ft = {}

local null_ls = require("null-ls")
local services = require("lsp.null-ls.services")

local function list_names(linters, options)
  options = options or {}
  local filter = options.filter or "supported"

  return vim.tbl_keys(linters[filter])
end

function M.list_supported_names(filetype)
  if not linters_by_ft[filetype] then return {} end
  return list_names(linters_by_ft[filetype], {filter = "supported"})
end

function M.list_unsupported_names(filetype)
  if not linters_by_ft[filetype] then return {} end
  return list_names(linters_by_ft[filetype], {filter = "unsupported"})
end

function M.list_available(filetype)
  local linters = {}
  for _, provider in pairs(null_ls.builtins.diagnostics) do
    if vim.tbl_contains(provider.filetypes or {}, filetype) then table.insert(linters, provider.name) end
  end

  return linters
end

function M.list_configured(linter_configs)
  local linters, errors = {}, {}

  for _, lnt_config in pairs(linter_configs) do
    local linter = null_ls.builtins.diagnostics[lnt_config.exe]

    if not linter then
      JM.notify("Not a valid linter: " .. lnt_config.exe, "error", "Null-ls")
      errors[lnt_config.exe] = {} -- Add data here when necessary
    else
      local linter_cmd = services.find_command(linter._opts.command)
      if not linter_cmd then
        JM.notify("Not found: " .. linter._opts.command, "warn", "Null-ls")
        errors[lnt_config.exe] = {} -- Add data here when necessary
      else
        JM.notify("Using linter: " .. linter_cmd, "info", "Null-ls")
        linters[lnt_config.exe] = linter.with {command = linter_cmd, extra_args = lnt_config.args}
      end
    end
  end

  return {supported = linters, unsupported = errors}
end

function M.setup(filetype, options)
  if not JM.lang[filetype] or (linters_by_ft[filetype] and not options.force_reload) then return end

  linters_by_ft[filetype] = M.list_configured(JM.lang[filetype].linters)
  null_ls.register {sources = linters_by_ft[filetype].supported}
end

return M
