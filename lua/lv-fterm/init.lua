local M = {}

M.config = function()
  require'FTerm'.setup({dimensions = {height = 0.8, width = 0.8, x = 0.5, y = 0.5}, border = 'single'})

  vim.api.nvim_set_keymap('n', '<S-f>', '<CMD>lua require("FTerm").toggle()<CR>', {noremap = true, silent = true})
  vim.api.nvim_set_keymap('t', '<S-f>', '<C-\\><C-n><CMD>lua require("FTerm").toggle()<CR>',
                          {noremap = true, silent = true})
end

return M

