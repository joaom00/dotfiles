local M = {}

function M.config()
  JM.lang.lua = {}
end

function M.formatter()
  JM.lang.lua.formatters = {
    {
      exe = "stylua",
      args = {},
    },
    -- {
    --   exe = "lua_format",
    --   args = {},
    -- },
  }
end

function M.linter()
  JM.lang.lua.linters = {}
end

function M.lsp()
  JM.lang.lua.lsp = {
    provider = "sumneko_lua",
    setup = {
      cmd = {
        DATA_PATH .. "/lspinstall/lua/sumneko-lua-language-server",
        "-E",
        DATA_PATH .. "/lspinstall/lua/main.lua",
      },
      settings = {
        Lua = {
          runtime = {
            version = "LuaJIT",
            path = vim.split(package.path, ";"),
          },
          diagnostics = {
            globals = { "vim", "JM" },
          },
          workspace = {
            library = {
              [vim.fn.expand "$VIMRUNTIME/lua"] = true,
              [vim.fn.expand "$VIMRUNTIME/lua/vim/lsp"] = true,
            },
            maxPreload = 100000,
            preloadFileSize = 1000,
          },
        },
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
