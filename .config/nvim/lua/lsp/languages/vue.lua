local M = {}

function M.config()
  JM.lang.vue = {}
end

function M.formatter()
  JM.lang.vue.formatters = {
    {
      exe = "prettier",
      args = {},
    },
    -- {
    --   exe = "prettierd",
    --   args = {},
    -- },
    -- {
    --   exe = "prettier_d_slim",
    --   args = {},
    -- },
  }
end

function M.linter()
  JM.lang.vue.linters = {
    {
      exe = "eslint",
    },
  }
end

function M.lsp()
  JM.lang.vue.lsp = {
    provider = "vuels",
    setup = {
      cmd = {
        DATA_PATH .. "/lsp_servers/vuels/node_modules/.bin/vls",
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
