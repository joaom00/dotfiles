local highlight = jm.highlight
local fmt = string.format
local api = vim.api
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
        opts = { color_square_width = 2 },
      },
    },
    config = function()
      local cmp = require "cmp"
      local luasnip = require "luasnip"
      local lspkind = require "lspkind"
      local ellipsis = jm.ui.icons.misc.ellipsis
      local MIN_MENU_WIDTH, MAX_MENU_WIDTH = 25, math.min(50, math.floor(vim.o.columns * 0.5))

      highlight.plugin("Cmp", {
        { CmpItemKindVariable = { link = "Variable" } },
        { CmpItemAbbrMatchFuzzy = { inherit = "CmpItemAbbrMatch", italic = true } },
        { CmpItemAbbrDeprecated = { strikethrough = true, inherit = "Comment" } },
        { CmpItemMenu = { inherit = "Comment", italic = true } },
      })

      cmp.setup {
        experimental = { ghost_text = false },
        matching = {
          disallow_partial_fuzzy_matching = false,
        },
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
          deprecated = true,
          fields = { "abbr", "kind", "menu" },
          format = lspkind.cmp_format {
            maxwidth = MAX_MENU_WIDTH,
            ellipsis_char = ellipsis,
            before = function(entry, vim_item)
              vim_item = require("tailwindcss-colorizer-cmp").formatter(entry, vim_item)
              local label, length = vim_item.abbr, api.nvim_strwidth(vim_item.abbr)
              if length < MIN_MENU_WIDTH then
                vim_item.abbr = label .. string.rep(" ", MIN_MENU_WIDTH - length)
              end
              return vim_item
            end,
            menu = {
              nvim_lsp = "[LSP]",
              nvim_lua = "[LUA]",
              emoji = "[EMOJI]",
              path = "[PATH]",
              neorg = "[NEORG]",
              luasnip = "[SNIP]",
              dictionary = "[DIC]",
              buffer = "[BUF]",
              spell = "[SPELL]",
              orgmode = "[ORG]",
              norg = "[NORG]",
              rg = "[RG]",
              git = "[GIT]",
            },
          },
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
    end,
  },
}
