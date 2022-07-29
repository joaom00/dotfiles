local M = {}

local fmt = string.format

function M.conf(name)
  return R(fmt("jm.%s", name))
end

return M
