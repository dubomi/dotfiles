-------------------------------------------------------------------------------
-- Plugin:      catppuccin (Colorscheme)
-- GitHub:      https://github.com/catppuccin/nvim
-- Description: A warm, soothing color palette theme designed for Neovim and modern terminal workflows.
-- Setup:       Acts as your primary editor theme, directly targeted by lualine.nvim and aligned with the terminal color scheme.
-------------------------------------------------------------------------------
return {
  "catppuccin/nvim", -- GitHub repository path
  enabled = true,
  name = "catppuccin",
  lazy = false, -- Load this plugin immediately during startup
  priority = 1000, -- Make sure this loads before all other plugins
  config = function()
    -- This inner function runs after the plugin is downloaded
    require("catppuccin").setup({
      flavour = "mocha", -- latte, frappe, macchiato, mocha
      background = { -- :h background
        light = "latte",
        dark = "mocha",
      },
      transparent_background = false,
      color_overrides = {
        mocha = {
          base = "#161622", -- Custom darker background
          green = "#60d673", -- Custom neon green for strings
          mauve = "#d28bff",
          lavender = "#9bb2ff",
          --surface2 = "#585b70",

          --mauve = "#cba6f7",
          --lavender = "#b4befe",
        },
      },
      custom_highlights = function(colors)
        return {
          -- 1. LINE NUMBERS (Higher contrast grays/whites)
          LineNr = { fg = colors.overlay2 }, -- #9399b2 (brighter gray than surface2)
        }
      end,
    })
    vim.cmd([[colorscheme catppuccin]])
  end,
}
