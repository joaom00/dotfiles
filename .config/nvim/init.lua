require "globals"
require "plugins"
require "settings"
require "keymappings"

vim.g.python3_host_prog = "/usr/bin/python3"
vim.g.ultest_use_pty = 1

require("jm.colorscheme").xcode()
require("lsp.null-ls").setup()

require("jm.autocmds").define_augroups {
  terminal = {
    -- { "TermOpen", "*", "startinsert" },
    { "TermOpen", "*", "setlocal listchars= nonumber norelativenumber" },
  },
}

vim.keymap.set('n', '<space>ca', vim.lsp.buf.code_action, { buffer = 0 })
vim.keymap.set('n', '<space>ca', vim.lsp.buf.code_action)

local dap = require "dap"

dap.adapters.node2 = {
  type = "executable",
  command = "node",
  args = { os.getenv "HOME" .. "/vscode-node-debug2/out/src/nodeDebug.js" },
}

dap.configurations.javascript = {
  {
    type = "node2",
    request = "launch",
    program = "${workspaceFolder}/${file}",
    cwd = vim.fn.getcwd(),
    sourceMaps = true,
    protocol = "inspector",
    console = "integratedTerminal",
  },
}

dap.configurations.typescript = {
  {
    name = "Launch",
    type = "node2",
    request = "launch",
    program = "${file}",
    cwd = vim.fn.getcwd(),
    sourceMaps = true,
    protocol = "inspector",
    console = "integratedTerminal",
  },
  {
    name = "Attach to process",
    type = "node2",
    request = "attach",
    processId = require("dap.utils").pick_process,
  },
}

local lspconfig_util = require "lspconfig.util"

local function on_attach(client, bufnr)
  client.server_capabilities.document_formatting = false
  require("navigator.lspclient.mapping").setup {
    client = client,
    bufnr = bufnr,
    cap = client.resolved_capabilities,
  }
end

require("lspconfig").tailwindcss.setup {
  on_attach = on_attach,
  root_dir = function(fname)
    return lspconfig_util.root_pattern("tailwind.config.js", "tailwind.config.ts")(fname)
  end,
}
