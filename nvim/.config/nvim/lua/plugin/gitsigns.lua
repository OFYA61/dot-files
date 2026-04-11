vim.pack.add({
	{ src = "https://github.com/lewis6991/gitsigns.nvim" },
})

local gs = require("gitsigns")
gs.setup({
	signs = {
		add = { text = "+" },
		change = { text = "~" },
		delete = { text = "_" },
		topdelete = { text = "‾" },
		changedelete = { text = "~" },
	},
	on_attach = function(bufnr)
		local function map(mode, l, r, opts)
			opts = opts or {}
			opts.buffer = bufnr
			vim.keymap.set(mode, l, r, opts)
		end

		map("n", ",c", gs.prev_hunk, { desc = "[,] Git Previous [C]hange" })
		map("n", ".c", gs.next_hunk, { desc = "[.] Git Next [C]hange" })

		map("n", "<leader>grr", gs.reset_hunk, { desc = "[G]it [RR]eset Change" })
		map("n", "<leader>grf", gs.reset_buffer, { desc = "[G]it [R]eset [F]ile" })
		map("n", "<leader>gp", gs.preview_hunk, { desc = "[G]it [P]review Change" })
		map("n", "<leader>gb", function()
			gs.blame_line({ full = true })
		end, { desc = "[G]it [B]lame Line" })
	end,
})
