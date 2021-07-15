local M = {}

M.config = function()
  vim.g.dashboard_default_executive = 'telescope'

  vim.g.dashboard_custom_section = {
    a = {description = {'  Find File             '}, command = 'Telescope find_files'},
    b = {description = {'  Recently Used Files   '}, command = 'Telescope oldfiles'},
    c = {description = {'  Load Last Session     '}, command = 'SessionLoad'},
    d = {description = {'  Projects              '}, command = ':lua require("lv-telescope").project()'},
    e = {description = {'  Find Word             '}, command = 'Telescope live_grep'},
    f = {description = {'  Neovim Configurations '}, command = ':lua require("lv-telescope").edit_neovim()'}
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

