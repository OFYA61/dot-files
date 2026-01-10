-- Status line
return {
	"nvim-lualine/lualine.nvim",
	dependencies = { "nvim-tree/nvim-web-devicons" },
	config = function()
		local ayu_theme = require("lualine.themes.ayu")
		ayu_theme.normal.c.bg = "none"
		require("lualine").setup({
			options = {
				icons_enabled = true,
				theme = ayu_theme,
			},
		})
	end,
}
