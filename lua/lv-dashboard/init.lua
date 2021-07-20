local M = {}

M.config = function()
  vim.g.dashboard_default_executive = 'telescope'

  vim.g.dashboard_custom_section = {
    a = {description = {'  Find File             '}, command = ':lua require"lv-telescope".search_all_files()'},
    b = {description = {'  Recently Used Files   '}, command = 'Telescope oldfiles'},
    c = {description = {'  Projects              '}, command = ':lua require("lv-telescope").project()'},
    d = {description = {'  Find Word             '}, command = ':lua require"lv-telescope".live_grep()'},
    e = {description = {'  Neovim Configurations '}, command = ':lua require("lv-telescope").edit_neovim()'},
    f = {description = {'  ColorScheme           '}, command = ':Telescope colorscheme'}
  }

  vim.g.dashboard_custom_header = {
    [[███████ ██   ██  █████  ██      ██          ██     ██ ███████     ██████  ██       █████  ██    ██      █████       ██████   █████  ███    ███ ███████ ██████  ]],
    [[██      ██   ██ ██   ██ ██      ██          ██     ██ ██          ██   ██ ██      ██   ██  ██  ██      ██   ██     ██       ██   ██ ████  ████ ██           ██ ]],
    [[███████ ███████ ███████ ██      ██          ██  █  ██ █████       ██████  ██      ███████   ████       ███████     ██   ███ ███████ ██ ████ ██ █████     ▄███  ]],
    [[     ██ ██   ██ ██   ██ ██      ██          ██ ███ ██ ██          ██      ██      ██   ██    ██        ██   ██     ██    ██ ██   ██ ██  ██  ██ ██        ▀▀    ]],
    [[███████ ██   ██ ██   ██ ███████ ███████      ███ ███  ███████     ██      ███████ ██   ██    ██        ██   ██      ██████  ██   ██ ██      ██ ███████   ██    ]]
  }

end

return M

