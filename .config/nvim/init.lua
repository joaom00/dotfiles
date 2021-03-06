require "globals"
require "plugins"
require "settings"
require "keymappings"

vim.g.python3_host_prog = "/usr/bin/python3"
vim.g.ultest_use_pty = 1

require("jm.colorscheme").gruvboxbaby()
require("lsp.null-ls").setup()
require "lsp"

require("jm.autocmds").define_augroups {
  terminal = {
    -- { "TermOpen", "*", "startinsert" },
    { "TermOpen", "*", "setlocal listchars= nonumber norelativenumber" },
  },
}

local highlight_group = vim.api.nvim_create_augroup("YankHighlight", { clear = true })
vim.api.nvim_create_autocmd("TextYankPost", {
  callback = function()
    vim.highlight.on_yank()
  end,
  group = highlight_group,
  pattern = "*",
})

vim.keymap.set("i", "<c-c>", "<esc>")

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
