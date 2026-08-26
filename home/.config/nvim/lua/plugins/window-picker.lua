-------------------------------------------------------------------------------
-- Plugin:      nvim-window-picker
-- GitHub:      https://github.com/s1n7ax/nvim-window-picker
-- Description: A target-selection plugin that prompts you with single-key overlays to select specific target windows when splitting or opening files.
-- Setup:       Integrated with Neo-tree to prompt for destination editor splits when opening files across multi-pane layouts.
-------------------------------------------------------------------------------
return {
  "s1n7ax/nvim-window-picker",
  name = "window-picker",
  event = "VeryLazy",
  version = "2.*",
  config = function()
    require("window-picker").setup({
      -- 1. Modern Floating Indicators instead of statusline shifts
      -- Options: 'statusline-winbar' | 'floating-big-letter' | 'floating-letter'
      hint = "floating-big-letter",

      -- 2. Ergonomic home-row characters for fast selection
      selection_chars = "FJDKSLA;CMRUEIWOQP",

      -- 3. Exclude structural utility windows you never want to swap text into
      filter_rules = {
        include_current_win = false,
        autoselect_one = true,
        bo = {
          -- Ignore these filetypes completely during evaluation loops
          filetype = { "neo-tree", "neo-tree-popup", "notify", "quickfix", "snacks_picker_input" },
          buftype = { "terminal", "quickfix" },
        },
      },

      -- 4. Aesthetic Highlighting Controls
      highlights = {
        -- The visual label text layout colors
        statusline = {
          focused = { fg = "#eceff4", bg = "#81a1c1", bold = true },
          unfocused = { fg = "#eceff4", bg = "#4c566a", bold = true },
        },
      },

      -- Dim unselected windows with an obvious background warning accent
      other_win_hl_color = "#e35e4f",
    })
  end,
}
