local execute = vim.api.nvim_command
local fn = vim.fn

local install_path = fn.stdpath('data') .. '/site/pack/packer/start/packer.nvim'

if fn.empty(fn.glob(install_path)) > 0 then
  execute('!git clone https://github.com/wbthomason/packer.nvim ' .. install_path)
  execute 'packadd packer.nvim'
end

local packer_ok, packer = pcall(require, 'packer')
if not packer_ok then return end

packer.init {
  compile_path = require('packer.util').join_paths(vim.fn.stdpath('config'), 'plugin', 'packer_compiled.vim'),
  git = {clone_timeout = 300},
  display = {
    open_fn = function()
      return require('packer.util').float {border = 'single'}
    end
  }
}

return require('packer').startup(function(use)
  use 'wbthomason/packer.nvim'

  -- DEPS
  use {'tami5/sql.nvim'}
  use {'nvim-lua/popup.nvim'}
  use {'nvim-lua/plenary.nvim'}
  use {'tjdevries/astronauta.nvim'}

  -- LSP
  use {'neovim/nvim-lspconfig'}
  use {'kabouzeid/nvim-lspinstall'}

  -- AUTOCOMPLETE
  use {
    'hrsh7th/nvim-compe',
    -- event = 'InsertEnter',
    config = function()
      require'lv-compe'.config()
    end
  }

  -- TELESCOPE
  use {'nvim-telescope/telescope.nvim', requires = {'nvim-lua/popup.nvim', 'nvim-lua/plenary.nvim'}}
  use {'nvim-telescope/telescope-github.nvim'}
  use {'nvim-telescope/telescope-fzf-native.nvim', run = 'make'}

  -- GIT
  use {
    'pwntester/octo.nvim',
    config = function()
      require'octo'.setup()
    end,
    requires = {'nvim-telescope/telescope.nvim'}
  }
  use {
    'sindrets/diffview.nvim',
    config = function()
      require'lv-diffview'.config()
    end
  }

  -- GO
  -- use {'zchee/nvim-go', run = 'make'}

  -- ELIXIR
  use {'elixir-editors/vim-elixir', ft = {'elixir', 'eelixir', 'euphoria3'}}
  use {'mhinz/vim-mix-format'}

  -- TREESITTER
  use {'nvim-treesitter/nvim-treesitter', run = ':TSUpdate'}
  use {'nvim-treesitter/playground', event = 'BufRead'}

  -- FILE EXPLORER
  use {
    'kyazdani42/nvim-tree.lua',
    config = function()
      require'lv-nvimtree'.config()
    end
  }

  -- STATUS LINE & BARBAR
  use {'glepnir/galaxyline.nvim'}
  use {'romgrk/barbar.nvim'}

  -- AUTOPAIRS
  use {
    'windwp/nvim-autopairs',
    config = function()
      require 'lv-autopairs'
    end
  }

  -- COMMENTS
  use {
    'terrortylor/nvim-comment',
    cmd = 'CommentToggle',
    config = function()
      require'nvim_comment'.setup()
    end
  }

  -- DASHBOARD
  use {
    'glepnir/dashboard-nvim',
    event = 'BufWinEnter',
    config = function()
      require'lv-dashboard'.config()
    end
  }

  -- THEMES & UI
  use {'rktjmp/lush.nvim'}
  use {'Shadorain/shadotheme'}
  use {'folke/tokyonight.nvim'}
  use {'arzg/vim-colors-xcode'}
  use {'kyazdani42/nvim-web-devicons'}
  use {'p00f/nvim-ts-rainbow'}
  use {
    'pwntester/nautilus.nvim',
    config = function()
      require'nautilus'.setup({mode = 'grey'})
    end
  }
  use {
    'norcalli/nvim-colorizer.lua',
    event = 'BufRead',
    config = function()
      require'colorizer'.setup()
      vim.cmd('ColorizerReloadAllBuffers')
    end
  }

  -- FLOATING TERMINAL
  use {
    'numToStr/FTerm.nvim',
    event = 'BufRead',
    config = function()
      require'lv-fterm'.config()
    end
  }

  -- AUTOTAGS 
  use {'windwp/nvim-ts-autotag', event = 'InsertEnter'}

  -- MARKDOWN PREVIEW
  use {'iamcco/markdown-preview.nvim', run = 'cd app && npm install', ft = 'markdown'}

  use {
    'ahmedkhalf/lsp-rooter.nvim',
    event = 'BufRead',
    config = function()
      require'lsp-rooter'.setup()
    end
  }

  use {'hrsh7th/vim-vsnip', event = 'InsertEnter'}

end)
