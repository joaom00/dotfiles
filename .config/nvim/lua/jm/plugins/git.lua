local cwd = vim.fn.getcwd
local highlight = jm.highlight
local border = jm.ui.current.border
local icons = jm.ui.icons.separators

return {
  {
    "TimUntersberger/neogit",
    cmd = "Neogit",
    dependencies = { "nvim-lua/plenary.nvim" },
    -- keys = {
    --   {
    --     "<localleader>gs",
    --     function()
    --       neogit().open()
    --     end,
    --     "open status buffer",
    --   },
    --   {
    --     "<localleader>gc",
    --     function()
    --       neogit().open { "commit" }
    --     end,
    --     "open commit buffer",
    --   },
    --   {
    --     "<localleader>gl",
    --     function()
    --       neogit().popups.pull.create()
    --     end,
    --     "open pull popup",
    --   },
    --   {
    --     "<localleader>gp",
    --     function()
    --       neogit().popups.push.create()
    --     end,
    --     "open push popup",
    --   },
    -- },
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
      highlight.plugin("neogit", {
        { NeogitDiffAdd = { link = "DiffAdd" } },
        { NeogitDiffDelete = { link = "DiffDelete" } },
        { NeogitDiffAddHighlight = { link = "DiffAdd" } },
        { NeogitDiffDeleteHighlight = { link = "DiffDelete" } },
        { NeogitDiffContextHighlight = { link = "NormalFloat" } },
        { NeogitHunkHeader = { link = "TabLine" } },
        { NeogitHunkHeaderHighlight = { link = "DiffText" } },
      })
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
      -- on_attach = function(bufnr)
      --   local gs = package.loaded.gitsigns
      --
      --   local function bmap(mode, l, r, opts)
      --     opts = opts or {}
      --     opts.buffer = bufnr
      --     vim.keymap.set(mode, l, r, opts)
      --   end
      --
      --   map("n", "<leader>hu", gs.undo_stage_hunk, { desc = "undo stage" })
      --   map("n", "<leader>hp", gs.preview_hunk_inline, { desc = "preview current hunk" })
      --   map("n", "<leader>hb", gs.toggle_current_line_blame, { desc = "toggle current line blame" })
      --   map("n", "<leader>hd", gs.toggle_deleted, { desc = "show deleted lines" })
      --   map("n", "<leader>hw", gs.toggle_word_diff, { desc = "toggle word diff" })
      --   map("n", "<localleader>gw", gs.stage_buffer, { desc = "stage entire buffer" })
      --   map("n", "<localleader>gre", gs.reset_buffer, { desc = "reset entire buffer" })
      --   map("n", "<localleader>gbl", gs.blame_line, { desc = "blame current line" })
      --   map("n", "<leader>lm", function()
      --     gs.setqflist "all"
      --   end, {
      --     desc = "list modified in quickfix",
      --   })
      --   bmap({ "n", "v" }, "<leader>hs", "<Cmd>Gitsigns stage_hunk<CR>", { desc = "stage hunk" })
      --   bmap({ "n", "v" }, "<leader>hr", "<Cmd>Gitsigns reset_hunk<CR>", { desc = "reset hunk" })
      --   bmap({ "o", "x" }, "ih", ":<C-U>Gitsigns select_hunk<CR>", { desc = "select hunk" })
      --
      --   map("n", "[h", function()
      --     vim.schedule(function()
      --       gs.next_hunk()
      --     end)
      --     return "<Ignore>"
      --   end, { expr = true, desc = "go to next git hunk" })
      --
      --   map("n", "]h", function()
      --     vim.schedule(function()
      --       gs.prev_hunk()
      --     end)
      --     return "<Ignore>"
      --   end, { expr = true, desc = "go to previous git hunk" })
      -- end,
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
