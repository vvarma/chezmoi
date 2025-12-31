return {
  {
    "hrsh7th/nvim-cmp",
    event = { "InsertEnter", "CmdlineEnter" },
    opts = {
      sources = {
        { name = "supermaven" },
        { name = "nvim_lsp" },
        { name = "path" },
      },
      experimental = {
        ghost_text = true,
      },
    },
  },
}
