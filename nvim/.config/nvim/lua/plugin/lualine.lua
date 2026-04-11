-- Status line
vim.pack.add({
	{ src = "https://github.com/nvim-lualine/lualine.nvim" },
	{
		src = "https::/github.com/nvim-tree/nvim-web-devicons",
	},
})

local ayu_theme = require("lualine.themes.ayu")
ayu_theme.normal.c.bg = "none"
require("lualine").setup({
	options = {
		icons_enabled = true,
		theme = ayu_theme,
	},
})
