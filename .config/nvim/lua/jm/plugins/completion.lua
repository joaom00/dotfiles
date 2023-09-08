local border = jm.ui.current.border

return {
  {
    "hrsh7th/nvim-cmp",
    event = "InsertEnter",
    version = false,
    dependencies = {
      { "hrsh7th/cmp-nvim-lsp" },
      { "hrsh7th/cmp-path" },
      { "hrsh7th/cmp-buffer" },
      { "saadparwaiz1/cmp_luasnip" },
      { "abecodes/tabout.nvim", opts = { tabkey = "<c-o>", ignore_beginning = false, completion = false } },
      {
        "roobert/tailwindcss-colorizer-cmp.nvim",
        opts = { color_square_width = 2 },
      },
    },
    config = function()
      local cmp = require "cmp"
      local lspkind = require "lspkind"

      cmp.setup {
        window = {
          completion = cmp.config.window.bordered {
            scrollbar = false,
            border = "shadow",
            winhighlight = "NormalFloat:Pmenu,CursorLine:PmenuSel,FloatBorder:FloatBorder",
          },
          documentation = cmp.config.window.bordered {
            border = border,
            winhighlight = "FloatBorder:FloatBorder",
          },
        },
        snippet = {
          expand = function(args)
            require("luasnip").lsp_expand(args.body)
          end,
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
        sources = cmp.config.sources {
          { name = "nvim_lsp", group_index = 1 },
          { name = "luasnip", group_index = 1 },
          { name = "path", group_index = 1 },
          {
            name = "buffer",
            options = {
              get_bufnrs = function()
                return vim.api.nvim_list_bufs()
              end,
            },
            group_index = 2,
          },
        },
        mapping = cmp.mapping.preset.insert {
          ["<C-n>"] = cmp.mapping.select_next_item { behavior = cmp.SelectBehavior.Insert },
          ["<C-p>"] = cmp.mapping.select_prev_item { behavior = cmp.SelectBehavior.Insert },
          ["<C-d>"] = cmp.mapping.scroll_docs(-4),
          ["<C-f>"] = cmp.mapping.scroll_docs(4),
          ["<c-y>"] = cmp.mapping(
            cmp.mapping.confirm {
              behavior = cmp.ConfirmBehavior.Insert,
              select = true,
            },
            { "i", "c" }
          ),
          ["<C-e>"] = cmp.mapping.complete(),
        },
      }

      -- cmp.setup.cmdline({ "/", "?" }, {
      --   mapping = cmp.mapping.preset.cmdline(),
      --   sources = {
      --     sources = cmp.config.sources({ { name = "nvim_lsp_document_symbol" } }, { { name = "buffer" } }),
      --   },
      -- })
      -- cmp.setup.cmdline(":", {
      --   mapping = cmp.mapping.preset.cmdline(),
      --   sources = cmp.config.sources {
      --     { name = "cmdline", keyword_pattern = [=[[^[:blank:]\!]*]=] },
      --     { name = "path" },
      --     { name = "cmdline_history", priority = 10, max_item_count = 5 },
      --   },
      -- })
    end,
  },
}
