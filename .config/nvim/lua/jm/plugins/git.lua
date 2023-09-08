local cwd = vim.fn.getcwd
local highlight = jm.highlight
local border = jm.ui.current.border
local icons = jm.ui.icons.separators

return {
  {
    "TimUntersberger/neogit",
    cmd = "Neogit",
    dependencies = { "nvim-lua/plenary.nvim" },
    opts = {
      disable_signs = false,
      disable_hint = true,
      disable_commit_confirmation = true,
      disable_builtin_notifications = true,
      disable_insert_on_commit = false,
      signs = {
        section = { "", "" }, -- "", ""
        item = { "▸", "▾" },
        hunk = { "樂", "" },
      },
      integrations = {
        diffview = true,
      },
    },
    config = function(_, opts)
      require("neogit").setup(opts)
      -- NOTE: highlights must be set AFTER neogit's setup
      -- highlight.plugin("neogit", {
      --   { NeogitDiffAdd = { link = "DiffAdd" } },
      --   { NeogitDiffDelete = { link = "DiffDelete" } },
      --   { NeogitDiffAddHighlight = { link = "DiffAdd" } },
      --   { NeogitDiffDeleteHighlight = { link = "DiffDelete" } },
      --   { NeogitDiffContextHighlight = { link = "NormalFloat" } },
      --   { NeogitHunkHeader = { link = "TabLine" } },
      --   { NeogitHunkHeaderHighlight = { link = "DiffText" } },
      -- })
    end,
  },
  {
    "sindrets/diffview.nvim",
    cmd = { "DiffviewOpen", "DiffviewFileHistory" },
    keys = {
      -- { "<localleader>gd", "<Cmd>DiffviewOpen<CR>", desc = "diffview: open", mode = "n" },
      { "gh", [[:'<'>DiffviewFileHistory<CR>]], desc = "diffview: file history", mode = "v" },
      {
        "<localleader>gh",
        "<Cmd>DiffviewFileHistory<CR>",
        desc = "diffview: file history",
        mode = "n",
      },
    },
    config = function()
      highlight.plugin("diffview", {
        { DiffAddedChar = { bg = "NONE", fg = { from = "diffAdded", attr = "bg", alter = 30 } } },
        {
          DiffChangedChar = { bg = "NONE", fg = { from = "diffChanged", attr = "bg", alter = 30 } },
        },
        { DiffviewStatusAdded = { link = "DiffAddedChar" } },
        { DiffviewStatusModified = { link = "DiffChangedChar" } },
        { DiffviewStatusRenamed = { link = "DiffChangedChar" } },
        { DiffviewStatusUnmerged = { link = "DiffChangedChar" } },
        { DiffviewStatusUntracked = { link = "DiffAddedChar" } },
      })
      ---@diagnostic disable-next-line: redundant-parameter
      require("diffview").setup {
        default_args = { DiffviewFileHistory = { "%" } },
        enhanced_diff_hl = true,
        hooks = {
          diff_buf_read = function()
            local opt = vim.opt_local
            opt.wrap, opt.list, opt.relativenumber = false, false, false
            opt.colorcolumn = ""
          end,
        },
        keymaps = {
          view = { q = "<Cmd>DiffviewClose<CR>" },
          file_panel = { q = "<Cmd>DiffviewClose<CR>" },
          file_history_panel = { q = "<Cmd>DiffviewClose<CR>" },
        },
      }
    end,
  },
  {
    "lewis6991/gitsigns.nvim",
    event = { "BufReadPre", "BufNewFile" },
    opts = {
      signs = {
        add = { text = icons.right_block },
        change = { text = icons.right_block },
        delete = { text = icons.right_block },
        topdelete = { text = icons.right_block },
        changedelete = { text = icons.right_block },
        untracked = { text = icons.light_shade_block },
      },
      -- Experimental ------------------------------------------------------------------------------
      _signs_staged_enable = false,
      ----------------------------------------------------------------------------------------------
      current_line_blame = not cwd():match "dotfiles",
      current_line_blame_formatter = " <author>, <author_time> · <summary>",
      preview_config = { border = border },
    },
  },
  {
    "akinsho/git-conflict.nvim",
    config = function()
      require("git-conflict").setup()
    end,
  },
  { "ThePrimeagen/git-worktree.nvim" },
  { "rhysd/committia.vim" },
}
