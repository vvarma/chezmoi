return {
  {
    --"mrcjkb/rustaceanvim",
    dir = "~/work/vvarma/lazy-plugins/rustaceanvim/",
    --version = false, -- Recommended
    ft = { "rust" },
    opts = {
      server = {
        load_vscode_settings = false,
        on_attach = function(client, bufnr)
          vim.keymap.set("n", "<leader>cR", function()
            vim.cmd.RustLsp("codeAction")
          end, { desc = "Code Action", buffer = bufnr })
          vim.keymap.set("n", "<leader>dr", function()
            vim.cmd.RustLsp("debuggables")
          end, { desc = "Rust Debuggables", buffer = bufnr })
        end,
        root_dir = function(fname)
          return require("lspconfig.util").root_pattern("Cargo.toml")(fname)
            or require("lspconfig.util").root_pattern("rust-analyzer.json")(fname)
            or require("lspconfig.util").find_git_ancestor(fname)
        end,
        default_settings = {
          -- rust-analyzer language server configuration
          ["rust-analyzer"] = {
            cargo = {
              allFeatures = true,
              loadOutDirsFromCheck = true,
              buildScripts = {
                enable = true,
              },
            },
            -- Add clippy lints for Rust.
            checkOnSave = true,
            procMacro = {
              enable = true,
            },
          },
        },
      },
    },
    config = function(_, opts)
      vim.g.rustaceanvim = vim.tbl_deep_extend("keep", vim.g.rustaceanvim or {}, opts or {})
      if vim.fn.executable("rust-analyzer") == 0 then
        LazyVim.error(
          "**rust-analyzer** not found in PATH, please install it.\nhttps://rust-analyzer.github.io/",
          { title = "rustaceanvim" }
        )
      end
    end,
  },
}
