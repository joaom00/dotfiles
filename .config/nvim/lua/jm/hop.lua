local ok, hop = pcall(require, "hop")
if not ok then
  return
end

local nnoremap = JM.mapper "n"

-- nnoremap("s", "<cmd>lua require('hop').hint_char1()<CR>")
nnoremap("s", ":HopWord<CR>")
nnoremap("<space><space>", ":HopWord<CR>")

hop.setup {
  keys = "asdfqwer;lkjpoiuxcv,mnhytgb",
}
