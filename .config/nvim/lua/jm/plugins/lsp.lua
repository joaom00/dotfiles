return {
  {
    "folke/lazydev.nvim",
    ft = "lua",
    opts = {
      libray = {
        -- Load luvit types when the `vim.uv` word is found
        { path = "${3rd}/luv/library", words = { "vim%.uv" } },
      },
    },
  },
  {
    "neovim/nvim-lspconfig",
    dependencies = {
      { "williamboman/mason.nvim", opts = {} },
      "williamboman/mason-lspconfig.nvim",
      { "j-hui/fidget.nvim", opts = {} },
      "hrsh7th/cmp-nvim-lsp",
    },
    config = function()
      vim.api.nvim_create_autocmd("LspAttach", {
        group = vim.api.nvim_create_augroup("kickstart-lsp-attach", { clear = true }),
        callback = function(event)
          local map = function(keys, func, desc, mode)
            mode = mode or "n"
            vim.keymap.set(mode, keys, func, { buffer = event.buf, desc = "LSP: " .. desc })
          end

          map("gd", require("telescope.builtin").lsp_definitions, "[G]oto [D]efinition")

          map("gr", require("telescope.builtin").lsp_references, "[G]oto [R]eferences")

          map("gI", require("telescope.builtin").lsp_implementations, "[G]oto [I]mplementation")

          map("<leader>D", require("telescope.builtin").lsp_type_definitions, "Type [D]efinition")

          map("<leader>ds", require("telescope.builtin").lsp_document_symbols, "[D]ocument [S]ymbols")

          map("<leader>ws", require("telescope.builtin").lsp_dynamic_workspace_symbols, "[W]orkspace [S]ymbols")

          map("rn", vim.lsp.buf.rename, "[R]e[n]ame")

          map("<space>ca", vim.lsp.buf.code_action, "[C]ode [A]ction", { "n", "x" })

          map("gD", vim.lsp.buf.declaration, "[G]oto [D]eclaration")

          map("<c-p>", function()
            vim.diagnostic.goto_prev { float = true }
          end, "Go to prev diagnostic")

          map("<c-n>", function()
            vim.diagnostic.goto_next { float = true }
          end, "Go to next diagnostic")

          local client = vim.lsp.get_client_by_id(event.data.client_id)
          if client and client.supports_method(vim.lsp.protocol.Methods.textDocument_documentHighlight) then
            local highlight_augroup = vim.api.nvim_create_augroup("kickstart-lsp-highlight", { clear = false })
            vim.api.nvim_create_autocmd({ "CursorHold", "CursorHoldI" }, {
              buffer = event.buf,
              group = highlight_augroup,
              callback = vim.lsp.buf.document_highlight,
            })

            vim.api.nvim_create_autocmd({ "CursorMoved", "CursorMovedI" }, {
              buffer = event.buf,
              group = highlight_augroup,
              callback = vim.lsp.buf.clear_references,
            })

            vim.api.nvim_create_autocmd("LspDetach", {
              group = vim.api.nvim_create_augroup("kickstart-lsp-detach", { clear = true }),
              callback = function(event2)
                vim.lsp.buf.clear_references()
                vim.api.nvim_clear_autocmds { group = "kickstart-lsp-highlight", buffer = event2.buf }
              end,
            })
          end

          if client and client.supports_method(vim.lsp.protocol.Methods.textDocument_inlayHint) then
            map("<leader>th", function()
              vim.lsp.inlay_hint.enable(not vim.lsp.inlay_hint.is_enabled { bufnr = event.buf })
            end, "[T]oggle Inlay [H]ints")
          end
        end,
      })

      local capabilities = vim.lsp.protocol.make_client_capabilities()
      capabilities = vim.tbl_deep_extend("force", capabilities, require("cmp_nvim_lsp").default_capabilities())

      local servers = {
        lua_ls = {
          -- cmd = { ... },
          -- filetypes = { ... },
          -- capabilities = {},
          settings = {
            Lua = {
              completion = {
                callSnippet = "Replace",
              },
              -- You can toggle below to ignore Lua_LS's noisy `missing-fields` warnings
              -- diagnostics = { disable = { 'missing-fields' } },
            },
          },
        },
      }

      local ensure_installed = vim.tbl_keys(servers or {})
      vim.list_extend(ensure_installed, {
        "stylua",
      })

      require("mason-lspconfig").setup {
        handlers = {
          function(server_name)
            local server = servers[server_name] or {}
            server.capabilities = vim.tbl_deep_extend("force", {}, capabilities, server.capabilities or {})
            require("lspconfig")[server_name].setup(server)
          end,
        },
      }
    end,
  },
  -- Autocompletion
  {
    "hrsh7th/nvim-cmp",
    event = "InsertEnter",
    dependencies = {
      "L3MON4D3/LuaSnip",
      "onsails/lspkind-nvim",
      "hrsh7th/cmp-nvim-lsp",
      "hrsh7th/cmp-nvim-lua",
    },
    config = function()
      -- Here is where you configure the autocompletion settings.
      -- local lsp_zero = require "lsp-zero"
      -- lsp_zero.extend_cmp()

      -- And you can configure cmp even more, if you want to.
      local cmp = require "cmp"
      -- local cmp_action = lsp_zero.cmp_action()
      local lspkind = require "lspkind"

      lspkind.init {}

      cmp.setup {
        sources = {
          { name = "nvim_lsp" },
          { name = "nvim_lua" },
        },
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
          -- ["<C-f>"] = cmp_action.luasnip_jump_forward(),
          -- ["<C-b>"] = cmp_action.luasnip_jump_backward(),
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
  {
    "pmizio/typescript-tools.nvim",
    dependencies = { "nvim-lua/plenary.nvim", "neovim/nvim-lspconfig" },
    opts = {
      settings = {
        expose_as_code_action = "all",
      },
    },
  },
  {
    "olrtg/nvim-emmet",
    config = function()
      vim.keymap.set({ "n", "v" }, "<space>e", require("nvim-emmet").wrap_with_abbreviation)
    end,
  },
}
