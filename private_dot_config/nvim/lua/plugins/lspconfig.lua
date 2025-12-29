return {
	{
		"neovim/nvim-lspconfig",
		-- event = "LazyFile",
		lazy = true,
		dependencies = {
			"mason.nvim",
			{ "mason-org/mason-lspconfig.nvim", config = function() end },
		},
		opts_extend = { "servers.*.keys" },
		opts = function()
			---@class PluginLspOpts
			local ret = {
				-- options for vim.diagnostic.config()
				---@type vim.diagnostic.Opts
				diagnostics = {
					underline = true,
					update_in_insert = false,
					virtual_text = {
						spacing = 4,
						source = "if_many",
						prefix = "●",
						-- this will set set the prefix to a function that returns the diagnostics icon based on the severity
						-- prefix = "icons",
					},
					severity_sort = true,
					signs = {
						text = {
							[vim.diagnostic.severity.ERROR] = "E",
							[vim.diagnostic.severity.WARN] = "W",
							[vim.diagnostic.severity.HINT] = "H",
							[vim.diagnostic.severity.INFO] = "I",
						},
					},
				},
				-- Enable this to enable the builtin LSP inlay hints on Neovim.
				-- Be aware that you also will need to properly configure your LSP server to
				-- provide the inlay hints.
				inlay_hints = {
					enabled = true,
					exclude = { "vue" }, -- filetypes for which you don't want to enable inlay hints
				},
				-- Enable this to enable the builtin LSP code lenses on Neovim.
				-- Be aware that you also will need to properly configure your LSP server to
				-- provide the code lenses.
				codelens = {
					enabled = false,
				},
				-- Enable this to enable the builtin LSP folding on Neovim.
				-- Be aware that you also will need to properly configure your LSP server to
				-- provide the folds.
				folds = {
					enabled = true,
				},
				-- options for vim.lsp.buf.format
				-- but can be also overridden when specified
				format = {
					formatting_options = nil,
					timeout_ms = nil,
				},
				-- LSP Server Settings
				-- Sets the default configuration for an LSP client (or all clients if the special name "*" is used).
				servers = {
					-- configuration for all lsp servers
					stylua = { enabled = false },
					lua_ls = {
						-- mason = false, -- set to false if you don't want this server to be installed with mason
						-- Use this to add any additional keymaps
						-- for specific lsp servers
						-- ---@type LazyKeysSpec[]
						-- keys = {},
						settings = {
							Lua = {
								workspace = {
									checkThirdParty = false,
								},
								codeLens = {
									enable = true,
								},
								completion = {
									callSnippet = "Replace",
								},
								doc = {
									privateName = { "^_" },
								},
								hint = {
									enable = true,
									setType = false,
									paramType = true,
									paramName = "Disable",
									semicolon = "Disable",
									arrayIndex = "Disable",
								},
							},
						},
					},
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
							)(fname) or require("lspconfig.util").root_pattern(
								"compile_commands.json",
								"compile_flags.txt"
							)(fname) or require("lspconfig.util").find_git_ancestor(fname)
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
				-- you can do any additional lsp server setup here
				-- return true if you don't want this server to be setup with lspconfig
				---@type table<string, fun(server:string, opts: vim.lsp.Config):boolean?>
				setup = {
					-- example to setup with typescript.nvim
					-- tsserver = function(_, opts)
					--   require("typescript").setup({ server = opts })
					--   return true
					-- end,
					-- Specify * to use this function as a fallback for any server
					-- ["*"] = function(server, opts) end,
				},
			}
			return ret
		end,
		---@param opts PluginLspOpts
		config = vim.schedule_wrap(function(_, opts)
			-- code lens
			if opts.codelens.enabled and vim.lsp.codelens then
				Snacks.util.lsp.on({ method = "textDocument/codeLens" }, function(buffer)
					vim.lsp.codelens.refresh()
					vim.api.nvim_create_autocmd({ "BufEnter", "CursorHold", "InsertLeave" }, {
						buffer = buffer,
						callback = vim.lsp.codelens.refresh,
					})
				end)
			end

			-- diagnostics
			if type(opts.diagnostics.virtual_text) == "table" and opts.diagnostics.virtual_text.prefix == "icons" then
				opts.diagnostics.virtual_text.prefix = function(diagnostic)
					local icons = require("config.icons").icons.diagnostics
					for d, icon in pairs(icons) do
						if diagnostic.severity == vim.diagnostic.severity[d:upper()] then
							return icon
						end
					end
					return "●"
				end
			end
			vim.diagnostic.config(vim.deepcopy(opts.diagnostics))

			if opts.capabilities then
				opts.servers["*"] = vim.tbl_deep_extend("force", opts.servers["*"] or {}, {
					capabilities = opts.capabilities,
				})
			end

			if opts.servers["*"] then
				vim.lsp.config("*", opts.servers["*"])
			end

			-- get all the servers that are available through mason-lspconfig
			local mason_all = vim.tbl_keys(require("mason-lspconfig.mappings").get_mason_map().lspconfig_to_package)
				or {} --[[ @as string[] ]]
			local mason_exclude = {} ---@type string[]

			---@return boolean? exclude automatic setup
			local function configure(server)
				if server == "*" then
					return false
				end
				local sopts = opts.servers[server]
				sopts = sopts == true and {} or (not sopts) and { enabled = false } or sopts

				if sopts.enabled == false then
					mason_exclude[#mason_exclude + 1] = server
					return
				end

				local use_mason = sopts.mason ~= false and vim.tbl_contains(mason_all, server)
				local setup = opts.setup[server] or opts.setup["*"]
				if setup and setup(server, sopts) then
					mason_exclude[#mason_exclude + 1] = server
				else
					vim.lsp.config(server, sopts) -- configure the server
					if not use_mason then
						vim.lsp.enable(server)
					end
				end
				return use_mason
			end

			local install = vim.tbl_filter(configure, vim.tbl_keys(opts.servers))
			if have_mason then
				require("mason-lspconfig").setup({
					ensure_installed = install,
					automatic_enable = { exclude = mason_exclude },
				})
			end
		end),
	},
}
