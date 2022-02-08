local diffview_ok, diffview = pcall(require, "diffview")
if not diffview_ok then
  JM.notify "Missing diffview dependency"
  return
end

local diffview_config_ok, diffview_config = pcall(require, "diffview.config")
if not diffview_config_ok then
  JM.notify "Failed to load diffview.config"
  return
end

local M = {}
local nnoremap = JM.mapper "n"
local cb = diffview_config.diffview_callback

function M.config()
  diffview.setup {
    diff_binaries = false,
    enhanced_diff_hl = true,
    use_icons = true,
    icons = {
      folder_closed = "",
      folder_open = "",
    },
    signs = {
      fold_closed = "",
      fold_open = "",
    },
    file_panel = {
      position = "left",
      width = 35,
      height = 10,
      listing_style = "list",
      tree_options = {
        flatten_dirs = true,
        folder_statuses = "only_folded",
      },
    },
    file_history_panel = {
      position = "bottom",
      width = 35,
      height = 16,
      log_options = {
        max_count = 256,
        follow = false,
        all = false,
        merges = false,
        no_merges = false,
        reverse = false,
      },
    },
    key_bindings = {
      disable_defaults = false,
      view = {
        ["<tab>"] = cb "select_next_entry",
        ["<s-tab>"] = cb "select_prev_entry",
        ["<C-w>gf"] = cb "goto_file",
        ["<C-w><C-f>"] = cb "goto_file_split",
        ["gf"] = cb "goto_file_tab",
        ["<leader>e"] = cb "focus_files",
        ["<leader>b"] = cb "toggle_files",
      },
      file_panel = {
        ["j"] = cb "next_entry",
        ["<down>"] = cb "next_entry",
        ["k"] = cb "prev_entry",
        ["<up>"] = cb "prev_entry",
        ["<cr>"] = cb "select_entry",
        ["o"] = cb "select_entry",
        ["<2-LeftMouse>"] = cb "select_entry",
        ["i"] = cb "toggle_stage_entry",
        ["S"] = cb "stage_all",
        ["U"] = cb "unstage_all",
        ["X"] = cb "restore_entry",
        ["R"] = cb "refresh_files",
        ["<tab>"] = cb "select_next_entry",
        ["<s-tab>"] = cb "select_prev_entry",
        ["gf"] = cb "goto_file",
        ["<C-w><C-f>"] = cb "goto_file_split",
        ["<C-w>gf"] = cb "goto_file_tab",
        ["<leader>e"] = cb "focus_files",
        ["<leader>b"] = cb "toggle_files",
      },
      file_history_panel = {
        ["g!"] = cb "options",
        ["<C-d>"] = cb "open_in_diffview",
        ["zR"] = cb "open_all_folds",
        ["zM"] = cb "close_all_folds",
        ["j"] = cb "next_entry",
        ["<down>"] = cb "next_entry",
        ["k"] = cb "prev_entry",
        ["<up>"] = cb "prev_entry",
        ["<cr>"] = cb "select_entry",
        ["o"] = cb "select_entry",
        ["<2-LeftMouse>"] = cb "select_entry",
        ["<tab>"] = cb "select_next_entry",
        ["<s-tab>"] = cb "select_prev_entry",
        ["<C-w>gf"] = cb "goto_file",
        ["<C-w><C-f>"] = cb "goto_file_split",
        ["gf"] = cb "goto_file_tab",
        ["<leader>e"] = cb "focus_files",
        ["<leader>b"] = cb "toggle_files",
      },
      option_panel = { ["<tab>"] = cb "select", ["q"] = cb "close" },
    },
  }
end

function M.keymappings()
  nnoremap("<leader>d", "<cmd>DiffviewOpen<CR>")
  nnoremap("<leader>df", "<cmd>DiffviewFileHistory<CR>")
  nnoremap("dc", "<cmd>DiffviewClose<CR>")
end

function M.highlight(group, options)
  local guibg = options.bg or "NONE"
  local guifg = options.fg or "NONE"

  vim.cmd(string.format("highlight %s guibg=%s guifg=%s", group, guibg, guifg))
end

function M.link(groupa, groupb)
  vim.cmd(string.format("highlight link %s %s", groupa, groupb))
end

function M.sanediffdefaults()
  M.highlight("DiffAdd", { bg = "#283B4D" })
  M.highlight("DiffDelete", { bg = "#3C2C3C" })
  M.highlight("DiffChange", { bg = "#28304D" })
  M.highlight("DiffText", { bg = "#36426B" })
  M.highlight("DiffAddAsDelete", { bg = "#3C2C3C" })

  M.link("diffAdded", "DiffAdd")
  M.link("diffChanged", "DiffAdd")
  M.link("diffRemoved", "DiffAdd")
  M.link("diffBDiffer", "DiffAdd")
  M.link("diffCommon", "DiffAdd")
  M.link("diffDiffer", "DiffAdd")
  M.link("diffFile", "DiffAdd")
  M.link("diffIdentical", "DiffAdd")
  M.link("diffIndexLine", "DiffAdd")
  M.link("diffIsA", "DiffAdd")
  M.link("diffNoEOL", "DiffAdd")
  M.link("diffOnly", "DiffAdd")
  M.link("GitsignsAdd", "String")
  M.link("DiffviewNormal", "NormalSB")
end

function M.setup()
  M.config()
  M.keymappings()
  M.sanediffdefaults()
end

return M
