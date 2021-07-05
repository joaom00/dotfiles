local M = {}

M.setup = function()

    local prettier = {
        formatCommand = "prettier --stdin-filepath ${INPUT}",
        formatStdin = true
    }

    if vim.fn.glob("node_modules/.bin/prettier") then
        prettier = {
            formatCommand = "./node_modules/.bin/prettier --stdin-filepath ${INPUT}",
            formatStdin = true
        }
    end

    require"lspconfig".efm.setup {
        -- init_options = {initializationOptions},
        cmd = {DATA_PATH .. "/lspinstall/efm/efm-langserver"},
        init_options = {documentFormatting = true, codeAction = false},
        filetypes = {"html", "css", "yaml", "vue"},
        settings = {
            rootMarkers = {".git/", "package.json"},
            languages = {
                html = {prettier},
                css = {prettier},
                json = {prettier},
                yaml = {prettier}
            }
        }
    }
end

return M
