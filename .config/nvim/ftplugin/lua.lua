local opts = {
  settings = {
    Lua = {
      runtime = {
        version = "LuaJIT",
        path = vim.split(package.path, ";"),
      },
      diagnostics = {
        globals = { "vim", "JM" },
      },
      workspace = {
        library = {
          [vim.fn.expand "$VIMRUNTIME/lua"] = true,
          [vim.fn.expand "$VIMRUNTIME/lua/vim/lsp"] = true,
        },
        maxPreload = 100000,
        preloadFileSize = 1000,
      },
    },
  },
}

local servers = require "nvim-lsp-installer.servers"
local server_available, requested_server = servers.get_server "sumneko_lua"

if server_available then
  opts.cmd_env = requested_server:get_default_options().cmd_env
end

require("lsp").setup("sumneko_lua", opts)
