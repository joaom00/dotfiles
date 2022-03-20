if not pcall(require, "navigator") then
  JM.notify "Missing navigator dependency"
  return
end

if not pcall(require, "nvim-lsp-installer") then
  JM.notify "Missing nvim-lsp-installer dependency"
  return
end

local M = {}

local function on_attach(client, bufnr)
  client.resolved_capabilities.document_formatting = false
  require("navigator.lspclient.mapping").setup {
    client = client,
    bufnr = bufnr,
    cap = client.resolved_capabilities,
  }
end

function M.setup()
  local lsp_installer = require "nvim-lsp-installer"
  local lspconfig_util = require "lspconfig.util"
  -- local path = require "nvim-lsp-installer.path"
  -- local install_root_dir = path.concat { vim.fn.stdpath "data", "lsp_servers" }

  local enhance_server_opts = {
    ["sumneko_lua"] = function(options)
      options.on_attach = on_attach
      options.settings = {
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
      }
    end,
    ["tsserver"] = function(options)
      options.on_attach = on_attach
    end,
    ["tailwindcss"] = function(options)
      options.on_attach = on_attach
      options.root_dir = function(fname)
        return lspconfig_util.root_pattern("tailwind.config.js", "tailwind.config.ts")(fname)
      end
    end,
    ["prismals"] = function(options)
      options.on_attach = on_attach
    end,
    ["yamlls"] = function(options)
      options.on_attach = on_attach
      options.settings = {
        yaml = {
          schemas = {
            ["https://json.schemastore.org/github-workflow.json"] = "/.github/workflows/*",
            ["https://raw.githubusercontent.com/compose-spec/compose-spec/master/schema/compose-spec.json"] = "docker-compose.yaml",
          },
        },
      }
    end,
  }

  lsp_installer.on_server_ready(function(server)
    local options = {}

    if enhance_server_opts[server.name] then
      enhance_server_opts[server.name](options)
    end

    server:setup(options)
  end)
end

return M
