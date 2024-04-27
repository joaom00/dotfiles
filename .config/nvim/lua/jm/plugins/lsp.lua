return {
  {
    "VonHeikemen/lsp-zero.nvim",
    branch = "v3.x",
    lazy = true,
    config = false,
    init = function()
      -- Disable automatic setup, we are doing it manually
      vim.g.lsp_zero_extend_cmp = 0
      vim.g.lsp_zero_extend_lspconfig = 0
    end,
  },
  {
    "williamboman/mason.nvim",
    lazy = false,
    config = true,
  },

  -- Autocompletion
  {
    "hrsh7th/nvim-cmp",
    event = "InsertEnter",
    dependencies = {
      { "L3MON4D3/LuaSnip" },
      { "onsails/lspkind-nvim" },
    },
    config = function()
      -- Here is where you configure the autocompletion settings.
      local lsp_zero = require "lsp-zero"
      lsp_zero.extend_cmp()

      -- And you can configure cmp even more, if you want to.
      local cmp = require "cmp"
      local cmp_action = lsp_zero.cmp_action()
      local lspkind = require "lspkind"

      lspkind.init {}

      cmp.setup {
        mapping = cmp.mapping.preset.insert {
          ["<C-e>"] = cmp.mapping.complete(),
          ["<C-y>"] = cmp.mapping(
            cmp.mapping.confirm {
              behavior = cmp.ConfirmBehavior.Insert,
              select = true,
            },
            { "i", "c" }
          ),
          ["<C-u>"] = cmp.mapping.scroll_docs(-4),
          ["<C-d>"] = cmp.mapping.scroll_docs(4),
          ["<C-f>"] = cmp_action.luasnip_jump_forward(),
          ["<C-b>"] = cmp_action.luasnip_jump_backward(),
        },
        formatting = {
          fields = { "kind", "abbr", "menu" },
          format = lspkind.cmp_format {
            mode = "symbol_text", -- options: 'text', 'text_symbol', 'symbol_text', 'symbol'
            maxwidth = 50, -- prevent the popup from showing more than provided characters (e.g 50 will not show more than 50 characters)
            menu = { -- showing type in menu
              nvim_lsp = "[LSP]",
              -- path = "[Path]",
              buffer = "[Buffer]",
              luasnip = "[LuaSnip]",
            },
            before = function(entry, vim_item) -- for tailwind css autocomplete
              if vim_item.kind == "Color" and entry.completion_item.documentation then
                local _, _, r, g, b = string.find(entry.completion_item.documentation, "^rgb%((%d+), (%d+), (%d+)")
                if r then
                  local color = string.format("%02x", r) .. string.format("%02x", g) .. string.format("%02x", b)
                  local group = "Tw_" .. color
                  if vim.fn.hlID(group) < 1 then
                    vim.api.nvim_set_hl(0, group, { fg = "#" .. color })
                  end
                  vim_item.kind = "■" -- or "⬤" or anything
                  vim_item.kind_hl_group = group
                  return vim_item
                end
              end
              -- vim_item.kind = icons[vim_item.kind] and (icons[vim_item.kind] .. vim_item.kind) or vim_item.kind
              -- or just show the icon
              vim_item.kind = lspkind.symbolic(vim_item.kind) and lspkind.symbolic(vim_item.kind) or vim_item.kind
              return vim_item
            end,
          },
        },
      }
    end,
  },

  -- LSP
  {
    "neovim/nvim-lspconfig",
    cmd = { "LspInfo", "LspInstall", "LspStart" },
    event = { "BufReadPre", "BufNewFile" },
    dependencies = {
      { "hrsh7th/cmp-nvim-lsp" },
      { "williamboman/mason-lspconfig.nvim" },
    },
    config = function()
      -- This is where all the LSP shenanigans will live
      local lsp_zero = require "lsp-zero"
      lsp_zero.extend_lspconfig()

      lsp_zero.configure("lua_ls", {
        settings = {
          Lua = {
            diagnostics = {
              globals = { "vim" },
            },
          },
        },
      })

      lsp_zero.configure("tailwindcss", {
        settings = {
          tailwindCSS = {
            experimental = {
              classRegex = {
                "tv\\(([^)]*)\\)",
                "[\"'`]([^\"'`]*).*?[\"'`]",
              },
            },
          },
        },
      })

      lsp_zero.on_attach(function(client, bufnr)
        -- see :help lsp-zero-keybindings
        -- to learn the available actions
        lsp_zero.default_keymaps { buffer = bufnr }

        vim.keymap.set("n", "<c-p>", function()
          vim.diagnostic.goto_prev { float = true }
        end, { buffer = bufnr, desc = "lsp: go to prev diagnostic" })

        vim.keymap.set("n", "<c-n>", function()
          vim.diagnostic.goto_next { float = true }
        end, { buffer = bufnr, desc = "lsp: go to next diagnostic" })

        vim.keymap.set("n", "<space>ca", function()
          vim.lsp.buf.code_action()
        end, { buffer = bufnr, desc = "lsp: code action" })
      end)

      require("mason-lspconfig").setup {
        ensure_installed = {},
        handlers = {
          lsp_zero.default_setup,
        },
      }
    end,
  },
}
