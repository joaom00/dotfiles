local servers = {
  vimls = {},
  cssls = {},
  tailwindcss = {
    settings = {
      tailwindCSS = {
        experimental = {
          classRegex = {
            "tv\\(([^)]*)\\)",
            "[\"'`]([^\"'`]*).*?[\"'`]",
            -- "cva\\(([^)]*)\\)",
            -- "[\"'`]([^\"'`]*).*?[\"'`]",
            -- "cx\\(([^)]*)\\)",
            -- "(?:'|\"|`)([^']*)(?:'|\"|`)",
            -- "tv\\(([^)]*)\\)",
            -- "[\"'`]([^\"'`]*).*?[\"'`]",
          },
        },
      },
    },
  },
  intelephense = {},
  prismals = {},
  gopls = {},
  rust_analyzer = {},
  emmet_language_server = {},
  jsonls = {
    settings = {
      json = {
        schemas = require("schemastore").json.schemas(),
        validate = { enable = true },
      },
    },
  },
  lua_ls = function()
    return {
      settings = {
        Lua = {
          hint = { enable = true, arrayIndex = "Disable", setType = true },
          format = { enable = false },
          diagnostics = {
            globals = {
              "vim",
              "P",
              "describe",
              "it",
              "before_each",
              "after_each",
              "packer_plugins",
              "pending",
            },
          },
          completion = { keywordSnippet = "Replace", callSnippet = "Replace" },
          workspace = { checkThirdParty = false },
          telemetry = { enable = false },
        },
      },
    }
  end,
}

return function(name)
  local config = name and servers[name] or {}
  if not config then
    return
  end
  if type(config) == "function" then
    config = config()
  end
  local ok, cmp_nvim_lsp = jm.require "cmp_nvim_lsp"
  if ok then
    config.capabilities = cmp_nvim_lsp.default_capabilities()
  end
  config.capabilities = vim.tbl_deep_extend("keep", config.capabilities or {}, {
    workspace = { didChangeWatchedFiles = { dynamicRegistration = true } },
    textDocument = { foldingRange = { dynamicRegistration = false, lineFoldingOnly = true } },
  })
  return config
end
