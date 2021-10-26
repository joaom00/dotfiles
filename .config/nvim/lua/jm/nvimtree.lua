local M = {}
local nnoremap = JM.mapper "n"

function M.config()
  JM.nvimtree = {
    setup = {
      update_cwd = 1,
      disable_netrw = 0,
      hijack_netrw = 0,
      open_on_setup = false,
      auto_close = true,
      open_on_tab = false,
      update_focused_file = {
        enable = true,
      },
      diagnostics = {
        enable = true,
        icons = {
          hint = "",
          info = "",
          warning = "",
          error = "",
        },
      },
      view = {
        width = 40,
        side = "left",
        auto_resize = false,
        mappings = {
          custom_only = false,
        },
      },
    },
    respect_buf_cwd = 1,
    indent_markers = 1,
    show_icons = {
      files = 1,
      git = 1,
      folders = 1,
      folder_arrows = 1,
    },
    ignore = { ".git", "node_modules", ".cache" },
    special_files = {},
    quit_on_open = 0,
    hide_dotfiles = 0,
    git_hl = 1,
    root_folder_modifier = ":t",
    allow_resize = 1,
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
      folder = {
        default = "",
        open = "",
        empty = "",
        empty_open = "",
        symlink = "",
      },
    },
  }
end

function M.keymappings()
  nnoremap("<space>e", "<cmd>NvimTreeToggle<CR>")
end

function M.on_open()
  if package.loaded["bufferline.state"] and JM.nvimtree.setup.view.side == "left" then
    require("bufferline.state").set_offset(JM.nvimtree.setup.view.width + 1, "")
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

  g.netrw_banner = 0

  local tree_cb = nvim_tree_config.nvim_tree_callback

  if not JM.nvimtree.setup.view.mappings.list then
    JM.nvimtree.setup.view.mappings.list = {
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

  require("nvim-tree").setup(JM.nvimtree.setup)
end

return M
