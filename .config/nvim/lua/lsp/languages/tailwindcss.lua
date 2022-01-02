local lspconfig_util = require "lspconfig.util"

local M = {}

function M.config()
  JM.lang.tailwindcss = {}
end

function M.formatter()
  JM.lang.tailwindcss.formatters = {}
end

function M.linter()
  JM.lang.tailwindcss.linters = {}
end

function M.lsp()
  JM.lang.tailwindcss.lsp = {
    provider = "tailwindcss",
    setup = {
      cmd = { DATA_PATH .. "/lsp_servers/tailwindcss_npm/node_modules/.bin/tailwindcss-language-server", "--stdio" },
      root_dir = function(fname)
        return lspconfig_util.root_pattern("tailwind.config.js", "tailwind.config.ts")(fname)
      end,
      settings = {
        tailwindCSS = {
          classAttributes = { "class", "className", "classList" },
        },
      },
    },
  }
end

function M.setup()
  M.config()
  M.formatter()
  M.linter()
  M.lsp()
end

return M
