later(function()
	-- Initialize plugins {{{
	add({ gh("Vigemus/iron.nvim") })
	-- }}}

	-- iron.nvim {{{1
	-- Setup {{{2
	local iron = require("iron.core")
	local view = require("iron.view")

	iron.setup({
		config = {
			scratch_repl = true,
			repl_definition = {
				lua = {
					command = { "luajit" },
					block_dividers = { "-- %%", "--%%" },
				},
			},
			repl_filetype = function(bufnr, ft)
				return ft
			end,
			dap_integration = true,
			repl_open_cmd = function()
				vim.cmd("botright 100 vsplit")
				return vim.api.nvim_get_current_win()
			end,
		},

		highlight = {
			italic = true,
		},

		ignore_blank_lines = true,
	})
	-- }}}
	--- }}}

	-- Keybindings {{{
	nm("<leader>kr", function()
		cmd("IronRepl")
	end, "Toggle REPL window")
	nm("<leader>kR", function()
		cmd("IronRestart")
	end, "Restart REPL")
	nm("<leader>kx", iron.close_repl, "Close the REPL window")
	vm("<leader>kc", iron.visual_send, "Send the selected lines to REPL")
	nm("<leader>kl", iron.send_line, "Send the current line to REPL")
	nm("<leader>kp", iron.send_paragraph, "Send the current paragraph to REPL")
	nm("<leader>kf", iron.send_file, "Send the current file to REPL")
	nm("<leader>ku", iron.send_until_cursor, "Send to REPL from start to cursor")
	nm("<leader>kb", function()
		iron.send_code_block(false)
	end, "Send to code block to the REPL")
	nm("<leader>kn", function()
		iron.send_code_block(true)
	end, "Send to code block to the REPL and move to next")
	nm("<leader>k<cr>", function()
		iron.send(nil, string.char(13))
	end, "Send <CR> to REPL")
	nm("<leader>kC", function()
		iron.send(nil, string.char(03))
	end, "Send Ctrl-C to REPL")
	nm("<leader>kL", function()
		iron.send(nil, string.char(12))
	end, "Send Ctrl-L to REPL")
	-- Full-screen toggle for REPL window {{{2
	nm("<leader>kz", function()
		local term_win = {}
		for _, win in ipairs(vim.api.nvim_tabpage_list_wins(0)) do
			if vim.bo[vim.api.nvim_win_get_buf(win)].buftype == "terminal" then
				table.insert(term_win, win)
			end
		end

		if #term_win ~= 1 then
			return print("Multiple terminals or no terminal found.")
		end

		term_win = term_win[1]

		if
			vim.api.nvim_win_get_width(term_win) > (vim.o.columns * 0.85)
			and vim.api.nvim_win_get_height(term_win) > (vim.o.lines * 0.85)
		then
			vim.cmd("wincmd = | wincmd p")
		else
			vim.api.nvim_set_current_win(term_win)
			vim.cmd("wincmd | | wincmd _")
		end
	end, "Toggle terminal zoom by size")
	-- }}}
	-- }}}
end)

-- vim: fdm=marker fdl=0
