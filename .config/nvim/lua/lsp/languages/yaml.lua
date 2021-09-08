local M = {}

function M.config()
  JM.lang.yaml = {}
end

function M.formatter()
  JM.lang.yaml.formatters = {
    {
      exe = "prettier",
      args = {},
    },
    -- {
    --   exe = "prettierd",
    --   args = {},
    -- },
  }
end

function M.linter()
  JM.lang.yaml.linters = {}
end

function M.lsp()
  JM.lang.yaml.lsp = {
    provider = "yamlls",
    setup = {
      cmd = {
        DATA_PATH .. "/lspinstall/yaml/node_modules/.bin/yaml-language-server",
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
