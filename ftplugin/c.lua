local clangd_flags = {"--background-index"};

table.insert(clangd_flags, "--cross-file-rename")

table.insert(clangd_flags,
             "--header-insertion=" .. O.lang.clang.header_insertion)

require'lspconfig'.clangd.setup {
    cmd = {
        DATA_PATH .. "/lspinstall/cpp/clangd/bin/clangd", unpack(clangd_flags)
    },
    on_attach = require'lsp'.common_on_attach,
    handlers = {
        ["textDocument/publishDiagnostics"] = vim.lsp.with(vim.lsp.diagnostic
                                                               .on_publish_diagnostics,
                                                           {
            virtual_text = {spacing = 0, prefix = ""},
            signs = true,
            underline = true,
            update_in_insert = true

        })
    }
}

require('utils').define_augroups({
    _clang_autoformat = {
        {'BufWritePre *.c lua vim.lsp.buf.formatting_sync(nil,1000)'},
        {'BufWritePre *.h lua vim.lsp.buf.formatting_sync(nil,1000)'},
        {'BufWritePre *.cpp lua vim.lsp.buf.formatting_sync(nil,1000)'},
        {'BufWritePre *.hpp lua vim.lsp.buf.formatting_sync(nil,1000)'}
    }
})
