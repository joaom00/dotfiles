autocmd BufWritePre *.js,*.jsx,*.ts,*.tsx Prettier
autocmd BufWritePre *.json lua vim.lsp.buf.formatting_sync(nil, 1000)
autocmd BufWritePre *.lua lua vim.lsp.buf.formatting_sync(nil, 1000)
autocmd BufWritePre *.py lua vim.lsp.buf.formatting_sync(nil, 1000)
autocmd BufWritePre *.c lua vim.lsp.buf.formatting_seq_sync(nil, 1000)

