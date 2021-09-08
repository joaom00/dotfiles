local M = {}

function M.config()
  JM.lang.c = {}
end

function M.formatter()
  JM.lang.c.formatters = {
    {
      exe = "clang_format",
      args = {},
    },
    -- {
    --   exe = "uncrustify",
    --   args = {},
    -- },
  }
end

function M.linter()
  JM.lang.c.linters = {}
end

function M.lsp()
  JM.lang.c.lsp = {
    provider = "clangd",
    setup = {
      cmd = {
        DATA_PATH .. "/lspinstall/cpp/clangd/bin/clangd",
        "--background-index",
        "--header-insertion=never",
        "--cross-file-rename",
        "--clang-tidy",
        "--clang-tidy-checks=-*,llvm-*,clang-analyzer-*",
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
