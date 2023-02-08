local M = {}
local nnoremap = JM.mapper "n"

function M.config()
  JM.nvimtree = {
    setup = {
      respect_buf_cwd = true,
      disable_netrw = false,
      hijack_netrw = false,
      open_on_setup = false,
      ignore_buffer_on_setup = false,
      ignore_ft_on_setup = {
        "startify",
        "dashboard",
        "alpha",
      },
      notify = {
        threshold = vim.log.levels.ERROR,
      },
      auto_reload_on_write = true,
      hijack_unnamed_buffer_when_opening = false,
      hijack_directories = {
        enable = true,
        auto_open = true,
      },
      open_on_tab = false,
      hijack_cursor = false,
      update_cwd = false,
      diagnostics = {
        enable = true,
        icons = {
          hint = "",
          info = "",
          warning = "",
          error = "",
        },
      },
      update_focused_file = {
        enable = true,
        update_cwd = true,
        ignore_list = {},
      },
      system_open = {
        cmd = nil,
        args = {},
      },
      git = {
        enable = true,
        ignore = false,
        timeout = 200,
      },
      view = {
        width = 50,
        hide_root_folder = false,
        side = "right",
        mappings = {
          custom_only = false,
          list = {},
        },
        number = false,
        relativenumber = false,
        signcolumn = "yes",
      },
      filters = {
        dotfiles = false,
        custom = { ".cache" },
      },
      trash = {
        cmd = "trash",
        require_confirm = true,
      },
      actions = {
        change_dir = {
          global = false,
        },
        open_file = {
          quit_on_open = false,
        },
        -- window_picker = {
        --   enable = false,
        --   chars = "ABCDEFGHIJKLMNOPQRSTUVWXYZ1234567890",
        --   exclude = {},
        -- },
      },
      renderer = {
        root_folder_modifier = ":t",
        indent_markers = {
          enable = true,
        },
        icons = {
          show = {
            git = true,
            file = true,
            folder = true,
            folder_arrow = true,
          },
          glyphs = {
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
        },
      },
    },
  }
end

function M.keymappings()
  nnoremap("<space>e", "<cmd>NvimTreeToggle<CR>")
end

function M.setup()
  M.config()
  M.keymappings()

  -- local ok = pcall(require, "nvim-tree.config")
  -- if not ok then
  --   JM.notify "Failed to load NvimTree Config"
  --   return
  -- end

  -- for opt, val in pairs(JM.nvimtree) do
  --   vim.g["nvim_tree_" .. opt] = val
  -- end

  -- local function telescope_find_files(_)
  --   require("jm.nvimtree").start_telescope "find_files"
  -- end

  -- local function telescope_live_grep(_)
  --   require("jm.nvimtree").start_telescope "live_grep"
  -- end

  -- if #JM.nvimtree.setup.view.mappings.list == 0 then
  --   JM.nvimtree.setup.view.mappings.list = {
  --     { key = { "l", "<CR>", "o" }, action = "edit", mode = "n" },
  --     { key = "h", action = "close_node" },
  --     { key = "v", action = "vsplit" },
  --     { key = "C", action = "cd" },
  --     { key = "gtf", action = "telescope_find_files", action_cb = telescope_find_files },
  --     { key = "gtg", action = "telescope_live_grep", action_cb = telescope_live_grep },
  --   }
  -- end

  require("nvim-tree").setup(JM.nvimtree.setup)
  -- require("nvim-tree").setup()
end

-- function M.start_telescope(telescope_mode)
--   local node = require("nvim-tree.lib").get_node_at_cursor()
--   local abspath = node.link_to or node.absolute_path
--   local is_folder = node.open ~= nil
--   local basedir = is_folder and abspath or vim.fn.fnamemodify(abspath, ":h")
--   require("telescope.builtin")[telescope_mode] {
--     cwd = basedir,
--   }
-- end

return M
