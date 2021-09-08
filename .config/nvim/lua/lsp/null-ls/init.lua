local M = {}

function M.list_supported_provider_names(filetype)
  local names = {}

  local formatters = require "lsp.null-ls.formatters"
  local linters = require "lsp.null-ls.linters"

  vim.list_extend(names, formatters.list_supported_names(filetype))
  vim.list_extend(names, linters.list_supported_names(filetype))

  return names
end

function M.list_unsupported_provider_names(filetype)
  local names = {}

  local formatters = require "lsp.null-ls.formatters"
  local linters = require "lsp.null-ls.linters"

  vim.list_extend(names, formatters.list_unsupported_names(filetype))
  vim.list_extend(names, linters.list_unsupported_names(filetype))

  return names
end

function M.setup(filetype, options)
  options = options or {}

  local status_ok, _ = pcall(require, "null-ls")
  if not status_ok then
    JM.notify("Missing null-ls dependency")
    return
  end

  local formatters = require "lsp.null-ls.formatters"
  local linters = require "lsp.null-ls.linters"

  formatters.setup(filetype, options)
  linters.setup(filetype, options)
end

return M
