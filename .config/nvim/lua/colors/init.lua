local M = {}

function M.init(theme)
  theme = theme or "tokyonight"

  local status_ok, base16 = pcall(require, "base16")

  if status_ok then
    base16(base16.themes(theme), true)
  else
    JM.notify "Missing base16 dependency"
    return
  end
end

function M.get(theme)
  theme = theme or "onedark"
  return require("colors.themes." .. theme)
end

return M
