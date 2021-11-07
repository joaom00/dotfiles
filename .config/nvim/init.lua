require "default-config"
require "keymappings"
require "settings"
require "theme"
require "plugins"

vim.g.omni_dev = true
vim.g.purple_daze_dev = true
vim.cmd("colorscheme " .. JM.colorscheme)

vim.g.mapleader = JM.leader

local utils = require "utils"
utils.toggle_autoformat()

require("lsp").config()

local null_status_ok, null_ls = pcall(require, "null-ls")
if null_status_ok then
  null_ls.config {}
  require("lspconfig")["null-ls"].setup(JM.lsp.null_ls.setup)
end

local lsp_settings_status_ok, lsp_settings = pcall(require, "nlspsettings")
if lsp_settings_status_ok then
  lsp_settings.setup { config_home = os.getenv "HOME" .. "/.config/nvim/lsp-settings" }
end

require("jm.autocmds").define_augroups {
  autolsp = { { "Filetype", "*", "lua require('utils.ft').do_filetype(vim.fn.expand(\"<amatch>\"))" } },
}
