local M = {}

function M.config()
  JM.lang.vim = {}
end

function M.formatter()
  JM.lang.vim.formatters = {}
end

function M.linter()
  JM.lang.vim.linters = {}
end

function M.lsp()
  JM.lang.vim.lsp = {
    provider = "vimls",
    setup = {
      cmd = {
        DATA_PATH .. "/lspinstall/vim/node_modules/.bin/vim-language-server",
        "--stdio",
      },
    },
  }
end

function M.setup()
  M.config()
  M.formatter()
  M.linter()
  M.lsp()
end

return M
