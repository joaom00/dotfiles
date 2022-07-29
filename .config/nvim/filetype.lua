if not vim.filetype then
  return
end

vim.filetype.add {
  pattern = {
    ["*.env.*"] = "lua",
  },
}
