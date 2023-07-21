local highlight = jm.highlight
local ui = jm.ui
local icons = ui.icons
local P = ui.palette

local function extensions(name)
  return require("telescope").extensions[name]
end

local function builtin(name)
  return function()
    return require("telescope.builtin")[name]
  end
end

local function git_worktree(picker)
  return function()
    extensions("git_worktree")[picker]()
  end
end

local function git_files()
  require("telescope.builtin").git_files {
    git_command = { "git", "ls-files", "--exclude-standard", "--cached", "--deduplicate" },
    sorting_strategy = "ascending",
    show_untracked = true,
  }
end

local function live_grep()
  require("telescope.builtin").live_grep {
    fzf_separator = "|>",
    previewer = false,
  }
end

local function live_grep_nvim_conf()
  require("telescope.builtin").live_grep {
    cwd = "~/.config/nvim",
    fzf_separator = "|>",
    previewer = false,
  }
end

local function fd()
  local themes = require "telescope.themes"
  local opts = themes.get_ivy { hidden = false, sorting_strategy = "ascending" }
  require("telescope.builtin").fd(opts)
end

local function project()
  local themes = require "telescope.themes"
  require("telescope").extensions.projects.projects(themes.get_dropdown {})
end

local function file_browser()
  require("telescope").extensions.file_browser.file_browser()
end

local function grep_prompt()
  require("telescope.builtin").grep_string {
    layout_strategy = "vertical",
    layout_config = {
      prompt_position = "top",
    },
    sorting_strategy = "ascending",
    search = vim.fn.input "Grep String > ",
  }
end

local function search_all_files()
  require("telescope.builtin").find_files {
    find_command = { "rg", "--no-ignore", "--files", "--hidden" },
  }
end

local function curbuf()
  require("telescope.builtin").current_buffer_fuzzy_find {
    border = true,
    previewer = false,
    path_display = { "shorten" },
  }
end

local function edit_neovim()
  require("telescope.builtin").fd {
    cwd = vim.fn.stdpath "config",
  }
end

return {
  "nvim-telescope/telescope.nvim",
  cmd = "Telescope",
  keys = {
    { "<space>en", edit_neovim },
    { "<space>ft", git_files },
    { "<space>fg", live_grep },
    { "<space>fgn", live_grep_nvim_conf },
    { "<space>fd", fd },
    { "<space>pp", project },
    { "<space>fe", file_browser },
    { "<space>gg", grep_prompt },
    { "<space>ff", curbuf },
    { "<space>fi", search_all_files },
    { "<space>fo", builtin "oldfiles" },
    { "<space>gs", builtin "git_status" },
    { "<space>gc", builtin "git_commits" },
    { "<space>gb", builtin "git_branches" },
    { "<space>gw", git_worktree "git_worktrees", desc = "list git worktrees" },
    { "<space>gwc", git_worktree "create_git_worktree", desc = "create git worktree" },
  },
  dependencies = {
    { "nvim-telescope/telescope-fzf-native.nvim", build = "make" },
    { "nvim-telescope/telescope-fzf-writer.nvim" },
    { "nvim-telescope/telescope-frecency.nvim" },
    { "nvim-telescope/telescope-file-browser.nvim" },
    { "nvim-telescope/telescope-ui-select.nvim" },
    {
      "ahmedkhalf/project.nvim",
      config = function()
        require("project_nvim").setup {
          ignore_lsp = { "null-ls" },
          silent_chdir = false,
          patterns = { ".git" },
        }
      end,
    },
  },
  config = function()
    local actions = require "telescope.actions"
    local actions_state = require "telescope.actions.state"
    local fb_utils = require "telescope._extensions.file_browser.utils"
    local ts_utils = require "telescope.utils"
    local Path = require "plenary.path"
    local os_sep = Path.path.sep

    local get_target_dir = function(finder)
      local entry_path
      if finder.files == false then
        local entry = actions_state.get_selected_entry()
        entry_path = entry and entry.value -- absolute path
      end
      return finder.files and finder.path or entry_path
    end

    jm.augroup("TelescopePreviews", {
      event = "User",
      pattern = "TelescopePreviewerLoaded",
      command = function(args)
        --- TODO: Contribute upstream change to telescope to pass preview buffer data in autocommand
        local bufname = vim.tbl_get(args, "data", "bufname")
        local ft = bufname and require("plenary.filetype").detect(bufname) or nil
        vim.opt_local.number = not ft or ui.decorations.get(ft, "number", "ft") ~= false
      end,
    })

    highlight.plugin("telescope", {
      theme = {
        ["*"] = {
          { TelescopeBorder = { foreground = P.grey } },
          { TelescopePromptPrefix = { link = "Statement" } },
          { TelescopeTitle = { inherit = "Normal", bold = true } },
          { TelescopePromptTitle = { fg = { from = "Normal" }, bold = true } },
          { TelescopeResultsTitle = { fg = { from = "Normal" }, bold = true } },
          { TelescopePreviewTitle = { fg = { from = "Normal" }, bold = true } },
        },
        ["doom-one"] = {
          { TelescopeMatching = { link = "Title" } },
        },
      },
    })

    require("telescope").setup {
      defaults = {
        borderchars = { "─", "│", "─", "│", "┌", "┐", "┘", "└" },
        dynamic_preview_title = true,
        prompt_prefix = " " .. icons.misc.telescope .. " ",
        selection_caret = icons.misc.chevron_right .. " ",
        cycle_layout_list = { "flex", "horizontal", "vertical", "bottom_pane", "center" },
        path_display = { "truncate" },
        layout_strategy = "flex",
        layout_config = { horizontal = { preview_width = 0.55 } },

        mappings = {
          i = {
            ["<C-j>"] = actions.move_selection_next,
            ["<C-k>"] = actions.move_selection_previous,
            ["<C-v>"] = actions.select_vertical,
            ["<C-s>"] = actions.select_horizontal,
          },
          n = {
            ["<C-j>"] = actions.move_selection_next,
            ["<C-k>"] = actions.move_selection_previous,
            ["<C-v>"] = actions.select_vertical,
            ["<C-s>"] = actions.select_horizontal,
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
          hijack_netrw = false,
          path = "%:p:h",
          mappings = {
            ["i"] = {
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
        -- oldfiles = {
        --   theme = "dropdown",
        --   previewer = false,
        -- },
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

    require("telescope").load_extension "fzf"
    require("telescope").load_extension "projects"
    require("telescope").load_extension "file_browser"
    require("telescope").load_extension "git_worktree"
    require("telescope").load_extension "ui-select"
    -- require('telescope').load_extension "twitch"
  end,
}
