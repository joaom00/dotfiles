local fn, api = vim.fn, vim.api
local highlight = jm.highlight
local icons = jm.ui.icons
local autocmd = api.nvim_create_autocmd

return {
  {
    "nvim-neo-tree/neo-tree.nvim",
    branch = "v3.x",
    cmd = { "Neotree" },
    keys = { { "<c-e>", "<cmd>Neotree toggle reveal<CR>", desc = "NeoTree" } },
    init = function()
      autocmd("BufEnter", {
        desc = "Load NeoTree if entering a directory",
        callback = function(args)
          if fn.isdirectory(api.nvim_buf_get_name(args.buf)) > 0 then
            require("lazy").load { plugins = { "neo-tree.nvim" } }
            api.nvim_del_autocmd(args.id)
          end
        end,
      })
    end,
    config = function()
      local symbols = require("lspkind").symbol_map
      local lsp_kinds = jm.ui.lsp.highlights

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
            position = "right",
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
          icon = {
            folder_empty = icons.documents.open_folder,
          },
          name = {
            highlight_opened_files = true,
          },
          document_symbols = {
            follow_cursor = true,
            kinds = jm.fold(function(acc, v, k)
              acc[k] = { icon = v, hl = lsp_kinds[k] }
              return acc
            end, symbols),
          },
          modified = {
            symbol = icons.misc.circle .. " ",
          },
          git_status = {
            symbols = {
              added = icons.git.add,
              deleted = icons.git.remove,
              modified = icons.git.mod,
              renamed = icons.git.rename,
              untracked = icons.git.untracked,
              ignored = icons.git.ignored,
              unstaged = icons.git.unstaged,
              staged = icons.git.staged,
              conflict = icons.git.conflict,
            },
          },
        },
        window = {
          mappings = {
            ["o"] = "toggle_node",
            ["<CR>"] = "open",
            ["<c-s>"] = "split_with_window_picker",
            ["<c-v>"] = "vsplit_with_window_picker",
            ["<esc>"] = "revert_preview",
            ["P"] = { "toggle_preview", config = { use_float = false } },
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
            other_win_hl_color = highlight.get("Visual", "bg"),
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
