local M = {}

function M.setup()
  local config = { -- your config
    virtual_text = JM.lsp.diagnostics.virtual_text,
    signs = JM.lsp.diagnostics.signs,
    underline = JM.lsp.diagnostics.underline,
    update_in_insert = JM.lsp.diagnostics.update_in_insert,
    severity_sort = JM.lsp.diagnostics.severity_sort,
    float = JM.lsp.diagnostics.float,
  }
  vim.diagnostic.config(config)
  vim.lsp.handlers["textDocument/hover"] = vim.lsp.with(vim.lsp.handlers.hover, JM.lsp.float)
  vim.lsp.handlers["textDocument/signatureHelp"] = vim.lsp.with(vim.lsp.handlers.signature_help, JM.lsp.float)
end

return M
