local M = {}

local function on_attach(client, bufnr)
  client.resolved_capabilities.document_formatting = false
  require("navigator.lspclient.mapping").setup {
    client = client,
    bufnr = bufnr,
    cap = client.resolved_capabilities,
  }
end

function M.lsp_installer_servers()
  local ok, lsp_installer = pcall(require, "nvim-lsp-installer")
  if not ok then
    JM.notify "Missing nvim-lsp-installer dependency"
    return
  end

  local lspconfig_util = require "lspconfig.util"
  local path = require "nvim-lsp-installer.path"
  local install_root_dir = path.concat { vim.fn.stdpath "data", "lsp_servers" }

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
    ["gopls"] = function(options)
      options.on_attach = on_attach
    end,
    ["tsserver"] = function(options)
      options.on_attach = on_attach
    end,
    ["tailwindcss"] = function(options)
      options.on_attach = on_attach
      options.cmd = { install_root_dir .. "/tailwindcss_npm/node_modules/.bin/tailwindcss-language-server" }
      options.root_dir = function(fname)
        return lspconfig_util.root_pattern("tailwind.config.js", "tailwind.config.ts")(fname)
      end
    end,
    ["html"] = function(options)
      options.on_attach = on_attach
    end,
    ["cssls"] = function(options)
      options.on_attach = on_attach
    end,
    ["cssmodules_ls"] = function(options)
      options.on_attach = on_attach
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

function M.setup()
  local ok, navigator = pcall(require, "navigator")
  if not ok then
    JM.notify "Missing navigator dependency"
    return
  end

  M.lsp_installer_servers()

  local single = { "╭", "─", "╮", "│", "╯", "─", "╰", "│" }
  local lspconfig_util = require "lspconfig.util"

  navigator.setup {
    lsp_installer = true,
    border = single,
    lsp_signature_help = true,
    default_mapping = false,
    combined_attach = "their",
    lsp = {
      format_on_save = true,
      code_lens = false,
      disable_format_cap = { "gopls", "volar" },
      servers = { "volar" },
      volar = {
        cmd = { "vue-language-server", "--stdio" },
        filetypes = { "typescript", "javascript", "javascriptreact", "typescriptreact", "vue", "json" },
        root_dir = lspconfig_util.root_pattern(".git", "yarn.lock", "package.json", "vite.config.ts"),
      },
    },
    keymaps = {
      { key = "gd", func = "require('navigator.definition').definition()" },
      { key = "gD", func = "declaration({ border = 'rounded', max_width = 80 })" },
      { key = "gr", func = "require('navigator.reference').async_ref()" },
      { key = "gi", func = "implementation()" },
      { key = "rn", func = "require('navigator.rename').rename()" },
      { key = "gp", func = "require('navigator.definition').definition_preview()" },
      { key = "<space>ca", func = "require('navigator.codeAction').code_action()" },
      { key = "K", func = "hover({ popup_opts = { border = single, max_width = 80 }})" },
      { key = "<c-p>", func = "diagnostic.goto_prev({ border = 'rounded', max_width = 80})" },
      { key = "<c-n>", func = "diagnostic.goto_next({ border = 'rounded', max_width = 80})" },
    },
  }
end

return M
