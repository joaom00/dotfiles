local M = {}

M.setup = function()

  local get_linter_instance = function()
    -- prioritize local instance over global
    local local_instance = './node_modules/.bin/eslint'
    if vim.fn.executable(local_instance) == 1 then return local_instance end
    return 'eslint_d'
  end

  local tsserver_args = {}
  local formattingSupported = false

  --   local prettier = {formatCommand = 'prettier --stdin-filepath ${INPUT}', formatStdin = true}
  -- 
  --   if vim.fn.glob('node_modules/.bin/prettier') then
  --     prettier = {formatCommand = './node_modules/.bin/prettier --stdin-filepath ${INPUT}', formatStdin = true}
  --   end
  -- 

  --   local eslint = {
  --     lintCommand = './node_modules/.bin/eslint -f unix --stdin --stdin-filename ${INPUT}',
  --     lintIgnoreExitCode = true,
  --     lintStdin = true,
  --     lintFormats = {'%f:%l:%c: %m'},
  --     -- formatCommand = "./node_modules/.bin/eslint -f unix --fix --stdin-filename ${INPUT}", -- TODO check if eslint is the formatter then add this
  --     formatStdin = true
  --   }
  -- 
  --   table.insert(tsserver_args, prettier)
  -- 
  --   table.insert(tsserver_args, eslint)

  local eslint = {
    lintCommand = get_linter_instance() .. ' -f visualstudio --stdin --stdin-filename ${INPUT}',
    lintStdin = true,
    lintFormats = {'%f(%l,%c): %tarning %m', '%f(%l,%c): %trror %m'},
    lintSource = 'eslint',
    lintIgnoreExitCode = true
  }
  table.insert(tsserver_args, eslint)
  -- Only eslint_d supports --fix-to-stdout
  if string.find(get_linter_instance(), 'eslint_d') then
    formattingSupported = true
    local eslint_fix = {
      formatCommand = get_linter_instance() .. ' --fix-to-stdout --stdin --stdin-filename ${INPUT}',
      formatStdin = true
    }
    table.insert(tsserver_args, eslint_fix)
  end

  require'lspconfig'.efm.setup {
    cmd = {DATA_PATH .. '/lspinstall/efm/efm-langserver'},
    init_options = {documentFormatting = formattingSupported, codeAction = false},
    root_dir = require('lspconfig').util.root_pattern('.git/', 'package.json'),
    filetypes = {
      'vue', 'javascript', 'javascriptreact', 'typescript', 'typescriptreact', 'javascript.jsx', 'typescript.tsx'
    },
    settings = {
      rootMarkers = {'.git/', 'package.json'},
      languages = {
        vue = tsserver_args,
        javascript = tsserver_args,
        javascriptreact = tsserver_args,
        ['javascript.jsx'] = tsserver_args,
        typescript = tsserver_args,
        ['typescript.tsx'] = tsserver_args,
        typescriptreact = tsserver_args
      }
    }
  }
end

return M
