local M = {}

function M.config()
  JM.blankline = {
    indent_blankline_buftype_exclude = { "terminal", "nofile" },
    indent_blankline_filetype_exclude = {
      "help",
      "startify",
      "dashboard",
      "packer",
      "neogitstatus",
      "NvimTree",
      "Trouble",
    },
    indentLine_enabled = 1,
    indent_blankline_char = "▏",
    indent_blankline_show_trailing_blankline_indent = false,
    indent_blankline_show_first_indent_level = true,
    indent_blankline_use_treesitter = true,
    indent_blankline_show_current_context = true,
    indent_blankline_context_patterns = {
      "class",
      "return",
      "function",
      "method",
      "^if",
      "^while",
      "jsx_element",
      "^for",
      "^object",
      "^table",
      "block",
      "arguments",
      "if_statement",
      "else_clause",
      "jsx_element",
      "jsx_self_closing_element",
      "try_statement",
      "catch_clause",
      "import_statement",
      "operation_type",
    },
  }
end

function M.setup()
  M.config()
  for k, v in pairs(JM.blankline) do
    vim.g[k] = v
  end
end

return M
