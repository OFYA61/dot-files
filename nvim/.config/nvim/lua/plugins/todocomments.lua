-- Highlight todo comments
return {
  "folke/todo-comments.nvim",
  event = "VimEnter",
  dependencies = { "nvim-lua/plenary.nvim" },
  opts = {},
  config = function()
    local todo = require("todo-comments")
    todo.setup({})
    vim.keymap.set("n", ",t", function() todo.jump_prev() end, { desc = "Previous todo comment" })
    vim.keymap.set("n", ".t", function() todo.jump_next() end, { desc = "Next todo comment" })
    vim.keymap.set("n", "<leader>st", ":TodoTelescope<CR>", { desc = "[S]earch [T]odo Comments" })
  end
}
