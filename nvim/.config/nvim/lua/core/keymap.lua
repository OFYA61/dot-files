vim.g.mapleader = " "

vim.keymap.set("n", "<leader>pv", vim.cmd.Ex)

-- To move visual mode block around
vim.keymap.set("v", "J", ":m '>+1<CR>gv=gv")
vim.keymap.set("v", "K", ":m '<-2<CR>gv=gv")

-- For centering the screen when moving up and down the file
vim.keymap.set("n", "<C-d>", "<C-d>zz")
vim.keymap.set("n", "<C-u>", "<C-u>zz")

-- For centering the screen when moving up and down with paragraph jumps
vim.keymap.set("n", "{", "{zz")
vim.keymap.set("n", "}", "}zz")

-- For centering the screen when jumping to search results
vim.keymap.set("n", "n", "nzz")
vim.keymap.set("n", "N", "Nzz")

-- Store stuff in the system buffer instead of the editor buffer
vim.keymap.set("n", "<leader>y", '"+y')
vim.keymap.set("v", "<leader>y", '"+y')
vim.keymap.set("n", "<leader>Y", '"+Y')

-- I am too used to Ctrl-C, so just in case mapping
vim.keymap.set("i", "<C-c>", "<Esc>")

-- New window/buffer
vim.keymap.set("n", "<C-w><C-l>", ":rightbelow vnew<CR>")
vim.keymap.set("n", "<C-w><C-h>", ":leftabove vnew<CR>")
vim.keymap.set("n", "<C-w><C-k>", ":new<CR>")
vim.keymap.set("n", "<C-w><C-j>", ":belowright new<CR>")
-- Move between window/buffer
vim.keymap.set("n", "<C-k>", "<C-w>k")
vim.keymap.set("n", "<C-j>", "<C-w>j")
vim.keymap.set("n", "<C-h>", "<C-w>h")
vim.keymap.set("n", "<C-l>", "<C-w>l")
-- Window resize
vim.keymap.set("n", "<M-Right>", ":vertical resize +2<CR>", { noremap = true, silent = true })
vim.keymap.set("n", "<M-Left>", ":vertical resize -2<CR>", { noremap = true, silent = true })
vim.keymap.set("n", "<M-Up>", ":resize +2<CR>", { noremap = true, silent = true })
vim.keymap.set("n", "<M-Down>", ":resize -2<CR>", { noremap = true, silent = true })

-- Useless mappings
vim.keymap.set("n", "[[", "<NOP>")
vim.keymap.set("n", "]]", "<NOP>")

-- Git
vim.keymap.set("n", "<leader>gs", vim.cmd.Git)

-- Clear highlights on search when pressing <Esc> in normal mode
--  See `:help hlsearch`
vim.keymap.set("n", "<Esc>", "<cmd>nohlsearch<CR>")

-- Diagnostic keymaps
vim.keymap.set("n", "<leader>q", vim.diagnostic.setloclist, { desc = "Open diagnostic [Q]uickfix list" })
