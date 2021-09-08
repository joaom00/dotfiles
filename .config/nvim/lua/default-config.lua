CONFIG_PATH = vim.fn.stdpath "config"
DATA_PATH = vim.fn.stdpath "data"
CACHE_PATH = vim.fn.stdpath "cache"
TERMINAL = vim.fn.expand "$TERMINAL"
USER = vim.fn.expand "$USER"

P = function(v)
  print(vim.inspect(v))
  return v
end

if pcall(require, "plenary") then
  RELOAD = require("plenary.reload").reload_module

  R = function(name)
    RELOAD(name)
    return require(name)
  end
end

JM = { leader = "-", colorscheme = "tokyonight", line_wrap_cursor_movement = true, format_on_save = true }

JM.lsp = {
  completion = {
    item_kind = {
      "   (Text) ",
      "   (Method)",
      "   (Function)",
      "   (Constructor)",
      " ﴲ  (Field)",
      "[] (Variable)",
      "   (Class)",
      " ﰮ  (Interface)",
      "   (Module)",
      " 襁 (Property)",
      "   (Unit)",
      "   (Value)",
      " 練 (Enum)",
      "   (Keyword)",
      "   (Snippet)",
      "   (Color)",
      "   (File)",
      "   (Reference)",
      "   (Folder)",
      "   (EnumMember)",
      " ﲀ  (Constant)",
      " ﳤ  (Struct)",
      "   (Event)",
      "   (Operator)",
      "   (TypeParameter)",
    },
  },
  diagnostics = {
    signs = {
      active = true,
      values = {
        { name = "LspDiagnosticsSignError", text = "" },
        { name = "LspDiagnosticsSignWarning", text = "" },
        { name = "LspDiagnosticsSignHint", text = "" },
        { name = "LspDiagnosticsSignInformation", text = "" },
      },
    },
    virtual_text = false,
    underline = true,
    severity_sort = true,
  },
  override = {},
  document_highlight = true,
  popup_border = "single",
  on_attach_callback = nil,
  on_init_callback = nil,
  null_ls = { setup = {} },
}

JM.lang = { emmet = { active = true } }

function JM.mapper(mode, is_noremap)
  is_noremap = is_noremap or true
  local map_opts = { noremap = is_noremap, silent = true }

  return function(key, rhs)
    vim.api.nvim_set_keymap(mode, key, rhs, map_opts)
  end
end

function JM.notify(message, level, title)
  local notify = require "notify"
  local log_level = level or "error"

  notify(message, log_level, { title = title or "Dependecy Error" })
end

local function load_lang(lang)
  local lang_path = string.format("lsp.languages.%s", lang)
  require(lang_path).setup()
end

local langs = {
  "c",
  "css",
  "dockerfile",
  "elm",
  "go",
  "graphql",
  "html",
  "javascript",
  "javascriptreact",
  "json",
  "lua",
  "python",
  "sh",
  "typescript",
  "typescriptreact",
  "vim",
  "yaml",
}

-- LSP
for _, lang in pairs(langs) do
  load_lang(lang)
end

require("jm.json_schemas").setup()
