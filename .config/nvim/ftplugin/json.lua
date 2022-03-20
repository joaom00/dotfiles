local capabilities = require("cmp_nvim_lsp").update_capabilities(vim.lsp.protocol.make_client_capabilities())
capabilities.textDocument.completion.completionItem.snippetSupport = true

local function on_attach(client, bufnr)
  client.resolved_capabilities.document_formatting = false
  require("navigator.lspclient.mapping").setup {
    client = client,
    bufnr = bufnr,
    cap = client.resolved_capabilities,
  }
end

require("lspconfig").jsonls.setup {
  capabilities = capabilities,
  on_attach = on_attach,
  settings = {
    json = {
      schemas = require("schemastore").json.schemas(),
    },
  },
  setup = {
    commands = {
      Format = {
        function()
          vim.lsp.buf.range_formatting({}, { 0, 0 }, { vim.fn.line "$", 0 })
        end,
      },
    },
  },
}
