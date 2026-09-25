local o = vim.opt
vim.g.mapleader = " " -- space is the leader key
o.expandtab = true -- Convert tabs to spaces
o.shiftwidth = 2 -- Size of an indent
o.tabstop = 2 -- Number of spaces that a <Tab> in the file counts for
o.softtabstop = 2
o.number = true -- absolute number on the cursor line, relative elsewhere
o.relativenumber = true -- relative line numbers for fast jumps
o.ignorecase = true -- search is case-insensitive by default
o.smartcase = true -- case-sensitive only if i type a capital
o.clipboard = "unnamedplus" -- share the system clipboard
o.scrolloff = 16 -- keep cursor away from the screen edge
o.undofile = true -- persistent undo across sessions
o.mouse = "" -- no mouse in nvim; also lets Herdr keep host mouse capture off so Escape isn't swallowed
o.termguicolors = true -- Enable 24-bit true color
o.background = "dark" -- Set background preference (dark or light)
o.spell = true -- enable spelling checker
o.spelllang = "en_us" -- set en_us as a spelling checker language

-- Auto-reload files changed outside nvim
o.autoread = true
vim.api.nvim_create_autocmd({ "FocusGained", "BufEnter", "CursorHold", "CursorHoldI" }, {
  command = "checktime",
})

-- Highlight yanked text
vim.api.nvim_create_autocmd("TextYankPost", {
  group = vim.api.nvim_create_augroup("highlight_yank", { clear = true }),
  pattern = "*",
  desc = "Highlight selection on yank",
  callback = function()
    vim.hl.on_yank({ timeout = 200, on_visual = true })
  end,
})

-- auto resize splits when the terminal's window is resized
vim.api.nvim_create_autocmd("VimResized", {
  command = "wincmd =",
})
