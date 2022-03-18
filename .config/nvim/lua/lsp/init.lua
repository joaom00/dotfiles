local M = {}
local nnoremap = JM.mapper "n"

function M.config()
  vim.lsp.protocol.CompletionItemKind = JM.lsp.completion.item_kind

  for _, sign in ipairs(JM.lsp.diagnostics.signs.values) do
    vim.fn.sign_define(sign.name, { texthl = sign.name, text = sign.text, numhl = sign.name })
  end

  require("lsp.handlers").setup()
  require("lsp.null-ls").setup()
end

nnoremap("gd", "<cmd>lua vim.lsp.buf.definition()<CR>")
nnoremap("gD", "<cmd>lua vim.lsp.buf.declaration()<CR>")
-- nnoremap("gr", "<cmd>lua vim.lsp.buf.references()<CR>")
nnoremap("gi", "<cmd>lua vim.lsp.buf.implementation()<CR>")
nnoremap("gp", "<cmd>lua require'lsp.peek'.Peek('definition')<CR>")
nnoremap("K", "<cmd>lua vim.lsp.buf.hover()<CR>")
nnoremap("gs", "<cmd>lua vim.lsp.buf.signature_help()<CR>")
nnoremap("<C-p>", "<cmd>lua vim.lsp.diagnostic.goto_prev({popup_opts = {border = 'single'}})<CR>")
nnoremap("<C-n>", "<cmd>lua vim.lsp.diagnostic.goto_next({popup_opts = {border = 'single'}})<CR>")

function M.common_capabilities()
  local capabilities = vim.lsp.protocol.make_client_capabilities()
  capabilities.textDocument.completion.completionItem.snippetSupport = true
  capabilities.textDocument.completion.completionItem.resolveSupport = {
    properties = { "documentation", "detail", "additionalTextEdits" },
  }

  local status_ok, cmp_nvim_lsp = pcall(require, "cmp_nvim_lsp")
  if status_ok then
    capabilities = cmp_nvim_lsp.update_capabilities(capabilities)
  end

  return capabilities
end

local function lsp_highlight_document(client)
  -- Set autocommands conditional on server_capabilities
  if client.resolved_capabilities.document_highlight then
    vim.api.nvim_exec(
      [[
      augroup lsp_document_highlight
        autocmd! * <buffer>
        autocmd CursorHold <buffer> lua vim.lsp.buf.document_highlight()
        autocmd CursorMoved <buffer> lua vim.lsp.buf.clear_references()
      augroup END
    ]],
      false
    )
  end
end

local function lsp_code_lens_refresh(client)
  if client.resolved_capabilities.code_lens then
    vim.api.nvim_exec(
      [[
      augroup lsp_code_lens_refresh
        autocmd! * <buffer>
        autocmd InsertLeave <buffer> lua vim.lsp.codelens.refresh()
        autocmd InsertLeave <buffer> lua vim.lsp.codelens.display()
      augroup END
    ]],
      false
    )
  end
end

local function select_default_formater(client)
  if client.name == "null-ls" or not client.resolved_capabilities.document_formatting then
    return
  end
  vim.notify("Checking for formatter overriding for " .. client.name, vim.log.levels.INFO)
  local formatters = require "lsp.null-ls.formatters"
  local client_filetypes = client.config.filetypes or {}
  for _, filetype in ipairs(client_filetypes) do
    if #vim.tbl_keys(formatters.list_registered(filetype)) > 0 then
      --       JM.notify("Formatter overriding detected. Disabling formatting capabilities for " .. client.name)
      client.resolved_capabilities.document_formatting = false
      client.resolved_capabilities.document_range_formatting = false
    end
  end
end

function M.get_ls_capabilities(client_id)
  local client
  if not client_id then
    local buf_clients = vim.lsp.buf_get_clients()
    for _, buf_client in ipairs(buf_clients) do
      if buf_client.name ~= "null-ls" then
        client_id = buf_client.id
        break
      end
    end
  end
  if not client_id then
    error "Unable to determine client_id"
  end

  client = vim.lsp.get_client_by_id(tonumber(client_id))

  local enabled_caps = {}

  for k, v in pairs(client.resolved_capabilities) do
    if v == true then
      table.insert(enabled_caps, k)
    end
  end

  return enabled_caps
end

function M.common_on_init(client)
  select_default_formater(client)
end

function M.common_on_attach(client)
  lsp_highlight_document(client)
  lsp_code_lens_refresh(client)
end

local function resolve_config(user_config)
  local config = {
    on_attach = M.common_on_attach,
    on_init = M.common_on_init,
    capabilities = M.common_capabilities(),
  }

  if user_config then
    config = vim.tbl_deep_extend("force", config, user_config)
  end

  return config
end

local function buf_try_add(server_name, bufnr)
  bufnr = bufnr or vim.api.nvim_get_current_buf()
  require("lspconfig")[server_name].manager.try_add_wrapper(bufnr)
end

function M.setup(server_name, user_config)
  local config = resolve_config(user_config)

  local servers = require "nvim-lsp-installer.servers"
  local server_available, requested_server = servers.get_server(server_name)

  if not server_available then
    pcall(function()
      require("lspconfig")[server_name].setup(config)
      buf_try_add(server_name)
    end)
    return
  end

  requested_server:on_ready(function()
    vim.notify(string.format("Installation complete for [%s] server", requested_server.name), vim.log.levels.INFO)
    requested_server:setup(config)
  end)
end

return M
