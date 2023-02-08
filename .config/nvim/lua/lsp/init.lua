local M = {}
local lspconfig = require "lspconfig"
local lspconfig_util = require "lspconfig.util"

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
vim.keymap.set("n", "<c-p>", vim.diagnostic.goto_prev)
vim.keymap.set("n", "<c-n>", vim.diagnostic.goto_next)
vim.keymap.set("n", "<leader>e", vim.diagnostic.open_float)
vim.keymap.set("n", "<leader>q", vim.diagnostic.setloclist)

local on_attach = function(_, bufnr)
  local nmap = function(keys, func, desc)
    if desc then
      desc = "LSP: " .. desc
    end
    vim.keymap.set("n", keys, func, { buffer = bufnr, desc = desc })
  end

  nmap("<leader>rn", vim.lsp.buf.rename, "Rename")
  nmap("<space>ca", vim.lsp.buf.code_action, "Code Action")
  nmap("gd", vim.lsp.buf.definition, "Goto definition")
  nmap("gi", vim.lsp.buf.implementation, "Goto Implementation")
  nmap("<leader>ds", require("telescope.builtin").lsp_document_symbols, "Document Symbols")
  nmap("<leader>ws", require("telescope.builtin").lsp_dynamic_workspace_symbols, "Workspace Symbols")
  nmap("K", vim.lsp.buf.hover, "Hover documentation")
  nmap("<c-k>", vim.lsp.buf.signature_help, "Signature Documentation")
  nmap("gD", vim.lsp.buf.declaration, "Goto Declaration")
  nmap("<leader>D", vim.lsp.buf.type_definition, "Type Definition")
end

local capabilities = require("cmp_nvim_lsp").default_capabilities(vim.lsp.protocol.make_client_capabilities())
local runtime_path = vim.split(package.path, ";")
table.insert(runtime_path, "lua/?.lua")
table.insert(runtime_path, "lua/?/init.lua")

local servers = {
  rust_analyzer = true,
  tsserver = true,
  gopls = true,
  yamlls = true,
  prismals = true,
  cssls = true,
  tailwindcss = true,
  -- emmet_ls = true,
  elixirls = {
    cmd = { vim.fn.expand("~/elixir-ls/language_server.sh") },
  },
  sumneko_lua = {
    settings = {
      Lua = {
        runtime = {
          version = "LuaJIT",
          path = runtime_path,
        },
        diagnostics = {
          globals = { "vim", "JM" },
        },
        workspace = { library = vim.api.nvim_get_runtime_file("", true), checkThirdParty = false },
      },
    },
  },
  jsonls = {
    settings = {
      json = {
        schemas = require("schemastore").json.schemas(),
      },
    },
  },
  -- tailwindcss = {
  --   settings = {
  --     classAttributes = { "class", "className", "classList", "ngClass" },
  --   },
  --   root_dir = function(fname)
  --     return lspconfig_util.root_pattern("tailwind.config.js", "tailwind.config.ts")(fname)
  --   end,
  -- },
}

local setup_server = function(server, config)
  if not config then
    return
  end

  if type(config) ~= "table" then
    config = {}
  end

  if server == "jsonls" then
    capabilities.textDocument.completion.completionItem.snippetSupport = true
  end

  config = vim.tbl_deep_extend("force", {
    on_attach = on_attach,
    capabilities = capabilities,
    flags = {
      debounce_text_changes = nil,
    },
  }, config)

  lspconfig[server].setup(config)
end

for server, config in pairs(servers) do
  setup_server(server, config)
end

return M
