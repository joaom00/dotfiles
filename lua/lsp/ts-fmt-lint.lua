local M = {}

M.setup = function()
  local tsserver_args = {}

  local prettier = {formatCommand = 'prettier --stdin-filepath ${INPUT}', formatStdin = true}

  if vim.fn.glob('node_modules/.bin/prettier') then
    prettier = {formatCommand = './node_modules/.bin/prettier --stdin-filepath ${INPUT}', formatStdin = true}
  end

  local eslint = {
    lintCommand = './node_modules/.bin/eslint -f unix --stdin --stdin-filename ${INPUT}',
    lintIgnoreExitCode = true,
    lintStdin = true,
    lintFormats = {'%f:%l:%c: %m'},
    -- formatCommand = "./node_modules/.bin/eslint -f unix --fix --stdin-filename ${INPUT}", -- TODO check if eslint is the formatter then add this
    formatStdin = true
  }

  table.insert(tsserver_args, prettier)

  table.insert(tsserver_args, eslint)

  require'lspconfig'.efm.setup {
    -- init_options = {initializationOptions},
    cmd = {DATA_PATH .. '/lspinstall/efm/efm-langserver'},
    init_options = {documentFormatting = true, codeAction = false},
    filetypes = {'javascriptreact', 'javascript', 'typescript', 'typescriptreact', 'html', 'css', 'yaml', 'vue'},
    settings = {
      rootMarkers = {'.git/', 'package.json'},
      languages = {
        javascript = tsserver_args,
        javascriptreact = tsserver_args,
        typescript = tsserver_args,
        typescriptreact = tsserver_args,
        html = {prettier},
        css = {prettier},
        json = {prettier},
        yaml = {prettier}
      }
    }
  }
end

return M
