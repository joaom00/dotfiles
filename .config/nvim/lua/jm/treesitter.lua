local status_ok, treesitter_configs = pcall(require, "nvim-treesitter.configs")
if not status_ok then
  JM.notify "Failed to load treesitter configs"
  return
end

local M = {}

function M.config()
  treesitter_configs.setup {
    ensure_installed = "maintained",
    highlight = { enable = true },
    indent = { enable = true },
    autotag = { enable = true },
    autopairs = { enable = true },
    context_commentstring = { enable = true, config = { css = "// %s" } },
    rainbow = {
      enable = true,
      colors = {
        "royalblue3",
        "darkorange3",
        "seagreen3",
        "firebrick",
        "darkorchid3",
      },
    },
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
  }
end

function M.setup()
  M.config()
end

return M
