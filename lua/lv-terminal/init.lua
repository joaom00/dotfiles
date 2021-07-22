local M = {}

vim.api.nvim_set_keymap('n', '<F9>', ':ToggleTermOpenAll<CR>', {noremap = true, silent = true})
vim.api.nvim_set_keymap('t', '<F10>', '<C-\\><C-n>:ToggleTermCloseAll<CR>', {noremap = true, silent = true})

M.config = function()
  require('toggleterm').setup {
    size = function(term)
      if term.direction == 'horizontal' then
        return 15
      elseif term.direction == 'vertical' then
        return vim.o.columns * 0.4
      end
    end,
    open_mapping = [[<c-t>]],
    hide_numbers = true, -- hide the number column in toggleterm buffers
    shade_filetypes = {},
    shade_terminals = true,
    shading_factor = 2, -- the degree by which to darken to terminal colour, default: 1 for dark backgrounds, 3 for light
    start_in_insert = true,
    insert_mappings = true, -- whether or not the open mapping applies in insert mode
    persist_size = false,
    -- direction = 'vertical' | 'horizontal' | 'window' | 'float',
    direction = 'horizontal',
    close_on_exit = true, -- close the terminal window when the process exits
    shell = vim.o.shell -- change the default shell
  }
end

return M
