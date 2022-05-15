local ok, ls = pcall(require, "luasnip")
if not ok then
  return
end

local snippet_from_nodes = ls.sn
local s = ls.snippet
local i = ls.insert_node
local t = ls.text_node
local c = ls.choice_node
-- local l = require("luasnip.extras").lambda
local d = ls.dynamic_node
-- local f = ls.function_node
local fmt = require("luasnip.extras.fmt").fmt

local require_var = function(args, _)
  local text = args[1][1] or ""

  text = text:gsub("^%l", string.upper)

  return snippet_from_nodes(nil, {
    t(text),
  })
end

return {
  javascript = {
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
    s("useeffect", {
      c(1, {
        t "React.useEffect(() => {",
        t "useEffect(() => {",
      }),
      t { "", "\t" },
      i(2),
      t { "", "}, [])" },
      i(0),
    }),
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
