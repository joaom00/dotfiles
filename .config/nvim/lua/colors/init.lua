local M = {}

function M.init(theme)
  theme = theme or ""

  local status_ok, base16 = pcall(require, "base16")
  if not status_ok then
    JM.notify "Missing base16 dependency"
    return
  end

  base16(base16.themes(theme), true)
end

function M.get(theme)
  theme = theme or "onedark"
  return require("colors.themes." .. theme)
end

return M
