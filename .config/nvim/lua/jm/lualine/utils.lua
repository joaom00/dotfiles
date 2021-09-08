local M = {}

function M.validate_theme()
  local theme = JM.lualine.options.theme

  local lualine_loader = require "lualine.utils.loader"
  local ok = pcall(lualine_loader.load_theme, theme)
  if not ok then
    JM.lualine.options.theme = "auto"
  end
end

function M.env_cleanup(venv)
  if string.find(venv, "/") then
    local final_venv = venv
    for w in venv:gmatch "([^/]+)" do
      final_venv = w
    end
    venv = final_venv
  end
  return venv
end

return M
