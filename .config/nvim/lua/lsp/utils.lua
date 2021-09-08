local M = {}

function M.is_client_active(name)
  local clients = vim.lsp.get_active_clients()
  for _, client in pairs(clients) do if client.name == name then return true, client end end
  return false
end

function M.get_active_client_by_ft(filetype)
  if not JM.lang[filetype] or not JM.lang[filetype].lsp then return nil end

  local clients = vim.lsp.get_active_clients()
  for _, client in pairs(clients) do if client.name == JM.lang[filetype].lsp.provider then return client end end
  return nil
end

return M
