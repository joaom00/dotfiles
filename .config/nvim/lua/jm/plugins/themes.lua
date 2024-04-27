return {
  { "akinsho/horizon.nvim", lazy = false, priority = 1000 },
  { "arzg/vim-colors-xcode", lazy = false },
  {
    "jesseleite/nvim-noirbuddy",
    lazy = false,
    dependencies = { "tjdevries/colorbuddy.nvim", branch = "dev" },
  },
  {
    "sainnhe/gruvbox-material",
    lazy = false,
    priority = 1000,
    config = function()
      vim.o.background = "dark"
      vim.g.gruvbox_material_background = "hard"
      -- vim.g.gruvbox_material_transparent_background = 1
      vim.cmd.colorscheme "gruvbox-material"
    end,
  },
  { "projekt0n/github-nvim-theme", lazy = false, priority = 1000 },
}
