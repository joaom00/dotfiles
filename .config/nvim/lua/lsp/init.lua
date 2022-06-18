local M = {}

-- local function on_attach(client, bufnr)
--   client.resolved_capabilities.document_formatting = false
--   require("navigator.lspclient.mapping").setup {
--     client = client,
--     bufnr = bufnr,
--     cap = client.resolved_capabilities,
--   }
-- end

-- function M.lsp_installer_servers()
--   local enhance_server_opts = {
--     ["sumneko_lua"] = function(options)
--       options.on_attach = on_attach
--       options.settings = {
--         Lua = {
--           runtime = {
--             version = "LuaJIT",
--             path = vim.split(package.path, ";"),
--           },
--           diagnostics = {
--             globals = { "vim", "JM" },
--           },
--           workspace = {
--             library = {
--               [vim.fn.expand "$VIMRUNTIME/lua"] = true,
--               [vim.fn.expand "$VIMRUNTIME/lua/vim/lsp"] = true,
--             },
--             maxPreload = 100000,
--             preloadFileSize = 1000,
--           },
--         },
--       }
--     end,
--     -- ["tailwindcss"] = function(options)
--     --   options.on_attach = on_attach
--     --   options.cmd = { install_root_dir .. "/tailwindcss_npm/node_modules/.bin/tailwindcss-language-server" }
--     --   options.root_dir = function(fname)
--     --     return lspconfig_util.root_pattern("tailwind.config.js", "tailwind.config.ts")(fname)
--     --   end
--     -- end,
--     ["prismals"] = function(options)
--       options.on_attach = function(client, bufnr)
--         client.resolved_capabilities.document_formatting = true
--         require("navigator.lspclient.mapping").setup {
--           client = client,
--           bufnr = bufnr,
--           cap = client.ser,
--         }
--       end
--     end,
--     ["yamlls"] = function(options)
--       options.on_attach = on_attach
--       options.settings = {
--         yaml = {
--           schemas = {
--             ["https://json.schemastore.org/github-workflow.json"] = "/.github/workflows/*",
--             ["https://raw.githubusercontent.com/compose-spec/compose-spec/master/schema/compose-spec.json"] = "docker-compose.yaml",
--           },
--         },
--       }
--     end,
--   }
-- end

function M.setup()
  local ok, navigator = pcall(require, "navigator")
  if not ok then
    JM.notify "Missing navigator dependency"
    return
  end

  navigator.setup {
    lsp_signature_help = true,
    default_mapping = false,
    lsp = {
      format_on_save = true,
      disable_format_cap = { "rust_analyzer", "gopls" },
      code_lens_action = { enable = true, sign = true, sign_priority = 40, virtual_text = false },
    },
    keymaps = {
      { key = "gd", func = "vim.lsp.buf.definition()" },
      { key = "gD", func = "vim.lsp.buf.declaration()" },
      { key = "gi", func = "vim.lsp.buf.implementation()" },
      { key = "rn", func = "vim.lsp.buf.rename()" },
      { key = "gp", func = "require('navigator.definition').definition_preview()" },
      -- { key = "<space>ca", func = "require('navigator.codeAction').code_action()" },
      { key = "K", func = "hover({ popup_opts = { border = single, max_width = 80 }})" },
      { key = "<c-p>", func = "diagnostic.goto_prev({ border = 'rounded', max_width = 80})" },
      { key = "<c-n>", func = "diagnostic.goto_next({ border = 'rounded', max_width = 80})" },
    },
  }
end

return M
