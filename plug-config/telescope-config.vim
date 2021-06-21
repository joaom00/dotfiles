"Neovim Files
nnoremap <silent> <space>en <cmd>lua require("plugins.telescope").edit_neovim()<CR>

"Files
nnoremap <silent> <space>ft <cmd>lua require("plugins.telescope").git_files()<CR>
nnoremap <silent> <space>fg <cmd>lua require("plugins.telescope").live_grep()<CR>
nnoremap <silent> <space>fo <cmd>lua require("plugins.telescope").oldfiles()<CR>
nnoremap <silent> <space>pp <cmd>lua require("plugins.telescope").project()<CR>
nnoremap <silent> <space>fe <cmd>Telescope file_browser<CR>
nnoremap <silent> <space>mf <cmd>Telescope media_files<CR>

"Git
nnoremap <silent> <space>gs <cmd>lua require("plugins.telescope").git_status()<CR>
nnoremap <silent> <space>gc <cmd>lua require("plugins.telescope").git_commits()<CR>
nnoremap <silent> <space>gi <cmd>lua require("plugins.telescope").git_issues()<CR>
nnoremap <silent> <space>gp <cmd>lua require("plugins.telescope").git_pr()<CR>
nnoremap <silent> <space>gg <cmd>Telescope gh gist<CR>
nnoremap <silent> <space>gb <cmd>Telescope git_branches<CR>

"LSP
nnoremap <silent> <space>gd <cmd>Telescope lsp_definitions<CR>
nnoremap <silent> <space>gr <cmd>Telescope lsp_references<CR>
nnoremap <silent> <space>fi <cmd>Telescope lsp_implementations<CR>

"Nvim
nnoremap <silent> <space>fb <cmd>lua require("plugins.telescope").buffers()<CR>
nnoremap <silent> <space>ff <cmd>lua require("plugins.telescope").curbuf()<CR>
nnoremap <silent> <space>gp <cmd>lua require("plugins.telescope").grep_prompt()<CR>
nnoremap <silent> <space>fi <cmd>lua require("plugins.telescope").search_all_files()<CR>


