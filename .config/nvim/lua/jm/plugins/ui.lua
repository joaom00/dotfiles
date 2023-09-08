local fn, api = vim.fn, vim.api
local icons = jm.ui.icons.lsp
local ui = jm.ui
local border = ui.current.border
local strwidth = api.nvim_strwidth

return {
  {
    "lukas-reineke/virt-column.nvim",
    enabled = false,
    event = "VimEnter",
    opts = { char = "▕" },
    init = function()
      jm.augroup("VirtCol", {
        event = { "VimEnter", "BufEnter", "WinEnter" },
        command = function(args)
          ui.decorations.set_colorcolumn(args.buf, function(virtcolumn)
            require("virt-column").setup_buffer { virtcolumn = virtcolumn }
          end)
        end,
      })
    end,
  },
  {
    "lukas-reineke/indent-blankline.nvim",
    enabled = false,
    lazy = false,
    opts = {
      char = "│", -- ┆ ┊ 
      show_foldtext = false,
      context_char = "▎",
      char_priority = 12,
      show_current_context = true,
      show_current_context_start = true,
      show_current_context_start_on_current_line = false,
      show_first_indent_level = true,
      -- stylua: ignore
      filetype_exclude = {
        'dbout', 'neo-tree-popup', 'log', 'gitcommit',
        'txt', 'help', 'NvimTree', 'git', 'flutterToolsOutline',
        'undotree', 'markdown', 'norg', 'org', 'orgagenda',
        '', -- for all buffers without a file type
      },
    },
  },
  {
    "stevearc/dressing.nvim",
    init = function()
      ---@diagnostic disable-next-line: duplicate-set-field
      vim.ui.select = function(...)
        require("lazy").load { plugins = { "dressing.nvim" } }
        return vim.ui.select(...)
      end
    end,
    opts = {
      input = { enabled = false },
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
  {
    "levouh/tint.nvim",
    enabled = false,
    event = "WinNew",
    branch = "untint-forcibly-closed-windows",
    opts = {
      tint = -30,
      -- stylua: ignore
      window_ignore_function = function(win_id)
        local win, buf = vim.wo[win_id], vim.bo[vim.api.nvim_win_get_buf(win_id)]
        -- TODO: ideally tint should just ignore all buffers with a special type other than maybe "acwrite"
        -- since if there is a custom buftype it's probably a special buffer we always want to pay
        -- attention to whilst its open.
        -- BUG: neo-tree cannot be ignore as either nofile or by filetype as this causes tinting bugs
        if win.diff or not jm.empty(fn.win_gettype(win_id)) then
          return true
        end
        local ignore_bt = jm.p_table { terminal = true, prompt = true, nofile = false }
        local ignore_ft = jm.p_table { ["Telescope.*"] = true, ["Neogit.*"] = true, ["qf"] = true }
        local has_bt, has_ft = ignore_bt[buf.buftype], ignore_ft[buf.filetype]
        return has_bt or has_ft
      end,
    },
  },
  {
    "akinsho/bufferline.nvim",
    event = "VimEnter",
    dependencies = { "nvim-tree/nvim-web-devicons" },
    config = function()
      local groups = require "bufferline.groups"
      require("bufferline").setup {
        options = {
          debug = { logging = true },
          mode = "buffers",
          sort_by = "insert_after_current",
          right_mouse_command = "vert sbuffer %d",
          show_close_icon = false,
          show_buffer_close_icons = true,
          indicator = { style = "underline" },
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
    "kevinhwang91/nvim-ufo",
    enabled = false,
    event = "VeryLazy",
    dependencies = { "kevinhwang91/promise-async" },
    keys = {
      {
        "zR",
        function()
          require("ufo").openAllFolds()
        end,
        "open all folds",
      },
      {
        "zM",
        function()
          require("ufo").closeAllFolds()
        end,
        "close all folds",
      },
      {
        "zP",
        function()
          require("ufo").peekFoldedLinesUnderCursor()
        end,
        "preview fold",
      },
    },
    opts = {
      open_fold_hl_timeout = 0,
      preview = { win_config = { winhighlight = "Normal:Normal,FloatBorder:Normal" } },
      enable_get_fold_virt_text = true,
      fold_virt_text_handler = function(virt_text, _, end_lnum, width, truncate, ctx)
        local result = {}
        local padding = ""
        local cur_width = 0
        local suffix_width = strwidth(ctx.text)
        local target_width = width - suffix_width

        for _, chunk in ipairs(virt_text) do
          local chunk_text = chunk[1]
          local chunk_width = strwidth(chunk_text)
          if target_width > cur_width + chunk_width then
            table.insert(result, chunk)
          else
            chunk_text = truncate(chunk_text, target_width - cur_width)
            local hl_group = chunk[2]
            table.insert(result, { chunk_text, hl_group })
            chunk_width = strwidth(chunk_text)
            if cur_width + chunk_width < target_width then
              padding = padding .. (" "):rep(target_width - cur_width - chunk_width)
            end
            break
          end
          cur_width = cur_width + chunk_width
        end

        local end_text = ctx.get_fold_virt_text(end_lnum)
        -- reformat the end text to trim excess whitespace from
        -- indentation usually the first item is indentation
        if end_text[1] and end_text[1][1] then
          end_text[1][1] = end_text[1][1]:gsub("[%s\t]+", "")
        end

        table.insert(result, { " ⋯ ", "UfoFoldedEllipsis" })
        vim.list_extend(result, end_text)
        table.insert(result, { padding, "" })

        return result
      end,
      provider_selector = function()
        return { "treesitter", "indent" }
      end,
    },
  },
  {
    "ray-x/lsp_signature.nvim",
    dev = true,
    enabled = true,
    event = "InsertEnter",
    config = function()
      require("lsp_signature").setup {
        hint_enable = false,
        handler_opts = { border = "single" },
        max_width = 80,
        check_completion_visible = false,
        -- bind = true,
        -- toggle_key = "<C-x>",
        -- floating_window = true,
        -- floating_window_above_cur_line = true,
        -- hint_enable = false,
        -- fix_pos = false,
        -- max_height = 4,
        -- auto_close_after = 15,
      }
    end,
  },
}
