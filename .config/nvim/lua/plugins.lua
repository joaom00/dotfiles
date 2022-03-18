local fn = vim.fn
local install_path = fn.stdpath "data" .. "/site/pack/packer/start/packer.nvim"
local packer_bootstrap
if fn.empty(fn.glob(install_path)) > 0 then
  packer_bootstrap = fn.system {
    "git",
    "clone",
    "--depth",
    "1",
    "https://github.com/wbthomason/packer.nvim",
    install_path,
  }
end

return require("packer").startup(function(use)
  use { "wbthomason/packer.nvim" }

  -- DEPS
  use { "tami5/sql.nvim" }
  use { "nvim-lua/popup.nvim" }
  use { "nvim-lua/plenary.nvim" }
  use { "rktjmp/lush.nvim" }

  -- DASHBOARD
  use {
    "glepnir/dashboard-nvim",
    event = "BufWinEnter",
    config = function()
      require("jm.dashboard").setup()
    end,
  }

  -- LSP
  use { "neovim/nvim-lspconfig" }
  use { "tamago324/nlsp-settings.nvim" }
  use {
    "ray-x/lsp_signature.nvim",
    config = function()
      require("jm.lsp_signature").setup()
    end,
  }
  use { "williamboman/nvim-lsp-installer" }

  -- TREESITTER
  use {
    "nvim-treesitter/nvim-treesitter",
    run = ":TSUpdate",
    config = function()
      require("jm.treesitter").setup()
    end,
  }
  use { "nvim-treesitter/playground", event = "BufRead" }

  -- AUTOCOMPLETE
  use {
    "hrsh7th/nvim-cmp",
    config = function()
      require("jm.cmp").setup()
    end,
    requires = {
      { "hrsh7th/cmp-buffer" },
      { "hrsh7th/cmp-path" },
      { "hrsh7th/cmp-nvim-lsp" },
      { "hrsh7th/cmp-nvim-lua" },
      { "saadparwaiz1/cmp_luasnip" },
      { "hrsh7th/cmp-cmdline" },
    },
  }
  use {
    "petertriho/cmp-git",
    after = "nvim-cmp",
    config = function()
      require("cmp_git").setup {
        filetypes = { "gitcommit", "COMMIT_EDITMSG" },
      }
    end,
  }
  use { "onsails/lspkind-nvim" }

  use {
    "L3MON4D3/LuaSnip",
    config = function()
      require "jm.luasnip"
    end,
  }

  -- FORMATTER & LINTER
  use { "jose-elias-alvarez/null-ls.nvim" }

  -- TELESCOPE
  use {
    "nvim-telescope/telescope.nvim",
    config = function()
      require "jm.telescope"
    end,
  }
  use { "nvim-telescope/telescope-fzf-native.nvim", run = "make" }
  use { "nvim-telescope/telescope-fzf-writer.nvim" }
  use { "nvim-telescope/telescope-frecency.nvim" }
  use {
    "ahmedkhalf/project.nvim",
    config = function()
      require("project_nvim").setup()
    end,
  }
  use { "nvim-telescope/telescope-file-browser.nvim" }
  use {
    "da-moon/telescope-toggleterm.nvim",
    event = "TermOpen",
    config = function()
      require("telescope").load_extension "toggleterm"
    end,
  }

  -- TROUBE
  use {
    "folke/trouble.nvim",
    config = function()
      require("trouble").setup()
    end,
  }

  -- TODO
  use {
    "folke/todo-comments.nvim",
    config = function()
      require("todo-comments").setup()
    end,
  }

  -- GIT
  use { "TimUntersberger/neogit" }
  use {
    "pwntester/octo.nvim",
    event = "BufRead",
    config = function()
      require("jm.octo").setup()
    end,
  }
  use {
    "sindrets/diffview.nvim",
    event = "BufRead",
    config = function()
      require("jm.diffview").setup()
    end,
  }
  use {
    "lewis6991/gitsigns.nvim",
    config = function()
      require("jm.gitsigns").setup()
    end,
  }
  use { "ThePrimeagen/git-worktree.nvim" }

  -- DEBUGGING
  use { "mfussenegger/nvim-dap" }
  use {
    "leoluz/nvim-dap-go",
    config = function()
      require("dap-go").setup()
    end,
  }
  use {
    "rcarriga/nvim-dap-ui",
    config = function()
      require("dapui").setup()
    end,
  }
  use { "theHamsta/nvim-dap-virtual-text" }
  use { "nvim-telescope/telescope-dap.nvim" }

  -- TERMINAL
  use {
    "akinsho/nvim-toggleterm.lua",
    event = "BufWinEnter",
    config = function()
      require("jm.toggleterm").setup()
    end,
  }

  -- FILE EXPLORER
  use {
    "kyazdani42/nvim-tree.lua",
    config = function()
      require("jm.nvimtree").setup()
    end,
  }
  use {
    "ahmedkhalf/lsp-rooter.nvim",
    config = function()
      require("lsp-rooter").setup()
    end,
  }

  -- STATUS LINE & BUFFERLINE
  use {
    "nvim-lualine/lualine.nvim",
    config = function()
      require("jm.lualine").setup()
    end,
  }
  use {
    "akinsho/nvim-bufferline.lua",
    event = "BufWinEnter",
    config = function()
      require("jm.bufferline").setup()
    end,
  }

  -- MARKDOWN PREVIEW
  use { "iamcco/markdown-preview.nvim", run = "cd app && npm install", ft = "markdown" }

  -- GO
  use {
    "ray-x/go.nvim",
    ft = "go",
    config = function()
      require("go").setup()
    end,
  }
  use { "b0o/schemastore.nvim" }

  -- THEMES & UI
  use { "Shadorain/shadotheme" }
  use { "folke/tokyonight.nvim" }
  use { "arzg/vim-colors-xcode" }
  use { "pwntester/nautilus.nvim" }
  use {
    "catppuccin/nvim",
    as = "catppuccin",
  }
  use { "tjdevries/gruvbuddy.nvim", requires = {
    { "tjdevries/colorbuddy.vim" },
  } }
  use {
    "NvChad/nvim-base16.lua",
    config = function()
      require("colors").init()
    end,
    disable = true,
  }
  use {
    "kyazdani42/nvim-web-devicons",
    config = function()
      require("jm.icons").setup()
    end,
  }

  -- UTILS
  use { "windwp/nvim-ts-autotag", event = "InsertEnter" }
  use { "JoosepAlviste/nvim-ts-context-commentstring" }
  use { "p00f/nvim-ts-rainbow" }
  use {
    "numToStr/Comment.nvim",
    event = "BufRead",
    config = function()
      require("jm.comment").setup()
    end,
  }
  use {
    "windwp/nvim-autopairs",
    after = "nvim-cmp",
    config = function()
      require("jm.autopairs").setup()
    end,
  }
  use {
    "norcalli/nvim-colorizer.lua",
    config = function()
      require("jm.colorizer").setup()
    end,
  }
  use {
    "lukas-reineke/indent-blankline.nvim",
    config = function()
      require("jm.blankline").setup()
    end,
  }
  use {
    "lukas-reineke/headlines.nvim",
    config = function()
      require("jm.headlines").setup()
    end,
  }
  use {
    "karb94/neoscroll.nvim",
    config = function()
      require("jm.neoscroll").setup()
    end,
  }
  use {
    "rcarriga/nvim-notify",
    config = function()
      require("notify").setup { timeout = 3000 }
    end,
  }
  use { "rlch/github-notifications.nvim" }
  use {
    "phaazon/hop.nvim",
    branch = "v1", -- optional but strongly recommended
    config = function()
      -- you can configure Hop the way you like here; see :h hop-config
      -- require("hop").setup { keys = "etovxqpdygfblzhckisuran" }
      require "jm.hop"
    end,
  }
  use {
    "abecodes/tabout.nvim",
    wants = { "nvim-treesitter" },
    after = { "nvim-cmp" },
    config = function()
      require("tabout").setup {
        tabkey = "<c-o>",
        ignore_beginning = false,
      }
    end,
  }
  use { "pantharshit00/vim-prisma" }
  use {
    "vuki656/package-info.nvim",
    requires = "MunifTanjim/nui.nvim",
    config = function()
      require("package-info").setup {
        autostart = false,
      }
    end,
  }
  use { "rhysd/committia.vim" }
  use {
    "simrat39/rust-tools.nvim",
    config = function()
      local opts = {
        tools = { -- rust-tools options
          autoSetHints = true,
          hover_with_actions = true,
          inlay_hints = {
            show_parameter_hints = false,
            parameter_hints_prefix = "",
            other_hints_prefix = "",
          },
        },

        -- all the opts to send to nvim-lspconfig
        -- these override the defaults set by rust-tools.nvim
        -- see https://github.com/neovim/nvim-lspconfig/blob/master/doc/server_configurations.md#rust_analyzer
        server = {
          -- on_attach is a callback called when the language server attachs to the buffer
          -- on_attach = on_attach,
          settings = {
            -- to enable rust-analyzer settings visit:
            -- https://github.com/rust-analyzer/rust-analyzer/blob/master/docs/user/generated_config.adoc
            ["rust-analyzer"] = {
              -- enable clippy on save
              checkOnSave = {
                command = "clippy",
              },
            },
          },
        },
      }
      require("rust-tools").setup()
    end,
  }

  use { "tpope/vim-surround" }

  use { "~/dev/omni.nvim" }
  use { "~/dev/404.nvim" }
  use { "~/dev/telescope-twitch.nvim" }

  if packer_bootstrap then
    require("packer").sync()
  end
end)
