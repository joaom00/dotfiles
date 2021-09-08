local M = {}

function M.config()
  JM.autopairs = {
    map_cr = true,
    map_complete = vim.bo.filetype ~= "tex",
    check_ts = true,
    ts_config = {lua = {"string"}, javascript = {"template_string"}}
  }
end

function M.setup()
  _G.MUtils = {}
  local autopairs = require("nvim-autopairs")
  local Rule = require("nvim-autopairs.rule")

  vim.g.completion_confirm_key = ""

  MUtils.completion_confirm = function()
    if vim.fn.pumvisible() ~= 0 then
      if vim.fn.complete_info()["selected"] ~= -1 then
        return vim.fn["compe#confirm"](autopairs.esc "<cr>")
      else
        return autopairs.esc "<cr>"
      end
    else
      return autopairs.autopairs_cr()
    end
  end

  M.config()

  if package.loaded["compe"] then
    require("nvim-autopairs.completion.compe").setup {
      map_cr = JM.autopairs.map_cr,
      map_complete = JM.autopairs.map_complete
    }
  end

  autopairs.setup {check_ts = JM.autopairs.check_ts, ts_config = JM.autopairs.ts_config}

  require("nvim-treesitter.configs").setup {autopairs = {enable = true}}

  local ts_conds = require("nvim-autopairs.ts-conds")

  autopairs.add_rules {
    Rule("%", "%", "lua"):with_pair(ts_conds.is_ts_node {"string", "comment"}),
    Rule("$", "$", "lua"):with_pair(ts_conds.is_not_ts_node {"function"})
  }

end

return M
