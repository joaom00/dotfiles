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
    diff_binaries = false, -- Show diffs for binaries
    use_icons = true, -- Requires nvim-web-devicons
    file_panel = {
      position = "left", -- One of 'left', 'right', 'top', 'bottom'
      width = 35, -- Only applies when position is 'left' or 'right'
      height = 10, -- Only applies when position is 'top' or 'bottom'
    },
    file_history_panel = {
      position = "bottom",
      width = 35,
      height = 16,
      log_options = {
        max_count = 256, -- Limit the number of commits
        follow = false, -- Follow renames (only for single file)
        all = false, -- Include all refs under 'refs/' including HEAD
        merges = false, -- List only merge commits
        no_merges = false, -- List no merge commits
        reverse = false, -- List commits in reverse order
      },
    },
    key_bindings = {
      disable_defaults = false, -- Disable the default key bindings
      -- The `view` bindings are active in the diff buffers, only when the current
      -- tabpage is a Diffview.
      view = {
        ["<tab>"] = cb "select_next_entry", -- Open the diff for the next file
        ["<s-tab>"] = cb "select_prev_entry", -- Open the diff for the previous file
        ["<C-w>gf"] = cb "goto_file", -- Open the file in a new split in previous tabpage
        ["<C-w><C-f>"] = cb "goto_file_split", -- Open the file in a new split
        ["gf"] = cb "goto_file_tab", -- Open the file in a new tabpage
        ["<leader>e"] = cb "focus_files", -- Bring focus to the files panel
        ["<leader>b"] = cb "toggle_files", -- Toggle the files panel.
      },
      file_panel = {
        ["j"] = cb "next_entry", -- Bring the cursor to the next file entry
        ["<down>"] = cb "next_entry",
        ["k"] = cb "prev_entry", -- Bring the cursor to the previous file entry.
        ["<up>"] = cb "prev_entry",
        ["<cr>"] = cb "select_entry", -- Open the diff for the selected entry.
        ["o"] = cb "select_entry",
        ["<2-LeftMouse>"] = cb "select_entry",
        ["-"] = cb "toggle_stage_entry", -- Stage / unstage the selected entry.
        ["S"] = cb "stage_all", -- Stage all entries.
        ["U"] = cb "unstage_all", -- Unstage all entries.
        ["X"] = cb "restore_entry", -- Restore entry to the state on the left side.
        ["R"] = cb "refresh_files", -- Update stats and entries in the file list.
        ["<tab>"] = cb "select_next_entry",
        ["<s-tab>"] = cb "select_prev_entry",
        ["gf"] = cb "goto_file",
        ["<C-w><C-f>"] = cb "goto_file_split",
        ["<C-w>gf"] = cb "goto_file_tab",
        ["<leader>e"] = cb "focus_files",
        ["<leader>b"] = cb "toggle_files",
      },
      file_history_panel = {
        ["g!"] = cb "options", -- Open the option panel
        ["<C-d>"] = cb "open_in_diffview", -- Open the entry under the cursor in a diffview
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

  -- require("jm.autocmds").define_augroups { init_colors = { { "Filetype", "*", "call SaneDiffDefaults()" } } }
end

function M.keymappings()
  nnoremap("<leader>d", "<cmd>DiffviewOpen<CR>")
  nnoremap("<leader>df", "<cmd>DiffviewFileHistory<CR>")
  nnoremap("<leader>dc", "<cmd>DiffviewClose<CR>")
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
