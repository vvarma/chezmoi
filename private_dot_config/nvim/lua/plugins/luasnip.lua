return {
  {
    "L3MON4D3/LuaSnip",
    lazy = true,
    config = function()
      require("luasnip.loaders.from_vscode").lazy_load()
      require("luasnip.loaders.from_vscode").lazy_load({ paths = { vim.fn.stdpath("config") .. "/snippets" } })
      local cwd = vim.fn.getcwd()
      local function is_dir(path)
        local stat = vim.loop.fs_stat(path)
        return stat and stat.type == "directory"
      end
      if is_dir(cwd .. "/.snippets") then
        require("luasnip.loaders.from_vscode").lazy_load({ paths = { cwd .. "/.snippets" } })
      end
    end,
    dependencies = {
      "rafamadriz/friendly-snippets",
    },
    opts = {
      history = true,
      delete_check_events = "TextChanged",
      -- Enable autotriggered snippets
      enable_autosnippets = true,

      -- Use Tab (or some other key if you prefer) to trigger visual selection
      store_selection_keys = "<Tab>",
    },
  },
}
