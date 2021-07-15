if not pcall(require, 'telescope') then return end

local should_reload = true
local reloader = function()
  if should_reload then
    RELOAD 'plenary'
    RELOAD 'popup'
    RELOAD 'telescope'
  end
end

reloader()

local actions = require 'telescope.actions'
local themes = require 'telescope.themes'
local previewers = require 'telescope.previewers'

local delta = previewers.new_termopen_previewer {
  get_command = function(entry)
    if entry.status == '??' or 'A ' then
      return {'git', '-c', 'core.pager=delta', '-c', 'delta.side-by-side=false', 'diff', entry.value}
    end

    return {'git', '-c', 'core.pager=delta', '-c', 'delta.side-by-side=false', 'diff', entry.value .. '^!'}

  end
}

require('telescope').setup {
  defaults = {
    prompt_prefix = ' ',
    selection_caret = ' ',

    prompt_title = false,
    results_title = false,
    preview_title = false,

    selection_strategy = 'reset',
    sorting_strategy = 'descending',
    scroll_strategy = 'cycle',

    file_previewer = require'telescope.previewers'.vim_buffer_cat.new,
    grep_previewer = require'telescope.previewers'.vim_buffer_vimgrep.new,
    qflist_previewer = require'telescope.previewers'.vim_buffer_qflist.new,

    mappings = {
      i = {
        ['<C-j>'] = actions.move_selection_next,
        ['<C-k>'] = actions.move_selection_previous,
        ['vv'] = actions.select_vertical
      },
      n = {
        ['<C-j>'] = actions.move_selection_next,
        ['<C-k>'] = actions.move_selection_previous,
        ['vv'] = actions.select_vertical

      }
    }

  },
  pickers = {
    git_commits = {
      mappings = {
        i = {
          ['<C-o>'] = function(prompt_bufnr)
            actions.close(prompt_bufnr)
            local value = actions.get_selected_entry(prompt_bufnr).value
            vim.cmd('DiffviewOpen' .. value .. '~1..' .. value)
          end
        }
      }
    }
  }
}

pcall(require('telescope').load_extension, 'fzf')

if vim.fn.executable 'gh' == 1 then
  pcall(require('telescope').load_extension, 'gh')
  pcall(require('telescope').load_extension, 'octo')
end

local M = {}

function M.edit_neovim()
  require('telescope.builtin').find_files {
    cwd = '~/.config/nvim',
    previewer = false,
    prompt_title = false,
    results_title = false,
    preview_title = false,
    sorting_strategy = 'ascending',
    layout_config = {prompt_position = 'top'}

  }
end

function M.git_files()
  local path = vim.fn.expand '%:h'

  require('telescope.builtin').git_files(themes.get_dropdown {
    cwd = path,
    prompt_title = false,
    results_title = false,
    previewer = false

  })
end

function M.live_grep()
  require('telescope').extensions.fzf_writer.staged_grep {shorten_path = true, previewer = false}
end

function M.oldfiles()
  if true then require('telescope').extensions.frecency.frecency() end
  if pcall(require('telescope').load_extension, 'frecency') then
  else
    require('telescope.builtin').oldfiles {layout_strategy = 'vertical'}
  end
end

function M.file_browser()
  require('telescope.builtin').file_browser(themes.get_dropdown {previewer = false})
end

function M.project()
  require('telescope.builtin').file_browser(themes.get_dropdown {
    prompt_title = '~ Projects ~',
    previewer = false,
    cwd = '~/dev'

  })
end

function M.git_status()
  require('telescope.builtin').git_status {
    layout_strategy = 'vertical',
    prompt_title = false,
    results_title = false,
    previewer = delta

  }

end

function M.git_commits()
  require('telescope.builtin').git_commits {
    layout_config = {horizontal = {preview_width = 85}},
    prompt_title = false,
    results_title = false,
    previewer = delta
  }
end

function M.git_issues()
  require('telescope').extensions.gh.issues {prompt_title = false}
end

function M.git_pr()
  require('telescope').extensions.gh.pull_request {}
end

function M.buffers()
  require('telescope.builtin').buffers {shorten_path = false}
end

function M.curbuf()
  require('telescope.builtin').current_buffer_fuzzy_find(themes.get_dropdown {
    border = true,
    previewer = false,
    shorten_path = false
  })
end

function M.grep_prompt()
  require('telescope.builtin').grep_string {shorten_path = true, search = vim.fn.input 'Grep String > '}
end

function M.search_all_files()
  require('telescope.builtin').find_files {find_command = {'rg', '--no-ignore', '--files'}}
end

return setmetatable({}, {
  __index = function(_, k)
    reloader()

    if M[k] then
      return M[k]
    else
      return require('telescope.builtin')[k]
    end
  end
})

