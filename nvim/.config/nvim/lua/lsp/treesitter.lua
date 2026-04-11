vim.pack.add({ { src = "https://github.com/nvim-treesitter/nvim-treesitter", build = ":TSUpdate" } })

local ts = require("nvim-treesitter")
ts.setup({
	-- Directory to install parsers and queries to (prepended to `runtimepath` to have priority)
	install_dir = vim.fn.stdpath("data") .. "/site",
})

ts.install({ "zig", "rust", "javascript", "c", "make" })
