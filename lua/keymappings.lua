-- Disable arrow keys
vim.cmd([[
map <up> :echoerr "Pq você ta fazendo isso?"<CR>
map <down> :echoerr "Pq você ta fazendo isso?"<CR>
map <left> :echoerr "Pq você ta fazendo isso?"<CR>
map <right> :echoerr "Pq você ta fazendo isso?"<CR>
]])

-- Better window movement
vim.api.nvim_set_keymap('n', '<C-h>', '<C-w>h', {silent = true})
vim.api.nvim_set_keymap('n', '<C-j>', '<C-w>j', {silent = true})
vim.api.nvim_set_keymap('n', '<C-k>', '<C-w>k', {silent = true})
vim.api.nvim_set_keymap('n', '<C-l>', '<C-w>l', {silent = true})

-- Better window movement (Terminal)
vim.api.nvim_set_keymap('t', '<C-h>', '<C-\\><C-n><C-w>h', {noremap = true, silent = true})
vim.api.nvim_set_keymap('t', '<C-j>', '<C-\\><C-n><C-w>j', {noremap = true, silent = true})
vim.api.nvim_set_keymap('t', '<C-k>', '<C-\\><C-n><C-w>k', {noremap = true, silent = true})

-- Alternative to quit
vim.api.nvim_set_keymap('n', 'q', ':q<CR>', {silent = true})

-- Alternative to save
vim.api.nvim_set_keymap('n', '<C-s>', ':w<CR>', {silent = true})

-- Clear Highlights
vim.api.nvim_set_keymap('n', '//', ':noh<return>', {silent = true})

-- Resize with arrows
vim.api.nvim_set_keymap('n', '<C-Up>', ':resize -2<CR>', {silent = true})
vim.api.nvim_set_keymap('n', '<C-Down>', ':resize +2<CR>', {silent = true})
vim.api.nvim_set_keymap('n', '<C-Left>', ':vertical resize -2<CR>', {silent = true})
vim.api.nvim_set_keymap('n', '<C-Right>', ':vertical resize +2<CR>', {silent = true})

-- Better indenting
vim.api.nvim_set_keymap('v', '<', '<gv', {noremap = true, silent = true})
vim.api.nvim_set_keymap('v', '>', '>gv', {noremap = true, silent = true})

-- I hate escape
vim.api.nvim_set_keymap('i', 'jk', '<ESC>', {noremap = true, silent = true})
vim.api.nvim_set_keymap('i', 'kj', '<ESC>', {noremap = true, silent = true})
vim.api.nvim_set_keymap('i', 'jj', '<ESC>', {noremap = true, silent = true})

-- Move selected line / block of text in visual mode
vim.api.nvim_set_keymap('x', 'J', ':move \'>+1<CR>gv-gv', {noremap = true, silent = true})
vim.api.nvim_set_keymap('x', 'K', ':move \'<-2<CR>gv-gv', {noremap = true, silent = true})

-- Move current line / block with Alt-j/k ala vscode.
vim.api.nvim_set_keymap('n', '<A-j>', ':m .+1<CR>==', {noremap = true, silent = true})
vim.api.nvim_set_keymap('n', '<A-k>', ':m .-2<CR>==', {noremap = true, silent = true})
vim.api.nvim_set_keymap('i', '<A-j>', '<Esc>:m .+1<CR>==gi', {noremap = true, silent = true})
vim.api.nvim_set_keymap('i', '<A-k>', '<Esc>:m .-2<CR>==gi', {noremap = true, silent = true})
vim.api.nvim_set_keymap('x', '<A-j>', ':m \'>+1<CR>gv-gv', {noremap = true, silent = true})
vim.api.nvim_set_keymap('x', '<A-k>', ':m \'<-2<CR>gv-gv', {noremap = true, silent = true})

-- Comment
vim.api.nvim_set_keymap('n', '<S-c>', ':CommentToggle<CR>', {noremap = true, silent = true})
vim.api.nvim_set_keymap('v', '<S-c>', ':CommentToggle<CR>', {noremap = true, silent = true})

-- Barbar
vim.api.nvim_set_keymap('n', '<TAB>', ':BufferNext<CR>', {noremap = true, silent = true})
vim.api.nvim_set_keymap('n', '<S-TAB>', ':BufferPrevious<CR>', {noremap = true, silent = true})
vim.api.nvim_set_keymap('n', '<C-x>', ':BufferClose<CR>', {noremap = true, silent = true})

-- Better nav for omnicomplete
vim.cmd('inoremap <expr> <c-j> (\"\\<C-n>\")')
vim.cmd('inoremap <expr> <c-k> (\"\\<C-p>\")')
