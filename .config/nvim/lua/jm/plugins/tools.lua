return {
  {
    "jose-elias-alvarez/null-ls.nvim",
    dependencies = { "nvim-lua/plenary.nvim" },
  },
  {
    "jay-babu/mason-null-ls.nvim",
    event = { "BufReadPre", "BufNewFile" },
    dependencies = { "mason.nvim", "null-ls.nvim" },
    config = function()
      require("mason-null-ls").setup {
        automatic_setup = true,
        -- automatic_installation = {},
        ensure_installed = { "goimports", "golangci_lint", "stylua", "prettierrd" },
        handlers = {},
      }
      local null_ls = require "null-ls"
      local package_json_action = {
        method = null_ls.methods.CODE_ACTION,
        filetypes = { "json" },
        generator = {
          fn = function()
            return {
              {
                title = "Show latest versions",
                action = function()
                  require("package-info").show()
                end,
              },
              {
                title = "Change package version",
                action = function()
                  require("package-info").change_version()
                end,
              },
              {
                title = "Install package",
                action = function()
                  require("package-info").install()
                end,
              },
              {
                title = "Delete package",
                action = function()
                  require("package-info").delete()
                end,
              },
            }
          end,
        },
      }
      null_ls.register(package_json_action)
      null_ls.setup()
    end,
  },
}
