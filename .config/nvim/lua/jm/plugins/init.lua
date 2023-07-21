local fn = vim.fn
local fmt = string.format
local ui = jm.ui
local border = ui.current.border
local highlight = jm.highlight

return {
  "nvim-lua/plenary.nvim", -- THE LIBRARY
  "nvim-tree/nvim-web-devicons",
  -----------------------------------------------------------------------------//
  -- LSP,Completion & Debugger {{{1
  -----------------------------------------------------------------------------//
  "onsails/lspkind.nvim",
  "b0o/schemastore.nvim",
  {
    {
      "williamboman/mason.nvim",
      cmd = "Mason",
      opts = { ui = { border = border, height = 0.8 } },
    },
    {
      "williamboman/mason-lspconfig.nvim",
      event = { "BufReadPre", "BufNewFile" },
      dependencies = {
        "mason.nvim",
        {
          "neovim/nvim-lspconfig",
          config = function()
            require("lspconfig.ui.windows").default_options.border = border
          end,
        },
      },
      config = function()
        require("mason-lspconfig").setup { automatic_installation = true }
        require("mason-lspconfig").setup_handlers {
          function(name)
            local config = require "jm.servers"(name)
            if config then
              require("lspconfig")[name].setup(config)
            end
          end,
        }
      end,
    },
  },
  {
    "folke/todo-comments.nvim",
    event = "VeryLazy",
    dependencies = { "nvim-treesitter/nvim-treesitter" },
    config = function()
      require("todo-comments").setup()
    end,
  },
  {
    "windwp/nvim-autopairs",
    event = "InsertEnter",
    dependencies = { "hrsh7th/nvim-cmp" },
    config = function()
      local autopairs = require "nvim-autopairs"
      local Rule = require "nvim-autopairs.rule"
      local cmp_autopairs = require "nvim-autopairs.completion.cmp"
      require("cmp").event:on("confirm_done", cmp_autopairs.on_confirm_done())
      autopairs.setup {
        close_triple_quotes = true,
        check_ts = true,
        fast_wrap = { map = "<c-e>" },
        ts_config = {
          lua = { "string" },
          dart = { "string" },
          javascript = { "template_string" },
        },
      }
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
    lazy = false,
    dependencies = { "nvim-lua/plenary.nvim", "neovim/nvim-lspconfig" },
    opts = {
      settings = {
        tsserver_file_preferences = {
          includeInlayParameterNameHints = "literal",
          includeInlayParameterNameHintsWhenArgumentMatchesName = false,
          includeInlayVariableTypeHintsWhenTypeMatchesName = false,
          includeInlayFunctionParameterTypeHints = true,
          includeInlayVariableTypeHints = true,
          includeInlayFunctionLikeReturnTypeHints = false,
          includeInlayPropertyDeclarationTypeHints = true,
          includeInlayEnumMemberValueHints = true,
        },
      },
    },
  },
  {
    "numToStr/Comment.nvim",
    keys = { "gcc", { "gc", mode = { "x", "n", "o" } } },
    opts = function(_, opts)
      local ok, integration = pcall(require, "ts_context_commentstring.integrations.comment_nvim")
      if ok then
        opts.pre_hook = integration.create_pre_hook()
      end
    end,
  },
  { "andweeb/presence.nvim", lazy = false, enabled = false },
  {
    "smjonas/inc-rename.nvim",
    opts = { hl_group = "Visual", preview_empty_name = true },
    keys = {
      {
        "rn",
        function()
          return ":IncRename " .. fn.expand "<cword>"
        end,
        expr = true,
        silent = false,
        desc = "lsp: incremental rename",
      },
    },
  },
  {
    "lvimuser/lsp-inlayhints.nvim",
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
    "zbirenbaum/neodim",
    event = "LspAttach",
    opts = function()
      highlight.plugin("neodim", { { TSVariable = { fg = { from = "Normal" } } } })
      -- don't use opts here as the value of highlight.get needs to be evaluated later
      require("neodim").setup {
        alpha = 0.45,
        blend_color = highlight.get("Normal", "bg"),
        update_in_insert = { enable = true, delay = 200 },
      }
    end,
  },
  {
    "kevinhwang91/nvim-bqf",
    ft = "qf",
    config = function()
      highlight.plugin("bqf", { { BqfPreviewBorder = { fg = { from = "Comment" } } } })
    end,
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
    "SmiteshP/nvim-navic",
    dependencies = { "neovim/nvim-lspconfig" },
    config = function()
      vim.g.navic_silence = true
      local misc = ui.icons.misc

      highlight.plugin("navic", {
        { NavicText = { bold = true } },
        { NavicSeparator = { link = "Directory" } },
      })
      local icons = jm.map(function(icon, key)
        highlight.set(fmt("NavicIcons%s", key), { link = ui.lsp.highlights[key] })
        return icon .. " "
      end, ui.current.lsp_icons)

      require("nvim-navic").setup {
        icons = icons,
        highlight = true,
        depth_limit_indicator = misc.ellipsis,
        separator = (" %s "):format(misc.arrow_right),
      }
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
}
