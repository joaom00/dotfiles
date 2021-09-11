local execute = vim.api.nvim_command
local fn = vim.fn

local install_path = fn.stdpath "data" .. "/site/pack/packer/start/packer.nvim"

if fn.empty(fn.glob(install_path)) > 0 then
  execute("!git clone https://github.com/wbthomason/packer.nvim " .. install_path)
  execute "packadd packer.nvim"
end

local packer_ok, packer = pcall(require, "packer")
if not packer_ok then
  return
end

packer.init {
  compile_path = require("packer.util").join_paths(vim.fn.stdpath "config", "plugin", "packer_compiled.vim"),
  git = { clone_timeout = 300 },
  display = {
    open_fn = function()
      return require("packer.util").float { border = "single" }
    end,
  },
}

return require("packer").startup(function(use)
  use "wbthomason/packer.nvim"

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
  use {
    "kabouzeid/nvim-lspinstall",
    event = "VimEnter",
    config = function()
      local lspinstall = require "lspinstall"
      lspinstall.setup()
    end,
  }

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
    "hrsh7th/nvim-compe",
    event = "InsertEnter",
    config = function()
      require("jm.compe").config()
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
  use {
    "ahmedkhalf/project.nvim",
    config = function()
      require("project_nvim").setup {}
    end,
  }

  -- TROUBE
  use {
    "folke/trouble.nvim",
    config = function()
      require("trouble").setup {}
    end,
  }

  -- TODO
  use {
    "folke/todo-comments.nvim",
    config = function()
      require("todo-comments").setup {}
    end,
  }

  -- GIT
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
    event = "BufRead",
    config = function()
      require("jm.gitsigns").setup()
    end,
  }

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
    "shadmansaleh/lualine.nvim",
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

  -- THEMES & UI
  use { "Shadorain/shadotheme" }
  use { "folke/tokyonight.nvim" }
  use { "arzg/vim-colors-xcode" }
  use { "pwntester/nautilus.nvim" }
  use {
    "NvChad/nvim-base16.lua",
    config = function()
      require("colors").init()
    end,
  }
  use {
    "kyazdani42/nvim-web-devicons",
    after = "nvim-base16.lua",
    config = function()
      require("jm.icons").setup()
    end,
  }

  -- UTILS
  use { "hrsh7th/vim-vsnip", event = "InsertEnter" }
  use { "windwp/nvim-ts-autotag", event = "InsertEnter" }
  use { "p00f/nvim-ts-rainbow" }
  use {
    "terrortylor/nvim-comment",
    event = "BufRead",
    config = function()
      require("nvim_comment").setup()
    end,
  }
  use {
    "windwp/nvim-autopairs",
    after = "nvim-compe",
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

  use { "~/dev/markdown.nvim", rtp = "~/dev/markdown.nvim" }
  use { "~/dev/discussions.nvim", rtp = "~/dev/discussions.nvim" }
end)
