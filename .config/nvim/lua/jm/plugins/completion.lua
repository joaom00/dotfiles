local highlight = jm.highlight
local fmt = string.format
local border = jm.ui.current.border

return {
  {
    "hrsh7th/nvim-cmp",
    event = "InsertEnter",
    dependencies = {
      { "hrsh7th/cmp-nvim-lsp" },
      { "hrsh7th/cmp-nvim-lua" },
      { "hrsh7th/cmp-cmdline" },
      { "hrsh7th/cmp-path" },
      { "hrsh7th/cmp-buffer" },
      { "hrsh7th/cmp-nvim-lsp-document-symbol" },
      { "hrsh7th/cmp-emoji" },
      { "saadparwaiz1/cmp_luasnip" },
      { "abecodes/tabout.nvim", opts = { tabkey = "<c-o>", ignore_beginning = false, completion = false } },
      {
        "roobert/tailwindcss-colorizer-cmp.nvim",
        config = function()
          require("tailwindcss-colorizer-cmp").setup {
            color_square_width = 2,
          }
        end,
      },
    },
    config = function()
      local cmp = require "cmp"
      local luasnip = require "luasnip"
      local kind_hls = jm.ui.lsp.highlights
      -- local kind_hls = {}
      local ellipsis = jm.ui.icons.misc.ellipsis

      local menu_hls = {
        { CmpItemAbbr = { foreground = "fg", background = "NONE", italic = false, bold = false } },
        { CmpItemAbbrMatch = { foreground = { from = "Keyword" } } },
        { CmpItemAbbrDeprecated = { strikethrough = true, inherit = "Comment" } },
        { CmpItemAbbrMatchFuzzy = { italic = true, foreground = { from = "Keyword" } } },
        -- Make the source information less prominent
        { CmpItemMenu = { fg = { from = "Pmenu", attr = "bg", alter = 30 }, italic = true, bold = false } },
      }

      highlight.plugin(
        "Cmp",
        jm.fold(function(accum, value, key)
          table.insert(accum, { [fmt("CmpItemKind%s", key)] = { foreground = { from = value } } })
          return accum
        end, kind_hls, menu_hls)
      )

      local cmp_window = {
        border = border,
        winhighlight = table.concat({
          "Normal:NormalFloat",
          "FloatBorder:FloatBorder",
          "CursorLine:Visual",
          "Search:None",
        }, ","),
      }
      cmp.setup {
        experimental = { ghost_text = false },
        matching = {
          disallow_partial_fuzzy_matching = false,
        },
        window = {
          completion = cmp.config.window.bordered(cmp_window),
          documentation = cmp.config.window.bordered(cmp_window),
        },
        snippet = {
          expand = function(args)
            require("luasnip").lsp_expand(args.body)
          end,
        },
        formatting = {
          -- deprecated = true,
          -- fields = { "abbr", "kind", "menu" },
          format = function(entry, vim_item)
            local MAX = math.floor(vim.o.columns * 0.5)
            if #vim_item.abbr >= MAX then
              vim_item.abbr = vim_item.abbr:sub(1, MAX) .. ellipsis
            end
            vim_item.kind = fmt("%s %s", jm.ui.current.lsp_icons[vim_item.kind], vim_item.kind)
            vim_item.menu = ({
              nvim_lsp = "[LSP]",
              nvim_lua = "[Lua]",
              emoji = "[E]",
              path = "[Path]",
              neorg = "[N]",
              luasnip = "[SN]",
              dictionary = "[D]",
              buffer = "[B]",
              spell = "[SP]",
              cmdline = "[Cmd]",
              cmdline_history = "[Hist]",
              orgmode = "[Org]",
              norg = "[Norg]",
              rg = "[Rg]",
              git = "[Git]",
            })[entry.source.name]
            return vim_item
          end,
        },
        sources = cmp.config.sources({
          { name = "nvim_lsp" },
          { name = "nvim_lua" },
          { name = "luasnip" },
          { name = "path" },
        }, {
          {
            name = "buffer",
            keyword_length = 5,
            options = {
              get_bufnrs = function()
                return vim.api.nvim_list_bufs()
              end,
            },
          },
        }),
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
          ["<C-e>"] = cmp.mapping {
            i = cmp.mapping.complete(),
            c = function(
              _ --[[fallback]]
            )
              if cmp.visible() then
                if not cmp.confirm { select = true } then
                  return
                end
              else
                cmp.complete()
              end
            end,
          },
          ["<TAB>"] = cmp.mapping(function(fallback)
            if not cmp.visible() then
              return fallback()
            end
            if not cmp.get_selected_entry() then
              cmp.select_next_item { behavior = cmp.SelectBehavior.Select }
            else
              if luasnip.expand_or_jumpable() then
                luasnip.expand_or_jump()
              else
                cmp.confirm()
              end
            end
          end, { "i", "s" }),
          ["<S-TAB>"] = cmp.mapping(function(fallback)
            if not cmp.visible() then
              return fallback()
            end
            if luasnip.jumpable(-1) then
              luasnip.jump(-1)
            end
          end, { "i", "s" }),
        },
        sorting = {
          comparators = {
            cmp.config.compare.offset,
            cmp.config.compare.exact,
            cmp.config.compare.score,

            function(entry1, entry2)
              local _, entry1_under = entry1.completion_item.label:find "^_+"
              local _, entry2_under = entry2.completion_item.label:find "^_+"
              entry1_under = entry1_under or 0
              entry2_under = entry2_under or 0
              if entry1_under > entry2_under then
                return false
              elseif entry1_under < entry2_under then
                return true
              end
            end,

            cmp.config.compare.kind,
            cmp.config.compare.sort_text,
            cmp.config.compare.length,
            cmp.config.compare.order,
          },
        },
      }

      cmp.setup.cmdline({ "/", "?" }, {
        mapping = cmp.mapping.preset.cmdline(),
        sources = {
          sources = cmp.config.sources({ { name = "nvim_lsp_document_symbol" } }, { { name = "buffer" } }),
        },
      })
      cmp.setup.cmdline(":", {
        mapping = cmp.mapping.preset.cmdline(),
        sources = cmp.config.sources {
          { name = "cmdline", keyword_pattern = [=[[^[:blank:]\!]*]=] },
          { name = "path" },
          { name = "cmdline_history", priority = 10, max_item_count = 5 },
        },
      })
      cmp.config.formatting = {
        format = require("tailwindcss-colorizer-cmp").formatter,
      }
    end,
  },
}
