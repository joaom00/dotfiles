return {
  -- FIXME: https://github.com/L3MON4D3/LuaSnip/issues/129
  -- causes formatting bugs on save when update events are TextChanged{I}
  {
    "L3MON4D3/LuaSnip",
    event = "InsertEnter",
    build = "make install_jsregexp",
    dependencies = { "rafamadriz/friendly-snippets" },
    config = function()
      local ls = require "luasnip"
      local types = require "luasnip.util.types"
      local extras = require "luasnip.extras"
      local fmt = require("luasnip.extras.fmt").fmt
      local t = ls.text_node
      local require_var = function(args, _)
        local text = args[1][1] or ""

        text = text:gsub("^%l", string.upper)

        return ls.sn(nil, {
          t(text),
        })
      end

      ls.config.set_config {
        history = true,
        updateevents = "TextChanged,TextChangedI",
        region_check_events = "CursorMoved,CursorHold,InsertEnter",
        delete_check_events = "InsertLeave",
        ext_opts = {
          [types.choiceNode] = {
            active = {
              hl_mode = "combine",
              virt_text = { { "●", "Operator" } },
            },
          },
          [types.insertNode] = {
            active = {
              hl_mode = "combine",
              virt_text = { { "●", "Type" } },
            },
          },
        },
        enable_autosnippets = true,
        snip_env = {
          fmt = fmt,
          m = extras.match,
          t = t,
          f = ls.function_node,
          c = ls.choice_node,
          d = ls.dynamic_node,
          i = ls.insert_node,
          l = extras.lamda,
          snippet = ls.snippet,
          require_var = require_var,
        },
      }

      jm.command("LuaSnipEdit", function()
        require("luasnip.loaders.from_lua").edit_snippet_files()
      end)

      -- vim.keymap.set({ "i", "s" }, "<c-k>", function()
      --   if ls.expand_or_jumpable() then
      --     ls.expand_or_jump()
      --   end
      -- end, {
      --   silent = true,
      -- })
      -- map({ "s", "i" }, "<c-k>", function()
      --   if not ls.expand_or_jumpable() then
      --     return "<Tab>"
      --   end
      --   ls.expand_or_jump()
      -- end, { expr = true })
      --
      -- vim.keymap.set({ "i", "s" }, "<c-j>", function()
      --   if ls.jumpable(-1) then
      --     ls.jump(-1)
      --   end
      -- end, {
      --   silent = true,
      -- })
      --
      -- vim.keymap.set({ "i", "s" }, "<c-l>", function()
      --   if ls.choice_active() then
      --     ls.change_choice(1)
      --   end
      -- end, {
      --   silent = true,
      -- })
      --
      -- vim.keymap.set("i", "<c-u>", require "luasnip.extras.select_choice")

      -- <c-l> is selecting within a list of options.
      map({ "s", "i" }, "<c-l>", function()
        if ls.choice_active() then
          ls.change_choice(1)
        end
      end)

      map({ "s", "i" }, "<c-k>", function()
        if not ls.expand_or_jumpable() then
          return "<Tab>"
        end
        ls.expand_or_jump()
      end, { expr = true })

      -- <C-K> is easier to hit but swallows the digraph key
      map({ "s", "i" }, "<c-j>", function()
        if not ls.jumpable(-1) then
          return "<S-Tab>"
        end
        ls.jump(-1)
      end, { expr = true })

      require("luasnip.loaders.from_lua").lazy_load()

      ls.filetype_extend("typescriptreact", { "javascript", "typescript" })
      ls.filetype_extend("NeogitCommitMessage", { "gitcommit" })
    end,
  },
  {
    "benfowler/telescope-luasnip.nvim",
    dependencies = { "nvim-telescope/telescope.nvim" },
    config = function()
      require("telescope").load_extension "luasnip"
    end,
  },
}
