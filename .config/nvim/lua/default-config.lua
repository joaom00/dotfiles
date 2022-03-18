CONFIG_PATH = vim.fn.stdpath "config"
DATA_PATH = vim.fn.stdpath "data"
CACHE_PATH = vim.fn.stdpath "cache"
TERMINAL = vim.fn.expand "$TERMINAL"
USER = vim.fn.expand "$USER"

P = function(v)
  print(vim.inspect(v))
  return v
end

R = function(name)
  require("plenary.reload").reload_module(name)
  return require(name)
end

JM = { leader = "-", colorscheme = "xcodedarkhc", line_wrap_cursor_movement = true, format_on_save = true }

JM.lsp = {
  completion = {
    item_kind = {
      "   (Text) ",
      "   (Method)",
      "   (Function)",
      "   (Constructor)",
      "   (Field)",
      "   (Variable)",
      "   (Class)",
      " ﰮ  (Interface)",
      "   (Module)",
      "   (Property)",
      " 塞 (Unit)",
      "   (Value)",
      " 練 (Enum)",
      "   (Keyword)",
      "   (Snippet)",
      "   (Color)",
      "   (File)",
      "   (Reference)",
      "   (Folder)",
      "   (EnumMember)",
      " ﲀ  (Constant)",
      "   (Struct)",
      "   (Event)",
      "   (Operator)",
      "   (TypeParameter)",
    },
  },
  diagnostics = {
    signs = {
      active = true,
      values = {
        -- { name = "DiagnosticsSignError", text = "" },
        -- { name = "DiagnosticsSignWarn", text = "" },
        -- { name = "DiagnosticsSignHint", text = "" },
        -- { name = "DiagnosticsSignInfo", text = "" },
        { name = "DiagnosticSignError", text = " " },
        { name = "DiagnosticSignWarn", text = "" },
        { name = "DiagnosticSignHint", text = "" },
        { name = "DiagnosticsSignInfo", text = "" },
      },
    },
    virtual_text = true,
    underline = true,
    severity_sort = true,
  },
  float = {
    border = "rounded",
  },
  document_highlight = true,
  on_attach_callback = nil,
  on_init_callback = nil,
  null_ls = { setup = {} },
}

function JM.mapper(mode, is_noremap)
  is_noremap = is_noremap or true
  local map_opts = { noremap = is_noremap, silent = true }

  return function(key, rhs)
    vim.api.nvim_set_keymap(mode, key, rhs, map_opts)
  end
end

function JM.notify(message, level, title)
  local status_ok, notify = pcall(require, "notify")
  if not status_ok then
    return
  end
  level = level or "error"

  notify(message, level, { title = title or "Dependecy Error" })
end
