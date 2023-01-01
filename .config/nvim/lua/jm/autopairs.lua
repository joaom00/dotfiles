local M = {}

function M.config()
  local npairs = require "nvim-autopairs"
  npairs.setup {
    close_triple_quotes = true,
    check_ts = true,
    ts_config = {
      lua = { "string" },
      javascript = { "template_string" },
    },
    fast_wrap = {
      map = "<c-j>",
    },
  }
local cmp_autopairs = require('nvim-autopairs.completion.cmp')
local cmp = require('cmp')
cmp.event:on(
  'confirm_done',
  cmp_autopairs.on_confirm_done()
)
end

-- function M.config()
--   JM.autopairs = {
--     disable_filetype = { "TelescopePrompt", "guihua", "guihua_rust", "clap_input" },
--     map_cr = true,
--     map_complete = vim.bo.filetype ~= "tex",
--     check_ts = true,
--     ts_config = {
--       lua = { "string" },
--       javascript = { "template_string" },
--     },
--   }
-- end

-- function M.setup()
--   M.config()
--   local autopairs = require "nvim-autopairs"
--   local Rule = require "nvim-autopairs.rule"
--   local cond = require "nvim-autopairs.conds"

--   autopairs.setup {
--     check_ts = JM.autopairs.check_ts,
--     ts_config = JM.autopairs.ts_config,
--   }

--   autopairs.add_rule(Rule("$$", "$$", "tex"))
--   autopairs.add_rules {
--     Rule("$", "$", { "tex", "latex" }) -- don't add a pair if the next character is %
--       :with_pair(cond.not_after_regex_check "%%") -- don't add a pair if  the previous character is xxx
--       :with_pair(cond.not_before_regex_check("xxx", 3)) -- don't move right when repeat character
--       :with_move(cond.none()) -- don't delete if the next character is xx
--       :with_del(cond.not_after_regex_check "xx") -- disable  add newline when press <cr>
--       :with_cr(cond.none()),
--   }
--   autopairs.add_rules {
--     Rule("$$", "$$", "tex"):with_pair(function(opts)
--       print(vim.inspect(opts))
--       if opts.line == "aa $$" then
--         -- don't add pair on that line
--         return false
--       end
--     end),
--   }

--   if package.loaded["cmp"] then
--     require("cmp").setup {}
--     -- require("nvim-autopairs.completion.cmp").setup {
--     --   map_cr = true, --  map <CR> on insert mode
--     --   map_complete = true, -- it will auto insert `(` after select function or method item
--     --   auto_select = true, -- automatically select the first item
--     -- }
--   end

--   require("nvim-treesitter.configs").setup { autopairs = { enable = true } }

--   local ts_conds = require "nvim-autopairs.ts-conds"

--   autopairs.add_rules {
--     Rule("%", "%", "lua"):with_pair(ts_conds.is_ts_node { "string", "comment" }),
--     Rule("$", "$", "lua"):with_pair(ts_conds.is_not_ts_node { "function" }),
--   }
-- end

return M
