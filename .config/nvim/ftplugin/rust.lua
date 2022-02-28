local opts = {
  on_attach = require("lsp").common_on_attach,
  on_init = require("lsp").common_on_init,
  capabilities = require("lsp").common_capabilities(),
}

local servers = require "nvim-lsp-installer.servers"
local server_available, requested_server = servers.get_server "rust_analyzer"

if server_available then
  opts.cmd_env = requested_server:get_default_options().cmd_env
end

require("lsp").setup("rust_analyzer", opts)
