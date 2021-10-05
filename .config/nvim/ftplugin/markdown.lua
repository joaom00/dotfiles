-- require("lsp").setup "markdown"
require("lsp.null-ls").setup "markdown"
JM.lang.markdown = {
  formatters = {
    {
      exe = "prettier",
    },
  },
  linters = {
    -- {
    --   exe = "markdownlint",
    -- },
  },
}
