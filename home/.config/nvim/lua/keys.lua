-- remapping command charcter to ;
vim.keymap.set("n", ";", ":")
vim.keymap.set("n", "<leader>q", "<cmd>wqa!<CR>", { desc = "Save all and quit Neovim" })
vim.keymap.set("n", "<leader>Q", "<cmd>qa!<CR>", { desc = "Force quit Neovim without saving" })
vim.keymap.set("n", "<Esc>", ":w<CR>", { desc = "Save on Esc" })
vim.keymap.set("n", "<C-a>", "ggVG", { desc = "Select All" })

-- pasting over a selection no longer clobbers your clipboard
vim.cmd([[ xnoremap <expr> p 'pgv"'.v:register.'y' ]])

-- Copy file path + line range reference for pasting into AI chats
vim.keymap.set({ "n", "v" }, "<leader>yr", function()
  local path = vim.fn.expand("%:.")
  local mode = vim.fn.mode()
  local ref = path
  if mode == "v" or mode == "V" then
    local start_line = vim.fn.line("v")
    local end_line = vim.fn.line(".")
    if start_line > end_line then
      start_line, end_line = end_line, start_line
    end
    ref = path .. ":" .. start_line .. ":" .. end_line
  end
  vim.fn.setreg("+", ref)
  vim.notify("Copied: " .. ref)
end, { desc = "Copy file path with line range" })

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
