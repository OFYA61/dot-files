return {
	"Shatur/neovim-ayu",
	priority = 1000,
	config = function()
		require("ayu").setup({
			terminal = true,
		})
		vim.cmd("colorscheme ayu")
		vim.o.winborder = "bold"

		vim.api.nvim_create_autocmd("VimEnter", {
			callback = function()
				vim.cmd("highlight LineNr guifg=#FFFFFF")
				vim.cmd("highlight CursorLineNr guifg=#FF8F40")
			end,
		})
	end,
}
