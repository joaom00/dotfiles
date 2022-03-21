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
  use {
    "ray-x/lsp_signature.nvim",
    config = function()
      require("jm.lsp_signature").setup()
    end,
  }
  use { "williamboman/nvim-lsp-installer" }
  use { "tamago324/nlsp-settings.nvim" }

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
      require("jm.completion").setup()
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

  -- TERMINAL
  use {
    "akinsho/nvim-toggleterm.lua",
    event = "BufWinEnter",
    config = function()
      require("jm.toggleterm").setup()
    end,
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
          require("project_nvim").setup()
        end,
      },
    },
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
      local path = require "nvim-lsp-installer.path"
      local install_root_dir = path.concat { vim.fn.stdpath "data", "lsp_servers" }
      require("go").setup {
        -- goimport = 'goimports', -- 'gopls'
        gopls_cmd = install_root_dir .. "/go/gopls",
        filstruct = "gopls",
        log_path = vim.fn.expand "$HOME" .. "/tmp/gonvim.log",
        lsp_codelens = false, -- use navigator
        dap_debug = true,
        goimport = "goimports",
        dap_debug_vt = "true",

        dap_debug_gui = true,
        test_runner = "go", -- richgo, go test, richgo, dlv, ginkgo
        -- run_in_floaterm = true, -- set to true to run in float window.
        lsp_document_formatting = false,
        -- lsp_on_attach = require("navigator.lspclient.attach").on_attach,
        -- lsp_cfg = true,
      }
      vim.cmd "augroup go"
      vim.cmd "autocmd!"
      vim.cmd "autocmd BufNewFile,BufRead *.go setlocal noexpandtab tabstop=4 shiftwidth=4"

      vim.cmd "augroup END"
    end,
  }
  use { "b0o/schemastore.nvim" }

  -- THEMES & UI
  use { "Shadorain/shadotheme" }
  use { "folke/tokyonight.nvim" }
  use { "arzg/vim-colors-xcode" }
  use { "pwntester/nautilus.nvim" }
  use { "ray-x/aurora" }
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
      require("rust-tools").setup()
    end,
  }

  use { "tpope/vim-surround" }
  use {
    "ray-x/navigator.lua",
    requires = { "ray-x/guihua.lua", run = "cd lua/fzy && make" },
    config = function()
      local single = { "╭", "─", "╮", "│", "╯", "─", "╰", "│" }

      require("lsp").setup()
      require("navigator").setup {
        lsp_installer = true,
        border = single,
        lsp_signature_help = true,
        default_mapping = false,
        combined_attach = "their",
        lsp = {
          format_on_save = true,
          code_lens = true,
          disable_format_cap = { "gopls" },
        },
        keymaps = {
          { key = "gd", func = "require('navigator.definition').definition()" },
          { key = "gD", func = "declaration({ border = 'rounded', max_width = 80 })" },
          { key = "gr", func = "require('navigator.reference').async_ref()" },
          { key = "gi", func = "implementation()" },
          { key = "rn", func = "require('navigator.rename').rename()" },
          { key = "gp", func = "require('navigator.definition').definition_preview()" },
          { key = "<space>ca", func = "require('navigator.codeAction').code_action()" },
          { key = "K", func = "hover({ popup_opts = { border = single, max_width = 80 }})" },
          { key = "<c-p>", func = "diagnostic.goto_prev({ border = 'rounded', max_width = 80})" },
          { key = "<c-n>", func = "diagnostic.goto_next({ border = 'rounded', max_width = 80})" },
        },
      }
    end,
  }

  use {
    "rcarriga/vim-ultest",
    requires = { "vim-test/vim-test" },
    run = ":UpdateRemotePlugins",
    config = function()
      local builders = {
        python = function(cmd)
          local non_modules = { "python", "pipenv", "poetry" }

          local module_index
          if vim.tbl_contains(non_modules, cmd[1]) then
            module_index = 3
          else
            module_index = 1
          end

          local args = vim.list_slice(cmd, module_index + 1)

          return {
            dap = {
              type = "python",
              name = "Ultest Debugger",
              request = "launch",
              module = cmd[module_index],
              args = args,
              justMyCode = false,
            },
          }
        end,
        ["go#gotest"] = function(cmd)
          local args = {}

          for i = 3, #cmd, 1 do
            local arg = cmd[i]
            if vim.startswith(arg, "-") then
              arg = "-test." .. string.sub(arg, 2)
            end
            args[#args + 1] = arg
          end
          return {
            dap = {
              type = "go",
              request = "launch",
              mode = "test",
              program = "${workspaceFolder}",
              dlvToolPath = vim.fn.exepath "dlv",
              args = args,
            },
            parse_result = function(lines)
              return lines[#lines] == "FAIL" and 1 or 0
            end,
          }
        end,
      }
      require("ultest").setup { builders = builders }
    end,
  }

  use { "~/dev/omni.nvim" }
  use { "~/dev/404.nvim" }
  use { "~/dev/telescope-twitch.nvim" }

  if packer_bootstrap then
    require("packer").sync()
  end
end)
