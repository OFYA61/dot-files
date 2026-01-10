-- Detect tabstop and shiftwidth automatically
return {
	"NMAC427/guess-indent.nvim",
	config = function()
		require("guess-indent").setup({})
	end,
}
