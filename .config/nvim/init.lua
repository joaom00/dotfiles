require "default-config"
require "plugins"
require "settings"
require "keymappings"
require "theme"

-- vim.g.omni_dev = true
-- vim.g.purpledaze_dev = true
-- vim.g.purpledaze_dark_sidebar = true
-- vim.cmd("colorscheme " .. JM.colorscheme)
require "jm.gruvbuddy"

vim.g.lightline = { coloscheme = "purpledaze" }

require("jm.autocmds").define_augroups {
  autoformat = {
    { "BufWritePre", "*", ":silent lua vim.lsp.buf.formatting_sync({}, 1000)" },
  },
  terminal = {
    { "TermOpen", "*", "startinsert" },
    { "TermOpen", "*", "setlocal listchars= nonumber norelativenumber" },
  },
  autolsp = {
    { "Filetype", "*", "lua require('utils.ft').do_filetype(vim.fn.expand(\"<amatch>\"))" },
  },
}

require("lsp").config()

local lsp_settings_status_ok, lsp_settings = pcall(require, "nlspsettings")
if lsp_settings_status_ok then
  lsp_settings.setup { config_home = os.getenv "HOME" .. "/.config/nvim/lsp-settings" }
end

local lspconfig_util = require "lspconfig.util"

require("lspconfig").tailwindcss.setup {
  cmd = { DATA_PATH .. "/lsp_servers/tailwindcss_npm/node_modules/.bin/tailwindcss-language-server", "--stdio" },
  root_dir = function(fname)
    return lspconfig_util.root_pattern("tailwind.config.js", "tailwind.config.ts")(fname)
  end,
}

require("lspconfig").prismals.setup {
  cmd = { DATA_PATH .. "/lsp_servers/prismals/node_modules/.bin/prisma-language-server", "--stdio" },
}

require("lsp.null-ls.formatters").setup {
  {
    exe = "prettier",
    extra_args = {
      "--print-width 100",
      "--tab-width 2",
    },
  },
  {
    exe = "stylua",
  },
  {
    exe = "gofumpt",
  },
  {
    exe = "golines",
  },
  {
    exe = "black",
  },
  {
    exe = "rustfmt",
  },
}

require("lsp.null-ls.linters").setup {
  {
    exe = "eslint",
  },
  {
    exe = "pylint",
  },
  -- {
  --   exe = "golangci_lint",
  -- },
}

require("lsp.null-ls.code_actions").setup {
  {
    name = "eslint",
  },
}

local dap = require "dap"

dap.adapters.chrome = {
  type = "executable",
  command = "node",
  args = { os.getenv "HOME" .. "/dev/vscode-chrome-debug/out/src/chromeDebug.js" }, -- TODO adjust
}

dap.configurations.javascriptreact = { -- change this to javascript if needed
  {
    type = "chrome",
    request = "attach",
    program = "${file}",
    cwd = vim.fn.getcwd(),
    sourceMaps = true,
    protocol = "inspector",
    port = 9222,
    webRoot = "${workspaceFolder}",
  },
}

dap.configurations.typescriptreact = { -- change to typescript if needed
  {
    type = "chrome",
    request = "attach",
    program = "${file}",
    cwd = vim.fn.getcwd(),
    sourceMaps = true,
    protocol = "inspector",
    port = 9222,
    webRoot = "${workspaceFolder}",
  },
}
