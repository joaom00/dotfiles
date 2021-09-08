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

    prompt_title = false,
    results_title = false,
    preview_title = false,

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
  pickers = {
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
load_extension "fzf_writer"
load_extension "projects"

function M.edit_neovim()
  require("telescope.builtin").find_files {
    cwd = "~/.config/nvim",
    previewer = false,
    prompt_title = false,
    results_title = false,
    sorting_strategy = "ascending",
    layout_config = { prompt_position = "top" },
  }
end

function M.git_files()
  local path = vim.fn.expand "%:h"

  require("telescope.builtin").git_files(themes.get_dropdown {
    cwd = path,
    prompt_title = false,
    results_title = false,
    previewer = false,
  })
end

function M.live_grep()
  require("telescope").extensions.fzf_writer.staged_grep {
    fzf_separator = "|>",
    prompt_title = false,
    results_title = false,
    preview_title = false,
    layout_config = { preview_width = 75 },
  }
end

function M.oldfiles()
  require("telescope.builtin").oldfiles { results_title = false }
end

function M.file_browser()
  require("telescope.builtin").file_browser(
    themes.get_dropdown { prompt_title = false, previewer = false, hidden = true }
  )
end

function M.project()
  require("telescope").extensions.projects.projects(themes.get_dropdown { prompt_title = false })
end

function M.git_status()
  require("telescope.builtin").git_status {
    results_title = false,
    previewer = delta,
    layout_config = { preview_width = 80 },
  }
end

function M.git_commits()
  require("telescope.builtin").git_commits { prompt_title = false, results_title = false, previewer = false }
end

function M.buffers()
  require("telescope.builtin").buffers { shorten_path = false }
end

function M.curbuf()
  require("telescope.builtin").current_buffer_fuzzy_find(themes.get_dropdown {
    border = true,
    previewer = false,
    shorten_path = false,
  })
end

function M.grep_prompt()
  require("telescope.builtin").grep_string { shorten_path = true, search = vim.fn.input "Grep String > " }
end

function M.search_all_files()
  require("telescope.builtin").find_files { find_command = { "rg", "--no-ignore", "--files", "--hidden" } }
end

function M.code_actions()
  require("telescope.builtin").lsp_code_actions { prompt_title = false, layout_config = { width = 0.3, height = 0.2 } }
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
