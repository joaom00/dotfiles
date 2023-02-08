local M = {}

function M.config()
  local ls_ok, luasnip = pcall(require, "luasnip")
  if not ls_ok then
    JM.notify "Missing luasnip dependency"
    return
  end

  local lk_ok, lspkind = pcall(require, "lspkind")
  if not lk_ok then
    JM.notify "Missing luasnip dependency"
    return
  end

  lspkind.init()

  local cmp = require "cmp"
  cmp.setup {
    experimental = {
      ghost_text = true,
    },
    view = {
      entries = "custom",
    },
    formatting = {
      format = lspkind.cmp_format {
        with_text = true,
        menu = {
          buffer = "[buf]",
          nvim_lsp = "[LSP]",
          nvim_lua = "[api]",
          path = "[path]",
          luasnip = "[snip]",
          gh_issues = "[issues]",
        },
      },
    },
    snippet = {
      expand = function(args)
        luasnip.lsp_expand(args.body)
      end,
    },
    sources = {
      { name = "cmp_git" },
      { name = "nvim_lua" },
      { name = "luasnip" },
      { name = "nvim_lsp" },
      { name = "path" },
      { name = "buffer", keyword_length = 5 },
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

  cmp.setup.cmdline(":", {
    sources = {
      { name = "cmdline" },
    },
    mapping = cmp.mapping.preset.cmdline(),
  })

  cmp.setup.cmdline("/", {
    sources = {
      { name = "buffer" },
    },
    mapping = cmp.mapping.preset.cmdline(),
  })
  cmp.config.formatting = {
    format = require("tailwindcss-colorizer-cmp").formatter,
  }
end

return M
