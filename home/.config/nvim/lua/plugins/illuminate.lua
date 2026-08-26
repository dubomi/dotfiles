-------------------------------------------------------------------------------
-- Plugin:      vim-illuminate
-- GitHub:      https://github.com/RRethy/vim-illuminate
-- Description: Automatically highlights and lets you navigate between other occurrences of the word under the cursor using LSP, Treesitter, or regex.
-- Setup:       Lazy-loaded on `BufReadPost` with a 100ms delay, ignoring sidebar windows while enabling `]]` and `[[` match jumps.
-------------------------------------------------------------------------------
return {
  "RRethy/vim-illuminate",
  event = "BufReadPost",
  config = function()
    local illuminate = require("illuminate")

    illuminate.configure({
      -- Providers used to get references (ordered by priority)
      providers = {
        "lsp",
        "treesitter",
        "regex",
      },
      -- Delay in milliseconds before highlighting occurrences
      delay = 100,
      -- Filetypes to disable illuminate in
      filetypes_denylist = {
        "dirvish",
        "fugitive",
        "NvimTree",
        "neo-tree",
        "TelescopePrompt",
        "Outline",
        "DressingInput",
        "toggleterm",
      },
      -- Don't illuminate under cursor in large files for performance
      large_file_cutoff = 2000,
      -- Don't illuminate on lines longer than this threshold
      large_file_overrides = {
        providers = { "flags" },
      },
      -- Set to true to allow under cursor highlighting
      under_cursor = true,
    })

    -- Navigation keymaps to jump between illuminated references
    vim.keymap.set("n", "]]", function()
      illuminate.goto_next_reference(false)
    end, { desc = "Next Reference" })

    vim.keymap.set("n", "[[", function()
      illuminate.goto_prev_reference(false)
    end, { desc = "Prev Reference" })
  end,
}
