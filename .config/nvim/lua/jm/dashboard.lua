local M = {}

function M.config()
  JM.dashboard = {
    default_execute = "telescope",
    custom_header = {
      [[███████ ██   ██  █████  ██      ██          ██     ██ ███████     ██████  ██       █████  ██    ██      █████       ██████   █████  ███    ███ ███████ ██████  ]],
      [[██      ██   ██ ██   ██ ██      ██          ██     ██ ██          ██   ██ ██      ██   ██  ██  ██      ██   ██     ██       ██   ██ ████  ████ ██           ██ ]],
      [[███████ ███████ ███████ ██      ██          ██  █  ██ █████       ██████  ██      ███████   ████       ███████     ██   ███ ███████ ██ ████ ██ █████     ▄███  ]],
      [[     ██ ██   ██ ██   ██ ██      ██          ██ ███ ██ ██          ██      ██      ██   ██    ██        ██   ██     ██    ██ ██   ██ ██  ██  ██ ██        ▀▀    ]],
      [[███████ ██   ██ ██   ██ ███████ ███████      ███ ███  ███████     ██      ███████ ██   ██    ██        ██   ██      ██████  ██   ██ ██      ██ ███████   ██    ]],
    },
    custom_section = {
      a = { description = { "  Find File     " }, command = "lua require('jm.telescope').search_all_files()" },
      b = { description = { "  Recents       " }, command = "Telescope oldfiles" },
      c = { description = { "  Projects      " }, command = "lua require('jm.telescope').project()" },
      d = { description = { "  Find Word     " }, command = "lua require('jm.telescope').live_grep()" },
      e = { description = { "  Neovim Files  " }, command = "lua require('jm.telescope').edit_neovim()" },
      f = { description = { "  Colorscheme   " }, command = "Telescope colorscheme" },
    },
  }
end

function M.setup()
  M.config()
  for k, v in pairs(JM.dashboard) do
    vim.g["dashboard_" .. k] = v
  end
end

return M
