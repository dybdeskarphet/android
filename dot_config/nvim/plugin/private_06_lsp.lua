later(function()
	-- Initialize plugins {{{
	add({
		gh("rafamadriz/friendly-snippets"),
		gh("stevearc/conform.nvim"),
		gh("neovim/nvim-lspconfig"),
		gh("kosayoda/nvim-lightbulb"),
	})
	-- }}}

	-- Custom LSP configurations {{{1
	-- basedpyright {{{2
	vim.lsp.config("basedpyright", {
		capabilities = {
			window = {
				workDoneProgress = false,
			},
		},
		root_markers = {
			"pyproject.toml",
			"setup.py",
			"setup.cfg",
			"requirements.txt",
			"Pipfile",
			"pyrightconfig.json",
			".git",
		},
		settings = {
			basedpyright = {
				analysis = { autoSearchPaths = true, useLibraryCodeForTypes = true },
			},
		},
	})
	-- }}}

	-- lua_ls {{{2
	vim.lsp.config("lua_ls", {
		settings = {
			Lua = {
				diagnostics = { globals = { "vim" } },
				workspace = {
					library = {
						vim.env.VIMRUNTIME,
						"${3rd}/luv/library",
						"${3rd}/busted/library",
					},
					checkThirdParty = false,
				},
				completion = { callSnippet = "Replace" },
			},
		},
	})
	-- }}}

	-- taplo {{{2
	vim.lsp.config("taplo", {
		filetypes = { "toml" },
		root_markers = {
			"*.toml",
			".git",
		},
	})
	-- }}}

	-- texlab {{{2
	vim.lsp.config("texlab", {
		cmd = { "texlab" },
		filetypes = { "tex", "markdown" },
	})
	-- }}}
	-- }}}

	-- Native LSP enable {{{
	vim.lsp.enable({
		"basedpyright",
		"lua_ls",
		"taplo",
		"marksman",
		"jsonls",
		"bashls",
		"texlab",
	})
	-- }}}

	-- conform.nvim {{{
	require("conform").setup({
		formatters_by_ft = {
			lua = { "stylua" },
			python = { "ruff" },
			sh = { "shfmt" },
			bash = { "shfmt" },
			toml = { "taplo", lsp_format = "fallback" },
			json = { "jq", lsp_format = "fallback" },
			markdown = { lsp_format = "fallback" },
		},
		formatters = {
			shfmt = {
				prepend_args = { "-ln", "bash" },
			},
			ruff = {
				append_args = { "--unfixable", "F401" },
			},
		},
		format_on_save = function(bufnr)
			if g.disable_autoformat or vim.b[bufnr].disable_autoformat then
				return
			end
			return { timeout_ms = 2000, lsp_format = "fallback" }
		end,
	})
	-- }}}

	-- Mappings {{{
	vim.api.nvim_create_user_command("FormatDisable", function(args)
		if args.bang then
			b.disable_autoformat = true
			notify("Disabled autoformat for current buffer")
		else
			g.disable_autoformat = true
		end
	end, {
		desc = "Disable autoformat-on-save",
		bang = true,
	})
	vim.api.nvim_create_user_command("FormatEnable", function()
		b.disable_autoformat = false
		g.disable_autoformat = false
		notify("Enabled autoformat for current buffer")
	end, {
		desc = "Re-enable autoformat-on-save",
	})
	nm("<leader>lfe", "<cmd>FormatEnable<cr>", "Enable formatting")
	nm("<leader>lfd", "<cmd>FormatDisable!<cr>", "Disable formatting")

	nm("<leader>F", function()
		require("conform").format({ bufnr = vim.api.nvim_get_current_buf() })
	end, "Format the buffer")
	nm("<leader>x", function()
		MiniExtra.pickers.diagnostic()
	end, "Toggle diagnostics (clue)")
	nm("<leader>X", vim.diagnostic.setloclist, "Toggle diagnostics (split)")

	local lsp = vim.lsp

	nm("<leader>lh", function()
		local filter = { bufnr = 0 }
		lsp.inlay_hint.enable(not lsp.inlay_hint.is_enabled(filter), filter)
	end, "Toggle inlay hints")

	nm("K", function()
		lsp.buf.hover()
	end, "LSP hover")

	nm("<leader>d", function()
		vim.diagnostic.open_float(nil, { focusable = true })
	end, "Diagnostics float")

	nm("<leader>la", function()
		lsp.buf.code_action()
	end, "Code action")

	nm("<leader>ln", function()
		lsp.buf.rename()
	end, "Rename symbol")

	nm("<leader>lr", function()
		MiniExtra.pickers.lsp({ scope = "references" })
	end, "List references")

	nm("gd", function()
		lsp.buf.definition()
	end, "Go to definition")

	nm("gD", function()
		lsp.buf.declaration()
	end, "Go to Declaration")

	nm("<leader>lR", "<cmd>lsp restart<cr>", "Restart LSP")
	nm("<leader>li", "<cmd>checkhealth vim.lsp<cr>", "Get LSP info")
	nm("<leader>lp", "<cmd>lsp stop<cr>", "Stop LSP")
	nm("<leader>ls", "<cmd>lsp start<cr>", "Start LSP")
	-- }}}

	-- Show code actions bulb {{{
	require("nvim-lightbulb").setup({
		autocmd = { enabled = true },
		sign = { enabled = false, text = "" },
		virtual_text = { enabled = true, text = "" },
	})
	-- }}}
end)
-- vim: fdm=marker fdl=0
