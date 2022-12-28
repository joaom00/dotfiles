local utils = require "utils"
local conf = utils.conf

local ensure_packer = function()
  local fn = vim.fn
  local install_path = fn.stdpath "data" .. "/site/pack/packer/start/packer.nvim"
  if fn.empty(fn.glob(install_path)) > 0 then
    fn.system { "git", "clone", "--depth", "1", "https://github.com/wbthomason/packer.nvim", install_path }
    vim.cmd [[packadd packer.nvim]]
    return true
  end
  return false
end

local packer_bootstrap = ensure_packer()

return require("packer").startup(function(use)
  use { "wbthomason/packer.nvim" }

  -- DEPS
  use { "tami5/sql.nvim" }
  use { "nvim-lua/popup.nvim" }
  use { "nvim-lua/plenary.nvim" }
  use { "rktjmp/lush.nvim" }

  -- LSP
  use { "neovim/nvim-lspconfig" }
  use {
    "ray-x/lsp_signature.nvim",
    config = conf("lsp_signature").config,
  }
  use { "tamago324/nlsp-settings.nvim" }

  -- TREESITTER
  use {
    "nvim-treesitter/nvim-treesitter",
    run = ":TSUpdate",
    config = conf("treesitter").config,
  }
  use { "nvim-treesitter/playground", event = "BufRead" }

  -- AUTOCOMPLETE
  use {
    "hrsh7th/nvim-cmp",
    config = conf("completion").config,
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
      require("jm.snippets").setup()
    end,
  }

  -- FORMATTER & LINTER
  use { "jose-elias-alvarez/null-ls.nvim" }

  -- TERMINAL
  use {
    "akinsho/nvim-toggleterm.lua",
    event = "BufWinEnter",
    config = conf("toggleterm").config,
    setup = conf("toggleterm").setup,
  }

  -- TELESCOPE
  use {
    "nvim-telescope/telescope.nvim",
    config = function()
      require "jm.telescope"
    end,
    requires = {
      { "nvim-telescope/telescope-fzf-native.nvim", run = "make" },
      { "nvim-telescope/telescope-fzf-writer.nvim" },
      { "nvim-telescope/telescope-frecency.nvim" },
      { "nvim-telescope/telescope-file-browser.nvim" },
      { "nvim-telescope/telescope-ui-select.nvim" },
      {
        "da-moon/telescope-toggleterm.nvim",
        event = "TermOpen",
        config = function()
          require("telescope").load_extension "toggleterm"
        end,
      },
      {
        "ahmedkhalf/project.nvim",
        config = function()
          require("project_nvim").setup {
            ignore_lsp = { "null-ls" },
            silent_chdir = false,
            patterns = { ".git" },
          }
        end,
      },
    },
  }

  -- TROUBE
  use {
    "folke/trouble.nvim",
    cmd = { "TroubleToggle" },
    setup = conf("trouble").setup,
    config = conf("trouble").config,
  }

  -- TODO
  use {
    "folke/todo-comments.nvim",
    setup = conf("todo").setup,
    config = conf("todo").config,
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
    event = "BufEnter",
    config = conf("diffview").config,
    setup = conf("diffview").setup,
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
      require("go").setup {
        -- goimport = 'goimports', -- 'gopls'
        filstruct = "gopls",
        log_path = vim.fn.expand "$HOME" .. "/tmp/gonvim.log",
        lsp_codelens = false, -- use navigator
        dap_debug = true,
        goimport = "gopls",
        dap_debug_vt = "true",

        dap_debug_gui = true,
        test_runner = "go", -- richgo, go test, richgo, dlv, ginkgo
        -- run_in_floaterm = true, -- set to true to run in float window.
        lsp_document_formatting = true,
        -- lsp_on_attach = require("navigator.lspclient.attach").on_attach,
        -- lsp_cfg = true,
      }
      -- vim.cmd "augroup go"
      -- vim.cmd "autocmd!"
      -- vim.cmd "autocmd BufNewFile,BufRead *.go setlocal noexpandtab tabstop=4 shiftwidth=4"

      -- vim.cmd "augroup END"
    end,
  }
  use { "b0o/schemastore.nvim" }

  -- THEMES & UI
  use { "Shadorain/shadotheme" }
  use { "folke/tokyonight.nvim" }
  use { "arzg/vim-colors-xcode" }
  use { "pwntester/nautilus.nvim" }
  use { "ellisonleao/gruvbox.nvim" }
  use { "luisiacc/gruvbox-baby" }
  use { "Yazeed1s/minimal.nvim" }
  use { "ray-x/aurora" }
  -- use {'B4mbus/oxocarbon-lua.nvim'}
  use { "nyoom-engineering/oxocarbon.nvim" }
  use { "wuelnerdotexe/vim-enfocado" }
  use {
    "catppuccin/nvim",
    as = "catppuccin",
  }
  use {
    "rose-pine/neovim",
    as = "rose-pine",
    tag = "v1.*",
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
    config = conf("autopairs").config,
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
      require("rust-tools").setup()
    end,
  }

  use { "tpope/vim-surround" }

  use { "404-theme/neovim" }

  use { "andweeb/presence.nvim" }
  -- use {
  --   "kevinhwang91/nvim-ufo",
  --   config = function()
  --     require("ufo").setup()
  --   end,
  --   requires = "kevinhwang91/promise-async",
  -- }

  -- use { "~/dev/omni.nvim" }
  -- use { "~/dev/404.nvim" }
  -- use { "~/dev/telescope-twitch.nvim" }
  use {
    "KadoBOT/nvim-spotify",
    requires = "nvim-telescope/telescope.nvim",
    config = function()
      local spotify = require "nvim-spotify"

      spotify.setup {
        -- default opts
        status = {
          update_interval = 10000, -- the interval (ms) to check for what's currently playing
          format = "%s %t by %a", -- spotify-tui --format argument
        },
      }
    end,
    run = "make",
  }

  if packer_bootstrap then
    require("packer").sync()
  end
end)
