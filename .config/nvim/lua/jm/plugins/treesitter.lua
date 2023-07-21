local highlight = jm.highlight

return {
  {
    "nvim-treesitter/nvim-treesitter",
    event = "VeryLazy",
    build = ":TSUpdate",
    dependencies = {
      { "nvim-treesitter/nvim-treesitter-textobjects" },
    },
    config = function()
      require("nvim-treesitter.configs").setup {
        ensure_installed = {
          "lua",
          "javascript",
          "typescript",
          "tsx",
          "go",
          "rust",
          "yaml",
          "vim",
          "prisma",
          "markdown",
          "json",
          "html",
          "gomod",
          "dockerfile",
          "css",
        },
        auto_install = true,
        highlight = { enable = true },
        indent = { enable = true },
        incremental_selection = {
          enable = true,
          keymaps = {
            init_selection = "<c-space>",
            node_incremental = "<c-space>",
            scope_incremental = "<c-a>",
            node_decremental = "<c-backspace>",
          },
        },
        autopairs = { enable = true },
        context_commentstring = { enable = true },
        playground = {
          enable = true,
          disable = {},
          updatetime = 25,
          persist_queries = false,
          keybindings = {
            toggle_query_editor = "o",
            toggle_hl_groups = "i",
            toggle_injected_languages = "t",
            toggle_anonymous_nodes = "a",
            toggle_language_display = "I",
            focus_language = "f",
            unfocus_language = "F",
            update = "R",
            goto_node = "<cr>",
            show_help = "?",
          },
        },
      }
    end,
  },
  { "JoosepAlviste/nvim-ts-context-commentstring" },
  {
    "windwp/nvim-ts-autotag",
    lazy = false,
    ft = { "typescriptreact", "javascript", "javascriptreact", "html", "tsx" },
    dependencies = { "nvim-treesitter/nvim-treesitter" },
    config = true,
  },
  {
    "nvim-treesitter/playground",
    cmd = { "TSPlaygroundToggle" },
    dependencies = { "nvim-treesitter" },
  },
  {
    "nvim-treesitter/nvim-treesitter-context",
    event = "VeryLazy",
    init = function()
      highlight.plugin("treesitter-context", {
        { TreesitterContextSeparator = { link = "Dim" } },
        { TreesitterContext = { inherit = "Normal" } },
        { TreesitterContextLineNumber = { inherit = "LineNr" } },
      })
    end,
    opts = {
      multiline_threshold = 4,
      separator = "─", -- alternatives: ▁ ─ ▄
      mode = "cursor",
    },
  },
}
