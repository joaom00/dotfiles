-- local diffview_ok, diffview = pcall(require, "diffview")
-- if not diffview_ok then
--   JM.notify "Missing diffview dependency"
--   return
-- end

local M = {}

function M.config()
  require("diffview").setup {
    default_args = {
      DiffviewFileHistory = { "%" },
    },
    hooks = {
      diff_buf_read = function()
        vim.wo.wrap = false
        vim.wo.list = false
        vim.wo.colorcolumn = ""
      end,
    },
    enhanced_diff_hl = true,
    keymaps = {
      view = { ["q"] = "<Cmd>DiffviewClose<CR>" },
      file_panel = { ["q"] = "<Cmd>DiffviewClose<CR>" },
      file_history_panel = { ["q"] = "<Cmd>DiffviewClose<CR>" },
    },
  }
end

-- local highlight = function(group, options)
--   local guibg = options.bg or "NONE"
--   local guifg = options.fg or "NONE"

--   vim.cmd(string.format("highlight %s guibg=%s guifg=%s", group, guibg, guifg))
-- end

-- local link = function(groupa, groupb)
--   vim.cmd(string.format("highlight link %s %s", groupa, groupb))
-- end

-- local sanediffdefaults = function()
--   highlight("DiffAdd", { bg = "#283B4D" })
--   highlight("DiffDelete", { bg = "#3C2C3C" })
--   highlight("DiffChange", { bg = "#28304D" })
--   highlight("DiffText", { bg = "#36426B" })
--   highlight("DiffAddAsDelete", { bg = "#3C2C3C" })

--   link("diffAdded", "DiffAdd")
--   link("diffChanged", "DiffAdd")
--   link("diffReved", "DiffAdd")
--   link("diffBDiffer", "DiffAdd")
--   link("diffCoon", "DiffAdd")
--   link("diffDiffer", "DiffAdd")
--   link("diffFile", "DiffAdd")
--   link("diffIdentical", "DiffAdd")
--   link("diffIndexLine", "DiffAdd")
--   link("diffIsA", "DiffAdd")
--   link("diffNoEOL", "DiffAdd")
--   link("diffOnly", "DiffAdd")
--   link("GitsignsAdd", "String")
--   link("DiffviewNorl", "NorlSB")
-- end

function M.setup()
  JM.nnoremap("<leader>d", "<cmd>DiffviewOpen<CR>", "diffview: open")
  JM.nnoremap("<leader>df", "<cmd>DiffviewFileHistory<CR>", "diffview: file history")
  JM.vnoremap("gh", "[[:'<'>DiffviewFileHistory<CR>]]", "diffview: file history")
  -- nnoremap("dc", "<cmd>DiffviewClose<CR>")
  -- sanediffdefaults()
end

return M
