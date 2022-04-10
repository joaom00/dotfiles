local ok, ls = pcall(require, "luasnip")
if not ok then
  return
end

local M = {}

local types = require "luasnip.util.types"

local s = ls.snippet
local i = ls.insert_node
local t = ls.text_node
local c = ls.choice_node
local d = ls.dynamic_node
local fmt = require("luasnip.extras.fmt").fmt
local snippet_from_nodes = ls.sn
-- local snippet = ls.s

local function get_file_name(file)
  return file:match "^.+/(.+)$"
end

local function insert_snippets_into_table(tt, modules_str, paths_table)
  for _, snip_fpath in ipairs(paths_table) do
    local snip_mname = get_file_name(snip_fpath):sub(1, -5)

    local sm = require(modules_str .. snip_mname)

    for ft, snips in pairs(sm) do
      if tt[ft] == nil then
        tt[ft] = snips
      else
        for _, sp in pairs(snips) do
          table.insert(tt[ft], sp)
        end
      end
    end
  end
  return t
end

local luasnip_snippets_path = "lua/snippets/"
local luasnip_snippets_modules = "snippets."

function M.load_snippets()
  local tt = {}

  local luasnip_snippets = vim.api.nvim_get_runtime_file(luasnip_snippets_path .. "*.lua", true)

  tt = insert_snippets_into_table(t, luasnip_snippets_modules, luasnip_snippets)

  return tt
end

local require_var = function(args, _)
  local text = args[1][1] or ""

  text = text:gsub("^%l", string.upper)

  return snippet_from_nodes(nil, {
    t(text),
  })
end

local js_snippets = {
  s("imp", fmt([[import {} from '{}']], { i(0, { "module" }), i(1) })),
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
      [[useEffect(() => {{
          {}
      }}, [])]],
      { i(0) }
    )
  ),
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
}

function M.setup()
  ls.config.set_config {
    history = true,
    updateevents = "TextChanged, TextChangedI",
    enable_autosnippets = true,

    ext_opts = {
      [types.choiceNode] = {
        active = {
          virt_text = { { " <- Current Choice", "Error" } },
        },
      },
    },
  }

  ls.snippets = {
    javascript = js_snippets,
    javascriptreact = js_snippets,
    typescript = js_snippets,
    typescriptreact = js_snippets,
    go = {
      s("iferr", fmt("if err != nil {{\n\t{}\n}}\n{}", { i(1), i(0) })),
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
end

return M
