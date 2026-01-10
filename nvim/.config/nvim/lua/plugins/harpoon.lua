-- File manager
return {
	"ThePrimeagen/harpoon",
	branch = "harpoon2",
	dependencies = { "nvim-lua/plenary.nvim" },
	config = function()
		local harpoon = require("harpoon")

		harpoon:setup()

		vim.keymap.set("n", "<leader>a", function()
			harpoon:list():add()
		end)
		vim.keymap.set("n", "<leader>e", function()
			harpoon.ui:toggle_quick_menu(harpoon:list())
		end)

		vim.keymap.set("n", "<M-a>", function()
			harpoon:list():select(1)
		end, { desc = "Harpoon: File 01" })
		vim.keymap.set("n", "<M-s>", function()
			harpoon:list():select(2)
		end, { desc = "Harpoon: File 02" })
		vim.keymap.set("n", "<M-d>", function()
			harpoon:list():select(3)
		end, { desc = "Harpoon: File 03" })
		vim.keymap.set("n", "<M-f>", function()
			harpoon:list():select(4)
		end, { desc = "Harpoon: File 04" })
		vim.keymap.set("n", "<M-g>", function()
			harpoon:list():select(5)
		end, { desc = "Harpoon: File 05" })
		vim.keymap.set("n", "<M-h>", function()
			harpoon:list():select(6)
		end, { desc = "Harpoon: File 06" })
		vim.keymap.set("n", "<M-j>", function()
			harpoon:list():select(7)
		end, { desc = "Harpoon: File 07" })
		vim.keymap.set("n", "<M-k>", function()
			harpoon:list():select(8)
		end, { desc = "Harpoon: File 08" })
		vim.keymap.set("n", "<M-l>", function()
			harpoon:list():select(9)
		end, { desc = "Harpoon: File 09" })
		vim.keymap.set("n", "<M-;>", function()
			harpoon:list():select(10)
		end, { desc = "Harpoon: File 10" })
	end,
}
