-------------------------------------------------------------------------------
-- Plugin:      supermaven-nvim
-- GitHub:      https://github.com/supermaven-inc/supermaven-nvim
-- Description: AI code completion using Supermaven's inline suggestion engine.
--              Shows ghost-text completions; Tab accepts, C-] rejects.
-------------------------------------------------------------------------------
return {
  {
    "supermaven-inc/supermaven-nvim",
    event = "InsertEnter",
    opts = {
      keymaps = {
        accept_suggestion = "<Tab>",
        clear_suggestion = "<C-]>",
        accept_word = "<C-j>",
      },
      ignore_filetypes = { "TelescopePrompt", "neo-tree" },
      color = {
        suggestion_color = "#808080",
        cterm = 244,
      },
      log_level = "off",
    },
  },
}
