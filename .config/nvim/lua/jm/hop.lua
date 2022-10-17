local ok, hop = pcall(require, "hop")
if not ok then
  return
end

JM.nnoremap("s", ":HopChar1<CR>")
-- JM.nnoremap("s", ":HopWord<CR>")
JM.nnoremap("<space><space>", ":HopWord<CR>")

hop.setup {
  keys = "asdfqwer;lkjpoiuxcv,mnhytgb",
}
