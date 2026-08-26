-- remapping command charcter to ;
vim.keymap.set("n", ";", ":")
-- save by pressing Escape
-- Save all files and quit Neovim completely
vim.keymap.set("n", "<leader>q", "<cmd>wqa!<CR>", { desc = "Save all and quit Neovim" })
-- Force quit Neovim without saving
vim.keymap.set("n", "<leader>Q", "<cmd>qa!<CR>", { desc = "Force quit Neovim" })
-- Save on Esc
vim.keymap.set("n", "<Esc>", ":w<CR>", { desc = "Save" })
-- select all
vim.keymap.set("n", "<C-a>", "ggVG", { desc = "Select All" })
-- pasting over a selection no longer clobbers your clipboard
vim.cmd([[ xnoremap <expr> p 'pgv"'.v:register.'y' ]])
-- Jump instantly to any window using just Space + w
vim.keymap.set("n", "<leader>w", function()
  local picked_window_id = require("window-picker").pick_window()
  if picked_window_id then
    vim.api.nvim_set_current_win(picked_window_id)
  end
end, { desc = "Window Picker" })
-- Jump to specific tabs with Alt + 1, Alt + 2, etc.
for i = 1, 9 do
  vim.keymap.set("n", "<A-" .. i .. ">", i .. "gt", { silent = true })
end
