local fn, api = vim.fn, vim.api

return {
  {
    "nvim-neo-tree/neo-tree.nvim",
    branch = "v3.x",
    cmd = { "Neotree" },
    keys = { { "<c-e>", "<cmd>Neotree toggle reveal<CR>", desc = "NeoTree" } },
    config = function()
      require("neo-tree").setup {
        sources = { "filesystem", "git_status", "document_symbols" },
        source_selector = {
          winbar = true,
          separator_active = "",
          sources = {
            { source = "filesystem" },
            { source = "git_status" },
            { source = "document_symbols" },
          },
        },
        enable_git_status = true,
        enable_normal_mode_for_inputs = true,
        git_status_async = true,
        filesystem = {
          hijack_netrw_behavior = "disabled",
          use_libuv_file_watcher = true,
          group_empty_dirs = false,
          follow_current_file = {
            enabled = true,
            leave_dirs_open = true,
          },
          filtered_items = {
            visible = true,
            hide_dotfiles = false,
            hide_gitignored = true,
            never_show = { ".DS_Store" },
          },
          window = {
            position = "float",
            mappings = {
              ["/"] = "noop",
              ["g/"] = "fuzzy_finder",
              ["o"] = "system_open",
            },
          },
          commands = {
            system_open = function(state)
              local node = state.tree:get_node()
              local path = node:get_id()
              path = fn.shellescape(path)
              api.nvim_command("silent !xdg-open " .. path)
            end,
          },
        },
        default_component_configs = {
          indent = {
            with_markers = false,
            with_expanders = true,
          },
          modified = {
            symbol = " ",
            highlight = "NeoTreeModified",
          },
          icon = {
            folder_closed = "",
            folder_open = "",
            folder_empty = "",
            folder_empty_open = "",
          },
          git_status = {
            symbols = {
              -- Change type
              added = "",
              deleted = "",
              modified = "",
              renamed = "",
              -- Status type
              untracked = "",
              ignored = "",
              unstaged = "",
              staged = "",
              conflict = "",
            },
          },
        },
        window = {
          mappings = {
            ["o"] = "toggle_node",
            ["<CR>"] = "open",
            ["<c-s>"] = "open_split",
            ["<c-v>"] = "open_vsplit",
            ["<esc>"] = "revert_preview",
            ["P"] = { "toggle_preview", config = { use_float = true } },
          },
        },
      }
    end,
    dependencies = {
      "nvim-lua/plenary.nvim",
      "MunifTanjim/nui.nvim",
      "nvim-tree/nvim-web-devicons",
      {
        "s1n7ax/nvim-window-picker",
        version = "*",
        config = function()
          require("window-picker").setup {
            hint = "floating-big-letter",
            autoselect_one = true,
            include_current = false,
            filter_rules = {
              bo = {
                filetype = { "neo-tree-popup", "quickfix" },
                buftype = { "terminal", "quickfix", "nofile" },
              },
            },
          }
        end,
      },
    },
  },
}
