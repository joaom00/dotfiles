local sumneko_root_path = DATA_PATH .. '/lspinstall/lua'
local sumneko_binary = sumneko_root_path .. '/sumneko-lua-language-server'

require'lspconfig'.sumneko_lua.setup {
  cmd = {sumneko_binary, '-E', sumneko_root_path .. '/main.lua'},
  on_attach = require'lsp'.common_on_attach,
  settings = {
    Lua = {
      runtime = {version = 'LuaJIT', path = vim.split(package.path, ';')},
      diagnostics = {globals = {'vim'}},
      workspace = {
        library = {[vim.fn.expand('$VIMRUNTIME/lua')] = true, [vim.fn.expand('$VIMRUNTIME/lua/vim/lsp')] = true},
        maxPreload = 100000,
        preloadFileSize = 1000
      }
    }
  }
}
require('utils').define_augroups({
  _lua_autoformat = {{'BufWritePre', '*.lua', 'lua vim.lsp.buf.formatting_sync(nil, 1000)'}}
})

local lua_arguments = {}

local luaFormat = {
  formatCommand = 'lua-format -i --no-keep-simple-function-one-line --column-limit=120 --no-use-tab --indent-width=2 --double-quote-to-single-quote',
  formatStdin = true
}

table.insert(lua_arguments, luaFormat)

require'lspconfig'.efm.setup {
  cmd = {DATA_PATH .. '/lspinstall/efm/efm-langserver'},
  init_options = {documentFormatting = true, codeAction = false},
  filetypes = {'lua'},
  settings = {rootMarkers = {'.git/'}, languages = {lua = lua_arguments}}
}

vim.cmd('setl ts=2 sw=2')

