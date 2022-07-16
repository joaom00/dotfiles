local status_ok, blankline = pcall(require, "indent_blankline")
if not status_ok then
  JM.notify "Missing blankline dependency"
  return
end

local M = {}

function M.config()
  blankline.setup {
    buftype_exclude = { "terminal", "nofile" },
    filetype_exclude = {
      "help",
      "startify",
      "dashboard",
      "packer",
      "neogitstatus",
      "NvimTree",
      "Trouble",
    },
    indentLine_enabled = 1,
    -- char = "»",
    char = " ",
    show_trailing_blankline_indent = false,
    show_end_of_line = true,
    show_first_indent_level = true,
    use_treesitter = true,
    show_current_context = true,
    context_patterns = {
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
end

return M
