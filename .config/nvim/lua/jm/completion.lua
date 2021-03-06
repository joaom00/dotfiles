local M = {}

local ok, cmp = pcall(require, "cmp")
if not ok then
  JM.notify "Missing nvim-cmp dependency"
  return
end

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

  JM.cmp = {
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
    -- documentation = {
    --   border = { "╭", "─", "╮", "│", "╯", "─", "╰", "│" },
    -- },
    sources = {
      { name = "cmp_git" },
      { name = "nvim_lua" },
      { name = "luasnip" },
      { name = "nvim_lsp" },
      { name = "path" },
      { name = "buffer", keyword_length = 5 },
    },
    mapping = cmp.mapping.preset.insert {
      -- ["<c-k>"] = cmp.mapping.select_prev_item(),
      -- ["<c-j>"] = cmp.mapping.select_next_item(),
      ["<c-d>"] = cmp.mapping.scroll_docs(-4),
      ["<c-f>"] = cmp.mapping.scroll_docs(4),
      ["<c-q>"] = cmp.mapping(
        cmp.mapping.confirm {
          behavior = cmp.ConfirmBehavior.Insert,
          select = true,
        },
        { "i", "c" }
      ),
      ["<c-y>"] = cmp.mapping(
        cmp.mapping.confirm {
          behavior = cmp.ConfirmBehavior.Insert,
          select = true,
        },
        { "i", "c" }
      ),
      ["<tab>"] = cmp.mapping(
        cmp.mapping.confirm {
          behavior = cmp.ConfirmBehavior.Insert,
          select = true,
        },
        { "i", "c" }
      ),
      ["<C-e>"] = cmp.mapping(cmp.mapping.complete(), { "i", "c" }),
      -- ["<c-e>"] = cmp.mapping.close(),
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
end

function M.setup()
  M.config()

  cmp.setup(JM.cmp)
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
end

return M
