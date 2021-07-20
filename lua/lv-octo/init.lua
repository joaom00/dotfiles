local M = {}

-- ISSUES
vim.api.nvim_set_keymap('n', '<space>il', ':Octo issue list<CR>', {noremap = true, silent = true})
vim.api.nvim_set_keymap('n', '<space>ilc', ':Octo issue list states=CLOSED<CR>', {noremap = true, silent = true})
vim.api.nvim_set_keymap('n', '<space>ic', ':Octo issue close<CR>', {noremap = true, silent = true})
vim.api.nvim_set_keymap('n', '<space>io', ':Octo issue reopen<CR>', {noremap = true, silent = true})
vim.api.nvim_set_keymap('n', '<space>in', ':Octo issue create<CR>', {noremap = true, silent = true})

-- PULL REQUESTS
vim.api.nvim_set_keymap('n', '<space>gp', ':Octo pr list<CR>', {noremap = true, silent = true})

M.config = function()
  require'octo'.setup()
end

return M
