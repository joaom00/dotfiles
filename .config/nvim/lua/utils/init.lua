local utils = {}

function utils.toggle_autoformat()
  if JM.format_on_save then
    require("jm.autocmds").define_augroups {
      autoformat = { { "BufWritePre", "*", ":silent lua vim.lsp.buf.formatting_sync({}, 1000)" } },
    }
  end

  if not JM.format_on_save then
    vim.cmd [[
      if exists('#autoformat#BufWritePre')
        :autocmd! autoformat
      endif
    ]]
    JM.notify("Format on save off", "info", "Utils")
  end
end

return utils
