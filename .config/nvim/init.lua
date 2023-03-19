vim.g.python3_host_prog = "/usr/bin/python3"
vim.g.ultest_use_pty = 1

require "jm.globals"
require "plugins"
require "settings"
require "keymappings"

require("colorizer").setup {
  user_default_options = {
    rgb_fn = true,
    hsl_fn = true,
    css = true,
    css_fn = true,
    tailwind = "both",
  },
}
require("jm.colorscheme").xcode()
require("lsp.null-ls").setup()
require "lsp"

require("jm.autocmds").define_augroups {
  terminal = {
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

vim.cmd [[
  augroup packer_user_config
    autocmd!
    autocmd BufWritePost plugins.lua source <afile> | PackerCompile
  augroup end
]]

vim.keymap.set("i", "<c-c>", "<esc>")

-- Telescope hijack_netrw
vim.g.loaded_netrw = 1
vim.g.loaded_netrwPlugin = 1

local netrw_bufname

pcall(vim.api.nvim_clear_autocmds, { group = "FileExplorer" })

vim.api.nvim_create_autocmd("VimEnter", {
  pattern = "*",
  once = true,
  callback = function()
    pcall(vim.api.nvim_clear_autocmds, { group = "FileExplorer" })
  end,
})
vim.api.nvim_create_autocmd("BufEnter", {
  group = vim.api.nvim_create_augroup("telescope-hijack-netrw", { clear = true }),
  pattern = "*",
  callback = function()
    vim.schedule(function()
      local bufname = vim.api.nvim_buf_get_name(0)
      if vim.fn.isdirectory(bufname) == 0 then
        netrw_bufname = vim.fn.expand "#:p:h"
        return
      end

      -- prevents reopening of file-browser if exiting without selecting a file
      if netrw_bufname == bufname then
        netrw_bufname = nil
        return
      else
        netrw_bufname = bufname
      end

      -- ensure no buffers remain with the directory name
      vim.api.nvim_buf_set_option(0, "bufhidden", "wipe")

      require("jm.telescope").fd()

      -- vim.fn.system "git rev-parse --is-inside-work-tree"
      -- local is_git = vim.v.shell_error == 0

      -- if is_git then
      --   -- Find root of git directory and remove trailing newline characters
      --   local cwd = string.gsub(vim.fn.system "git rev-parse --show-toplevel", "[\n\r]+", "")
      --   require("jm.telescope").git_files(cwd)
      -- else
      --   require("jm.telescope").fd()
      --   -- require("jm.telescope").git_files(cwd)
      -- end
    end)
  end,
  desc = "Telescope replacement for netrw",
})

--local dap = require "dap"

--dap.adapters.node2 = {
-- type = "executable",
-- command = "node",
--args = { os.getenv "HOME" .. "/vscode-node-debug2/out/src/nodeDebug.js" },
--}

--dap.configurations.javascript = {
-- {
--   type = "node2",
-- request = "launch",
--  program = "${workspaceFolder}/${file}",
--  cwd = vim.fn.getcwd(),
-- sourceMaps = true,
--  protocol = "inspector",
--  console = "integratedTerminal",
-- },
--}

--dap.configurations.typescript = {
-- {
--  name = "Launch",
--   type = "node2",
--   request = "launch",
--   program = "${file}",
--   cwd = vim.fn.getcwd(),
--   sourceMaps = true,
--   protocol = "inspector",
--   console = "integratedTerminal",
-- },
-- {
-- name = "Attach to process",
--   type = "node2",
--   request = "attach",
--   processId = require("dap.utils").pick_process,
-- },
--}
