CONFIG_PATH = vim.fn.stdpath "config"
DATA_PATH = vim.fn.stdpath "data"
CACHE_PATH = vim.fn.stdpath "cache"
TERMINAL = vim.fn.expand "$TERMINAL"
USER = vim.fn.expand "$USER"

P = function(v)
  print(vim.inspect(v))
  return v
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
        { name = "DiagnosticsSignError", text = " " },
        { name = "DiagnosticsSignWarn", text = "" },
        { name = "DiagnosticsSignHint", text = "" },
        { name = "DiagnosticsSignInfo", text = "" },
      },
    },
    virtual_text = false,
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

JM.lang = { emmet = { active = true } }

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
  "tailwindcss",
  "vim",
  "vue",
  "yaml",
}

-- LSP
for _, lang in pairs(langs) do
  load_lang(lang)
end

require("jm.json_schemas").setup()
