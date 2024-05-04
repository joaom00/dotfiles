local fn, api = vim.fn, vim.api
local icons = jm.ui.icons.lsp
local ui = jm.ui
local border = ui.current.border
-- local uLualine = require "jm.util.lualine"

return {
  {
    "nvim-lualine/lualine.nvim",
    dependencies = { "nvim-tree/nvim-web-devicons" },
    event = "VeryLazy",
    config = function()
      require("lualine").setup {
        options = {
          icons_enabled = true,
          theme = "gruvbox-material",
          component_separators = { left = "", right = "" },
          section_separators = { left = "", right = "" },
          disabled_filetypes = {
            statusline = {},
            winbar = {},
          },
          ignore_focus = {},
          always_divide_middle = true,
          globalstatus = false,
          refresh = {
            statusline = 1000,
            tabline = 1000,
            winbar = 1000,
          },
        },
        sections = {
          lualine_a = { "mode" },
          lualine_b = { "branch", "diff", "diagnostics" },
          lualine_c = { "filename" },
          lualine_x = { "encoding", "fileformat", "filetype" },
          lualine_y = { "progress" },
          lualine_z = { "location" },
        },
        inactive_sections = {
          lualine_a = {},
          lualine_b = {},
          lualine_c = { "filename" },
          lualine_x = { "location" },
          lualine_y = {},
          lualine_z = {},
        },
        tabline = {},
        winbar = {},
        inactive_winbar = {},
        extensions = {},
      }
    end,
  },
  {
    "stevearc/dressing.nvim",
    event = "VeryLazy",
    enabled = true,
    opts = {
      input = {
        override = function(conf)
          conf.col = -1
          conf.row = 0
          return conf
        end,
      },
      select = {
        -- telescope = jm.telescope.adaptive_dropdown(),
        builtin = {
          border = border,
          min_height = 10,
          win_options = { winblend = 10 },
          mappings = { n = { ["q"] = "Close" } },
        },
        nui = { min_height = 10, win_options = { winblend = 10 } },
        -- get_config = function(opts)
        --   if opts.kind == "codeaction" then
        --     return { backend = "telescope", telescope = as.telescope.cursor() }
        --   end
        -- end,
      },
    },
  },
  {
    "rcarriga/nvim-notify",
    init = function()
      local notify = require "notify"

      notify.setup {
        timeout = 5000,
        stages = "fade_in_slide_out",
        top_down = false,
        background_colour = "NormalFloat",
        max_width = function()
          return math.floor(vim.o.columns * 0.6)
        end,
        max_height = function()
          return math.floor(vim.o.lines * 0.8)
        end,
        on_open = function(win)
          if not api.nvim_win_is_valid(win) then
            return
          end
          api.nvim_win_set_config(win, { border = border })
        end,
        render = function(...)
          local notification = select(2, ...)
          local style = jm.empty(notification.title[1]) and "minimal" or "default"
          require("notify.render")[style](...)
        end,
      }
      map("n", "<leader>nd", function()
        notify.dismiss { silent = true, pending = true }
      end, {
        desc = "dismiss notifications",
      })
    end,
  },
  { "echasnovski/mini.bufremove", version = "*" },
  {
    "akinsho/bufferline.nvim",
    event = "VeryLazy",
    dependencies = { "nvim-tree/nvim-web-devicons" },
    config = function()
      local groups = require "bufferline.groups"
      require("bufferline").setup {
        options = {
          mode = "buffers",
          sort_by = "insert_after_current",
          -- right_mouse_command = "vert sbuffer %d",
          -- stylua: ignore
          close_command = function (n) require('mini.bufremove').delete(n, false) end,
          -- stylua: ignore
          right_mouse_command = function (n) require('mini.bufremove').delete(n, false) end,
          show_close_icon = false,
          show_buffer_close_icons = true,
          always_show_bufferline = false,
          -- indicator = { style = "underline" },
          diagnostics = "nvim_lsp",
          diagnostics_indicator = function(count, level)
            level = level:match "warn" and "warn" or level
            return (icons[level] or "?") .. " " .. count
          end,
          diagnostics_update_in_insert = false,
          hover = { enabled = true, reveal = { "close" } },
          offsets = {
            {
              text = "EXPLORER",
              filetype = "neo-tree",
              highlight = "PanelHeading",
              text_align = "left",
              separator = true,
            },
            {
              text = " FLUTTER OUTLINE",
              filetype = "flutterToolsOutline",
              highlight = "PanelHeading",
              separator = true,
            },
            {
              text = "UNDOTREE",
              filetype = "undotree",
              highlight = "PanelHeading",
              separator = true,
            },
            {
              text = " DATABASE VIEWER",
              filetype = "dbui",
              highlight = "PanelHeading",
              separator = true,
            },
            {
              text = " DIFF VIEW",
              filetype = "DiffviewFiles",
              highlight = "PanelHeading",
              separator = true,
            },
          },
          groups = {
            options = { toggle_hidden_on_enter = true },
            items = {
              groups.builtin.pinned:with { icon = "" },
              groups.builtin.ungrouped,
              {
                name = "Dependencies",
                icon = "",
                highlight = { fg = "#ECBE7B" },
                matcher = function(buf)
                  return vim.startswith(buf.path, vim.env.VIMRUNTIME)
                end,
              },
              {
                name = "Terraform",
                matcher = function(buf)
                  return buf.name:match "%.tf" ~= nil
                end,
              },
              {
                name = "Kubernetes",
                matcher = function(buf)
                  return buf.name:match "kubernetes" and buf.name:match "%.yaml"
                end,
              },
              -- {
              --   name = "SQL",
              --   matcher = function(buf)
              --     return buf.filename:match "%.sql$"
              --   end,
              -- },
              -- {
              --   name = "tests",
              --   icon = "",
              --   matcher = function(buf)
              --     local name = buf.filename
              --     if name:match "%.sql$" == nil then
              --       return false
              --     end
              --     return name:match "_spec" or name:match "_test"
              --   end,
              -- },
              {
                name = "docs",
                icon = "",
                matcher = function(buf)
                  if vim.bo[buf.id].filetype == "man" or buf.path:match "man://" then
                    return true
                  end
                  for _, ext in ipairs { "md", "txt", "org", "norg", "wiki" } do
                    if ext == fn.fnamemodify(buf.path, ":e") then
                      return true
                    end
                  end
                end,
              },
            },
          },
        },
      }

      map("n", "<TAB>", "<cmd>BufferLineCycleNext<CR>")
      map("n", "<S-TAB>", "<cmd>BufferLineCyclePrev<CR>")
      map("n", "<C-x>", "<cmd>BufferLinePickClose<CR>")
      map("n", "<Space>cr", "<cmd>BufferLineCloseRight<CR>")
      map("n", "<Space>cl", "<cmd>BufferLineCloseLeft<CR>")
    end,
  },
  {
    "folke/noice.nvim",
    event = "VeryLazy",
    enabled = true,
    opts = {
      lsp = {
        -- override markdown rendering so that **cmp** and other plugins use **Treesitter**
        override = {
          ["vim.lsp.util.convert_input_to_markdown_lines"] = true,
          ["vim.lsp.util.stylize_markdown"] = true,
          ["cmp.entry.get_documentation"] = true,
        },
        hover = {
          enabled = false,
          silent = true,
        },
        signature = {
          enabled = false,
        },
        message = {
          view = "mini",
        },
      },
      messages = {
        view = "mini",
      },
      notify = {
        enabled = false,
      },
      -- you can enable a preset for easier configuration
      presets = {
        inc_rename = true, -- enables an input dialog for inc-rename.nvim
        lsp_doc_border = true, -- add a border to hover docs and signature help
      },
    },
    dependencies = {
      -- if you lazy-load any plugin below, make sure to add proper `module="..."` entries
      "MunifTanjim/nui.nvim",
      -- OPTIONAL:
      --   `nvim-notify` is only needed, if you want to use the notification view.
      --   If not available, we use `mini` as the fallback
      "rcarriga/nvim-notify",
    },
  },
}
