local M = {}

function M.config()
  require("nvim-treesitter.configs").setup {
    ensure_installed = "all",
    ignore_install = { "haskell" },
    matchup = { enable = true },
    highlight = { enable = true, additional_vim_regex_highlighting = true, disable = { "latex" } },
    context_commentstring = { enable = false, config = { css = "// %s" } },
    indent = { enable = { "javascriptreact" } },
    autotag = { enable = true },

    playground = {
      enable = true,
      disable = {},
      updatetime = 25,
      persist_queries = false,
      keybindings = {
        toggle_query_editor = "o",
        toggle_hl_groups = "i",
        toggle_injected_languages = "t",
        toggle_anonymous_nodes = "a",
        toggle_language_display = "I",
        focus_language = "f",
        unfocus_language = "F",
        update = "R",
        goto_node = "<cr>",
        show_help = "?",
      },
    },
    rainbow = { enable = true, extended_mode = true, max_file_lines = 1000 },
  }
end

function M.setup()
  M.config()
end

return M
