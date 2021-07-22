local M = {}

M.config = function()
  O.lang.clang = {
    diagnostics = {virtual_text = {spacing = 0, prefix = ''}, signs = true, underline = true},
    cross_file_rename = true,
    header_insertion = 'never',
    filetypes = {'c', 'cpp', 'objc'},
    formatter = {exe = 'clang-format', args = {}, stdin = true},
    linters = {'cppcheck', 'clangtidy'},
    debug = {adapter = {command = '/usr/bin/lldb-vscode'}, stop_on_entry = false},
    lsp = {path = DATA_PATH .. '/lspinstall/cpp/clangd/bin/clangd'}
  }
end

M.format = function()
  local shared_config = {
    function()
      return {
        exe = O.lang.clang.formatter.exe,
        args = O.lang.clang.formatter.args,
        stdin = O.lang.clang.formatter.stdin,
        cwd = vim.fn.expand '%:h:p'
      }
    end
  }
  O.formatters.filetype['c'] = shared_config
  O.formatters.filetype['cpp'] = shared_config
  O.formatters.filetype['objc'] = shared_config

  require('formatter.config').set_defaults {logging = false, filetype = O.formatters.filetype}
end

M.lint = function()
  require('lint').linters_by_ft = {c = O.lang.clang.linters, cpp = O.lang.clang.linters}
end

M.lsp = function()
  local clangd_flags = {'--background-index'}

  if O.lang.clang.cross_file_rename then table.insert(clangd_flags, '--cross-file-rename') end

  table.insert(clangd_flags, '--header-insertion=' .. O.lang.clang.header_insertion)

  require('lspconfig').clangd.setup {
    cmd = {O.lang.clang.lsp.path, unpack(clangd_flags)},
    on_attach = require('lsp').common_on_attach,
    handlers = {
      ['textDocument/publishDiagnostics'] = vim.lsp.with(vim.lsp.diagnostic.on_publish_diagnostics, {
        virtual_text = O.lang.clang.diagnostics.virtual_text,
        signs = O.lang.clang.diagnostics.signs,
        underline = O.lang.clang.diagnostics.underline,
        update_in_insert = true
      })
    }
  }
end

M.dap = function()
  -- TODO: implement dap
  return 'No DAP configured!'
end

return M
