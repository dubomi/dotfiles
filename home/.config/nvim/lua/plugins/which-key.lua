-------------------------------------------------------------------------------
-- Plugin:      which-key.nvim
-- GitHub:      https://github.com/folke/which-key.nvim
-- Description: A popup panel that displays available keybindings in real-time as you type your leader key or command chords.
-- Setup:       Provides instant visual discovery for your custom keymaps (like `<leader>ca` for code actions or `g` for Neogit) and window navigation options.
-------------------------------------------------------------------------------
return {
  {
    "folke/which-key.nvim",
    lazy = false,
    config = true, -- popup that shows what my leader keys do
  },
}
