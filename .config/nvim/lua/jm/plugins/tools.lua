return {
  {
    "stevearc/conform.nvim",
    event = "BufReadPre",
    -- opts = {
    --   formatters_by_ft = {
    --     lua = { "stylua" },
    --     css = { "prettier" },
    --     javascript = { "prettier", "eslint" },
    --     typescript = { "prettier", "eslint" },
    --     typescriptreact = { "prettier", "eslint" },
    --     python = { "isort", "black" },
    --     markdown = { "prettierd" },
    --     go = { "goimports", "gofumpt" },
    --   },
    --   format_on_save = function(buf)
    --     if vim.g.formatting_disabled or vim.b[buf].formatting_disabled then
    --       return
    --     end
    --     return { timeout_ms = 500, lsp_fallback = true }
    --   end,
    -- },
    config = function()
      -- require("conform.formatters.eslint").cwd = require("conform.util").root_file {
      --   ".eslint.js",
      --   ".eslint.cjs",
      --   ".eslint.yaml",
      --   ".eslint.yml",
      --   ".eslint.json",
      -- }
      -- require("conform.formatters.eslint").require_cwd = true
      require("conform").setup {
        formatters_by_ft = {
          lua = { "stylua" },
          css = { "prettier" },
          javascript = { "prettier" },
          typescript = { "prettier" },
          typescriptreact = { "prettier" },
          python = { "isort", "black" },
          markdown = { "prettierd" },
          go = { "goimports", "gofumpt" },
        },
        format_on_save = function(buf)
          if vim.g.formatting_disabled or vim.b[buf].formatting_disabled then
            return
          end
          return { timeout_ms = 500, lsp_fallback = true }
        end,
        formatters = {
          eslint = {
            require_cwd = true,
            cwd = require("conform.util").root_file {
              ".eslintrc.js",
              ".eslintrc.cjs",
            },
          },
        },
      }
    end,
  },
  {
    "mfussenegger/nvim-lint",
    enabled = true,
    event = "BufReadPre",
    init = function()
      vim.api.nvim_create_autocmd({ "BufWritePost" }, {
        callback = function()
          require("lint").try_lint()
        end,
      })
    end,
    config = function()
      local lint = require "lint"
      local pylint = lint.linters.pylint
      pylint.args = {
        "--load-plugins",
        "pylint_django",
        "--load-plugins",
        "pylint_django.checkers.migrations",
        "-f",
        "json",
        "--init-hook",
      }
      require("lint").linters_by_ft = {
        javascript = { "eslint" },
        typescript = { "eslint" },
        typescriptreact = { "eslint" },
        go = { "golangcilint" },
        python = { "pylint" },
        markdown = { "markdownlint" },
      }
    end,
  },
  -- {
  --   "jay-babu/mason-null-ls.nvim",
  --   event = { "BufReadPre", "BufNewFile" },
  --   dependencies = {
  --     "williamboman/mason.nvim",
  --     "nvimtools/none-ls.nvim",
  --   },
  --   config = function()
  --     require("mason").setup()
  --     require("mason-null-ls").setup {
  --       automatic_installation = true,
  --       ensure_installed = { "goimports", "golangci_lint", "stylua", "prettierd", "pyright", "mypy", "ruff", "eslint" },
  --     }
  --     local null_ls = require "null-ls"
  --     local package_json_action = {
  --       method = null_ls.methods.CODE_ACTION,
  --       filetypes = { "json" },
  --       generator = {
  --         fn = function()
  --           return {
  --             {
  --               title = "Show latest versions",
  --               action = function()
  --                 require("package-info").show()
  --               end,
  --             },
  --             {
  --               title = "Change package version",
  --               action = function()
  --                 require("package-info").change_version()
  --               end,
  --             },
  --             {
  --               title = "Install package",
  --               action = function()
  --                 require("package-info").install()
  --               end,
  --             },
  --             {
  --               title = "Delete package",
  --               action = function()
  --                 require("package-info").delete()
  --               end,
  --             },
  --           }
  --         end,
  --       },
  --     }
  --     null_ls.register(package_json_action)
  --     null_ls.setup()
  --   end,
  -- },
}
