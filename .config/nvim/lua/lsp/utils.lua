local M = {}

local tbl = require "utils.table"

function M.is_client_active(name)
  local clients = vim.lsp.get_active_clients()
  return tbl.find_first(clients, function(client)
    return client.name == name
  end)
end

-- function M.get_active_client_by_ft(filetype)
--   local matches = {}
--   local clients = vim.lsp.get_active_clients()
--   for _, client in pairs(clients) do
--     local supported_filetypes = client.config.filetypes or {}
--     if client.name ~= "null-ls" and vim.tbl_contains(supported_filetypes, filetype) then
--       table.insert(matches, client)
--     end
--   end
--   return matches
-- end

return M
