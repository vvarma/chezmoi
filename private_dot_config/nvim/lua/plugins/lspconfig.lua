vim.g.rustaceanvim = {
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

return {
  {
    "mrcjkb/rustaceanvim",
    version = "^7", -- Recommended
    lazy = false, -- This plugin is already lazy
  },
  --{
  --  "neovim/nvim-lspconfig",
  --  dependencies = {
  --    "saghen/blink.cmp",
  --    "mason.nvim",
  --    { "mason-org/mason-lspconfig.nvim", config = function() end },
  --  },

  --  -- example using `opts` for defining servers
  --  opts = {
  --    diagnostics = {
  --      underline = true,
  --      update_in_insert = false,
  --      virtual_text = true,
  --      --virtual_text = {
  --      --  spacing = 4,
  --      --  source = "if_many",
  --      --  prefix = "●",
  --      --  -- this will set set the prefix to a function that returns the diagnostics icon based on the severity
  --      --  -- prefix = "icons",
  --      --},
  --      severity_sort = true,
  --      signs = {
  --        text = {
  --          [vim.diagnostic.severity.ERROR] = "E",
  --          [vim.diagnostic.severity.WARN] = "W",
  --          [vim.diagnostic.severity.HINT] = "H",
  --          [vim.diagnostic.severity.INFO] = "I",
  --        },
  --      },
  --    },
  --    -- Enable this to enable the builtin LSP inlay hints on Neovim.
  --    -- Be aware that you also will need to properly configure your LSP server to
  --    -- provide the inlay hints.
  --    inlay_hints = {
  --      enabled = true,
  --      exclude = { "vue" }, -- filetypes for which you don't want to enable inlay hints
  --    },
  --    -- Enable this to enable the builtin LSP code lenses on Neovim.
  --    -- Be aware that you also will need to properly configure your LSP server to
  --    -- provide the code lenses.
  --    codelens = {
  --      enabled = false,
  --    },
  --    -- Enable this to enable the builtin LSP folding on Neovim.
  --    -- Be aware that you also will need to properly configure your LSP server to
  --    -- provide the folds.
  --    folds = {
  --      enabled = true,
  --    },
  --    -- options for vim.lsp.buf.format
  --    -- but can be also overridden when specified
  --    format = {
  --      formatting_options = nil,
  --      timeout_ms = nil,
  --    },
  --    servers = {
  --      ["*"] = {
  --        capabilities = {
  --          workspace = {
  --            fileOperations = {
  --              didRename = true,
  --              willRename = true,
  --            },
  --          },
  --        },
  --          -- stylua: ignore
  --          keys = {
  --            { "<leader>cl", function() Snacks.picker.lsp_config() end, desc = "Lsp Info" },
  --            { "gd", vim.lsp.buf.definition, desc = "Goto Definition", has = "definition" },
  --            { "gr", vim.lsp.buf.references, desc = "References", nowait = true },
  --            { "gI", vim.lsp.buf.implementation, desc = "Goto Implementation" },
  --            { "gy", vim.lsp.buf.type_definition, desc = "Goto T[y]pe Definition" },
  --            { "gD", vim.lsp.buf.declaration, desc = "Goto Declaration" },
  --            { "K", function() return vim.lsp.buf.hover() end, desc = "Hover" },
  --            { "gK", function() return vim.lsp.buf.signature_help() end, desc = "Signature Help", has = "signatureHelp" },
  --            { "<c-k>", function() return vim.lsp.buf.signature_help() end, mode = "i", desc = "Signature Help", has = "signatureHelp" },
  --            { "<leader>ca", vim.lsp.buf.code_action, desc = "Code Action", mode = { "n", "x" }, has = "codeAction" },
  --            { "<leader>cc", vim.lsp.codelens.run, desc = "Run Codelens", mode = { "n", "x" }, has = "codeLens" },
  --            { "<leader>cC", vim.lsp.codelens.refresh, desc = "Refresh & Display Codelens", mode = { "n" }, has = "codeLens" },
  --            { "<leader>cR", function() Snacks.rename.rename_file() end, desc = "Rename File", mode ={"n"}, has = { "workspace/didRenameFiles", "workspace/willRenameFiles" } },
  --            { "<leader>cr", vim.lsp.buf.rename, desc = "Rename", has = "rename" },
  --            -- { "<leader>cA", LazyVim.lsp.action.source, desc = "Source Action", has = "codeAction" },
  --            { "]]", function() Snacks.words.jump(vim.v.count1) end, has = "documentHighlight",
  --              desc = "Next Reference", enabled = function() return Snacks.words.is_enabled() end },
  --            { "[[", function() Snacks.words.jump(-vim.v.count1) end, has = "documentHighlight",
  --              desc = "Prev Reference", enabled = function() return Snacks.words.is_enabled() end },
  --            { "<a-n>", function() Snacks.words.jump(vim.v.count1, true) end, has = "documentHighlight",
  --              desc = "Next Reference", enabled = function() return Snacks.words.is_enabled() end },
  --            { "<a-p>", function() Snacks.words.jump(-vim.v.count1, true) end, has = "documentHighlight",
  --              desc = "Prev Reference", enabled = function() return Snacks.words.is_enabled() end },
  --          },
  --      },
  --      rust_analyzer = {
  --        enabled = true,
  --        cmd = vim.lsp.rpc.connect("127.0.0.1", 27631),
  --        settings = load_project_rust_analyzer_settings(),
  --      },
  --      starpls = {},
  --      lua_ls = {
  --        -- mason = false, -- set to false if you don't want this server to be installed with mason
  --        -- Use this to add any additional keymaps
  --        -- for specific lsp servers
  --        -- ---@type LazyKeysSpec[]
  --        -- keys = {},
  --        settings = {
  --          Lua = {
  --            workspace = {
  --              checkThirdParty = false,
  --            },
  --            codeLens = {
  --              enable = true,
  --            },
  --            completion = {
  --              callSnippet = "Replace",
  --            },
  --            doc = {
  --              privateName = { "^_" },
  --            },
  --            hint = {
  --              enable = true,
  --              setType = false,
  --              paramType = true,
  --              paramName = "Disable",
  --              semicolon = "Disable",
  --              arrayIndex = "Disable",
  --            },
  --          },
  --        },
  --      },
  --      clangd = {
  --        filetypes = { "c", "cpp", "objc", "objcpp", "cuda" },
  --        root_dir = function(fname)
  --          return require("lspconfig.util").root_pattern(
  --            "Makefile",
  --            "configure.ac",
  --            "configure.in",
  --            "config.h.in",
  --            "meson.build",
  --            "meson_options.txt",
  --            "build.ninja"
  --          )(fname) or require("lspconfig.util").root_pattern("compile_commands.json", "compile_flags.txt")(
  --            fname
  --          ) or require("lspconfig.util").find_git_ancestor(fname)
  --        end,
  --        capabilities = {
  --          offsetEncoding = { "utf-16" },
  --        },
  --        cmd = {
  --          "clangd",
  --          "--background-index",
  --          "--clang-tidy",
  --          "--header-insertion=iwyu",
  --          "--completion-style=detailed",
  --          "--function-arg-placeholders",
  --          "--fallback-style=llvm",
  --        },
  --        init_options = {
  --          usePlaceholders = true,
  --          completeUnimported = true,
  --          clangdFileStatus = true,
  --        },
  --      },
  --      bashls = {},
  --      cmake = {
  --        settings = {
  --          cmake = {
  --            initializationOptions = {
  --              buildDirectory = "local_build",
  --            },
  --          },
  --        },
  --      },
  --      gopls = {},
  --    },
  --  },
  --  config = function(_, opts)
  --    local lspconfig = require("lspconfig")
  --    for server, config in pairs(opts.servers) do
  --      -- passing config.capabilities to blink.cmp merges with the capabilities in your
  --      -- `opts[server].capabilities, if you've defined it
  --      config.capabilities = require("blink.cmp").get_lsp_capabilities(config.capabilities)
  --      lspconfig[server].setup(config)
  --    end
  --    if opts.inlay_hints.enabled then
  --      Snacks.util.lsp.on({ method = "textDocument/inlayHint" }, function(buffer)
  --        if
  --          vim.api.nvim_buf_is_valid(buffer)
  --          and vim.bo[buffer].buftype == ""
  --          and not vim.tbl_contains(opts.inlay_hints.exclude, vim.bo[buffer].filetype)
  --        then
  --          vim.lsp.inlay_hint.enable(true, { bufnr = buffer })
  --        end
  --      end)
  --    end
  --  end,
  --},
  --{
  --  "vxpm/ferris.nvim",
  --  opts = {
  --    -- your options here
  --  },
  --},
}
