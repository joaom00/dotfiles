return {
  "akinsho/toggleterm.nvim",
  event = "VeryLazy",
  opts = {
    open_mapping = [[<c-t>]],
    shade_filetypes = { "none" },
    direction = "vertical",
    autochdir = true,
    persist_mode = true,
    insert_mappings = false,
    start_in_insert = true,
    highlights = {
      FloatBorder = { link = "FloatBorder" },
      NormalFloat = { link = "NormalFloat" },
    },
    float_opts = {
      winblend = 3,
    },
    size = function(term)
      if term.direction == "horizontal" then
        return 15
      elseif term.direction == "vertical" then
        return math.floor(vim.o.columns * 0.4)
      end
    end,
  },
  config = function(_, opts)
    require("toggleterm").setup(opts)

    local float_handler = function(term)
      vim.wo.sidescrolloff = 0
      if vim.fn.mapcheck("jk", "t") ~= "" then
        vim.keymap.del("t", "jk", { buffer = term.bufnr })
        vim.keymap.del("t", "<esc>", { buffer = term.bufnr })
      end
    end

    local Terminal = require("toggleterm.terminal").Terminal

    local gh_dash = Terminal:new {
      cmd = "gh dash",
      hidden = true,
      direction = "float",
      on_open = float_handler,
      float_opts = {
        height = function()
          return math.floor(vim.o.lines * 0.8)
        end,
        width = function()
          return math.floor(vim.o.columns * 0.95)
        end,
      },
    }

    map("n", "<leader>gd", function()
      gh_dash:toggle()
    end, {
      desc = "toggleterm: toggle github dashboard",
    })
  end,
}
