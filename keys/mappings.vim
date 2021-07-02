" Change leader key to "-"
let mapleader = "-"

" Disable arrow keys
map <up> :echoerr "Pq você ta fazendo isso?"<CR>
map <down> :echoerr "Pq você ta fazendo isso?"<CR>
map <left> :echoerr "Pq você ta fazendo isso?"<CR>
map <right> :echoerr "Pq você ta fazendo isso?"<CR>

" Split Navigations
nnoremap <C-j> <C-w><C-J>
nnoremap <C-k> <C-w><C-K>
nnoremap <C-l> <C-w><C-L>
nnoremap <C-h> <C-w><C-H>

" I hate Esc
inoremap <silent> <C-c> <Esc>
inoremap <silent> jj <Esc>
inoremap <silent> jk <Esc>
inoremap <silent> kk <Esc>

" Alternative to quit
nnoremap q :q<CR>

" Alternative to save
nnoremap <C-s> :w<CR>

" Resize Split
nnoremap <silent> <C-Up> :resize -2<CR>
nnoremap <silent> <C-Down> :resize +2<CR>
nnoremap <silent> <C-Left> :vertical resize +2<CR>
nnoremap <silent> <C-Right> :vertical resize -2<CR>

" Enable folding with spacebar
"nnoremap <space> za

" Clear Highlights
nnoremap // :noh<return>

" Move current line down or up
nnoremap <Leader>- ddp
nnoremap <Leader>_ ddkP
