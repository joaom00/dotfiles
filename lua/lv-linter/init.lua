local M = {}

M.setup = function()
  require'utils'.define_augroups {
    autolint = {
      {'BufWritePost', '<buffer>', ':silent lua require(\'lint\').try_lint()'},
      {'BufEnter', '<buffer>', ':silent lua require(\'lint\').try_lint()'}
    }
  }
end

local status_ok, _ = pcall(require, 'lint')
if not status_ok then return end

return M
