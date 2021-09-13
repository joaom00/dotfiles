local M = {}
local nnoremap = JM.mapper "n"

function M.config()
  JM.nvimtree = {
    side = "left",
    width = 40,
    show_icons = { git = 1, folders = 1, files = 1, folder_arrows = 1 },
    ignore = { ".git", "node_modules", ".cache" },
    auto_open = 0,
    auto_close = 1,
    hide_dotfiles = 0,
    quit_on_open = 0,
    follow = 1,
    indent_markers = 1,
    git_hl = 1,
    root_folder_modifier = ":t",
    tab_open = 0,
    allow_resize = 1,
    lsp_diagnostics = 1,
    auto_ignore_ft = { "startify", "dashboard" },
    icons = {
      default = "",
      symlink = "",
      git = {
        unstaged = "",
        staged = "S",
        unmerged = "",
        renamed = "➜",
        deleted = "",
        untracked = "U",
        ignored = "◌",
      },
      folder = { default = "", open = "", empty = "", empty_open = "", symlink = "" },
    },
  }
end

function M.keymappings()
  nnoremap("<space>e", "<cmd>NvimTreeToggle<CR>")
end

function M.on_open()
  if package.loaded["bufferline.state"] and JM.nvimtree.side == "left" then
    require("bufferline.state").set_offset(JM.nvimtree.width + 1, "")
  end
end

function M.on_close()
  local buf = tonumber(vim.fn.expand "<abuf>")
  local ft = vim.api.nvim_buf_get_option(buf, "filetype")
  if ft == "NvimTree" and package.loaded["bufferline.state"] then
    require("bufferline.state").set_offset(0)
  end
end

function M.change_tree_dir(dir)
  local lib_status_ok, lib = pcall(require, "nvim-tree.lib")
  if lib_status_ok then
    lib.change_dir(dir)
  end
end

function M.setup()
  M.config()
  M.keymappings()

  local nvim_tree_config_ok, nvim_tree_config = pcall(require, "nvim-tree.config")
  if not nvim_tree_config_ok then
    JM.notify "Failed to load NvimTree Config"
    return
  end

  local g = vim.g

  for opt, val in pairs(JM.nvimtree) do
    g["nvim_tree_" .. opt] = val
  end

  -- Implicitly update nvim-tree when project module is active
  vim.g.nvim_tree_update_cwd = 1
  vim.g.nvim_tree_respect_buf_cwd = 1
  vim.g.nvim_tree_disable_netrw = 0
  vim.g.nvim_tree_hijack_netrw = 0
  vim.g.netrw_banner = 0

  local tree_cb = nvim_tree_config.nvim_tree_callback

  if not g.nvim_tree_bindings then
    g.nvim_tree_bindings = {
      { key = { "l", "<CR>", "o" }, cb = tree_cb "edit" },
      { key = "h", cb = tree_cb "close_node" },
      { key = "v", cb = tree_cb "vsplit" },
    }
  end

  local tree_view = require "nvim-tree.view"

  -- Add nvim_tree open callback
  local open = tree_view.open
  tree_view.open = function()
    M.on_open()
    open()
  end

  vim.cmd "au WinClosed * lua require('jm.nvimtree').on_close()"
end

return M
