filetype plugin on

source ~/.config/nvim/plug-config/polyglot.vim
"-------------------------------------------------------------------------------
" General
"-------------------------------------------------------------------------------
source ~/.config/nvim/vim-plug/plugins.vim
source ~/.config/nvim/general/theme.vim
source ~/.config/nvim/general/settings.vim
source ~/.config/nvim/keys/mappings.vim
source ~/.config/nvim/general/compile-run.vim

autocmd BufWritePre *.tsx,*.ts Prettier


"-------------------------------------------------------------------------------
" Dashboard
"-------------------------------------------------------------------------------
source ~/.config/nvim/plug-config/dashboard.vim

luafile ~/.config/nvim/lua/plugins/dashboard-config.lua


"-------------------------------------------------------------------------------
" Telescope
"-------------------------------------------------------------------------------
source ~/.config/nvim/plug-config/telescope-config.vim

luafile ~/.config/nvim/lua/plugins/telescope/init.lua


"-------------------------------------------------------------------------------
" Git
"-------------------------------------------------------------------------------
source ~/.config/nvim/plug-config/gitgutter.vim


"-------------------------------------------------------------------------------
" LSP
"-------------------------------------------------------------------------------
source ~/.config/nvim/plug-config/lsp-saga.vim
source ~/.config/nvim/plug-config/compe-config.vim
source ~/.config/nvim/plug-config/lsp-config.vim

luafile ~/.config/nvim/lua/lsp/init.lua
luafile ~/.config/nvim/lua/plugins/compe-config.lua
luafile ~/.config/nvim/lua/plugins/lsp-install.lua
luafile ~/.config/nvim/lua/lsp/lsp-config.lua

luafile ~/.config/nvim/lua/lsp/clangd.lua
luafile ~/.config/nvim/lua/lsp/css-ls.lua
luafile ~/.config/nvim/lua/lsp/graphql-ls.lua
luafile ~/.config/nvim/lua/lsp/html-ls.lua
luafile ~/.config/nvim/lua/lsp/javascript-ls.lua
luafile ~/.config/nvim/lua/lsp/json-ls.lua
luafile ~/.config/nvim/lua/lsp/python-ls.lua


"-------------------------------------------------------------------------------
" Styles
"-------------------------------------------------------------------------------
source ~/.config/nvim/plug-config/rainbow-config.vim

luafile ~/.config/nvim/lua/plugins/galaxyline-config.lua
luafile ~/.config/nvim/lua/plugins/colorizer-config.lua


"-------------------------------------------------------------------------------
" Terminal
"-------------------------------------------------------------------------------
source ~/.config/nvim/plug-config/floaterm-config.vim


"-------------------------------------------------------------------------------
" File Explorer
"-------------------------------------------------------------------------------
source ~/.config/nvim/plug-config/nvimtree-config.vim

luafile ~/.config/nvim/lua/plugins/nvimtree-config.lua


"-------------------------------------------------------------------------------
" Web 
"-------------------------------------------------------------------------------
source ~/.config/nvim/plug-config/tagalong.vim
source ~/.config/nvim/plug-config/closetags.vim


"-------------------------------------------------------------------------------
" Treesitter 
"-------------------------------------------------------------------------------
luafile ~/.config/nvim/lua/plugins/treesitter-config.lua


"-------------------------------------------------------------------------------
" Barbar 
"-------------------------------------------------------------------------------
source ~/.config/nvim/plug-config/barbar-config.vim



