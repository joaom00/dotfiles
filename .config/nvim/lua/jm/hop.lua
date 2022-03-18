local ok, hop = pcall(require, "hop")
if not ok then
  return
end

local c = require("colorbuddy.color").colors
local Group = require("colorbuddy.group").Group
local s = require("colorbuddy.style").styles

local nnoremap = JM.mapper "n"

-- nnoremap("s", "<cmd>lua require('hop').hint_char1()<CR>")
nnoremap("s", ":HopWord<CR>")
nnoremap("<space><space>", ":HopWord<CR>")

Group.new("HopNextKey", c.pink, nil, s.bold)
Group.new("HopNextKey1", c.cyan:saturate(), nil, s.bold)
Group.new("HopNextKey2", c.cyan:dark(), nil)

hop.setup {
  keys = "asdfqwer;lkjpoiuxcv,mnhytgb",
}
