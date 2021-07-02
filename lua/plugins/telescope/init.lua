if not pcall(require, "telescope") then
  return
end

local actions = require('telescope.actions')
local themes = require('telescope.themes')

require('telescope').setup {
    defaults = {
        prompt_position = "top",
        prompt_prefix = " ",
        selection_caret = " ",
        selection_strategy = "reset",
        sorting_strategy = "descending",
        layout_strategy = "horizontal",
        scroll_strategy = "cycle",
        file_sorter = require'telescope.sorters'.get_fzy_sorter,
        winblend = 0,
        borderchars = {'─', '│', '─', '│', '╭', '╮', '╯', '╰'},
        color_devicons = true,
        file_previewer = require'telescope.previewers'.vim_buffer_cat.new,
        grep_previewer = require'telescope.previewers'.vim_buffer_vimgrep.new,
        qflist_previewer = require'telescope.previewers'.vim_buffer_qflist.new,

        layout_config = {
            width = 0.8,
            height = 0.85,
            preview_cutoff = 120,

            horizontal = {
                -- width_padding = 0.1,
                -- height_padding = 0.1,
                preview_width = 0.6,
            },

            vertical = {
                -- width_padding = 0.05,
                -- height_padding = 1,
                width = 0.9,
                height = 0.95,
                preview_height = 0.5,
            },

            flex = {
                horizontal = {
                    preview_width = 0.9,
                }
            }
        },
        mappings = {
            i = {
                ["<C-j>"] = actions.move_selection_next,
                ["<C-k>"] = actions.move_selection_previous,
                ["vv"] = actions.select_vertical
            },
            n = {
                ["<C-j>"] = actions.move_selection_next,
                ["<C-k>"] = actions.move_selection_previous,
                ["vv"] = actions.select_vertical

            }
        }
        },
    extensions = {
        fzy_native = {
            override_generic_sorter = true,
            override_file_sorter = true
        },

        fzf_writer = {
            use_highlighter = false,
            minimum_grep_characters = 6,
        }
     },
    pickers = {
        git_commits = {
            mappings = {
                i = {
                    ["<C-o>"] = function(prompt_bufnr)
                        actions.close(prompt_bufnr)
                        local value = actions.get_selected_entry(prompt_bufnr).value
                        vim.cmd('DiffviewOpen' .. value .. '~1..' .. value)
                    end,
                }
            },
        },
    }
}

pcall(require("telescope").load_extension, "media_files")
pcall(require("telescope").load_extension, "fzy_native")
pcall(require("telescope").load_extension, "fzf")
pcall(require("telescope").load_extension, "gh")

local M = {}

function M.edit_neovim()
    require("telescope.builtin").find_files {
        prompt_title = "~ Neovim ~",
        shorten_path = false,
        cwd = "~/.config/nvim",

        layout_strategy = "flex",
        layout_config = {
            width = 0.9,
            height = 0.8,

            horizontal = {
                width = { padding = 0.2 },
            },
            vertical = {
                preview_height = 0.75,
            },
        },
    }
end

function M.git_files()
    local path = vim.fn.expand "%:h"

    require("telescope.builtin").git_files(themes.get_dropdown {
        previewer = false,
        shorten_path = false,
        cwd = path,
        layout_config = {
            width = 0.25,
        },

    })
end

function M.live_grep()
    require("telescope").extensions.fzf_writer.staged_grep {
        shorten_path = true,
        previewer = false,
    }
end

function M.oldfiles()
    if true then
        require("telescope").extensions.frecency.frecency()
    end
    if pcall(require("telescope").load_extension, "frecency") then
    else
        require("telescope.builtin").oldfiles {layout_strategy = "vertical"}
    end
end

function M.file_browser()
    require("telescope.builtin").file_browser(themes.get_dropdown {
        previewer = false,
        layout_config = {
            width = 0.25,
        }

    })
end

function M.project()
    require("telescope.builtin").file_browser(themes.get_dropdown {
        prompt_title = "~ Projects ~",
        previewer = false,
        cwd = "~/dev",
        layout_config = {
            width = 0.25,
        }

    })
end

function M.git_status()
    require("telescope.builtin").git_status {
        border = true,
        previewer = false,
        shorten_path = true
    }
end

function M.git_commits()
    require("telescope.builtin").git_commits {}
end

function M.git_issues()
    require("telescope").extensions.gh.issues(themes.get_dropdown {
        shorten_path = true,
        layout_config = {
            width = 0.25,
        }
    })
end

function M.git_pr()
    require("telescope").extensions.gh.pull_request(themes.get_dropdown {
        shorten_path = true,
        layout_config = {
            width = 0.25,
        }
    })
end

function M.buffers()
    require("telescope.builtin").buffers {
        shorten_path = false,
    }
end

function M.curbuf()
    require("telescope.builtin").current_buffer_fuzzy_find(themes.get_dropdown {
        border = true,
        previewer = false,
        shorten_path = false,
    })
end

function M.grep_prompt()
    require("telescope.builtin").grep_string {
        shorten_path = true,
        search = vim.fn.input "Grep String > ",
    }
end

function M.search_all_files()
    require("telescope.builtin").find_files {
        find_command = {"rg", "--no-ignore", "--files"}
    }
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

