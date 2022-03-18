local ok, ls = pcall(require, "luasnip")
if not ok then
  return
end

local types = require "luasnip.util.types"

local snippet_from_nodes = ls.sn
local s = ls.snippet
local i = ls.insert_node
local t = ls.text_node
local c = ls.choice_node
-- local l = require("luasnip.extras").lambda
local d = ls.dynamic_node
local f = ls.function_node
local fmt = require("luasnip.extras.fmt").fmt

ls.config.set_config {
  history = true,
  updateevents = "TextChanged, TextChangedI",
  enable_autosnippets = true,

  ext_opts = {
    [types.choiceNode] = {
      active = {
        virt_text = { { "<-", "Error" } },
      },
    },
  },
}

local require_var = function(args, _)
  local text = args[1][1] or ""

  text = text:gsub("^%l", string.upper)

  return snippet_from_nodes(nil, {
    t(text),
  })
end

ls.snippets = {
  lua = {
    s(
      "req",
      fmt(
        [[local {} = require "{}"]],
        { f(function(import_name)
          return import_name[1]
        end, { 1 }), i(1) }
      )
    ),
  },
  typescriptreact = {
    s("usestate", {
      t "const [",
      i(1),
      t ", set",
      d(2, require_var, { 1 }),
      t "] = ",
      c(4, {
        t "React.useState(",
        t "useState(",
      }),
      i(3, "initialState"),
      t ")",
      i(0),
    }),
    s(
      "useeffect",
      fmt(
        [[
  useEffect(() => {{
    {}
  }}, [])
  ]],
        { i(0) }
      )
    ),
  },
  typescript = {
    s("sc", {
      t "export const ",
      i(1, { "val" }),
      t " = styled.",
      i(2, { "el" }),
      t { "`", "\t" },
      c(3, {
        t { "${({ theme }) => css`", "\t" },
        t "",
      }),
      i(0),
      t { "", "`}" },
      t { "", "`" },
    }),
  },
}

vim.keymap.set({ "i", "s" }, "<c-k>", function()
  if ls.expand_or_jumpable() then
    ls.expand_or_jump()
  end
end, {
  silent = true,
})

vim.keymap.set({ "i", "s" }, "<c-j>", function()
  if ls.jumpable(-1) then
    ls.jump(-1)
  end
end, {
  silent = true,
})

vim.keymap.set({ "i", "s" }, "<c-l>", function()
  if ls.choice_active() then
    ls.change_choice(1)
  end
end, {
  silent = true,
})
