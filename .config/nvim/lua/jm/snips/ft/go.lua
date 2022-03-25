local ls = require "luasnip"

local i = ls.insert_node
local t = ls.text_node

local fmt = require("luasnip.extras.fmt").fmt

return {
  iferr = fmt("if err != nil {{\n\t{}\n}}\n{}", { i(1), i(0) }),
}
