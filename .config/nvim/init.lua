require "default-config"
require "plugins"
require "settings"
require "keymappings"
require "theme"

vim.g.omni_dev = true
vim.g.purpledaze_dev = true
vim.g.purpledaze_dark_sidebar = true
vim.cmd("colorscheme " .. JM.colorscheme)

vim.g.mapleader = JM.leader
vim.g.lightline = { coloscheme = "purpledaze" }

--local utils = require "utils"
--utils.toggle_autoformat()

require("lsp").config()

local null_status_ok, null_ls = pcall(require, "null-ls")
if null_status_ok then
  -- null_ls.config {}
  --  require("lspconfig")["null-ls"].setup(JM.lsp.null_ls.setup)
  -- null_ls.setup(JM.lsp.null_ls.setup)
  null_ls.setup {
    sources = {
      null_ls.builtins.formatting.prettier,
      null_ls.builtins.formatting.stylua,
      null_ls.builtins.diagnostics.eslint,
    },
  }
end

local lsp_settings_status_ok, lsp_settings = pcall(require, "nlspsettings")
if lsp_settings_status_ok then
  lsp_settings.setup { config_home = os.getenv "HOME" .. "/.config/nvim/lsp-settings" }
end

require("jm.autocmds").define_augroups {
  autolsp = { { "Filetype", "*", "lua require('utils.ft').do_filetype(vim.fn.expand(\"<amatch>\"))" } },
}

require("lspconfig").prismals.setup {
  cmd = { DATA_PATH .. "/lsp_servers/prismals/node_modules/.bin/prisma-language-server", "--stdio" },
}

require("jm.autocmds").define_augroups {
  autoformat = { { "BufWritePre", "*", ":silent lua vim.lsp.buf.formatting_sync({}, 1000)" } },
}
