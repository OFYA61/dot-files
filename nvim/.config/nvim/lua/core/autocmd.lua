-- Sync clipboard between OS and Neovim.
-- Schedule the setting after `UiEnter` because it can increase startup-time.
-- Remove this option if you want your OS clipboard to remain independent.
vim.schedule(function()
	vim.o.clipboard = "unnamedplus"
end)

-- Highlight when yanking (copying) text
--  Try it with `yap` in normal mode
vim.api.nvim_create_autocmd("TextYankPost", {
	desc = "Highlight when yanking (copying) text",
	group = vim.api.nvim_create_augroup("kickstart-highlight-yank", { clear = true }),
	callback = function()
		vim.hl.on_yank()
	end,
})

vim.api.nvim_create_autocmd("FocusGained", {
	desc = "Reload files from disk when focusing on neovim",
	pattern = "*",
	command = "if getcmdwintype() == '' | checktime | endif",
	group = aug,
})
vim.api.nvim_create_autocmd("BufEnter", {
	desc = "Every time an unmodified buffer is entered, check if it changed on disk",
	pattern = "*",
	command = "if &buftype == '' && !&modified && expand('%') != '' | exec 'checktime ' . expand('<abuf>') | endif",
	group = aug,
})
