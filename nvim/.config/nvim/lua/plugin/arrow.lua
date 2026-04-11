vim.pack.add({
	{ src = "https://github.com/otavioschwanck/arrow.nvim" },
	{ src = "https://github.com/nvim-tree/nvim-web-devicons" },
})

require("arrow").setup({
	show_icons = true,
	leader_key = "<leader>;",
	buffer_leader_key = "m",
})

local keys = { "a", "s", "d", "f", "g", "h", "j", "k", "l", ";" }
for i, key in ipairs(keys) do
	vim.keymap.set("n", "<M-" .. key .. ">", function()
		-- Arrow usually uses its own internal index handling
		require("arrow.persist").go_to(i)
	end)
end

vim.keymap.set("n", "<leader>a", function()
	require("arrow.persist").save(require("arrow.utils").get_current_buffer_path())
end)

vim.keymap.set("n", "<leader>e", function()
	require("arrow.persist").open_cache_file()
end)
