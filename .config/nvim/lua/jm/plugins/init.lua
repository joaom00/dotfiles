local fn = vim.fn
local ui = jm.ui
local border = ui.current.border

return {
  "nvim-lua/plenary.nvim", -- THE LIBRARY
  "nvim-tree/nvim-web-devicons",
  -----------------------------------------------------------------------------//
  -- LSP,Completion & Debugger {{{1
  -----------------------------------------------------------------------------//
  "onsails/lspkind.nvim",
  "b0o/schemastore.nvim",
  {
    "folke/todo-comments.nvim",
    cmd = { "TodoTrouble", "TodoTelescope" },
    event = { "BufReadPost", "BufNewFile" },
    config = true,
  },
  {
    "echasnovski/mini.pairs",
    version = "*",
    event = "VeryLazy",
    config = function()
      require("mini.pairs").setup()
    end,
  },
  {
    "karb94/neoscroll.nvim", -- NOTE: alternative: 'declancm/cinnamon.nvim'
    event = "VeryLazy",
    opts = {
      mappings = { "<C-d>", "<C-u>", "<C-y>", "zt", "zz", "zb" },
      hide_cursor = true,
    },
  },
  {
    "pmizio/typescript-tools.nvim",
    event = "VeryLazy",
    enabled = false,
    dependencies = { "nvim-lua/plenary.nvim", "neovim/nvim-lspconfig" },
    opts = {
      settings = {
        expose_as_code_action = { "add_missing_imports", "fix_all", "remove_unused" },
      },
    },
  },
  { "JoosepAlviste/nvim-ts-context-commentstring", lazy = true },
  {
    "echasnovski/mini.comment",
    event = "VeryLazy",
    opts = {
      options = {
        custom_commentstring = function()
          return require("ts_context_commentstring.internal").calculate_commentstring() or vim.bo.commentstring
        end,
      },
    },
  },
  {
    "smjonas/inc-rename.nvim",
    event = "VeryLazy",
    config = function()
      require("inc_rename").setup {}
      vim.keymap.set("n", "rn", function()
        return ":IncRename " .. vim.fn.expand "<cword>"
      end, { expr = true })
    end,
  },
  {
    "lvimuser/lsp-inlayhints.nvim",
    enabled = false,
    init = function()
      jm.augroup("InlayHintsSetup", {
        event = "LspAttach",
        command = function(args)
          local id = vim.tbl_get(args, "data", "client_id") --[[@as lsp.Client]]
          if not id then
            return
          end
          local client = vim.lsp.get_client_by_id(id)
          require("lsp-inlayhints").on_attach(client, args.buf)
        end,
      })
    end,
    opts = {
      inlay_hints = {
        highlight = "Comment",
        labels_separator = " ⏐ ",
        parameter_hints = { prefix = "" },
        type_hints = { prefix = "=> ", remove_colon_start = true },
      },
    },
  },
  {
    "iamcco/markdown-preview.nvim",
    build = function()
      fn["mkdp#util#install"]()
    end,
    ft = { "markdown" },
    config = function()
      vim.g.mkdp_auto_start = 0
      vim.g.mkdp_auto_close = 1
    end,
  },
  {
    "kylechui/nvim-surround",
    version = "*",
    keys = { { "s", mode = "v" }, "<C-g>s", "<C-g>S", "ys", "yss", "yS", "cs", "ds" },
    opts = { move_cursor = true, keymaps = { visual = "s" } },
    config = function()
      require("nvim-surround").setup()
    end,
  },
  {
    "NvChad/nvim-colorizer.lua",
    event = "VeryLazy",
    opts = {
      user_default_options = {
        tailwind = "lsp",
      },
    },
  },
  {
    "vuki656/package-info.nvim",
    config = function()
      require("package-info").setup()
    end,
  },
}
