vim.g.rustaceanvim = {
  dap = {
    autoload_configurations = false, -- without this non-cargo projects have issues
  },
  server = {
    load_vscode_settings = false,
    cmd = nil, -- use lspmux
    settings = function(root_dir, default_settings)
      local rust_analyzer_path = vim.fs.joinpath(root_dir, "rust-analyzer.json")
      if vim.fn.filereadable(rust_analyzer_path) == 0 then
        return default_settings
      end
      local lines = vim.fn.readfile(rust_analyzer_path)

      local overrides = vim.json.decode(table.concat(lines, "\n"))
      if type(overrides) ~= "table" then
        return default_settings
      end

      return vim.tbl_deep_extend("force", default_settings, overrides)
    end,
    root_dir = function(fname, default_root_dir)
      local cwd = vim.fn["getcwd"]()
      return cwd
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
}

vim.lsp.enable({ "starpls", "lua", "clangd", "cmake", "bashls", "gopls" })

return {
  {
    "mrcjkb/rustaceanvim",
    version = "^7", -- Recommended
    lazy = false, -- This plugin is already lazy
  },
}
