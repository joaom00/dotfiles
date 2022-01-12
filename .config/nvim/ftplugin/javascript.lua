local opts = {}

local servers = require "nvim-lsp-installer.servers"
local server_available, requested_server = servers.get_server "tsserver"

if server_available then
  opts.cmd_env = requested_server:get_default_options().cmd_env
end

require("lsp").setup("tsserver", opts)
