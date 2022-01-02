local nnoremap = JM.mapper "n"

require("lsp").setup "go"

vim.cmd "setl ts=4 sw=4"

nnoremap("fs", "<cmd>GoFillStruct<CR>")
nnoremap("gt", "<cmd>GoTestFunc<CR>")
