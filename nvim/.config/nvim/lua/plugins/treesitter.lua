return {
	"nvim-treesitter/nvim-treesitter",
	build = ":TSUpdate",
	config = function()
		local ts = require("nvim-treesitter")
		ts.setup {
			-- Directory to install parsers and queries to (prepended to `runtimepath` to have priority)
			install_dir = vim.fn.stdpath("data") .. "/site"
		}

		ts.install { "rust", "javascript", "c", "cpp", "css", "java", "typescript", "go", "make" }
	end,
}
