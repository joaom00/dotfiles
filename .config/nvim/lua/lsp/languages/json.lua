local M = {}

local schemas = nil
local status_ok, jsonls_settings = pcall(require, "nlspsettings.jsonls")
if not status_ok then
  JM.notify("Failed to load nlsp_settings", "error")
  return
end

schemas = jsonls_settings.get_default_schemas()

function M.config()
  JM.lang.json = {}
end

function M.formatter()
  JM.lang.json.formatters = {
    -- {
    --   exe = "json_tool",
    --   args = {},
    -- },
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
  JM.lang.json.linters = {}
end

function M.lsp()
  JM.lang.json.lsp = {
    provider = "jsonls",
    setup = {
      cmd = {
        "node",
        DATA_PATH .. "/lspinstall/json/vscode-json/json-language-features/server/dist/node/jsonServerMain.js",
        "--stdio",
      },
      settings = {
        json = {
          schemas = schemas,
          --   = {
          --   {
          --     fileMatch = { "package.json" },
          --     url = "https://json.schemastore.org/package.json",
          --   },
          -- },
        },
      },
      commands = {
        Format = {
          function()
            vim.lsp.buf.range_formatting({}, { 0, 0 }, { vim.fn.line "$", 0 })
          end,
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
