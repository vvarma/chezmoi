return {
  "neovim/nvim-lspconfig",
  init = function()
    local keys = require("lazyvim.plugins.lsp.keymaps").get()
    keys[#keys + 1] = { "gd", vim.lsp.buf.definition }
  end,
  opts = {
    autoformat = false,
    servers = {
      clangd = {
        filetypes = { "c", "cpp", "objc", "objcpp", "cuda" },
        root_dir = function(fname)
          return require("lspconfig.util").root_pattern(
            "Makefile",
            "configure.ac",
            "configure.in",
            "config.h.in",
            "meson.build",
            "meson_options.txt",
            "build.ninja"
          )(fname) or require("lspconfig.util").root_pattern("compile_commands.json", "compile_flags.txt")(
            fname
          ) or require("lspconfig.util").find_git_ancestor(fname)
        end,
        capabilities = {
          offsetEncoding = { "utf-16" },
        },
        cmd = {
          "clangd",
          "--background-index",
          "--clang-tidy",
          "--header-insertion=iwyu",
          "--completion-style=detailed",
          "--function-arg-placeholders",
          "--fallback-style=llvm",
        },
        init_options = {
          usePlaceholders = true,
          completeUnimported = true,
          clangdFileStatus = true,
        },
      },
      bashls = {},
      --rust_analyzer = {
      --  imports = {
      --    granularity = {
      --      group = "module",
      --    },
      --    prefix = "self",
      --  },
      --  cargo = {
      --    buildScripts = {
      --      enable = true,
      --    },
      --  },
      --  procMacro = {
      --    enable = true,
      --  },
      --},
      cmake = {
        settings = {
          cmake = {
            initializationOptions = {
              buildDirectory = "local_build",
            },
          },
        },
      },
      gopls = {},
    },
    setup = {
      clangd = function(_, opts)
        local clangd_ext_opts = require("lazyvim.util").opts("clangd_extensions.nvim")
        require("clangd_extensions").setup(vim.tbl_deep_extend("force", clangd_ext_opts or {}, { server = opts }))
        return false
      end,
    },
  },
}
