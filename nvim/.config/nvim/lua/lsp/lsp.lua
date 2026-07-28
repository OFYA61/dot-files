vim.pack.add({
	{ src = "https://github.com/neovim/nvim-lspconfig" },
	{ src = "https://github.com/mason-org/mason.nvim" },
	{ src = "https://github.com/mason-org/mason-lspconfig.nvim" },
	{ src = "https://github.com/WhoIsSethDaniel/mason-tool-installer.nvim" },
	{ src = "https://github.com/j-hui/fidget.nvim" },
	{ src = "https://github.com/saghen/blink.cmp" },
})

-- Settings for all the servers
local servers = {
	clangd = {},
	rust_analyzer = {
		settings = {
			["rust-analyzer"] = {
				cargo = {
					extraEnv = {
						PKG_CONFIG_PATH = vim.fn.expand("~/.local/lib/pkgconfig:/usr/local/lib/pkgconfig")
							.. ":"
							.. (os.getenv("PKG_CONFIG_PATH") or ""),
						LD_LIBRARY_PATH = vim.fn.expand("~/.local/lib:/usr/local/lib:$LD_LIBRARY_PATH")
							.. ":"
							.. (os.getenv("LD_LIBRARY_PATH") or ""),
					},
				},
				imports = {
					granularity = {
						group = "item",
						enforce = true,
					},
					prefix = "self",
					merge = {
						glob = false,
					},
				},
			},
		},
	},
	pyright = {},
	ts_ls = {},
	lua_ls = {
		settings = {
			Lua = {
				completion = {
					callSnippet = "Replace",
				},
				runtime = {
					version = "LuaJIT",
				},
				diagnostics = {
					globals = {
						"vim",
						"require",
					},
				},
				workspace = {
					library = vim.api.nvim_get_runtime_file("", true),
				},
				telemetry = {
					enable = false,
				},
			},
		},
	},
	zls = {
		enable_build_on_save = true,
		settings = {
			zls = {
				zig_exe_path = "/home/hamza/src/software/zig-x86_64-linux-0.16.0/zig",
			},
		},
	},
}

local ensure_installed = vim.tbl_keys(servers or {})
vim.list_extend(ensure_installed, {
	"stylua", -- Used to format Lua code
})

require("mason").setup()
require("mason-lspconfig").setup()
require("mason-tool-installer").setup({
	ensure_installed = ensure_installed,
})
require("fidget").setup({})

--  LSP servers and clients are able to communicate to each other what features they support.
--  By default, Neovim doesn't support everything that is in the LSP specification.
--  When you add blink.cmp, luasnip, etc. Neovim now has *more* capabilities.
--  So, we create new capabilities with blink.cmp, and then broadcast that to the servers.
local capabilities = require("blink.cmp").get_lsp_capabilities()

-- Setup all the desired servers
for server_name, server_config in pairs(servers) do
	server_config.capabilities = vim.tbl_deep_extend("force", {}, capabilities, server_config.capabilities or {})
	vim.lsp.enable(server_name)
	vim.lsp.config(server_name, server_config)
end

-- LSP hotkeys
vim.api.nvim_create_autocmd("LspAttach", {
	group = vim.api.nvim_create_augroup("setup-lsp-attach", { clear = true }),
	callback = function(event)
		local telescope_builtin = require("telescope.builtin")
		local map = function(keys, func, desc, mode)
			mode = mode or "n"
			vim.keymap.set(mode, keys, func, { buffer = event.buf, desc = "LSP: " .. desc })
		end

		map("<leader>rn", vim.lsp.buf.rename, "[R]e[n]ame")
		map("<leader>ca", vim.lsp.buf.code_action, "[C]ode [A]ction")
		map("<leader>lr", "<cmd>lua require('telescope.builtin').lsp_references({})<CR>", "[L]ist [R]eferences")
		map("K", vim.lsp.buf.hover, "Hover Documentation")
		map("<C-k>", vim.lsp.buf.signature_help, "Signature Documentation")

		map(",e", function()
			vim.diagnostic.jump({ count = -1, float = true })
		end, "Previous diagnostic")
		map(".e", function()
			vim.diagnostic.jump({ count = 1, float = true })
		end, "Next diagnostic")
		map("<leader>od", vim.diagnostic.open_float, "[O]pen [D]iagnostic")

		map("gd", telescope_builtin.lsp_definitions, "[G]oto [D]efinition")
		map("gr", telescope_builtin.lsp_references, "[G]oto [R]eferences")
		map("gI", telescope_builtin.lsp_implementations, "[G]oto [I]mplementation")

		map("<leader>D", telescope_builtin.lsp_type_definitions, "Type [D]efinition")
		map("<leader>ds", telescope_builtin.lsp_document_symbols, "[D]ocument [S]ymbols")
		map("<leader>ws", telescope_builtin.lsp_dynamic_workspace_symbols, "[W]orkspace [S]ymbols")

		map("gD", vim.lsp.buf.declaration, "[G]oto [D]eclaration")
		map("<leader>wa", vim.lsp.buf.add_workspace_folder, "[W]orkspace [A]dd Folder")
		map("<leader>wr", vim.lsp.buf.remove_workspace_folder, "[W]orkspace [R]emove Folder")
		map("<leader>wl", function()
			print(vim.inspect(vim.lsp.buf.list_workspace_folders()))
		end, "[W]orkspace [L]ist Folders")

		-- Create command `:Fmt` local to the LSP buffer
		-- vim.api.nvim_buf_create_user_command(bufnr, "Fmt", function(_)
		-- 	vim.lsp.buf.format({ async = true })
		-- end, { desc = "[F]or[m]a[t] current buffer with LSP" })

		-- This function resolves a difference between neovim nightly (version 0.11) and stable (version 0.10)
		---@param client vim.lsp.Client
		---@param method vim.lsp.protocol.Method
		---@param bufnr? integer some lsp support methods only in specific files
		---@return boolean
		local function client_supports_method(client, method, bufnr)
			if vim.fn.has("nvim-0.11") == 1 then
				return client:supports_method(method, bufnr)
			else
				return client.supports_method(method, { bufnr = bufnr })
			end
		end

		-- The following two autocommands are used to highlight references of the
		-- word under your cursor when your cursor rests there for a little while.
		--    See `:help CursorHold` for information about when this is executed
		--
		-- When you move your cursor, the highlights will be cleared (the second autocommand).
		local client = vim.lsp.get_client_by_id(event.data.client_id)
		if
			client
			and client_supports_method(client, vim.lsp.protocol.Methods.textDocument_documentHighlight, event.buf)
		then
			local highlight_augroup = vim.api.nvim_create_augroup("setup-lsp-highlight", { clear = false })
			vim.api.nvim_create_autocmd({ "CursorHold", "CursorHoldI" }, {
				buffer = event.buf,
				group = highlight_augroup,
				callback = vim.lsp.buf.document_highlight,
			})

			vim.api.nvim_create_autocmd({ "CursorMoved", "CursorMovedI" }, {
				buffer = event.buf,
				group = highlight_augroup,
				callback = vim.lsp.buf.clear_references,
			})

			vim.api.nvim_create_autocmd("LspDetach", {
				group = vim.api.nvim_create_augroup("setup-lsp-detach", { clear = true }),
				callback = function(event2)
					vim.lsp.buf.clear_references()
					vim.api.nvim_clear_autocmds({ group = "setup-lsp-highlight", buffer = event2.buf })
				end,
			})
		end

		-- The following code creates a keymap to toggle inlay hints in your
		-- code, if the language server you are using supports them
		--
		-- This may be unwanted, since they displace some of your code
		if client and client_supports_method(client, vim.lsp.protocol.Methods.textDocument_inlayHint, event.buf) then
			map("<leader>th", function()
				vim.lsp.inlay_hint.enable(not vim.lsp.inlay_hint.is_enabled({ bufnr = event.buf }))
			end, "[T]oggle Inlay [H]ints")
		end
	end,
})

-- Diagnostic Config
-- See :help vim.diagnostic.Opts
vim.diagnostic.config({
	severity_sort = true,
	float = { border = "rounded", source = "if_many" },
	underline = { severity = vim.diagnostic.severity.ERROR },
	signs = vim.g.have_nerd_font and {
		text = {
			[vim.diagnostic.severity.ERROR] = "󰅚 ",
			[vim.diagnostic.severity.WARN] = "󰀪 ",
			[vim.diagnostic.severity.INFO] = "󰋽 ",
			[vim.diagnostic.severity.HINT] = "󰌶 ",
		},
	} or {},
	virtual_text = {
		source = "if_many",
		spacing = 2,
		format = function(diagnostic)
			local diagnostic_message = {
				[vim.diagnostic.severity.ERROR] = diagnostic.message,
				[vim.diagnostic.severity.WARN] = diagnostic.message,
				[vim.diagnostic.severity.INFO] = diagnostic.message,
				[vim.diagnostic.severity.HINT] = diagnostic.message,
			}
			return diagnostic_message[diagnostic.severity]
		end,
	},
})
