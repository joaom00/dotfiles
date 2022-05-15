local M = {}

function M.setup()
  local status_ok, null_ls = pcall(require, "null-ls")
  if not status_ok then
    return
  end

  local path = require "nvim-lsp-installer.path"
  local install_root_dir = path.concat { vim.fn.stdpath "data", "lsp_servers" }

  local formatting = null_ls.builtins.formatting
  local diagnostics = null_ls.builtins.diagnostics
  local actions = null_ls.builtins.code_actions

  local sources = {
    -- FORMATTERS
    formatting.shfmt,
    formatting.stylua,
    formatting.black,
    formatting.rustfmt,
    formatting.gofumpt,
    formatting.golines.with {
      extra_args = {
        "--max-len=160",
        "--base-formatter=gofumpt",
      },
    },
    formatting.prettierd,

    -- DIAGNOSTICS
    diagnostics.golangci_lint.with {
      command = install_root_dir .. "/golangci_lint_ls/golangci-lint",
    },
    diagnostics.golangci_lint,
    diagnostics.eslint,
    -- diagnostics.pylint,
    diagnostics.yamllint,

    -- CODE ACTIONS
    actions.eslint,
    actions.proselint,
  }

  local cfg = {
    sources = sources,
    debounce = 1000,
    default_timeout = 3000,
    fallback_severity = vim.diagnostic.severity.WARN,
    on_attach = function(client)
      if client.resolved_capabilities.document_formatting then
        vim.cmd "autocmd BufWritePre <buffer> lua vim.lsp.buf.formatting_sync()"
      end
    end,
  }

  null_ls.setup(cfg)
end

return M
