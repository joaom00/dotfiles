if not pcall(require, "telescope") then return end

local sorters = require "telescope.sorters"

TelescopeMapArgs = TelescopeMapArgs or {}

local map_tele = function(key, f, options, buffer)
    local map_key = vim.api.nvim_replace_termcodes(key .. f, true, true, true)

    TelescopeMapArgs[map_key] = options or {}

    local mode = "n"
    local rhs = string.format(
                    "<cmd>lua R('lv-telescope')['%s'](TelescopeMapArgs['%s'])<CR>",
                    f, map_key)

    local map_options = {noremap = true, silent = true}

    if not buffer then
        vim.api.nvim_set_keymap(mode, key, rhs, map_options)
    else
        vim.api.nvim_buf_set_keymap(0, mode, key, rhs, map_options)
    end
end

-- Neovim Files
map_tele('<space>en', 'edit_neovim')

-- Files
map_tele('<space>ft', 'git_files')
map_tele('<space>fg', 'live_grep')
map_tele('<space>fo', 'oldfiles')
map_tele('<space>pp', 'project')
map_tele('<space>fe', 'file_browser')

-- Git
map_tele('<space>gs', 'git_status')
map_tele('<space>gc', 'git_commits')
map_tele('<space>gi', 'git_issues')
map_tele('<space>gp', 'git_pr')

-- Nvim
map_tele('<space>fb', 'buffers')
map_tele('<space>ff', 'curbuf')
map_tele('<space>gg', 'grep_prompt')
map_tele('<space>fi', 'search_all_files')

return map_tele
