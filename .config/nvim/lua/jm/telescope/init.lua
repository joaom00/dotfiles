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
local actions_state = require "telescope.actions.state"
local themes = require "telescope.themes"
local previewers = require "telescope.previewers"
-- local fb_actions = require("telescope").extensions.file_browser.actions
local fb_utils = require "telescope._extensions.file_browser.utils"
local Path = require "plenary.path"

local ts_utils = require "telescope.utils"

local os_sep = Path.path.sep

local delta = previewers.new_termopen_previewer {
  get_command = function(entry)
    if entry.status == "??" or "A " then
      return { "git", "-c", "core.pager=delta", "-c", "delta.side-by-side=false", "diff", entry.value }
    end

    return { "git", "-c", "core.pager=delta", "-c", "delta.side-by-side=false", "diff", entry.value .. "^!" }
  end,
}

local get_target_dir = function(finder)
  local entry_path
  if finder.files == false then
    local entry = actions_state.get_selected_entry()
    entry_path = entry and entry.value -- absolute path
  end
  return finder.files and finder.path or entry_path
end

-- local borderchars = { " ", " ", " ", " ", " ", " ", " ", " " }

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

    preview = {
      filesize_limit = 5,
      timeout = 150,
      treesitter = true,
      filesize_hook = function(filepath, bufnr, opts)
        local path = Path:new(filepath)
        local height = vim.api.nvim_win_get_height(opts.winid)
        local lines = vim.split(path:head(height), "[\r]?\n")
        vim.api.nvim_buf_set_lines(bufnr, 0, -1, false, lines)
      end,
    },
    mappings = {
      i = {
        ["<C-j>"] = actions.move_selection_next,
        ["<C-k>"] = actions.move_selection_previous,
        ["<C-v>"] = actions.select_vertical,
      },
      n = {
        ["<C-j>"] = actions.move_selection_next,
        ["<C-k>"] = actions.move_selection_previous,
        ["<C-v>"] = actions.select_vertical,
      },
    },
  },
  extensions = {
    ["ui-select"] = {
      require("telescope.themes").get_dropdown {},
    },
    file_browser = {
      grouped = true,
      default_selection_index = 2,
      mappings = {
        ["i"] = {
          ["<C-o>"] = function(prompt_bufnr)
            local current_picker = actions_state.get_current_picker(prompt_bufnr)
            local finder = current_picker.finder
            actions.close(prompt_bufnr)

            local default = get_target_dir(finder) .. os_sep
            local dir = vim.split(default, "/")

            ts_utils.get_os_command_output { "explorer.exe", dir[#dir - 1] }
          end,
          ["<C-e>"] = function(prompt_bufnr)
            local current_picker = actions_state.get_current_picker(prompt_bufnr)
            local finder = current_picker.finder
            local default = get_target_dir(finder) .. os_sep

            local file = actions_state.get_current_line()
            if not file then
              return
            end
            if file == "" then
              print "Please enter valid filename!"
              return
            end

            file = default .. file
            if file == finder.path .. os_sep then
              print "Please enter valid file or folder name!"
              return
            end
            file = Path:new(file)

            if file:exists() then
              error "File or folder already exists."
              return
            end
            if not fb_utils.is_dir(file.filename) then
              file:touch { parents = true }
            else
              Path:new(file.filename:sub(1, -2)):mkdir { parents = true }
            end
            current_picker:refresh(finder, { reset_prompt = true, multi = current_picker._multi })
          end,
        },
      },
    },
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
    live_grep = {
      file_ignore_patterns = { ".git/", "node_modules/", "yarn.lock", "package-json.lock" },
    },
    git_branches = {
      previewer = false,
      theme = "dropdown",
      mappings = {
        i = {
          ["<CR>"] = function(prompt_bufnr)
            local cwd = actions_state.get_current_picker(prompt_bufnr).cwd
            local selection = actions_state.get_selected_entry()
            if selection == nil then
              print "[telescope] Nothing currently selected"
              return
            end
            actions.close(prompt_bufnr)
            local _, ret, stderr = ts_utils.get_os_command_output({ "git", "checkout", selection.value }, cwd)
            if ret == 0 then
              print("Checked out: " .. selection.value)
              vim.cmd ":e"
            else
              print(
                string.format(
                  'Error when checking out: %s. Git returned: "%s"',
                  selection.value,
                  table.concat(stderr, "  ")
                )
              )
            end
          end,
        },
      },
    },
    git_commits = {
      mappings = {
        i = {
          ["<c-l>"] = function(prompt_bufnr)
            R("telescope.actions").close(prompt_bufnr)
            local value = actions_state.get_selected_entry().value
            vim.cmd("DiffviewOpen " .. value .. "~1.." .. value)
          end,
          ["<c-a>"] = function(prompt_bufnr)
            R("telescope.actions").close(prompt_bufnr)
            local value = actions_state.get_selected_entry().value
            vim.cmd("DiffviewOpen " .. value)
          end,
          ["<c-u>"] = function(prompt_bufnr)
            R("telescope.actions").close(prompt_bufnr)
            local value = actions_state.get_selected_entry().value
            local rev = ts_utils.get_os_command_output({ "git", "rev-parse", "origin/main" }, vim.loop.cwd())[1]
            vim.cmd("DiffviewOpen " .. rev .. " " .. value)
          end,
        },
      },
    },
    git_status = {
      mappings = {
        i = {
          ["<C-r>"] = function(prompt_bufnr)
            local selection = actions_state.get_selected_entry()
            actions.close(prompt_bufnr)
            local _, ret, stderr = R("telescope.utils").get_os_command_output {
              "git",
              "checkout",
              "HEAD",
              "--",
              selection.value,
            }
            if ret == 0 then
              vim.cmd ":e"
              print("Reset to HEAD: " .. selection.value)
            else
              print(
                string.format(
                  'Error when applying: %s. Git returned: "%s"',
                  selection.value,
                  table.concat(stderr, "  ")
                )
              )
            end
          end,
        },
      },
    },
    buffers = {
      sort_mru = true,
      sort_lastused = true,
      show_all_buffers = true,
      ignore_current_buffer = true,
      shorten_path = false,
      previewer = false,
      theme = "dropdown",
      mappings = { i = { ["<c-x>"] = "delete_buffer" }, n = { ["<c-x>"] = "delete_buffer" } },
    },
    oldfiles = {
      theme = "dropdown",
      previewer = false,
    },
    colorscheme = {
      enable_preview = true,
    },
    lsp_code_actions = {
      theme = "dropdown",
    },
    projects = {
      theme = "dropdown",
    },
  },
}

load_extension "fzf"
load_extension "projects"
load_extension "ghn"
load_extension "file_browser"
load_extension "git_worktree"
load_extension "ui-select"
load_extension "twitch"
load_extension "dap"

function M.edit_neovim()
  require("telescope.builtin").find_files {
    cwd = "~/.config/nvim",
    previewer = false,
    sorting_strategy = "ascending",
    layout_config = { prompt_position = "top" },
  }
end

function M.live_grep_nvim_conf()
  require("telescope.builtin").live_grep {
    cwd = "~/.config/nvim",
    fzf_separator = "|>",
    previewer = false,
  }
end

function M.git_files()
  local path = vim.fn.expand "%:h"
  local opts = themes.get_ivy {
    sorting_strategy = "ascending",
    cwd = path,
  }
  require("telescope.builtin").git_files(opts)
end

function M.fd()
  local opts = themes.get_ivy { hidden = false, sorting_strategy = "ascending" }
  require("telescope.builtin").fd(opts)
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

function M.file_browser()
  require("telescope").extensions.file_browser.file_browser()
end

function M.project()
  require("telescope").extensions.projects.projects(themes.get_dropdown {})
end

function M.git_status()
  require("telescope.builtin").git_status {
    layout_strategy = "vertical",
    previewer = delta,
  }
end

function M.curbuf()
  require("telescope.builtin").current_buffer_fuzzy_find(themes.get_dropdown {
    border = true,
    previewer = false,
    path_display = { "shorten" },
  })
end

function M.grep_prompt()
  require("telescope.builtin").grep_string {
    layout_strategy = "vertical",
    layout_config = {
      prompt_position = "top",
    },
    sorting_strategy = "ascending",
    search = vim.fn.input "Grep String > ",
  }
end

function M.search_all_files()
  require("telescope.builtin").find_files {
    find_command = { "rg", "--no-ignore", "--files", "--hidden" },
  }
end

function M.code_actions()
  require("telescope.builtin").lsp_code_actions {}
end

function M.diagnostics()
  require("telescope.builtin").diagnostics {
    layout_strategy = "vertical",
    -- layout_config = {
    --   prompt_position = "top",
    -- },
    -- sorting_strategy = "ascending",
    ignore_filename = false,
  }
end

function M.lsp_references()
  require("telescope.builtin").lsp_references {
    layout_strategy = "vertical",
    layout_config = {
      prompt_position = "top",
    },
    sorting_strategy = "ascending",
    ignore_filename = false,
  }
end

function M.git_notification()
  require("telescope").extensions.ghn.notifications()
end

function M.twitch()
  require("telescope").extensions.twitch.twitch()
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
