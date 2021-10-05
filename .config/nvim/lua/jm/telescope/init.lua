local M = {}

if not pcall(require, "telescope") then
  JM.notify "Missing telescope dependency"
  return
end

local function load_extension(extension)
  if not pcall(require("telescope").load_extension, extension) then
    JM.notify("Failed to load " .. extension .. " extension", "info", "Telescope")
    return
  end
end

local actions = require "telescope.actions"
local themes = require "telescope.themes"
local previewers = require "telescope.previewers"

local delta = previewers.new_termopen_previewer {
  get_command = function(entry)
    if entry.status == "??" or "A " then
      return { "git", "-c", "core.pager=delta", "-c", "delta.side-by-side=false", "diff", entry.value }
    end

    return { "git", "-c", "core.pager=delta", "-c", "delta.side-by-side=false", "diff", entry.value .. "^!" }
  end,
}

require("telescope").setup {
  defaults = {
    prompt_prefix = " ",
    selection_caret = " ",

    selection_strategy = "reset",
    sorting_strategy = "descending",
    scroll_strategy = "cycle",

    file_previewer = require("telescope.previewers").vim_buffer_cat.new,
    grep_previewer = require("telescope.previewers").vim_buffer_vimgrep.new,
    qflist_previewer = require("telescope.previewers").vim_buffer_qflist.new,

    mappings = {
      i = {
        ["<C-j>"] = actions.move_selection_next,
        ["<C-k>"] = actions.move_selection_previous,
        ["vv"] = actions.select_vertical,
      },
      n = {
        ["<C-j>"] = actions.move_selection_next,
        ["<C-k>"] = actions.move_selection_previous,
        ["vv"] = actions.select_vertical,
      },
    },
  },
  extensions = {
    frecency = {
      workspaces = {
        ["conf"] = vim.env.DOTFILES,
        ["project"] = vim.env.PROJECTS_DIR,
        ["js"] = vim.env.JS_PROJECTS,
        ["rct"] = vim.env.RCT_PROJECTS,
        ["go"] = vim.env.GO_PROJECTS,
      },
    },
    fzf_writer = {
      use_highlighter = false,
      minimum_grep_characters = 6,
    },
  },
  pickers = {
    find_files = {
      hidden = true,
    },
    git_commits = {
      mappings = {
        i = {
          ["<C-o>"] = function(prompt_bufnr)
            actions.close(prompt_bufnr)
            local value = actions.get_selected_entry(prompt_bufnr).value
            vim.cmd("DiffviewOpen " .. value .. "~1.." .. value)
          end,
        },
      },
    },
    buffers = {
      sort_mru = true,
      sort_lastused = true,
      show_all_buffers = true,
      ignore_current_buffer = true,
      previewer = false,
      theme = "dropdown",
      mappings = { i = { ["<c-x>"] = "delete_buffer" }, n = { ["<c-x>"] = "delete_buffer" } },
    },
    oldfiles = { theme = "dropdown", previewer = false },
    colorscheme = { enable_preview = true },
    lsp_code_actions = { theme = "cursor" },
    projects = { theme = "dropdown" },
  },
}

load_extension "fzf"
load_extension "projects"

function M.edit_neovim()
  require("telescope.builtin").find_files {
    cwd = "~/.config/nvim",
    previewer = false,
    sorting_strategy = "ascending",
    layout_config = { prompt_position = "top" },
  }
end

function M.git_files()
  local path = vim.fn.expand "%:h"

  require("telescope.builtin").git_files(themes.get_dropdown {
    cwd = path,
    previewer = false,
    hidden = true,
  })
end

function M.live_grep()
  require("telescope.builtin").live_grep {
    fzf_separator = "|>",
    previewer = false,
  }
end

function M.frecency()
  require("telescope").extensions.frecency.frecency(themes.get_dropdown {
    winblend = 10,
    border = true,
    previewer = false,
    path_display = { "shorten" },
  })
end

function M.oldfiles()
  require("telescope.builtin").oldfiles()
end

function M.file_browser()
  require("telescope.builtin").file_browser(themes.get_dropdown { previewer = false, hidden = true })
end

function M.project()
  require("telescope").extensions.projects.projects(themes.get_dropdown())
end

function M.git_status()
  require("telescope.builtin").git_status {
    previewer = delta,
    layout_config = { preview_width = 80 },
  }
end

function M.git_commits()
  require("telescope.builtin").git_commits { previewer = false }
end

function M.buffers()
  require("telescope.builtin").buffers { shorten_path = false }
end

function M.curbuf()
  require("telescope.builtin").current_buffer_fuzzy_find(themes.get_dropdown {
    border = true,
    previewer = false,
    path_display = { "shorten" },
  })
end

function M.grep_prompt()
  require("telescope.builtin").grep_string { path_display = { "shorten" }, search = vim.fn.input "Grep String > " }
end

function M.search_all_files()
  require("telescope.builtin").find_files { find_command = { "rg", "--no-ignore", "--files", "--hidden" } }
end

function M.code_actions()
  require("telescope.builtin").lsp_code_actions { layout_config = { width = 0.3, height = 0.2 } }
end

function M.colorscheme()
  require("telescope.builtin").colorscheme()
end

return setmetatable({}, {
  __index = function(_, k)
    if M[k] then
      return M[k]
    else
      return require("telescope.builtin")[k]
    end
  end,
})
