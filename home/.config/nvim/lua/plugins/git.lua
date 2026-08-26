-------------------------------------------------------------------------------
-- Plugin:      neogit
-- GitHub:      https://github.com/NeogitOrg/neogit
-- Description: An interactive, Magit-inspired Git interface and workflow manager for Neovim.
-- Setup:       Configured with `snacks.nvim` UI integration and `sindrets/diffview.nvim` for rich side-by-side diffs, lazy-loaded on the `g` key map.
-------------------------------------------------------------------------------
return {
  {
    "NeogitOrg/neogit",
    dependencies = {
      "nvim-lua/plenary.nvim",
      "sindrets/diffview.nvim",
      "folke/snacks.nvim",
    },
    -- stylua: ignore start
    keys = {
      { "<leader>g", function() require("neogit").open() end, desc = "Neogit" },
    },
    -- stylua: ignore end
    opts = {
      integrations = {
        diffview = true,
        snacks = true,
      },
    },
  },
  {
    "lewis6991/gitsigns.nvim",
    event = "BufReadPost",
    opts = {
      current_line_blame = true,
    },
  },
}
