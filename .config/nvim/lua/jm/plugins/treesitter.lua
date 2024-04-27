return {
  {
    "nvim-treesitter/nvim-treesitter",
    build = ":TSUpdate",
    dependencies = {
      { "nvim-treesitter/nvim-treesitter-textobjects" },
    },
    config = function()
      local status, treesitter = pcall(require, "nvim-treesitter.configs")
      if not status then
        return
      end

      treesitter.setup {
        -- enable syntax highlighting
        highlight = {
          enable = true,
        },
        -- enable indentation
        indent = { enable = true },
        autotag = {
          enable = true,
        },
        -- ensure these language parsers are installed
        ensure_installed = {
          "bash",
          "css",
          "dockerfile",
          "gitignore",
          "go",
          "gomod",
          "gosum",
          "javascript",
          "json",
          "jsonc",
          "lua",
          "markdown",
          "sql",
          "toml",
          "tsx",
          "typescript",
          "yaml",
          "html",
        },
        -- auto install above language parsers
        auto_install = true,
        -- magic
        sync_install = false,
      }
    end,
  },
  {
    "windwp/nvim-ts-autotag",
    lazy = false,
    ft = { "typescriptreact", "javascript", "javascriptreact", "html", "tsx" },
    dependencies = { "nvim-treesitter/nvim-treesitter" },
    config = function()
      require("nvim-treesitter.configs").setup {
        autotag = {
          enable_close_on_slash = false,
        },
      }
    end,
  },
  {
    "nvim-treesitter/playground",
    cmd = { "TSPlaygroundToggle" },
    dependencies = { "nvim-treesitter" },
  },
  {
    "nvim-treesitter/nvim-treesitter-context",
    enabled = false,
    event = "VeryLazy",
    opts = {
      multiline_threshold = 4,
      separator = "─", -- alternatives: ▁ ─ ▄
      mode = "cursor",
    },
  },
}
