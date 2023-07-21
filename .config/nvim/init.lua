-- vim.g.python3_host_prog = "/usr/bin/python3"
-- vim.g.ultest_use_pty = 1

local g = vim.g
local fn = vim.fn
local opt = vim.opt
local loop = vim.loop
local cmd = vim.cmd
local data = fn.stdpath "data"

----------------------------------------------------------------------------------------------------
-- Ensure all autocommands are cleared
vim.api.nvim_create_augroup("vimrc", {})
----------------------------------------------------------------------------------------------------
-- Leader bindings
----------------------------------------------------------------------------------------------------
g.mapleader = "-" -- Remap leader key
g.maplocalleader = " " -- Local leader is <Space>
----------------------------------------------------------------------------------------------------
-- Global namespace
----------------------------------------------------------------------------------------------------

local namespace = {
  ui = {
    winbar = { enable = true },
    foldtext = { enable = false },
  },
  -- some vim mappings require a mixture of commandline commands and function calls
  -- this table is place to store lua functions to be called in those mappings
  mappings = { enable = true },
}

_G.jm = jm or namespace
_G.map = vim.keymap.set
----------------------------------------------------------------------------------------------------
-- Settings
----------------------------------------------------------------------------------------------------
require "jm.globals"
require "jm.highlights"
require "jm.ui"
require "settings"
require "keymappings"
-----------------------------------------------------------------------------//
-- Plugins
-----------------------------------------------------------------------------//
local lazypath = data .. "/lazy/lazy.nvim"
if not loop.fs_stat(lazypath) then
  fn.system {
    "git",
    "clone",
    "--filter=blob:none",
    "--single-branch",
    "https://github.com/folke/lazy.nvim.git",
    lazypath,
  }
end
opt.runtimepath:prepend(lazypath)
-----------------------------------------------------------------------------
require("lazy").setup("jm.plugins", {
  defaults = { lazy = true },
  change_detection = { notify = false },
  checker = {
    enabled = true,
    concurrency = 30,
    notify = false,
    frequency = 3600, -- check for updates every hour
  },
})

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

      require("telescope.builtin").fd()

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
-----------------------------------------------------------------------------//
-- Color Scheme {{{1
-----------------------------------------------------------------------------//
jm.wrap_err("theme failed to load because", cmd.colorscheme, "horizon")
