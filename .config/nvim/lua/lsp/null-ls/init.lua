local M = {}

local lsp_formatting = function(bufnr)
  vim.lsp.buf.format {
    filter = function(client)
      -- apply whatever logic you want (in this example, we'll only use null-ls)
      return client.name == "null-ls"
    end,
    bufnr = bufnr,
  }
end

local augroup = vim.api.nvim_create_augroup("LspFormatting", {})

function M.setup()
  local status_ok, null_ls = pcall(require, "null-ls")
  if not status_ok then
    return
  end

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
    formatting.sql_formatter,

    -- DIAGNOSTICS
    --   diagnostics.golangci_lint.with {
    --     command = install_root_dir .. "/golangci_lint_ls/golangci-lint",
    -- },
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
      if client.supports_method "textDocument/formatting" then
        vim.api.nvim_clear_autocmds { group = augroup, buffer = bufnr }
        vim.api.nvim_create_autocmd("BufWritePre", {
          group = augroup,
          buffer = bufnr,
          callback = function()
            lsp_formatting(bufnr)
          end,
        })
      end
    end,
  }

  null_ls.setup(cfg)
end

return M
