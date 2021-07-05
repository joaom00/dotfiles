local execute = vim.api.nvim_command
local fn = vim.fn

local install_path = fn.stdpath("data") .. "/site/pack/packer/start/packer.nvim"

if fn.empty(fn.glob(install_path)) > 0 then
    execute("!git clone https://github.com/wbthomason/packer.nvim " ..
                install_path)
    execute "packadd packer.nvim"
end

local packer_ok, packer = pcall(require, "packer")
if not packer_ok then return end

packer.init {
    -- compile_path = vim.fn.stdpath('data')..'/site/pack/loader/start/packer.nvim/plugin/packer_compiled.vim',
    compile_path = require("packer.util").join_paths(vim.fn.stdpath('config'),
                                                     'plugin',
                                                     'packer_compiled.vim'),
    git = {clone_timeout = 300},
    display = {
        open_fn = function()
            return require("packer.util").float {border = "single"}
        end
    }
}

vim.cmd "autocmd BufWritePost plugins.lua PackerCompile" -- Auto compile when there are changes in plugins.lua

return require("packer").startup(function(use)
    use 'wbthomason/packer.nvim'

    -- LSP
    use {'neovim/nvim-lspconfig'}
    use {'glepnir/lspsaga.nvim', cmd = 'Lspsaga'}
    use {'kabouzeid/nvim-lspinstall', cmd = 'LspInstall'}

    -- Autocomplete
    use {
        'hrsh7th/nvim-compe',
        event = 'InsertEnter',
        config = function()
            require'lv-compe'.config()
        end
    }

    -- Telescope
    use {'nvim-lua/popup.nvim'}
    use {'nvim-lua/plenary.nvim'}
    use {'tjdevries/astronauta.nvim'}
    use {'nvim-telescope/telescope.nvim'}
    use {'nvim-telescope/telescope-media-files.nvim'}
    use {'nvim-telescope/telescope-github.nvim'}
    use {'nvim-telescope/telescope-fzf-writer.nvim'}
    use {'nvim-telescope/telescope-frecency.nvim'}
    --    use {'nvim-telescope/telescope-fzy-native.nvim'}
    use {'nvim-telescope/telescope-fzf-native.nvim', run = 'make'}

    -- Javascript / Typescript
    use {
        "jose-elias-alvarez/nvim-lsp-ts-utils",
        ft = {
            "javascript", "javascriptreact", "javascript.jsx", "typescript",
            "typescriptreact", "typescript.tsx"
        }
    }
    use {
        "jose-elias-alvarez/null-ls.nvim",
        ft = {
            "javascript", "javascriptreact", "javascript.jsx", "typescript",
            "typescriptreact", "typescript.tsx"
        },
        config = function()
            require('null-ls').setup()
        end
    }

    -- Treesitter
    use {'nvim-treesitter/nvim-treesitter', run = ':TSUpdate'}
    use {'nvim-treesitter/playground', event = 'BufRead'}

    -- File Explorer
    use {
        'kyazdani42/nvim-tree.lua',
        config = function()
            require'lv-nvimtree'.config()
        end
    }

    -- Icons
    use {'kyazdani42/nvim-web-devicons'}

    -- Status Line and Bufferline
    use {'glepnir/galaxyline.nvim'}
    use {
        'akinsho/nvim-bufferline.lua',
        config = function()
            require'lv-bufferline'.config()
        end,
        event = 'BufRead'
    }

    -- Autopairs
    use {
        'windwp/nvim-autopairs',
        config = function()
            require 'lv-autopairs'
        end
    }

    -- Comments
    use {
        'terrortylor/nvim-comment',
        cmd = 'CommentToggle',
        config = function()
            require'nvim_comment'.setup()
        end
    }

    -- Colorizer
    use {
        'norcalli/nvim-colorizer.lua',
        event = 'BufRead',
        config = function()
            require'colorizer'.setup()
            vim.cmd('ColorizerReloadAllBuffers')
        end
    }

    -- Dashboard
    use {
        'glepnir/dashboard-nvim',
        event = 'BufWinEnter',
        config = function()
            require'lv-dashboard'.config()
        end
    }

    -- Themes
    use {'Shadorain/shadotheme'}
    use {'folke/tokyonight.nvim'}
    use {'arzg/vim-colors-xcode'}

    -- Floating terminal
    use {
        'numToStr/FTerm.nvim',
        event = 'BufRead',
        config = function()
            require'FTerm'.setup({
                dimensions = {height = 0.8, width = 0.8, x = 0.5, y = 0.5},
                border = 'single'
            })
        end
    }

    use {
        'ahmedkhalf/lsp-rooter.nvim',
        event = 'BufRead',
        config = function()
            require'lsp-rooter'.setup()
        end
    }

    use {"hrsh7th/vim-vsnip", event = "InsertEnter"}
end)
