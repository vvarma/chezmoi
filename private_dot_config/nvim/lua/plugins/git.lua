return {
  { -- Adds git related signs to the gutter, as well as utilities for managing changes
    "lewis6991/gitsigns.nvim",
    opts = {
      auto_attach = false,
      signs = {
        add = { text = "+" },
        change = { text = "~" },
        delete = { text = "_" },
        topdelete = { text = "‾" },
        changedelete = { text = "~" },
      },
    },
    config = function(_, opts)
      require("gitsigns").setup(opts)

      local gitsigns = require("gitsigns")
      local group = vim.api.nvim_create_augroup("user_gitsigns_attach", { clear = true })

      local function attach(bufnr, trigger)
        if vim.api.nvim_buf_get_name(bufnr) == "" then
          return
        end

        gitsigns.attach(bufnr, nil, trigger)
      end

      vim.api.nvim_create_autocmd({ "BufFilePost", "BufRead", "BufWritePost" }, {
        group = group,
        desc = "User: gitsigns attach after file exists",
        callback = function(args)
          attach(args.buf, args.event)
        end,
      })

      for _, buf in ipairs(vim.api.nvim_list_bufs()) do
        if vim.api.nvim_buf_is_loaded(buf) then
          attach(buf, "setup")
        end
      end
    end,
  },
  -- nvim v0.8.0
  {
    "kdheepak/lazygit.nvim",
    lazy = true,
    cmd = {
      "LazyGit",
      "LazyGitConfig",
      "LazyGitCurrentFile",
      "LazyGitFilter",
      "LazyGitFilterCurrentFile",
    },
    -- optional for floating window border decoration
    dependencies = {
      "nvim-lua/plenary.nvim",
    },
    -- setting the keybinding for LazyGit with 'keys' is recommended in
    -- order to load the plugin when the command is run for the first time
    keys = {
      { "<leader>lg", "<cmd>LazyGit<cr>", desc = "LazyGit" },
    },
  },
}
