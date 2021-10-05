-- Disable arrow keys
local nmap = JM.mapper("n", false)

local nnoremap = JM.mapper "n"
local inoremap = JM.mapper "i"
local tnoremap = JM.mapper "t"
local vnoremap = JM.mapper "v"
local xnoremap = JM.mapper "x"

vim.cmd [[
map <up> :echoerr "Pq você ta fazendo isso?"<CR>
map <down> :echoerr "Pq você ta fazendo isso?"<CR>
map <left> :echoerr "Pq você ta fazendo isso?"<CR>
map <right> :echoerr "Pq você ta fazendo isso?"<CR>
]]

require "jm.telescope.mappings"

-- Better window movement
nmap("<C-h>", "<C-w>h")
nmap("<C-j>", "<C-w>j")
nmap("<C-k>", "<C-w>k")
nmap("<C-l>", "<C-w>l")

-- Better window movement (Terminal)
tnoremap("<C-h>", "<C-\\><C-n><C-w>h")
tnoremap("<C-j>", "<C-\\><C-n><C-w>j")
tnoremap("<C-k>", "<C-\\><C-n><C-w>k")
tnoremap("<C-l>", "<C-\\><C-n><C-w>l")

-- Alternative to quit
nnoremap("q", "<cmd>q<CR>")

-- Alternative to save
nnoremap("<C-s>", "<cmd>w<CR>")

-- Clear Highlights
nmap("//", "<cmd>noh<return>")

-- Resize with arrows
nmap("<C-Up>", "<cmd>resize -2<CR>")
nmap("<C-Down>", "<cmd>resize +2<CR>")
nmap("<C-Left>", "<cmd>vertical resize -2<CR>")
nmap("<C-Right>", "<cmd>vertical resize +2<CR>")

-- Better indenting
vnoremap("<", "<gv")
vnoremap(">", ">gv")

-- I hate escape
inoremap("jk", "<ESC>")
inoremap("kj", "<ESC>")
inoremap("jj", "<ESC>")

-- Move selected line / block of text in visual mode
xnoremap("J", "<cmd>move '>+1<CR>gv-gv")
xnoremap("K", "<cmd>move '<-2<CR>gv-gv")

-- Move current line / block with Alt-j/k ala vscode.
nnoremap("<A-j>", "<cmd>m .+1<CR>==")
nnoremap("<A-k>", "<cmd>m .-2<CR>==")
inoremap("<A-j>", "<Esc><cmd>m .+1<CR>==gi")
inoremap("<A-k>", "<Esc><cmd>m .-2<CR>==gi")
xnoremap("<A-j>", "<cmd>m '>+1<CR>gv-gv")
xnoremap("<A-k>", "<cmd>m '<-2<CR>gv-gv")

-- Comment
nnoremap("/", "<cmd>CommentToggle<CR>")
vnoremap("/", ":CommentToggle<CR>")

nnoremap("<Space>go", "<cmd>lua vim.cmd('colorscheme xcodedarkhc')<CR>")
