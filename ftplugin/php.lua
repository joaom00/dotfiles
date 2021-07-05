require'lspconfig'.intelephense.setup {
    cmd = {
        DATA_PATH .. "/lspinstall/php/node_modules/.bin/intelephense", "--stdio"
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
    },
    filetypes = {'php', 'phtml'},
    settings = {
        intelephense = {
            format = {braces = 'psr12'},
            environment = {phpVersion = '7.4'}
        }
    }
}
